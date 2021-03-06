#' Average expression values per cluster
#'
#' @param mat expression matrix
#' @param cluster_info data.frame or vector containing cluster assignments per cell.
#' Order must match column order in supplied matrix. If a data.frame
#' provide the cluster_col parameters.
#' @param log_scale input data is natural log,
#' averaging will be done on unlogged data
#' @param cluster_col column in cluster_info with cluster number
#'
#' @export
average_clusters <- function(mat, cluster_info,
                             log_scale = T,
                             cluster_col = "cluster") {

  if(is.vector(cluster_info)){
    cluster_ids <- split(colnames(mat), cluster_info)
  } else if (is.data.frame(cluster_info) & !is.null(cluster_col)){
    cluster_ids <- split(colnames(mat), cluster_info[[cluster_col]])
  } else {
    stop("cluster_info not formatted correctly,
         supply either a  vector or a dataframe")
  }

  out <- lapply(
    cluster_ids,
    function(cell_ids) {
      if (!all(cell_ids %in% colnames(mat))) {
        stop("cell ids not found in input matrix")
      }
      if (log_scale) {
        mat_data <- expm1(mat[, cell_ids])
      } else {
        mat_data <- mat[, cell_ids]
      }
      res <- Matrix::rowMeans(mat_data)
      if (log_scale) {
        res <- log1p(res)
      }
      res
    }
  )
  return(do.call(cbind, out))
}

#' Percentage detected per cluster
#'
#' @param mat expression matrix
#' @param cluster_info data.frame with cells
#' @param cluster_col column in cluster_info with cluster number
#' @param cut_num binary cutoff for detection
#'
#' @export
percent_clusters <- function(mat, cluster_info,
                             cluster_col = "cluster",
                             cut_num = 0.5) {
  mat[mat >= cut_num] <- 1
  mat[mat <= cut_num] <- 0

  average_clusters(mat, cluster_info,
    log_scale = F,
    cluster_col = cluster_col
  )
}

#' Function to make call and attach score
#'
#' @param name name of row to query
#' @param best_mat binarized call matrix
#' @param cor_mat correlation matrix
#' @param carry_cor whether the correlation score gets reported
#'
#' @export
get_best_str <- function(name,
                         best_mat,
                         cor_mat,
                         carry_cor = TRUE) {
  if (sum(as.numeric(best_mat[name, ])) > 0) {
    best.names <- colnames(best_mat)[which(best_mat[name, ] == 1)]
    best.cor <- round(cor_mat[name, which(best_mat[name, ] == 1)], 2)
    for (i in 1:length(best.cor)) {
      if (i == 1) {
        str <- paste0(best.names[i], " (", best.cor[i], ")")
      } else {
        str <- paste0(str, "; ", best.names[i], " (", best.cor[i], ")")
      }
    }
  } else {
    str <- "?"
  }

  if (carry_cor == FALSE) {
    str <- gsub(" \\(.*\\)", "", str)
  }
  return(str)
}

#' Find entries shared in all vectors
#' @description return entries found in all supplied vectors. If the vector supplied
#' is NULL or NA, then it will be excluded from the comparision.
#' @param ... vectors
#' @examples
#' a <- rep(1:5)
#' b <- rep(4:10)
#' c <- rep(4:6)
#' get_common_elements(a, b, c)
#' @export
get_common_elements <- function(...) {
  vecs <- list(...)
  # drop NULL elements of list
  vecs <- vecs[!sapply(vecs, is.null)]
  # drop NA elements of list (NA values OK in a vector)
  vecs <- vecs[!is.na(vecs)]

  Reduce(intersect, vecs)
}
