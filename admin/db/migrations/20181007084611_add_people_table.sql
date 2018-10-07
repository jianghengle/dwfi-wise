-- +micrate Up
CREATE TABLE people(
  id BIGSERIAL PRIMARY KEY,
  first_name character varying,
  last_name character varying,
  credentials character varying,
  title character varying,
  employer character varying,
  dwfi_affiliation character varying,
  email character varying,
  phone character varying,
  website character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE people;