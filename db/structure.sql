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


SET search_path = public, pg_catalog;

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
    externalid__c character varying(36),
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
    account__externalid__c character varying(36),
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

CREATE UNIQUE INDEX hcu_idx_account_externalid__c ON account USING btree (externalid__c);


--
-- Name: hcu_idx_account_sfid; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE UNIQUE INDEX hcu_idx_account_sfid ON account USING btree (sfid);


--
-- Name: hcu_idx_contact_sfid; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE UNIQUE INDEX hcu_idx_contact_sfid ON contact USING btree (sfid);


--
-- Name: idx_contact_account__externalid__c; Type: INDEX; Schema: salesforce; Owner: -
--

CREATE INDEX idx_contact_account__externalid__c ON contact USING btree (account__externalid__c);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160613120134');

INSERT INTO schema_migrations (version) VALUES ('20160614113646');

INSERT INTO schema_migrations (version) VALUES ('20160614113653');

INSERT INTO schema_migrations (version) VALUES ('20160614114454');

