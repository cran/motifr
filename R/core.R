#' Translate multi-level statnet or igraph network object to Python networkx
#' object
#'
#' The function \code{motifr::is.directed} is used to determine whether the
#' provided network is directed (if \code{directed = FALSE}).
#'
#' The nodal attribute specified by \code{lvl_attr} indicates the levels of the
#' nodes. Values are automatically converted to integers. Levels must be
#' numbered starting with 0, 1, ….
#'
#' @param g statnet or igraph network object
#' @param lvl_attr character vector specifying the attribute name where level
#'   information is stored in \code{net}.
#' @param relabel should nodes be relabelled with statnet \code{vertex.names} or
#'   igraph nodal attribute \code{name}
#' @param directed whether the graph shall be treated as a directed graph. Per
#'   default (\code{NULL}), this is determined automatically using the structure
#'   of the provided network object
#'
#' @return Python networkx graph object
#' @export
#'
#' @examples
#' \dontrun{
#' to_py_graph(motifr::dummy_net, lvl_attr = "sesType")
#' }
to_py_graph <- function(g, lvl_attr, relabel = TRUE, directed = NULL) {
  if (network::is.network(g)) {
    # function for translating a statnet network object into a Python compatible
    # networkx object
    adjacency_matrix <- network::as.matrix.network(g)
    attribute_names <- as.list(network::list.vertex.attributes(g))
    attribute_values <- lapply(
      network::list.vertex.attributes(g),
      function(x) network::get.vertex.attribute(g, x)
    )
    vertex_names <- network::network.vertex.names(g)
  } else if (igraph::is.igraph(g)) {
    adjacency_matrix <- igraph::as_adjacency_matrix(g, sparse = FALSE)
    attributes <- as.data.frame(igraph::vertex.attributes(g))
    attribute_names <- as.list(colnames(attributes))
    attribute_values <- lapply(
      attribute_names,
      function(x) attributes[[x]]
    )
    if (is.null(igraph::V(g)$name)) {
      # vertices don't carry names, uses igraph's internal numbering
      vertex_names <- 1:igraph::gorder(g)
    } else {
      vertex_names <- igraph::V(g)$name
    }
  } else {
    stop(paste("Provided network object is of unsupported format:", class(g)))
  }

  if (is.null(directed)) {
    directed <- motifr::is.directed(g)
  } else if (directed == TRUE && !motifr::is.directed(g)) {
    warning(paste(
      "Attempting to treat an undirected network as directed.",
      "This might lead to unintended results."
    ))
  }

  py_g <- pkg.env$sma$translateGraph(adjacency_matrix,
    attribute_names,
    attribute_values,
    lvl_attr,
    directed = directed
  )

  if (relabel == TRUE) {
    # JS: renaming in here right now,
    # but will suggest update to rbridge.py to do in Python
    node_names <-
      reticulate::py_dict(
        keys = as.integer(0:(py_g$number_of_nodes() - 1)),
        values = vertex_names
      )
    py_g <- pkg.env$nx$relabel_nodes(py_g, mapping = node_names)
  }
  return(py_g)
}

#' Checks whether the given network is directed
#'
#' Placeholder function for the corresponding functions of the various supported
#' network formats. For example, this function calls
#' \code{network::is.directed()} on \code{network} objects and
#' \code{igraph::is.directed()} on \code{igraph} objects.
#'
#' @param net the network
#' @return whether the given network is directed
#' @export
#'
#' @examples
#' is.directed(motifr::ml_net)
is.directed <- function(net) {
  if (network::is.network(net)) {
    return(network::is.directed(net))
  } else if (igraph::is.igraph(net)) {
    return(igraph::is.directed(net))
  } else {
    stop(paste("Provided network object is of unsupported format:", class(net)))
  }
}

#' Returns subgraph induced by one level of the network
#'
#' This function is intended to be used together with \code{simulate_baseline()}
#' for partial ERGM models. Currently, only \code{network} objects are supported
#' as input.
#'
#' @param net the network
#' @param level the (number of the) level
#' @param lvl_attr name of the nodal attribute specifying the level
#' @return induced subgraph as \code{network} object.
#' @export
#' @examples
#'
#' subgraph_actors <- induced_level_subgraph(motifr::ml_net, 1)
#' plot_mnet(subgraph_actors, label = TRUE)
induced_level_subgraph <- function(net, level, lvl_attr = "sesType") {
  if (!network::is.network(net)) {
    stop(paste(
      "motifr::induced_level_subgraph is only implemented for graph",
      "objects stemming from the network package."
    ))
  }
  levels <- network::get.vertex.attribute(net, lvl_attr)
  indices <- which(levels == level)
  subgraph <- network::get.inducedSubgraph(net, indices)
  return(subgraph)
}
