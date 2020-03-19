#' Link papers to the full details of citations
#'
#' One observation for each combination of a paper and citation. Includes
#' only the ones in \code{\link{cord19_papers}} (thus, deduplicated and
#' filtered). Can be joined with \code{\link{cord19_paragraph_citations}} with
#' \code{paper_id} and \code{ref_id}, or with \code{cord19_papers} using
#' \code{paper_id}.
#'
#' @format A tibble with variables:
#' \describe{
#'   \item{paper_id}{Unique identifier that can link to metadata and citations.
#'   SHA of the paper PDF.}
#'   \item{ref_id}{Reference ID, can be used to join to
#'   \code{\link{cord19_paragraph_citations}}}
#'   \item{venue}{Journal}
#'   \item{volume}{Volume number}
#'   \item{issn}{Issue number}
#'   \item{pages}{Pages}
#'   \item{year}{Year}
#'   \item{doi}{Digital Object Identifier}
#' }
#'
#' @source \url{https://www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge}
"cord19_paper_citations"
