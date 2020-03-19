#' Link papers, and paragraphs within them, to citations
#'
#' One observation for each combination of a paragraph and citation. Includes
#' only the ones in \code{\link{cord19_papers}} (thus, deduplicated and
#' filtered). Can be joined with \code{\link{cord19_paper_citations}} with
#' \code{paper_id} and \code{ref_id}, or with \code{cord19_paragraphs} using
#' \code{paper_id} and \code{paragraph}.
#'
#' @format A tibble with variables:
#' \describe{
#'   \item{paper_id}{Unique identifier that can link to metadata and citations.
#'   SHA of the paper PDF.}
#'   \item{paragraph}{Index of the paragraph within the paper (1, 2, 3)}
#'   \item{start}{Index within the text where this citation starts}
#'   \item{end}{Index within the text where this citation starts}
#'   \item{text}{Text of the citation (usually a number, or a number with parentheses)}
#'   \item{ref_id}{Reference ID, can be used to join to
#'   \code{\link{cord19_paper_citations}}}.
#' }
#'
#' @seealso \url{https://www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge}
"cord19_paragraph_citations"
