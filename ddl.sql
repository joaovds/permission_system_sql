CREATE TABLE IF NOT EXISTS roles (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(80) NOT NULL UNIQUE,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS entity_types (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(80) NOT NULL UNIQUE,
  "description" TEXT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS permissions (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(80) NOT NULL UNIQUE,
  "description" TEXT NULL,
  "entity_type_id" INT NOT NULL REFERENCES entity_types(id) ON DELETE CASCADE,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS role_permissions (
  "role_id" INT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  "permission_id" INT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
  PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS users (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(120) NOT NULL,
  "email" VARCHAR(255) NOT NULL UNIQUE,
  "password" VARCHAR(255) NOT NULL,
  "is_active" BOOLEAN DEFAULT 'true',
  "role_id" INT REFERENCES roles(id) ON DELETE SET NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
  "deleted_at" TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);

CREATE TABLE IF NOT EXISTS entity_permissions (
  "id" SERIAL PRIMARY KEY,
  "entity_id" INT NOT NULL,
  "user_id" INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  "permission_id" INT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
  "is_denied" BOOLEAN NOT NULL DEFAULT FALSE,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
  UNIQUE (user_id, entity_id, permission_id)
);
