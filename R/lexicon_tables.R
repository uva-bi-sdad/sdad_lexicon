create_metadata_dataprovider <- function(con) {
  sql <- "DROP TABLE IF EXISTS metadata_dataprovider CASCADE;
        CREATE TABLE metadata_dataprovider (
        dataprovider_id SERIAL PRIMARY KEY,
        dataprovider_name text,
        display_name varchar(25) NULL,
        description text NULL,
        created date NOT NULL DEFAULT NOW(),
        created_by varchar(25) NULL,
        updated date NOT NULL DEFAULT NOW(),
        updated_by varchar(25) NULL
        );"
  DBI::dbSendQuery(con, sql)
  DBI::dbSendQuery(con, "DROP ROLE IF EXISTS anonymous;")
  DBI::dbSendQuery(con, "CREATE ROLE anonymous WITH LOGIN PASSWORD 'anonymous'")
  DBI::dbSendQuery(con, "GRANT INSERT, UPDATE ON metadata_dataprovider TO anonymous")
  DBI::dbSendQuery(con, "GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anonymous")
  DBI::dbDisconnect(con)
}
create_metadata_dataprovider(lexicon_connection(db_user = Sys.getenv("db_userid"), db_pass = Sys.getenv("db_pwd")))


create_metadata_dataset <- function(con) {
  sql <- "DROP TABLE IF EXISTS metadata_dataset CASCADE;
        CREATE TABLE metadata_dataset (
        dataset_id SERIAL PRIMARY KEY,
        dataprovider_id SERIAL REFERENCES metadata_dataprovider(dataprovider_id),
        dataset_name text,
        display_name varchar(25) NULL,
        description text NULL,
        categories text NULL,
        subcategories varchar(25)[] NULL,
        keywords text NULL,
        geo_location_name text NULL,
        geo_resolution char[2] NULL,
        critical_changes text NULL,
        created date NOT NULL DEFAULT NOW(),
        created_by varchar(25) NULL,
        updated date NOT NULL DEFAULT NOW(),
        updated_by varchar(25) NULL
        );"
  DBI::dbSendQuery(con, sql)
  DBI::dbSendQuery(con, "GRANT INSERT, UPDATE ON metadata_dataset TO anonymous")
  DBI::dbDisconnect(con)
}
create_metadata_dataset(lexicon_connection(db_user = "ads7fg", db_pass = "Iwnftp$2"))

create_metadata_dataitem <- function(con) {
  sql <- "DROP TABLE IF EXISTS metadata_item;
        CREATE TABLE metadata_item (
        dataitem_id SERIAL PRIMARY KEY,
        dataset_id SERIAL REFERENCES metadata_dataset(dataset_id),
        dataitem_name text,
        display_name varchar(25) NULL,
        description text NULL,
        requirement varchar(25) NULL,
        requirement_description text NULL,
        demographic_type varchar(25) NULL,
        numeric_range_min integer NULL,
        numeric_range_max integer NULL,
        date_range_min date NULL,
        date_range_max date NULL,
        id_length_min integer NULL,
        id_length_max integer NULL,
        critical_changes text NULL,
        valid_use_begin_date date NULL,
        valid_use_end_date date NULL,
        valid_values text[],
        original_entry_by varchar(25) NULL,
        created date NOT NULL DEFAULT NOW(),
        created_by varchar(25) NULL,
        updated date NOT NULL DEFAULT NOW(),
        updated_by varchar(25) NULL
        );"
  DBI::dbSendQuery(con, sql)
  DBI::dbSendQuery(con, "GRANT INSERT, UPDATE ON metadata_item TO anonymous")
  DBI::dbDisconnect(con)
}
create_metadata_dataitem(lexicon_connection(db_user = "ads7fg", db_pass = "Iwnftp$2"))

create_metadata_valid_values <- function(con) {
  sql <- "DROP TABLE IF EXISTS metadata_valid_values;
        CREATE TABLE metadata_valid_values (
        dataitem_id SERIAL PRIMARY KEY,
        value text NOT NULL,
        description text NULL,
        created date NOT NULL DEFAULT NOW(),
        created_by varchar(25) NULL,
        updated date NOT NULL DEFAULT NOW(),
        updated_by varchar(25) NULL
        );"
  DBI::dbSendQuery(con, sql)
  DBI::dbSendQuery(con, "GRANT INSERT, UPDATE ON metadata_valid_values TO anonymous")
  DBI::dbDisconnect(con)
}
create_metadata_dataitem(lexicon_connection(db_user = db_userid, db_pass = db_pwd))


# "CREATE TABLE todos (
#   id SERIAL NOT NULL PRIMARY KEY,
#   content TEXT,
#   created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
#   updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
#   updated_by VARCHAR(30) NOT NULL DEFAULT CURRENT_USER,
#   completed_at TIMESTAMPTZ
# );"


