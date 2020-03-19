<!-- README.md is generated from README.Rmd. Please edit that file -->



# cord19

<!-- badges: start -->
<!-- badges: end -->

(WORK IN PROGRESS)

The cord19 package shares the [COVID-19 Open Research Dataset (CORD-19)](https://www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge#all_sources_metadata_2020-03-13.csv) in a tidy form that is easily analyzed within R.

## Installation

Install the package from GitHub here:

``` r
remotes::install_github("dgrtwo/cord19")
```

## Example

The package turns the CORD-19 dataset into a set of tidy tables. For example, the paper metadata is stored in `cord19_papers`:


```r
library(cord19)

cord19_papers
#> # A tibble: 12,503 x 14
#>    paper_id source title doi   pmcid pubmed_id license abstract publish_time
#>    <chr>    <chr>  <chr> <chr> <lgl>     <dbl> <chr>   <chr>           <dbl>
#>  1 210a892… CZI    Incu… 10.3… NA           NA cc-by   The geo…         2020
#>  2 e3b40cc… CZI    Char… 10.3… NA     32093211 cc-by   In Dece…         2020
#>  3 0df0d52… CZI    An u… 10.1… NA           NA cc-by-… The bas…         2020
#>  4 f242425… CZI    Real… 10.1… NA           NA cc-by-… The ini…         2020
#>  5 e1b336d… CZI    COVI… 10.1… NA           NA cc-by-… Cruise …         2020
#>  6 e923910… CZI    Dist… 10.1… NA           NA cc-by   Coronav…         2020
#>  7 469ed0f… CZI    Firs… 10.1… NA           NA cc-by   Similar…         2020
#>  8 4e550e0… CZI    Effe… 10.2… NA           NA cc-by   We simu…         2020
#>  9 4bbb0c5… CZI    Geno… 10.1… NA     32108862 cc-by-… SUMMARY…         2020
#> 10 c821803… CZI    Case… 10.3… NA           NA cc-by-… Since m…         2020
#> # … with 12,493 more rows, and 5 more variables: authors <chr>, journal <chr>,
#> #   microsoft_academic_paper_id <dbl>, who_number_covidence <chr>,
#> #   has_full_text <lgl>

# Learn how many papers came from each journal
cord19_papers %>%
    count(journal, sort = TRUE)
#> # A tibble: 1,300 x 2
#>    journal              n
#>    <chr>            <int>
#>  1 PLoS One          1560
#>  2 Emerg Infect Dis   726
#>  3 Viruses            545
#>  4 <NA>               503
#>  5 Sci Rep            485
#>  6 PLoS Pathog        357
#>  7 Virol J            357
#>  8 BMC Infect Dis     246
#>  9 Front Immunol      210
#> 10 Front Microbiol    202
#> # … with 1,290 more rows
```

Most usefully, it has the full text of the papers in `cord19_paragraphs`.


```r
cord19_paragraphs
#> # A tibble: 364,755 x 4
#>    paper_id               paragraph section text                               
#>    <chr>                      <int> <chr>   <chr>                              
#>  1 0015023cc06b5362d332b…         1 ""      VP3, and VP0 (which is further pro…
#>  2 0015023cc06b5362d332b…         2 70      The FMDV 5′ UTR is the largest kno…
#>  3 0015023cc06b5362d332b…         3 120     To introduce mutations into the PK…
#>  4 0015023cc06b5362d332b…         4 120     132 133 author/funder. All rights …
#>  5 0015023cc06b5362d332b…         5 120     The copyright holder for this prep…
#>  6 0015023cc06b5362d332b…         6 135     Mutations were then introduced int…
#>  7 0015023cc06b5362d332b…         7 136     To assess the effects of truncatio…
#>  8 0015023cc06b5362d332b…         8 144     Transcription reactions to produce…
#>  9 0015023cc06b5362d332b…         9 144     The copyright holder for this prep…
#> 10 0015023cc06b5362d332b…        10 144     The copyright holder for this prep…
#> # … with 364,745 more rows
```

This allows for some mining with a package like tidytext.


```r
library(tidytext)
set.seed(2020)

# Sample 1000 random paragraphs
cord19_paragraphs %>%
    sample_n(1000) %>%
    unnest_tokens(word, text) %>%
    count(word, sort = TRUE) %>%
    anti_join(stop_words, by = "word")
#> # A tibble: 14,799 x 2
#>    word          n
#>    <chr>     <int>
#>  1 1           573
#>  2 cells       507
#>  3 2           440
#>  4 virus       391
#>  5 3           344
#>  6 infection   315
#>  7 viral       303
#>  8 cell        294
#>  9 5           290
#> 10 4           278
#> # … with 14,789 more rows
```

### Citations

This also includes the articles cited by each paper.


```r
# What are the most commonly cited articles?
cord19_paper_citations %>%
    count(title, sort = TRUE)
#> # A tibble: 418,002 x 2
#>    title                                                                      n
#>    <chr>                                                                  <int>
#>  1 Isolation of a novel coronavirus from a man with pneumonia in Saudi A…   397
#>  2 Submit your next manuscript to BioMed Central and take full advantage…   295
#>  3 Identification of a novel coronavirus in patients with severe acute r…   236
#>  4 A novel coronavirus associated with severe acute respiratory syndrome    226
#>  5 This article is an open access article distributed under the terms an…   210
#>  6 Global trends in emerging infectious diseases                            193
#>  7 Bats are natural reservoirs of SARS-like coronaviruses                   177
#>  8 Coronavirus as a possible cause of severe acute respiratory syndrome     164
#>  9 The copyright holder for this preprint (which was not peer-reviewed) …   150
#> 10 Characterization of a novel coronavirus associated with severe acute …   149
#> # … with 417,992 more rows
```
