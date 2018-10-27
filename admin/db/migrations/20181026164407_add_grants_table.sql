-- +micrate Up
CREATE TABLE grants(
  id BIGSERIAL PRIMARY KEY,
  organization character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE grants;