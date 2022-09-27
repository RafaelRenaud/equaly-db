-- Script Versão 2.0

--
-- Banco de dados: "equaly_db"
--
START TRANSACTION;

CREATE SCHEMA IF NOT EXISTS "equaly_config";

CREATE TABLE IF NOT EXISTS equaly_config."corporation_keys"(
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "name" VARCHAR(128) NOT NULL UNIQUE,
  "alias" VARCHAR(64) NOT NULL,
  "document" CHAR(14) NOT NULL UNIQUE,
  "contact" VARCHAR(256) NOT NULL,
  "application_key" CHAR(48) NOT NULL UNIQUE,
  "is_active" BOOLEAN NOT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP DEFAULT NULL,
  "last_inactivated_at" TIMESTAMP DEFAULT NULL
);

-- --------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS "equaly_db";
--
-- Estrutura para tabela "department"
--

CREATE TABLE IF NOT EXISTS equaly_db."department" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "name" VARCHAR(64) NOT NULL UNIQUE,
  "is_active" BOOLEAN NOT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP DEFAULT NULL,
  "last_inactivated_at" TIMESTAMP DEFAULT NULL
);

--
-- Estrutura para tabela "user"
--

DROP TYPE IF EXISTS equaly_db.USER_ROLE CASCADE;
DROP TYPE IF EXISTS equaly_db.USER_SUBROLE CASCADE;

CREATE TYPE equaly_db.USER_ROLE AS ENUM('EVENT_OPENER','QUALITY_INSPECTOR','RNC_REPORTER','IT_MANAGER');
CREATE TYPE equaly_db.USER_SUBROLE AS ENUM('ADMIN','USER'); 

CREATE TABLE IF NOT EXISTS equaly_db."user" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "department_id" BIGINT NOT NULL,
  "login" VARCHAR(32) NOT NULL UNIQUE,
  "name" VARCHAR(128) NOT NULL,
  "nickname" VARCHAR(64) NOT NULL,
  "email" VARCHAR(256) NOT NULL UNIQUE,
  "password" VARCHAR(72) NOT NULL,
  "role" equaly_db.USER_ROLE NOT NULL,
  "subrole" equaly_db.USER_SUBROLE NOT NULL,
  "is_active" BOOLEAN NOT NULL,
  "first_access" BOOLEAN NOT NULL,
  "last_login_at" TIMESTAMP DEFAULT NULL,
  "avatar_id" VARCHAR(256) DEFAULT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP DEFAULT NULL,
  "last_inactivated_at" TIMESTAMP DEFAULT NULL
) ;

--
-- Estrutura para tabela "occur_type"
--

CREATE TABLE IF NOT EXISTS equaly_db."occur_type" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "name" VARCHAR(128) NOT NULL UNIQUE,
  "is_active" BOOLEAN NOT NULL,
  "created_at" TIMESTAMP DEFAULT NULL,
  "updated_at" TIMESTAMP DEFAULT NULL,
  "last_inactivated_at" TIMESTAMP DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Estrutura para tabela "file"
--

CREATE TABLE IF NOT EXISTS equaly_db."file" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "occur_id" BIGINT NOT NULL,
  "name" VARCHAR(256) NOT NULL,
  "format" VARCHAR(256) NOT NULL,
  "type" VARCHAR(256) NOT NULL,
  "size" VARCHAR(256) NOT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP DEFAULT NULL,
  "uri" VARCHAR(256) NOT NULL
);

--
-- Estrutura para tabela "occur"
--

DROP TYPE IF EXISTS equaly_db.PRIORITY_LEVEL CASCADE;
DROP TYPE IF EXISTS equaly_db.OCCUR_STATUS CASCADE;


CREATE TYPE equaly_db.PRIORITY_LEVEL AS ENUM('LOW','MEDIUM','HIGH','DEAFULT');
CREATE TYPE equaly_db.OCCUR_STATUS AS ENUM('OPENED','AWAITING_EDIT','CLOSED');

