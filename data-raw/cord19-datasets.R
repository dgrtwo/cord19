library(dplyr)
library(purrr)
library(tidyr)
library(readr)
library(stringr)
library(jsonlite)
library(janitor)

# Download the dataset from Kaggle here (requires account), then decompress
# https://www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge
infolder <- "~/Downloads/2020-03-13"

# Read in and remove duplicates
cord19_papers <- read_csv(paste0(infolder, "/all_sources_metadata_2020-03-13.csv")) %>%
    clean_names() %>%
    rename(paper_id = sha,
           source = source_x) %>%
    filter(!is.na(paper_id), !is.na(title)) %>%
    arrange(is.na(title), is.na(abstract), is.na(authors), is.na(journal)) %>%
    distinct(paper_id, .keep_all = TRUE) %>%
    distinct(lower_title = str_to_lower(title), .keep_all = TRUE) %>%
    distinct(doi, .keep_all = TRUE) %>%
    select(-lower_title)

# Read in all the JSON objects as well
# dir() with recursive = TRUE allows us to get a full vector of filenames
json_objects <- dir(infolder,
                    pattern = "*.json",
                    full.names = TRUE,
                    recursive = TRUE) %>%
    map(read_json)

articles_hoisted <- tibble(json = json_objects) %>%
    hoist(json,
          paper_id = "paper_id",
          section = c("body_text", function(.) map_chr(., "section")),
          text = c("body_text", function(.) map_chr(., "text")),
          citations = c("body_text", function(.) map(., "cite_spans")),
          bib_entries = "bib_entries") %>%
    select(-json)

paragraphs <- articles_hoisted %>%
    select(-bib_entries) %>%
    unnest(cols = c(text, section, citations)) %>%
    group_by(paper_id) %>%
    mutate(paragraph = row_number()) %>%
    ungroup() %>%
    select(paper_id, paragraph, everything())

# Could use unnest_wider, but hoist seems to be faster
paragraph_citations <- paragraphs %>%
    select(paper_id, paragraph, citations) %>%
    unnest(citations) %>%
    hoist(citations, start = "start", end = "end", text = "text", ref_id = "ref_id")

# Remaining cleanup of paragraphs
cord19_paragraphs <- paragraphs %>%
    select(-citations) %>%
    mutate(section = str_to_title(section)) %>%
    semi_join(cord19_papers, by = "paper_id") %>%
    mutate_if(is.character, na_if, "")

# Pulling out the details from the article references

citations <- articles_hoisted %>%
    semi_join(cord19_papers, by = "paper_id") %>%
    select(paper_id, bib_entries) %>%
    unnest(bib_entries) %>%
    hoist(bib_entries,
          ref_id = "ref_id",
          title = "title",
          venue = "venue",
          volume = "volume",
          issn = "issn",
          pages = "pages",
          year = "year",
          doi = list("other_ids", "DOI", 1)) %>%
    select(-bib_entries)

# Filter out the references that aren't journal titles
blacklist_regex <- "Publisher's Note|Springer Nature remains|This article is|The copyright holder|All rights reserved|No reuse allowed"
cord19_paper_citations <- citations %>%
    filter(!is.na(ref_id),
           !str_detect(title, blacklist_regex))

cord19_paragraph_citations <- paragraph_citations %>%
    filter(!is.na(ref_id)) %>%
    semi_join(cord19_papers, by = "paper_id") %>%
    mutate(ref_id = str_replace(ref_id, "BIBREF", "b")) %>%
    semi_join(cord19_paper_citations, by = c("paper_id", "ref_id"))

usethis::use_data(cord19_papers, overwrite = TRUE)
usethis::use_data(cord19_paragraphs, overwrite = TRUE)
usethis::use_data(cord19_paper_citations, overwrite = TRUE)
usethis::use_data(cord19_paragraph_citations, overwrite = TRUE)
