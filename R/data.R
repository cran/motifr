#' Two-level network example (wetlands management)
#'
#' A statnet network object based on empirical data about actors and their
#' activities in a case study of Swiss wetlands management
#'
#' @format Statnet network object with 132 nodes and 566 edges on two levels.
#'   One network level contains actors, a second network level contains
#'   activities. Links between actors indicate collaboration among actors. Links
#'   between actors and activities indicate that an actor is active in a given
#'   activity. Links between activities indicate that the activities are
#'   causally interdependent. The network contains two variables to describe
#'   nodes/ vertices. \describe{ \item{vertex.names}{node labes}
#'   \item{sesType}{Binary variable specifying network levels for every node (1
#'   = node is a social node (actor) , 0 = node is a non-social node (an
#'   activity))} ... }
#' @source Surveys and expert interviews in a Swiss wetland. Data is anonymized
#'   and should only be used for exemplary purposes.
#' @examples
#' plot_mnet(ml_net)
"ml_net"

#' Three-level network dummy example
#'
#' A simple statnet network object based on dummy data.
#'
#' @format Statnet network object with 60 nodes and 1035 edges on three levels.
#' The network contains two variables to describe nodes/ vertices.
#' \describe{
#'   \item{vertex.names}{node labes}
#'   \item{sesType}{Categorical variable specifying network levels for every node (levels are 0,1 and 2)}
#'   ...
#' }
#' @source Dummy data
#' \url{https://gitlab.com/t.seppelt/sesmotifanalyser/-/tree/master/test/data}
#' @examples
#' plot_mnet(dummy_net)
"dummy_net"

#' Two-level directed network dummy example
#'
#' Simple igraph network object based on dummy data
#'
#' @format igraph network object
#' @source Dummy data
#'  \url{https://gitlab.com/t.seppelt/sesmotifanalyser/-/tree/master/test/data},
#'  \url{https://github.com/marioangst/motifr/blob/master/notes/directed_dummy_net.R}
#' @examples
#' plot_mnet(directed_dummy_net)
"directed_dummy_net"

#' Two-level tidygraph network example
#'
#' Simple \code{tidygraph} network object for testing
#'
#' @format tidygraph network object
#' @source Dummy data
#'  \url{https://github.com/marioangst/motifr/blob/master/notes/tidygraph_dummy_net.R}
#' @examples
#' plot_mnet(tidygraph_dummy_net)
"tidygraph_dummy_net"

#' Large two-level directed network dummy example
#'
#'
#' @format network network object
#' @source Dummy data
#'  \url{https://gitlab.com/t.seppelt/sesmotifanalyser/-/tree/master/test/data}
#' @examples
#' plot_mnet(large_directed_dummy_net)
"large_directed_dummy_net"
