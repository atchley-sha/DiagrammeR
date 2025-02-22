% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_n_nodes.R
\name{add_n_nodes}
\alias{add_n_nodes}
\title{Add one or several unconnected nodes to the graph}
\usage{
add_n_nodes(
  graph,
  n,
  type = NULL,
  label = NULL,
  node_aes = NULL,
  node_data = NULL
)
}
\arguments{
\item{graph}{A graph object of class \code{dgr_graph}.}

\item{n}{The number of new nodes to add to the graph.}

\item{type}{An optional character vector that provides group identifiers for
the nodes to be added.}

\item{label}{An optional character object that describes the nodes to be
added.}

\item{node_aes}{An optional list of named vectors comprising node aesthetic
attributes. The helper function \code{\link[=node_aes]{node_aes()}} is strongly recommended for
use here as it contains arguments for each of the accepted node aesthetic
attributes (e.g., \code{shape}, \code{style}, \code{color}, \code{fillcolor}).}

\item{node_data}{An optional list of named vectors comprising node data
attributes. The helper function \code{\link[=node_data]{node_data()}} is strongly recommended for
use here as it helps bind data specifically to the created nodes.}
}
\value{
A graph object of class \code{dgr_graph}.
}
\description{
Add \code{n} new nodes to a graph object of class \code{dgr_graph}. Optionally, set
node \code{type} values for the new nodes.
}
\examples{
# Create an empty graph and
# add 5 nodes; these nodes
# will be assigned ID values
# from `1` to `5`
graph <-
  create_graph() \%>\%
  add_n_nodes(n = 5)

# Get the graph's node IDs
graph \%>\% get_node_ids()

}
\seealso{
Other Node creation and removal: 
\code{\link{add_n_node_clones}()},
\code{\link{add_n_nodes_ws}()},
\code{\link{add_node_clones_ws}()},
\code{\link{add_node_df}()},
\code{\link{add_nodes_from_df_cols}()},
\code{\link{add_nodes_from_table}()},
\code{\link{add_node}()},
\code{\link{colorize_node_attrs}()},
\code{\link{copy_node_attrs}()},
\code{\link{create_node_df}()},
\code{\link{delete_nodes_ws}()},
\code{\link{delete_node}()},
\code{\link{drop_node_attrs}()},
\code{\link{join_node_attrs}()},
\code{\link{layout_nodes_w_string}()},
\code{\link{mutate_node_attrs_ws}()},
\code{\link{mutate_node_attrs}()},
\code{\link{node_data}()},
\code{\link{recode_node_attrs}()},
\code{\link{rename_node_attrs}()},
\code{\link{rescale_node_attrs}()},
\code{\link{set_node_attr_to_display}()},
\code{\link{set_node_attr_w_fcn}()},
\code{\link{set_node_attrs_ws}()},
\code{\link{set_node_attrs}()},
\code{\link{set_node_position}()}
}
\concept{Node creation and removal}
