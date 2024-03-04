-- SCHEMA: equaly_app
-- OBSERVATION: RUN THIS SCRIPT AS USER EQUALY_ADMIN

-- DROP SCHEMA IF EXISTS equaly_app ;


CREATE SCHEMA IF NOT EXISTS equaly_app
    AUTHORIZATION equaly_admin;

COMMENT ON SCHEMA equaly_app
    IS 'eQualy Core Application Database Schema';

GRANT USAGE ON SCHEMA equaly_app TO equaly;

GRANT ALL ON SCHEMA equaly_app TO equaly_admin;

BEGIN;

DROP TYPE IF EXISTS "equaly_app".OCCUR_STATUS CASCADE;
CREATE TYPE "equaly_app".OCCUR_STATUS AS ENUM('OPENED','AWAITING_EDIT','AWAITING_FEEDBACK','CLOSED');

DROP TYPE IF EXISTS "equaly_app".OCCUR_PRIORITY CASCADE;
CREATE TYPE "equaly_app".OCCUR_PRIORITY AS ENUM('LOW','MEDIUM','HIGH');

CREATE TABLE IF NOT EXISTS "equaly_app"."OCCUR" (
	"ID" BIGSERIAL CHECK ("ID" > 0) PRIMARY KEY,
    "CORPORATION_ID" BIGINT NOT NULL,
    "TYPE_ID" BIGINT NOT NULL,
    "OPENER_ID" BIGINT NOT NULL,
	"PRIORITY" "equaly_app".OCCUR_PRIORITY NOT NULL,
	"CREATED_AT" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "CREATED_BY" VARCHAR(128) NOT NULL,
    "OCCURED_DATE" DATE NOT NULL,
    "INSPECTOR_ID" BIGINT DEFAULT NULL,
    "INTERNAL_OCCUR" BOOLEAN NOT NULL,
    "CLIENT_NAME" VARCHAR(128) DEFAULT NULL,
    "CLIENT_CONTACT" VARCHAR(256) DEFAULT NULL,
    "INVOICE_NOTES" VARCHAR ARRAY DEFAULT NULL,
    "TITLE" VARCHAR(64) NOT NULL,
    "DESCRIPTION" TEXT NOT NULL,
    "FILE_ID" VARCHAR ARRAY DEFAULT NULL,
    "STATUS" "equaly_app".OCCUR_STATUS NOT NULL,
    "CLOSED_AT" TIMESTAMP DEFAULT NULL,
    "RNC_OPENED" BOOLEAN DEFAULT NULL,
    "CLIENT_FEEDBACK" TEXT DEFAULT NULL,
    "FEEDBACK_AT" TIMESTAMP DEFAULT NULL,
	"UPDATED_AT" TIMESTAMP DEFAULT NULL,
    "UPDATED_BY" VARCHAR(128) DEFAULT NULL
);

ALTER TABLE "equaly_app"."OCCUR" DROP CONSTRAINT IF EXISTS "OCCUR_FK_CORPORATION_ID";
ALTER TABLE "equaly_app"."OCCUR" ADD CONSTRAINT "OCCUR_FK_CORPORATION_ID" FOREIGN KEY ("CORPORATION_ID") REFERENCES "equaly_iam"."CORPORATION"("ID");

ALTER TABLE "equaly_app"."OCCUR" DROP CONSTRAINT IF EXISTS "OCCUR_FK_TYPE_ID";
ALTER TABLE "equaly_app"."OCCUR" ADD CONSTRAINT "OCCUR_FK_TYPE_ID" FOREIGN KEY ("TYPE_ID") REFERENCES "equaly_adm"."OCCUR_TYPE"("ID");

ALTER TABLE "equaly_app"."OCCUR" DROP CONSTRAINT IF EXISTS "OCCUR_FK_OPENER_ID";
ALTER TABLE "equaly_app"."OCCUR" ADD CONSTRAINT "OCCUR_FK_OPENER_ID" FOREIGN KEY ("OPENER_ID") REFERENCES "equaly_adm"."USER"("ID");

ALTER TABLE "equaly_app"."OCCUR" DROP CONSTRAINT IF EXISTS "OCCUR_FK_INSPECTOR_ID";
ALTER TABLE "equaly_app"."OCCUR" ADD CONSTRAINT "OCCUR_FK_INSPECTOR_ID" FOREIGN KEY ("INSPECTOR_ID") REFERENCES "equaly_adm"."USER"("ID");


CREATE TABLE IF NOT EXISTS "equaly_app"."OCCUR_FILE" (
	"ID" BIGSERIAL CHECK ("ID" > 0) PRIMARY KEY,
    "CORPORATION_ID" BIGINT NOT NULL,
    "OCCUR_ID" BIGINT NOT NULL,
    "NAME" VARCHAR NOT NULL,
    "FORMAT" VARCHAR NOT NULL,
    "TYPE" VARCHAR NOT NULL,
    "SIZE" VARCHAR NOT NULL,
    "GNID" VARCHAR NOT NULL UNIQUE,
    "UPLOADED_AT" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UPLOADED_BY" VARCHAR(128) NOT NULL,
    "UPDATED_AT" TIMESTAMP DEFAULT NULL,
    "UPDATED_BY" VARCHAR(128) DEFAULT NULL
);

ALTER TABLE "equaly_app"."OCCUR_FILE" DROP CONSTRAINT IF EXISTS "OCCUR_FILE_FK_CORPORATION_ID";
ALTER TABLE "equaly_app"."OCCUR_FILE" ADD CONSTRAINT "OCCUR_FILE_FK_CORPORATION_ID" FOREIGN KEY ("CORPORATION_ID") REFERENCES "equaly_iam"."CORPORATION"("ID");

ALTER TABLE "equaly_app"."OCCUR_FILE" DROP CONSTRAINT IF EXISTS "OCCUR_FILE_FK_OCCUR_ID";
ALTER TABLE "equaly_app"."OCCUR_FILE" ADD CONSTRAINT "OCCUR_FILE_FK_OCCUR_ID" FOREIGN KEY ("OCCUR_ID") REFERENCES "equaly_app"."OCCUR"("ID");

COMMIT;