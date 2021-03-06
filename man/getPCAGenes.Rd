% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_pca_genes.R
\name{getPCAGenes}
\alias{getPCAGenes}
\title{Returns a list of variable genes based on PCA}
\usage{
getPCAGenes(sc_avg_expr, bulk_expr, nr_pcs, percentile)
}
\arguments{
\item{sc_avg_expr}{Expression data frame. Rownames are genes,
colnames are single cell cluster name, and
values are average single cell expression (log transformed).}

\item{bulk_expr}{Bulk RNA expression data frame. Rownames are genes,
colnames are bulk sample names, and values are expression counts.}

\item{nr_pcs}{Number of PCs to selected gene loadings from.
See the explore_PCA_corr.Rmd vignette for details.}

\item{percentile}{Select the percentile of absolute values of
PCA loadings to select genes from. E.g. 0.999 would select the
top point 1 percent of genes with the largest loadings.}
}
\value{
The list of genes to use as features.
}
\description{
@description  Extract genes, i.e. "features", based on the top
loadings of principal components
formed from the bulk expression data set
}
