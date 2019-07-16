-- +micrate Up
CREATE TABLE directories(
  id BIGSERIAL PRIMARY KEY,
  people_id INTEGER references people(id),
  typ character varying,
  role character varying,
  tags character varying,
  institution character varying,
  department character varying,
  area character varying,
  specialty character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE directories;
