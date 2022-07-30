-- Script Versão 1.0

--
-- Banco de dados: "equaly_db"
--
START TRANSACTION;
-- --------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS "equaly_db";
--
-- Estrutura para tabela "department"
--

CREATE TABLE IF NOT EXISTS equaly_db."department" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "name" VARCHAR(64) NOT NULL UNIQUE,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP NULL DEFAULT NULL,
  "deleted_at" TIMESTAMP NULL DEFAULT NULL
) ;


-- --------------------------------------------------------

--
-- Estrutura para tabela "occur_type"
--

CREATE TABLE IF NOT EXISTS equaly_db."occur_type" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "name" VARCHAR(128) NOT NULL UNIQUE,
  "created_at" TIMESTAMP NULL DEFAULT NULL,
  "updated_at" TIMESTAMP NULL DEFAULT NULL,
  "deleted_at" TIMESTAMP NULL DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Estrutura para tabela "users"
--
CREATE TYPE equaly_db.USER_TYPE AS ENUM('EVENT_OPENER','QUALITY_INSPECTOR','RNC_REPORTER','ADMIN');

CREATE TABLE IF NOT EXISTS equaly_db."user" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "is_active" BOOLEAN NOT NULL,
  "first_access" BOOLEAN NOT NULL,
  "department_id" BIGINT NOT NULL,
  "login" VARCHAR(32) NOT NULL UNIQUE,
  "name" VARCHAR(64) NOT NULL,
  "password" VARCHAR(72) NOT NULL,
  "email" VARCHAR(256) NOT NULL UNIQUE,
  "last_login_at" TIMESTAMP NULL DEFAULT NULL,
  "role" equaly_db.USER_TYPE NOT NULL,
  "avatar_id" VARCHAR(256) NULL DEFAULT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP NULL DEFAULT NULL,
  "deleted_at" TIMESTAMP NULL DEFAULT NULL
) ;

-- Adicionando Chaves Estrangeiras
	
ALTER TABLE equaly_db."user" ADD CONSTRAINT "user_fk_department_id"
	FOREIGN KEY ("department_id") REFERENCES equaly_db."department" ("id");

COMMIT;