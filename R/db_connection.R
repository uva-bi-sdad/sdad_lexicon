lexicon_connection <- function(db_name = "lexicon", db_host = "127.0.0.1", db_port = "5433", db_user = "anonymous", db_pass = "anonymous") {
  DBI::dbConnect(
    drv = RPostgreSQL::PostgreSQL() ,
    dbname = db_name,
    host = db_host,
    port = db_port,
    user = db_user,
    password = db_pass)
}
