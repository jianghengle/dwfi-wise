-- +micrate Up
CREATE TABLE files(
  id BIGSERIAL PRIMARY KEY,
  name character varying NOT NULL,
  file_type character varying,
  url character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE files;