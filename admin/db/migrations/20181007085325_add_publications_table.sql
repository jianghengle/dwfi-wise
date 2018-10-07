-- +micrate Up
CREATE TABLE publications(
  id BIGSERIAL PRIMARY KEY,
  title character varying,
  authors character varying,
  abstract character varying,
  url character varying,
  status character varying,
  point_of_contact character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE publications;