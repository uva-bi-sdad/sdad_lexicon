lexicon_select <- function(con, dataset = "metadata_dataset", dataitems = c("dataset_name", "categories"), limit = 0) {
  browser()
  # get dataset dataitems (columns) and data types from database
  db_dataitems <- DBI::dbGetQuery(con, paste0("select column_name, data_type from information_schema.columns where table_name = '", dataset, "'"))

  if (dataitems != "") {
    # check if fields are in table
    tf <- dataitems %in% db_dataitems$column_name
    if (length(tf[tf == FALSE]) > 0) {
      return("all specified dataitems not in dataset, check spelling?")
    }
  } else {
    dataitems <- db_dataitems
  }

  # convert arrays to json
  data.table::setDT(dataitems)
  dataitems[, dataitem := paste0("\"", column_name, "\"")]
  dataitems[data_type == "ARRAY", dataitem := paste0("array_to_json(", dataitem, ") ", dataitem)]

  # build SQL query
  sql <- paste("select", paste0(dataitems$dataitem, collapse = ","), "from", dataset)
  if (limit > 0) sql <- paste(sql, "limit", limit)
  # execute SQL query
  DBI::dbGetQuery(con, sql)
}

lexicon_select(lexicon_connection(), "metadata_dataset", dataitems = "", 0)
