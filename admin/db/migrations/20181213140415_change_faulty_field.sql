-- +micrate Up
ALTER TABLE faculty RENAME COLUMN yearJoined TO year_joined;


-- +micrate Down
ALTER TABLE faculty RENAME COLUMN year_joined TO yearJoined;
