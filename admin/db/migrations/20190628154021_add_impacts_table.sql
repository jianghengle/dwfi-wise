-- +micrate Up
CREATE TABLE impacts(
  id BIGSERIAL PRIMARY KEY,
  impact_indicator character varying,
  number_field INTEGER,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE impacts;