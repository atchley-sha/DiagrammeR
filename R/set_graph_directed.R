#' Convert an undirected graph to a directed graph
#'
#' @description
#'
#' Take a graph which is undirected and convert it to a directed graph.
#'
#' @inheritParams render_graph
#'
#' @return A graph object of class `dgr_graph`.
#'
#' @examples
#' # Create a graph with a
#' # undirected tree
#' graph <-
#'   create_graph(
#'     directed = FALSE) %>%
#'   add_balanced_tree(
#'     k = 2, h = 2)
#'
#' # Convert this graph from
#' # undirected to directed
#' graph <-
#'   graph %>%
#'   set_graph_directed()
#'
#' # Perform a check on whether
#' # graph is directed
#' graph %>% is_graph_directed()
#'
#' @export
set_graph_directed <- function(graph) {

  # Get the time of function start
  time_function_start <- Sys.time()

  # Get the name of the function
  fcn_name <- get_calling_fcn()

  # Validation: Graph object is valid
  if (graph_object_valid(graph) == FALSE) {

    emit_error(
      fcn_name = fcn_name,
      reasons = "The graph object is not valid")
  }

  # Set the `directed` vector to TRUE
  graph$directed <- TRUE

  # Update the `graph_log` df with an action
  graph$graph_log <-
    add_action_to_log(
      graph_log = graph$graph_log,
      version_id = nrow(graph$graph_log) + 1,
      function_used = fcn_name,
      time_modified = time_function_start,
      duration = graph_function_duration(time_function_start),
      nodes = nrow(graph$nodes_df),
      edges = nrow(graph$edges_df))

  # Write graph backup if the option is set
  if (graph$graph_info$write_backups) {
    save_graph_as_rds(graph = graph)
  }

  graph
}
