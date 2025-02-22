#' Set node attribute values with a graph function
#'
#' @description
#'
#' From a graph object of class `dgr_graph` or a node data frame, set node
#' attribute properties for all nodes in the graph using one of several
#' whole-graph functions.
#'
#' @inheritParams render_graph
#' @param node_attr_fcn The name of the function to use for creating a column of
#'   node attribute values. Valid functions are: [get_alpha_centrality()],
#'   [get_authority_centrality()], [get_betweenness()], [get_closeness()],
#'   [get_cmty_edge_btwns()], [get_cmty_fast_greedy()], [get_cmty_l_eigenvec()],
#'   [get_cmty_louvain()], [get_cmty_walktrap()], [get_degree_distribution()],
#'   [get_degree_histogram()], [get_degree_in()], [get_degree_out()],
#'   [get_degree_total()], [get_eccentricity()], [get_eigen_centrality()],
#'   [get_pagerank()], [get_s_connected_cmpts()], and [get_w_connected_cmpts()].
#' @param ... Arguments and values to pass to the named function in
#'   `node_attr_fcn`, if necessary.
#' @param column_name An option to supply a column name for the new node
#'   attribute column. If `NULL` then the column name supplied by the function
#'   will used along with a `__A` suffix.
#'
#' @return A graph object of class `dgr_graph`.
#'
#' @examples
#' # Create a random graph using the
#' # `add_gnm_graph()` function
#' graph <-
#'   create_graph() %>%
#'   add_gnm_graph(
#'     n = 10,
#'     m = 22,
#'     set_seed = 23) %>%
#'   set_node_attrs(
#'     node_attr = value,
#'     values = rnorm(
#'       n = count_nodes(.),
#'       mean = 5,
#'       sd = 1) %>% round(1))
#'
#' # Get the betweenness values for
#' # each of the graph's nodes as a
#' # node attribute
#' graph_1 <-
#'   graph %>%
#'   set_node_attr_w_fcn(
#'     node_attr_fcn = "get_betweenness")
#'
#' # Inspect the graph's internal
#' # node data frame
#' graph_1 %>% get_node_df()
#'
#' # If a specified function takes argument
#' # values, these can be supplied as well
#' graph_2 <-
#'   graph %>%
#'   set_node_attr_w_fcn(
#'     node_attr_fcn = "get_alpha_centrality",
#'     alpha = 2,
#'     exo = 2)
#'
#' # Inspect the graph's internal
#' # node data frame
#' graph_2 %>% get_node_df()
#'
#' # The new column name can be provided
#' graph_3 <-
#'   graph %>%
#'   set_node_attr_w_fcn(
#'     node_attr_fcn = "get_pagerank",
#'     column_name = "pagerank")
#'
#' # Inspect the graph's internal
#' # node data frame
#' graph_3 %>% get_node_df()
#'
#' # If `graph_3` is modified by
#' # adding a new node then the column
#' # `pagerank` will have stale data; we
#' # can run the function again and re-use
#' # the existing column name to provide
#' # updated values
#' graph_3 <-
#'   graph_3 %>%
#'   add_node(
#'     from = 1,
#'     to = 3) %>%
#'   set_node_attr_w_fcn(
#'     node_attr_fcn = "get_pagerank",
#'     column_name = "pagerank")
#'
#' # Inspect the graph's internal
#' # node data frame
#' graph_3 %>% get_node_df()
#'
#' @family Node creation and removal
#'
#' @export
set_node_attr_w_fcn <- function(
    graph,
    node_attr_fcn,
    ...,
    column_name = NULL
) {

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

  value_per_node_fcn_names <-
    value_per_node_functions() %>% names()

  if (!any(value_per_node_fcn_names %in% node_attr_fcn)) {

    emit_error(
      fcn_name = fcn_name,
      reasons = "The function name must be one that produces values for every graph node")
  }

  # Collect extra vectors of arguments and values as `extras`
  extras <- list(...)

  if (length(extras) > 0) {

  nodes_df <-
    graph$nodes_df %>%
    dplyr::inner_join(
      eval(
        parse(
          text = paste0(
            node_attr_fcn,
            "(graph, ",
            paste(names(extras),
                  "=",
                  extras,
                  collapse =  ", "),
            ")"))) %>%
        dplyr::mutate(id = as.integer(id)),
      by = "id")

  } else {

    nodes_df <-
      graph$nodes_df %>%
      dplyr::inner_join(
        eval(
          parse(
            text = paste0(
              node_attr_fcn,
              "(graph)"))) %>%
          dplyr::mutate(id = as.integer(id)),
        by = "id")
  }

  if (!is.null(column_name)) {

    # If a new column name is specified in
    # `column_name`, use that for the new column
    colnames(nodes_df)[length(colnames(nodes_df))] <-
      column_name
  } else {

    # Add the `_A` tag to the column name normally
    # supplied by the function
    colnames(nodes_df)[length(colnames(nodes_df))] <-
      paste0(colnames(nodes_df)[length(colnames(nodes_df))], "__A")
  }

  # Determine if there is a column with the same name;
  # if there is, replace its contents with that of the
  # new column
  if (colnames(nodes_df)[length(colnames(nodes_df))] %in%
      colnames(nodes_df)[1:(length(colnames(nodes_df)) - 1)]) {

    col_no_matching <-
      which(colnames(nodes_df)[1:(length(colnames(nodes_df)) - 1)] ==
              colnames(nodes_df)[length(colnames(nodes_df))])

    # Move contents of new column to matching column
    nodes_df[, col_no_matching] <-
      nodes_df[, length(colnames(nodes_df))]

    # Remove the last column from the ndf
    nodes_df[, length(colnames(nodes_df))] <- NULL
  }

  if (paste0(colnames(nodes_df)[length(colnames(nodes_df))], ".x") %in%
      colnames(nodes_df)[1:(length(colnames(nodes_df)) - 1)]) {

    col_no_matching <-
      which(colnames(nodes_df)[1:(length(colnames(nodes_df)) - 1)] ==
              paste0(colnames(nodes_df)[length(colnames(nodes_df))], ".x"))

    # Get the column name of the new column
    new_col_name <- colnames(nodes_df)[length(colnames(nodes_df))]

    # Move contents of new column to matching column
    nodes_df[, col_no_matching] <-
      nodes_df[, length(colnames(nodes_df))]

    # Remove the last column from the ndf
    nodes_df[, length(colnames(nodes_df))] <- NULL

    # Rename the refreshed column
    colnames(nodes_df)[col_no_matching] <- new_col_name
  }

  # Replace the graph's ndf with the
  # revised version
  graph$nodes_df <- nodes_df

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
