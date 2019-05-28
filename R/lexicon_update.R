lexicon_update_datasource <- function(con, col_vals_df, uid = 1) {
  dt <- data.table::setDT(col_vals_df)
  # get dataset dataitems (columns) and data types from database
  db_datasources <-
    DBI::dbGetQuery(
      lexicon_connection(),
      paste0(
        "select column_name, data_type, udt_name from information_schema.columns where table_name = 'metadata_datasource'"
      )
    )
  in_datasources <- merge(dt, db_datasources, by.x = "col", by.y = "column_name")

  browser()
  in_datasources[, col_sql := paste0("\"", col, "\"")]
  in_datasources[data_type %in% c("integer"), val_sql := paste0(val)]
  in_datasources[data_type %in% c("text", "character varying"), val_sql := paste0("'", val, "'")]
  in_datasources[data_type %in% c("ARRAY") & grepl("*date*", udt_name), val_sql := paste0("ARRAY", val, "::date[]")]
  in_datasources[data_type %in% c("ARRAY") & grepl("*varchar%*", udt_name), val_sql := paste0("ARRAY", val, "::varchar[]")]

  # format(Sys.Date(), "%Y-%m-%d")

  sql <-
    paste0("UPDATE metadata_datasource SET ",
           in_datasources[, paste0(col_sql, " = ", val_sql, collapse = ", ")],
           " WHERE datasource_id = ",
           uid)

  DBI::dbSendQuery(con, sql)
  DBI::dbDisconnect(con)
}

col_vals_df <-
  data.frame(
    col = c(
      "datasource_name",
      "display_name",
      "updated",
      "updated_by"),
    val = c(
      "Federal Bureau of Investigation",
      "FBI",
      "['1968-11-13']",
      "['Aaron Schroeder', 'Aaron D. Schroeder']"
    )
  )
lexicon_update_datasource(lexicon_connection(), col_vals_df)
