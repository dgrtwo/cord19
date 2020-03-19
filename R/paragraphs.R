#' Full text of the papers in the CORD-19 dataset, separated into paragraphs
#'
#' Full text of the papers in one-observation-per-paragraph form. Includes
#' only the ones in \code{\link{cord19_papers}} (thus, deduplicated and
#' filtered).
#'
#' @format A tibble with variables:
#' \describe{
#'   \item{paper_id}{Unique identifier that can link to metadata and citations.
#'   SHA of the paper PDF.}
#'   \item{paragraph}{Index of the paragraph within the paper (1, 2, 3)}
#'   \item{section}{Section (e.g. Introduction, Results, Discussion). The
#'   casing is standardized to title case.}
#'   \item{text}{Full text}
#' }
#'
#' @examples
#'
#' library(dplyr)
#' library(stringr)
#'
#' # What are the most common section titles?
#' cord19_paragraphs %>%
#'   count(section = str_to_lower(section), sort = TRUE)
#'
#' @source \url{https://www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge}
"cord19_paragraphs"