CREATE TABLE IF NOT EXISTS equaly_db."occur" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "type_id" BIGINT NOT NULL,
  "opener_id" BIGINT NOT NULL,
  "priority" equaly_db.PRIORITY_LEVEL NOT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "occured_at" DATE NOT NULL,
  "inspector_id" BIGINT NOT NULL,
  "reporter_name" VARCHAR(128) NOT NULL,
  "is_internal" BOOLEAN NOT NULL,
  "reporter_contact" VARCHAR(256) DEFAULT NULL,
  "receipt" VARCHAR(64) DEFAULT NULL,
  "title" VARCHAR(64) NOT NULL,
  "description" TEXT NOT NULL,
  "status" equaly_db.OCCUR_STATUS NOT NULL,
  "closed_at" TIMESTAMP DEFAULT NULL,
  "feedback" TEXT DEFAULT NULL,
  "feedback_readed_at" TIMESTAMP DEFAULT NULL,
  "rnc_opened" BOOLEAN DEFAULT NULL,
  "updated_at" TIMESTAMP DEFAULT NULL,
  "last_updated_by" BIGINT DEFAULT NULL
) ;



--
-- Estrutura para tabela "rncs"
--

DROP TYPE IF EXISTS equaly_db.RNC_STATUS CASCADE;

CREATE TYPE equaly_db.RNC_STATUS AS ENUM('OPENED','WORK_IN_PROGRESS','ROLLBACK_IN_PROGRESS','REOPENED','CLOSED');

CREATE TABLE IF NOT EXISTS equaly_db."rnc" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY ,
  "occur_id" BIGINT NOT NULL,
  "priority" equaly_db.PRIORITY_LEVEL NOT NULL,
  "inspector_id" BIGINT NOT NULL,
  "status" equaly_db.RNC_STATUS NOT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP DEFAULT NULL,
  "closed_at" TIMESTAMP DEFAULT NULL,
  "last_updated_by" BIGINT DEFAULT NULL
) ;


DROP TYPE IF EXISTS equaly_db.FORM_STATUS CASCADE;
DROP TYPE IF EXISTS equaly_db.FORM_TYPE CASCADE;

CREATE TYPE equaly_db.FORM_STATUS AS ENUM('OPENED','AWAITING_VALIDATION','AWAITING_FORM_EDITION','VALIDATION_REPROVED','AWAITING_FINALIZATION','AWAITING_EFFICACY_ANALYSIS','AWAITING_FINALIZATION_EDITION','EFFICACY_REPROVED','CLOSED');
CREATE TYPE equaly_db.FORM_TYPE AS ENUM('5W2H','ISHIKAWA');

CREATE TABLE IF NOT EXISTS equaly_db."rnc_form" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "rnc_id" BIGINT NOT NULL,
  "form_type" equaly_db.FORM_TYPE NOT NULL,
  "answerable_id" BIGINT NOT NULL,
  "answered_at" TIMESTAMP DEFAULT NULL,
  "root_cause" TEXT DEFAULT NULL,
  "secondary_cause" TEXT DEFAULT NULL,
  "action_plan_description" TEXT DEFAULT NULL,
  "action_plan_involveds" TEXT DEFAULT NULL,
  "preview_date" DATE DEFAULT NULL,
  "quality_validation" TEXT DEFAULT NULL,
  "validated_at" TIMESTAMP DEFAULT NULL,
  "answerable_implementation" TEXT DEFAULT NULL,
  "implemented_at" TIMESTAMP DEFAULT NULL,
  "quality_eficacy" TEXT DEFAULT NULL,
  "status" equaly_db.FORM_STATUS NOT NULL,
  "created_at" TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP DEFAULT NULL,
  "last_updated_by" BIGINT DEFAULT NULL,
  "closed_at" TIMESTAMP DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS equaly_db."form_5w2h"(
  "whys" VARCHAR(64)[5] NOT NULL,
  "hows" VARCHAR(64)[2] DEFAULT NULL,
  "answers" VARCHAR(128)[7] NOT NULL
) INHERITS (equaly_db."rnc_form");

