-- +goose Up
-- +goose StatementBegin
CREATE TABLE
    subjects (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        name VARCHAR(100) NOT NULL UNIQUE,
        code VARCHAR(20) NOT NULL UNIQUE,
        exam_type exam_type NOT NULL,
        description TEXT,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW ()
    );

CREATE TRIGGER set_timestamp_subjects BEFORE
UPDATE ON subjects FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp ();

-- +goose StatementEnd
-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS subjects;

DROP TRIGGER IF EXISTS set_timestamp_subjects ON subjects;

-- +goose StatementEnd