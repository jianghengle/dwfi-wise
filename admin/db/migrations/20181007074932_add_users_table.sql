-- +micrate Up
CREATE TABLE users(
  id BIGSERIAL PRIMARY KEY,
  email character varying NOT NULL,
  encrypted_password character varying,
  auth_token character varying,
  privileges character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);


-- +micrate Down
DROP TABLE users;