CREATE TABLE IF NOT EXISTS equaly_db."form_ishikawa"(
  "problems" JSONB NOT NULL
) INHERITS (equaly_db."rnc_form");


DROP TYPE IF EXISTS equaly_db.FORM_HISTORY_TYPE CASCADE;

CREATE TYPE equaly_db.FORM_HISTORY_TYPE AS ENUM('VALIDATION','IMPLEMENTATION');

CREATE TABLE IF NOT EXISTS equaly_db."reproved_form_history" (
  "id" BIGSERIAL CHECK (id > 0) PRIMARY KEY,
  "form_id" BIGINT NOT NULL,
  "type" equaly_db.FORM_HISTORY_TYPE NOT NULL,
  "created_at" TIMESTAMP NOT NULL
);

-- Adicionando Chaves Estrangeiras

ALTER TABLE equaly_db."user" DROP CONSTRAINT IF EXISTS "user_fk_department_id";

ALTER TABLE equaly_db."user" ADD CONSTRAINT "user_fk_department_id"
  FOREIGN KEY ("department_id") REFERENCES equaly_db."department"("id");
 
ALTER TABLE equaly_db."file" DROP CONSTRAINT IF EXISTS "file_fk_occur_id";

ALTER TABLE equaly_db."file" ADD CONSTRAINT "file_fk_occur_id" FOREIGN KEY ("occur_id") REFERENCES equaly_db."occur"("id");

ALTER TABLE equaly_db."occur" DROP CONSTRAINT IF EXISTS "occur_fk_inspector_id",
DROP CONSTRAINT IF EXISTS "occur_fk_type_id",
DROP CONSTRAINT IF EXISTS "occur_fk_opener_id";

ALTER TABLE equaly_db."occur" 
  ADD CONSTRAINT "occur_fk_inspector_id"
    FOREIGN KEY ("inspector_id") REFERENCES equaly_db."user"("id"),
  ADD CONSTRAINT "occur_fk_type_id" 
  FOREIGN KEY ("type_id") REFERENCES equaly_db."occur_type"("id"),
  ADD CONSTRAINT "occur_fk_opener_id" 
  FOREIGN KEY ("opener_id") REFERENCES equaly_db."user"("id");

ALTER TABLE equaly_db."rnc" DROP CONSTRAINT IF EXISTS "rnc_fk_occur_id",
DROP CONSTRAINT IF EXISTS "rnc_fk_inspector_id";

ALTER TABLE equaly_db."rnc" 
  ADD CONSTRAINT "rnc_fk_occur_id" 
  FOREIGN KEY ("occur_id") REFERENCES equaly_db."occur"("id"),
  ADD CONSTRAINT "rnc_fk_inspector_id"
    FOREIGN KEY ("inspector_id") REFERENCES equaly_db."user"("id");
   
ALTER TABLE equaly_db."rnc_form" DROP CONSTRAINT IF EXISTS "rnc_form_fk_rnc_id",
DROP CONSTRAINT IF EXISTS "rnc_form_fk_answerable_id";

ALTER TABLE equaly_db."rnc_form" ADD CONSTRAINT "rnc_form_fk_rnc_id"
  FOREIGN KEY ("rnc_id") REFERENCES equaly_db."rnc"("id"),
  ADD CONSTRAINT "rnc_form_fk_answerable_id" 
  FOREIGN KEY ("answerable_id") REFERENCES equaly_db."user"("id");
 
ALTER TABLE equaly_db."reproved_form_history" DROP CONSTRAINT IF EXISTS "reproved_form_history_fk_form_id";

ALTER TABLE equaly_db."reproved_form_history" ADD CONSTRAINT "reproved_form_history_fk_form_id" 
  FOREIGN KEY ("form_id") REFERENCES equaly_db."rnc_form"("id");

COMMIT;