-- +goose Up
-- +goose StatementBegin
CREATE TABLE questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject_id UUID NOT NULL REFERENCES subjects(id),
    created_by UUID NOT NULL REFERENCES users(id),
    question_text TEXT NOT NULL,
    explanation TEXT,
    options JSONB NOT NULL,
    correct_answer INTEGER NOT NULL,
    difficulty difficulty_level NOT NULL DEFAULT 'medium',
    status question_status NOT NULL DEFAULT 'draft',
    tags TEXT[] NOT NULL DEFAULT '{}',
    metadata JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT valid_correct_answer CHECK (correct_answer >= 0 AND correct_answer < jsonb_array_length(options, 1))
);

CREATE TABLE question_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES questions(id),
    reviewed_by UUID NOT NULL REFERENCES users(id),
    status VARCHAR(20) NOT NULL,
    feedback TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_questions_subject ON questions(subject_id);
CREATE INDEX idx_questions_status ON questions(status);
CREATE INDEX idx_questions_created_by ON questions(created_by);
CREATE INDEX idx_questions_difficulty ON questions(difficulty);
CREATE INDEX idx_question_reviews_question ON question_reviews(question_id);

CREATE TRIGGER set_timestamp_questions
    BEFORE UPDATE ON questions
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER set_timestamp_question_reviews
    BEFORE UPDATE ON question_reviews
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TRIGGER IF EXISTS set_timestamp_question_reviews ON question_reviews;
DROP TRIGGER IF EXISTS set_timestamp_questions ON questions;
DROP INDEX IF EXISTS idx_question_reviews_question;
DROP INDEX IF EXISTS idx_questions_difficulty;
DROP INDEX IF EXISTS idx_questions_created_by;
DROP INDEX IF EXISTS idx_questions_status;
DROP INDEX IF EXISTS idx_questions_subject;
DROP TABLE IF EXISTS question_reviews;
DROP TABLE IF EXISTS questions;
-- +goose StatementEnd
