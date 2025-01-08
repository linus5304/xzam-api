-- +goose Up
-- +goose StatementBegin
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create enum types for better data consistency
CREATE TYPE user_role AS ENUM ('student', 'teacher', 'admin');
CREATE TYPE question_status AS ENUM ('draft', 'review', 'published', 'archived');
CREATE TYPE exam_type AS ENUM ('gce_ol', 'gce_al');
CREATE TYPE difficulty_level AS ENUM ('easy', 'medium', 'hard');

-- Create timestamp trigger function
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP FUNCTION IF EXISTS trigger_set_timestamp();
DROP TYPE IF EXISTS difficulty_level;
DROP TYPE IF EXISTS exam_type;
DROP TYPE IF EXISTS question_status;
DROP TYPE IF EXISTS user_role;
DROP EXTENSION IF EXISTS "uuid-ossp";
-- +goose StatementEnd
