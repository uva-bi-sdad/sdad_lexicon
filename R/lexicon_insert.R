lexicon_insert_datasource <- function(con, col_vals_df) {
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

  sql <-
    paste0(
      "INSERT INTO metadata_datasource (",
      in_datasources[, paste0(col_sql, collapse = ", ")],
      ") VALUES (",
      in_datasources[, paste0(val_sql, collapse = ", ")],
      ")"
    )

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
lexicon_insert_datasource(lexicon_connection(), col_vals_df)


lexicon_insert <- function(con) {
  sql <- "INSERT INTO metadata_dataset (
        datasource_id,
        dataset_name,
        display_name,
        description,
        categories,
        subcategories,
        keywords,
        geo_location_name,
        geo_resolution,
        critical_changes,
        updated,
        updated_by
        ) VALUES (
        1, 'dataset 1', 'ds1', 'Im a dataset',
        ARRAY['category 1', 'category 2'],
        NULL, NULL, NULL, NULL, NULL, NULL, NULL
        );"
  DBI::dbSendQuery(con, sql)
  DBI::dbDisconnect(con)
}

lexicon_insert(lexicon_connection())
