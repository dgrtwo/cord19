<!-- README.md is generated from README.Rmd. Please edit that file -->



# cord19

<!-- badges: start -->
<!-- badges: end -->

The cord19 package shares the [COVID-19 Open Research Dataset (CORD-19)](https://www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge#all_sources_metadata_2020-03-13.csv) in a tidy form that is easily analyzed within R.

## Installation

Install the package from GitHub as follows:

``` r
remotes::install_github("dgrtwo/cord19")
```

## Papers

The package turns the CORD-19 dataset into a set of tidy tables.

For example, the paper metadata is stored in `cord19_papers`.


```r
library(dplyr)
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

### Full text

Most usefully, `cord19_paragraphs` has the full text of the papers, with one observation for each paragraph.


```r
cord19_paragraphs
#> # A tibble: 364,755 x 4
#>    paper_id               paragraph section text                               
#>    <chr>                      <int> <chr>   <chr>                              
#>  1 0015023cc06b5362d332b…         1 <NA>    VP3, and VP0 (which is further pro…
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

# What are common sections
cord19_paragraphs %>%
    count(section, sort = TRUE)
#> # A tibble: 79,531 x 2
#>    section                   n
#>    <chr>                 <int>
#>  1 Discussion            41868
#>  2 Introduction          24128
#>  3 <NA>                  12503
#>  4 Results               11317
#>  5 Background             6709
#>  6 Conclusions            5328
#>  7 Methods                4167
#>  8 Materials And Methods  3677
#>  9 Conclusion             2872
#> 10 Statistical Analysis   2689
#> # … with 79,521 more rows
```

This allows for some analysis with a package like tidytext.


```r
library(tidytext)
set.seed(2020)

# Sample 100 random papers
paper_words <- cord19_paragraphs %>%
    filter(paper_id %in% sample(unique(paper_id), 100)) %>%
    unnest_tokens(word, text) %>%
    anti_join(stop_words, by = "word")

paper_words %>%
    count(word, sort = TRUE)
#> # A tibble: 21,612 x 2
#>    word          n
#>    <chr>     <int>
#>  1 1          1556
#>  2 2          1366
#>  3 cells      1300
#>  4 virus      1184
#>  5 infection  1033
#>  6 3           920
#>  7 cell        854
#>  8 study       848
#>  9 viral       830
#> 10 data        773
#> # … with 21,602 more rows
```

### Citations

This also includes the articles cited by each paper.


```r
cord19_paper_citations
#> # A tibble: 605,650 x 9
#>    paper_id       ref_id title            venue  volume issn  pages  year doi  
#>    <chr>          <chr>  <chr>            <chr>  <chr>  <chr> <chr> <int> <chr>
#>  1 0015023cc06b5… b0     Genetic economy… PLOS … 13     ""    ""     2017 <NA> 
#>  2 0015023cc06b5… b2     A universal pro… BMC G… 604    ""    ""     2014 <NA> 
#>  3 0015023cc06b5… b3     Library prepara… Nat P… 9      ""    1760…  2014 <NA> 
#>  4 0015023cc06b5… b4     IDBA-UD: a de n… ""     ""     ""    ""     2012 <NA> 
#>  5 0015023cc06b5… b6     Basic local ali… J Mol… 215    ""    403-…  1990 <NA> 
#>  6 0015023cc06b5… b7     Genetically eng… J 614… 67     ""    5139…  1993 <NA> 
#>  7 0015023cc06b5… b9     Both cis and tr… J Vir… 90     ""    6864…  2016 <NA> 
#>  8 0015023cc06b5… b10    Mutational anal… J Vir… 620    ""    2027…  1996 <NA> 
#>  9 0015023cc06b5… b12    Figure 3. The p… ""     ""     ""    ""       NA <NA> 
#> 10 0015023cc06b5… b13    A replicon 650 … ""     ""     ""    ""       NA <NA> 
#> # … with 605,640 more rows
```

What are the most commonly cited articles?


```r
cord19_paper_citations %>%
    count(title, sort = TRUE)
#> # A tibble: 417,863 x 2
#>    title                                                                      n
#>    <chr>                                                                  <int>
#>  1 Isolation of a novel coronavirus from a man with pneumonia in Saudi A…   397
#>  2 Submit your next manuscript to BioMed Central and take full advantage…   295
#>  3 Identification of a novel coronavirus in patients with severe acute r…   236
#>  4 A novel coronavirus associated with severe acute respiratory syndrome    226
#>  5 Global trends in emerging infectious diseases                            193
#>  6 Bats are natural reservoirs of SARS-like coronaviruses                   177
#>  7 Coronavirus as a possible cause of severe acute respiratory syndrome     164
#>  8 Characterization of a novel coronavirus associated with severe acute …   149
#>  9 Severe acute respiratory syndrome coronavirus-like virus in Chinese h…   140
#> 10 Identification of a new human coronavirus                                137
#> # … with 417,853 more rows
```

We could use the [widyr](https://github.com/dgrtwo/widyr) package to find which papers are often cited *by* the same paper.


```r
library(widyr)

filtered_citations <- cord19_paper_citations %>%
    add_count(title) %>%
    filter(n >= 25)

# What papers are often cited by the same paper?
filtered_citations %>%
    pairwise_cor(title, paper_id, sort = TRUE)
#> # A tibble: 244,530 x 3
#>    item1                            item2                           correlation
#>    <chr>                            <chr>                                 <dbl>
#>  1 Small molecule inhibitors revea… Ebola virus entry requires the…       0.776
#>  2 Ebola virus entry requires the … Small molecule inhibitors reve…       0.776
#>  3 VISA is an adapter protein requ… IPS-1, an adaptor triggering R…       0.765
#>  4 IPS-1, an adaptor triggering RI… VISA is an adapter protein req…       0.765
#>  5 Identification of a novel polyo… Identification of a third huma…       0.735
#>  6 Identification of a third human… Identification of a novel poly…       0.735
#>  7 The IFITM proteins mediate cell… Distinct patterns of IFITM-med…       0.727
#>  8 Distinct patterns of IFITM-medi… The IFITM proteins mediate cel…       0.727
#>  9 Cardif is an adaptor protein in… VISA is an adapter protein req…       0.698
#> 10 VISA is an adapter protein requ… Cardif is an adaptor protein i…       0.698
#> # … with 244,520 more rows
```
