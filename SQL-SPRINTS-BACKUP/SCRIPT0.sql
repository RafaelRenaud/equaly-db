-- Script Versão 2.0

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
-- Estrutura para tabela "file"
--

CREATE TABLE IF NOT EXISTS equaly_db."file" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "occur_id" BIGINT NOT NULL,
  "name" VARCHAR(128)  NOT NULL,
  "format" VARCHAR(128)  NOT NULL,
  "type" VARCHAR(128)  NOT NULL,
  "size" VARCHAR(128)  NOT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP NULL DEFAULT NULL,
  "content" BYTEA NOT NULL
) ;

--
-- Estrutura para tabela "occur"
--

CREATE TYPE equaly_db.PRIORITY_LEVEL AS ENUM('LOW','MEDIUM','HIGH','DEAFULT');
CREATE TYPE equaly_db.OCCUR_STATUS AS ENUM('OCCUR_OPENED','OCCUR_CLOSED');

CREATE TABLE IF NOT EXISTS equaly_db."occur" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "type_id" BIGINT NOT NULL,
  "opener_id" BIGINT NOT NULL,
  "priority" equaly_db.PRIORITY_LEVEL NOT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "occured_at" DATE NOT NULL,
  "inspector_id" BIGINT NOT NULL,
  "author" VARCHAR(128)  NOT NULL,
  "author_document" VARCHAR(64)  DEFAULT NULL,
  "author_contact" VARCHAR(128)  DEFAULT NULL,
  "nf" VARCHAR(64)  DEFAULT NULL,
  "title" VARCHAR(64)  NOT NULL,
  "description" TEXT  NOT NULL,
  "status" equaly_db.OCCUR_STATUS NOT NULL,
  "closed_at" TIMESTAMP NULL DEFAULT NULL,
  "feedback" TEXT  DEFAULT NULL,
  "feedback_flag" BOOLEAN DEFAULT NULL,
  "feedback_readed_at" TIMESTAMP NULL DEFAULT NULL,
  "rnc_opened" BOOLEAN DEFAULT NULL,
  "updated_at" TIMESTAMP NULL DEFAULT NULL
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
-- Estrutura para tabela "rncs"
--

CREATE TYPE equaly_db.RNC_STATUS AS ENUM('RNC_OPENED','RNC_WAITING_PA_VALIDATION','RNC_PA_REPROVED','RNC_WAITING_FINALIZATION','RNC_WAITING_CLOSE','RNC_CLOSE_REPROVED','RNC_CLOSED');

CREATE TABLE IF NOT EXISTS equaly_db."rnc" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY ,
  "occur_id" BIGINT NOT NULL,
  "inspector_id" BIGINT NOT NULL,
  "reporter_id" BIGINT NOT NULL,
  "5w" JSON DEFAULT NULL,
  "preview_date" DATE DEFAULT NULL,
  "reported_at" TIMESTAMP NULL DEFAULT NULL,
  "validation" TEXT  DEFAULT NULL,
  "validated_at" TIMESTAMP NULL DEFAULT NULL,
  "implementation" TEXT  DEFAULT NULL,
  "implemented_at" TIMESTAMP NULL DEFAULT NULL,
  "eficacy" TEXT  DEFAULT NULL,
  "closed_at" TIMESTAMP NULL DEFAULT NULL,
  "status" equaly_db.RNC_STATUS NOT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP NULL DEFAULT NULL
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
  "nickname" VARCHAR(32) NOT NULL,
  "password" VARCHAR(60) NOT NULL,
  "email" VARCHAR(128) NOT NULL UNIQUE,
  "last_login_at" TIMESTAMP NULL DEFAULT NULL,
  "role" equaly_db.USER_TYPE NOT NULL,
  "avatar" BYTEA NULL,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP NULL DEFAULT NULL,
  "deleted_at" TIMESTAMP NULL DEFAULT NULL
) ;

-- Adicionando Chaves Estrangeiras
ALTER TABLE equaly_db."file" ADD CONSTRAINT "file_fk_occur_id" FOREIGN KEY ("occur_id") REFERENCES equaly_db."occur"("id");

ALTER TABLE equaly_db."occur" ADD CONSTRAINT "occur_fk_inspector_id"
    FOREIGN KEY ("inspector_id") REFERENCES equaly_db."user"("id"),
  ADD CONSTRAINT "occur_fk_type_id" 
	FOREIGN KEY ("type_id") REFERENCES equaly_db."occur_type"("id"),
  ADD CONSTRAINT "occur_fk_opener_id" 
	FOREIGN KEY ("opener_id") REFERENCES equaly_db."user"("id");

ALTER TABLE equaly_db."rnc" ADD CONSTRAINT "rnc_fk_occur_id" 
	FOREIGN KEY ("occur_id") REFERENCES equaly_db."occur"("id"),
  ADD FOREIGN KEY ("inspector_id") REFERENCES equaly_db."user"("id"),
  ADD CONSTRAINT "rnc_fk_reporter_id"
	FOREIGN KEY ("reporter_id") REFERENCES equaly_db."user"("id");
	
ALTER TABLE equaly_db."user" ADD CONSTRAINT "user_fk_department_id"
	FOREIGN KEY ("department_id") REFERENCES equaly_db."department" ("id");

COMMIT;