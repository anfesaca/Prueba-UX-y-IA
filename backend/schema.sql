-- GH30 Green House 2030 — Database Schema
-- PostgreSQL 16 — puerto 5433
-- Ejecutar en pgAdmin: selecciona la BD "gh30" → Tools → Query Tool → pega esto → F5

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS users (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        VARCHAR(200) NOT NULL,
    email       VARCHAR(200) UNIQUE NOT NULL,
    role        VARCHAR(20) DEFAULT 'student' CHECK (role IN ('student','admin')),
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS modules (
    id          SERIAL PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    subtitle    VARCHAR(200),
    difficulty  VARCHAR(50),
    time_min    INT,
    video_key   VARCHAR(500),
    pdf_key     VARCHAR(500),
    "order"     INT UNIQUE,
    active      BOOLEAN DEFAULT true
);

INSERT INTO modules (title, subtitle, difficulty, time_min, "order") VALUES
('El Corazón del Sistema',      'ISO 14001:2015 y PHVA',           'Básica',     15, 1),
('Liderazgo y Responsabilidad', 'Roles, canal #911',                'Básica',     12, 2),
('Aspectos e Impactos',         'De la acción a la consecuencia',   'Media',      18, 3),
('Los 3 Pilares de Misión Verde','Ecoeficiencia, residuos y compras','Media/Alta', 20, 4)
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS questions (
    id          SERIAL PRIMARY KEY,
    module_id   INT REFERENCES modules(id),
    text        TEXT NOT NULL,
    options     JSONB NOT NULL,
    correct     INT NOT NULL,
    explanation TEXT,
    difficulty  VARCHAR(20) DEFAULT 'Media',
    active      BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS assessment_sessions (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID,
    module_id       INT REFERENCES modules(id),
    question_ids    INT[],
    answers         INT[],
    score           INT,
    total           INT,
    passed          BOOLEAN,
    time_taken_s    INT,
    attempt_number  INT DEFAULT 1,
    completed_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_progress (
    user_id         UUID,
    module_id       INT REFERENCES modules(id),
    completed       BOOLEAN DEFAULT false,
    best_score      INT DEFAULT 0,
    attempts        INT DEFAULT 0,
    last_attempt_at TIMESTAMPTZ,
    PRIMARY KEY (user_id, module_id)
);

CREATE TABLE IF NOT EXISTS certificates (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID,
    session_id      UUID,
    score           INT,
    total           INT,
    pdf_key         VARCHAR(500),
    issued_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS chat_history (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID,
    module_id   INT REFERENCES modules(id),
    role        VARCHAR(20) CHECK (role IN ('user','assistant')),
    content     TEXT NOT NULL,
    model_used  VARCHAR(50),
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_progress_user ON user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_user ON assessment_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_chat_user_module ON chat_history(user_id, module_id);

-- Verificación: muestra las tablas creadas
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
