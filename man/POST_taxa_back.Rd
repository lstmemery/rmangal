% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/POST_taxa_back.R
\name{POST_taxa_back}
\alias{POST_taxa_back}
\title{POST data into the Mangal taxo_back table}
\usage{
POST_taxa_back(taxa_back = taxa_back)
}
\arguments{
\item{taxa_back}{A dataframe with five columns: \cr
'name': clean taxonomy, name of the taxa without numbers or 'sp'\cr
'bold': BOLD taxa id\cr
'eol': Encyclopedia of life taxa id\cr
'tsn': ITIS taxa id\cr
'ncbi': NCBI taxa id\cr}
}
\value{
The status of the injection:
'taxo_back done' ids have been created and the injection is succesfull
}
\description{
POST the metadata associated to the taxonomic backbone.
}
\author{
Gabriel Bergeron
}
\keyword{database}
