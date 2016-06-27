--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: salesforce; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA salesforce;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: externalid_uuid_proc(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION externalid_uuid_proc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        DECLARE
          externalid_column varchar;
          oldxmlbinary varchar;
        BEGIN
          -- Get external ID column name
          IF TG_ARGV[0] IS NOT NULL THEN
            externalid_column := TG_ARGV[0]::text;
          ELSE
            externalid_column := 'externalid__c';
          END IF;

          -- Save old value
          oldxmlbinary := get_xmlbinary();

          -- Change value to ensure writing to _trigger_log is enabled
          EXECUTE format('SET SESSION xmlbinary TO base64');

          -- Update the external ID
          EXECUTE format('UPDATE %I.%I SET %I = %L WHERE %I = %L', TG_TABLE_SCHEMA, TG_TABLE_NAME, externalid_column, uuid_generate_v4(), 'id', NEW.id);

          -- Reset the value
          EXECUTE format('SET SESSION xmlbinary TO %L', oldxmlbinary);

          RETURN NEW;
        END;
      $$;


--
-- Name: get_xmlbinary(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION get_xmlbinary() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
        DECLARE
          xmlbin varchar;
        BEGIN
          select into xmlbin setting from pg_settings where name='xmlbinary';
          RETURN xmlbin;
        END;
      $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


SET search_path = salesforce, pg_catalog;

--
-- Name: account; Type: TABLE; Schema: salesforce; Owner: -
--

CREATE TABLE account (
    id integer NOT NULL,
    sfid character varying(18),
    name character varying(255),
    phone character varying(40),
    website character varying(255),
    externalid__c character varying(36) DEFAULT ''::character varying,
    isdeleted boolean,
    createddate timestamp without time zone,
    systemmodstamp timestamp without time zone,
    _hc_lastop character varying(32),
    _hc_err text
);


--
-- Name: account_id_seq; Type: SEQUENCE; Schema: salesforce; Owner: -
--

CREATE SEQUENCE account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: salesforce; Owner: -
--

ALTER SEQUENCE account_id_seq OWNED BY account.id;


--
-- Name: contact; Type: TABLE; Schema: salesforce; Owner: -
--

CREATE TABLE contact (
    id integer NOT NULL,
    sfid character varying(18),
    accountid character varying(18),
    name character varying(121),
    email character varying(80),
    firstname character varying(40),
    lastname character varying(80),
    account__externalid__c character varying(36) DEFAULT ''::character varying,
    isdeleted boolean,
    createddate timestamp without time zone,
    systemmodstamp timestamp without time zone,
    _hc_lastop character varying(32),
    _hc_err text
);


--
-- Name: contact_id_seq; Type: SEQUENCE; Schema: salesforce; Owner: -
--

CREATE SEQUENCE contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_id_seq; Type: SEQUENCE OWNED BY; Schema: salesforce; Owner: -
--

ALTER SEQUENCE contact_id_seq OWNED BY contact.id;


--
-- Name: id; Type: DEFAULT; Schema: salesforce; Owner: -
--

ALTER TABLE ONLY account ALTER COLUMN id SET DEFAULT nextval('account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: salesforce; Owner: -
--

ALTER TABLE ONLY contact ALTER COLUMN id SET DEFAULT nextval('contact_id_seq'::regclass);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: salesforce; Owner: -
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: salesforce; Owner: -
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


SET search_path = public, pg_catalog;

--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


SET search_path = salesforce, pg_catalog;

--
-- Name: hc_idx_account_systemmodstamp; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE INDEX hc_idx_account_systemmodstamp ON account USING btree (systemmodstamp);


--
-- Name: hc_idx_contact_accountid; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE INDEX hc_idx_contact_accountid ON contact USING btree (accountid);


--
-- Name: hc_idx_contact_systemmodstamp; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE INDEX hc_idx_contact_systemmodstamp ON contact USING btree (systemmodstamp);


--
-- Name: hcu_idx_account_externalid__c; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE UNIQUE INDEX hcu_idx_account_externalid__c ON account USING btree (externalid__c) WHERE ((externalid__c)::text <> ''::text);


--
-- Name: hcu_idx_account_sfid; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE UNIQUE INDEX hcu_idx_account_sfid ON account USING btree (sfid);


--
-- Name: hcu_idx_contact_sfid; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE UNIQUE INDEX hcu_idx_contact_sfid ON contact USING btree (sfid);


--
-- Name: idx_account_sfid_externalid__c; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE UNIQUE INDEX idx_account_sfid_externalid__c ON account USING btree (sfid, externalid__c);


--
-- Name: idx_contact_account__externalid__c; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE INDEX idx_contact_account__externalid__c ON contact USING btree (account__externalid__c);


--
-- Name: account_externalid_trigger; Type: TRIGGER; Schema: salesforce; Owner: -
--

CREATE TRIGGER account_externalid_trigger AFTER INSERT OR UPDATE ON account FOR EACH ROW WHEN ((NULLIF(btrim((new.externalid__c)::text), ''::text) IS NULL)) EXECUTE PROCEDURE public.externalid_uuid_proc();


--
-- Name: fk_contact_accountid_account__externalid__c; Type: FK CONSTRAINT; Schema: salesforce; Owner: -
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT fk_contact_accountid_account__externalid__c FOREIGN KEY (accountid, account__externalid__c) REFERENCES account(sfid, externalid__c) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160613120134');

INSERT INTO schema_migrations (version) VALUES ('20160614113646');

INSERT INTO schema_migrations (version) VALUES ('20160614113653');

INSERT INTO schema_migrations (version) VALUES ('20160614114454');

INSERT INTO schema_migrations (version) VALUES ('20160616170707');

INSERT INTO schema_migrations (version) VALUES ('20160616171054');

INSERT INTO schema_migrations (version) VALUES ('20160616225802');

INSERT INTO schema_migrations (version) VALUES ('20160616225941');

INSERT INTO schema_migrations (version) VALUES ('20160627103927');

INSERT INTO schema_migrations (version) VALUES ('20160627105702');

INSERT INTO schema_migrations (version) VALUES ('20160627105844');

INSERT INTO schema_migrations (version) VALUES ('20160627110535');

