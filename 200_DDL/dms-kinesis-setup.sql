--
-- CDC APP User
--

CREATE ROLE app_user WITH LOGIN PASSWORD 'We1come$';

--
-- dms-source tables
--

DROP TABLE IF EXISTS source_tbl;
CREATE TABLE source_tbl (
    id SERIAL PRIMARY KEY
  , head TEXT
  , body TEXT
  , payload JSONB
  , create_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  , update_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE source_tbl OWNER TO app_user;

--
-- dms-target tables
--

DROP TABLE IF EXISTS target_tbl_1;
CREATE TABLE target_tbl_1 (
    id SERIAL PRIMARY KEY
  , head TEXT
  , body TEXT
  , payload JSONB
  , create_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  , update_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE target_tbl_1 OWNER TO app_user;

DROP TABLE IF EXISTS target_tbl_2;
CREATE TABLE target_tbl_2 (
    id SERIAL PRIMARY KEY
  , head TEXT
  , body TEXT
  , payload JSONB
  , create_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  , update_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE target_tbl_2 OWNER TO app_user;

