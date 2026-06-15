SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: kithe_models_friendlier_id_gen(bigint, bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.kithe_models_friendlier_id_gen(min_value bigint, max_value bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
  DECLARE
    new_id_int bigint;
    new_id_str character varying := '';
    done bool;
    tries integer;
    alphabet char[] := ARRAY['0','1','2','3','4','5','6','7','8','9',
      'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
      'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
    alphabet_length integer := array_length(alphabet, 1);

  BEGIN
    done := false;
    tries := 0;
    WHILE (NOT done) LOOP
      tries := tries + 1;
      IF (tries > 3) THEN
        RAISE 'Could not find non-conflicting friendlier_id in 3 tries';
      END IF;

      new_id_int := trunc(random() * (max_value - min_value) + min_value);

      -- convert bigint to a Base-36 alphanumeric string
      -- see https://web.archive.org/web/20130420084605/http://www.jamiebegin.com/base36-conversion-in-postgresql/
      -- https://gist.github.com/btbytes/7159902
      WHILE new_id_int != 0 LOOP
        new_id_str := alphabet[(new_id_int % alphabet_length)+1] || new_id_str;
        new_id_int := new_id_int / alphabet_length;
      END LOOP;

      done := NOT exists(SELECT 1 FROM kithe_models WHERE friendlier_id=new_id_str);
    END LOOP;
    RETURN new_id_str;
  END;
  $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: import_transitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.import_transitions (
    id bigint NOT NULL,
    to_state character varying NOT NULL,
    metadata text DEFAULT '{}'::text,
    sort_key integer NOT NULL,
    import_id integer NOT NULL,
    most_recent boolean NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: import_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.import_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: import_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.import_transitions_id_seq OWNED BY public.import_transitions.id;


--
-- Name: imports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.imports (
    id bigint NOT NULL,
    name character varying NOT NULL,
    source character varying,
    description text,
    filename character varying,
    row_count integer,
    headers text[] DEFAULT '{}'::text[],
    encoding character varying,
    content_type character varying,
    extension character varying,
    validity boolean DEFAULT false NOT NULL,
    validation_result text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    type character varying,
    import_log json DEFAULT '{}'::json
);


--
-- Name: imports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: imports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.imports_id_seq OWNED BY public.imports.id;


--
-- Name: kithe_derivatives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kithe_derivatives (
    id bigint NOT NULL,
    key character varying NOT NULL,
    file_data jsonb,
    asset_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: kithe_derivatives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.kithe_derivatives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: kithe_derivatives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.kithe_derivatives_id_seq OWNED BY public.kithe_derivatives.id;


--
-- Name: kithe_model_contains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kithe_model_contains (
    containee_id uuid,
    container_id uuid
);


--
-- Name: kithe_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kithe_models (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title character varying NOT NULL,
    type character varying NOT NULL,
    "position" integer,
    json_attributes jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    parent_id uuid,
    friendlier_id character varying DEFAULT public.kithe_models_friendlier_id_gen('2821109907456'::bigint, '101559956668415'::bigint) NOT NULL,
    file_data jsonb,
    representative_id uuid,
    leaf_representative_id uuid,
    kithe_model_type integer NOT NULL,
    import_id bigint
);


--
-- Name: mappings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mappings (
    id bigint NOT NULL,
    source_header character varying,
    destination_field character varying,
    delimited boolean,
    transformation_method character varying,
    import_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mappings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mappings_id_seq OWNED BY public.mappings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id uuid NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone,
    object_changes text
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: import_transitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_transitions ALTER COLUMN id SET DEFAULT nextval('public.import_transitions_id_seq'::regclass);


--
-- Name: imports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.imports ALTER COLUMN id SET DEFAULT nextval('public.imports_id_seq'::regclass);


--
-- Name: kithe_derivatives id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kithe_derivatives ALTER COLUMN id SET DEFAULT nextval('public.kithe_derivatives_id_seq'::regclass);


--
-- Name: mappings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mappings ALTER COLUMN id SET DEFAULT nextval('public.mappings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: import_transitions import_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_transitions
    ADD CONSTRAINT import_transitions_pkey PRIMARY KEY (id);


--
-- Name: imports imports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.imports
    ADD CONSTRAINT imports_pkey PRIMARY KEY (id);


--
-- Name: kithe_derivatives kithe_derivatives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kithe_derivatives
    ADD CONSTRAINT kithe_derivatives_pkey PRIMARY KEY (id);


--
-- Name: kithe_models kithe_models_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kithe_models
    ADD CONSTRAINT kithe_models_pkey PRIMARY KEY (id);


--
-- Name: mappings mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mappings
    ADD CONSTRAINT mappings_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_import_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_import_transitions_parent_most_recent ON public.import_transitions USING btree (import_id, most_recent) WHERE most_recent;


--
-- Name: index_import_transitions_parent_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_import_transitions_parent_sort ON public.import_transitions USING btree (import_id, sort_key);


--
-- Name: index_kithe_derivatives_on_asset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_kithe_derivatives_on_asset_id ON public.kithe_derivatives USING btree (asset_id);


--
-- Name: index_kithe_derivatives_on_asset_id_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_kithe_derivatives_on_asset_id_and_key ON public.kithe_derivatives USING btree (asset_id, key);


--
-- Name: index_kithe_model_contains_on_containee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_kithe_model_contains_on_containee_id ON public.kithe_model_contains USING btree (containee_id);


--
-- Name: index_kithe_model_contains_on_container_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_kithe_model_contains_on_container_id ON public.kithe_model_contains USING btree (container_id);


--
-- Name: index_kithe_models_on_friendlier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_kithe_models_on_friendlier_id ON public.kithe_models USING btree (friendlier_id);


--
-- Name: index_kithe_models_on_import_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_kithe_models_on_import_id ON public.kithe_models USING btree (import_id);


--
-- Name: index_kithe_models_on_leaf_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_kithe_models_on_leaf_representative_id ON public.kithe_models USING btree (leaf_representative_id);


--
-- Name: index_kithe_models_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_kithe_models_on_parent_id ON public.kithe_models USING btree (parent_id);


--
-- Name: index_kithe_models_on_representative_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_kithe_models_on_representative_id ON public.kithe_models USING btree (representative_id);


--
-- Name: index_mappings_on_import_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mappings_on_import_id ON public.mappings USING btree (import_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);

--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: kithe_model_contains fk_rails_091010187b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kithe_model_contains
    ADD CONSTRAINT fk_rails_091010187b FOREIGN KEY (container_id) REFERENCES public.kithe_models(id);


--
-- Name: kithe_derivatives fk_rails_3dac8b4201; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kithe_derivatives
    ADD CONSTRAINT fk_rails_3dac8b4201 FOREIGN KEY (asset_id) REFERENCES public.kithe_models(id);


--
-- Name: kithe_models fk_rails_403cce5c0d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kithe_models
    ADD CONSTRAINT fk_rails_403cce5c0d FOREIGN KEY (leaf_representative_id) REFERENCES public.kithe_models(id);


--
-- Name: kithe_model_contains fk_rails_490c1158f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kithe_model_contains
    ADD CONSTRAINT fk_rails_490c1158f7 FOREIGN KEY (containee_id) REFERENCES public.kithe_models(id);


--
-- Name: kithe_models fk_rails_90130a9780; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kithe_models
    ADD CONSTRAINT fk_rails_90130a9780 FOREIGN KEY (parent_id) REFERENCES public.kithe_models(id);


--
-- Name: kithe_models fk_rails_afa93b7b5d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kithe_models
    ADD CONSTRAINT fk_rails_afa93b7b5d FOREIGN KEY (representative_id) REFERENCES public.kithe_models(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: import_transitions fk_rails_e10d6cb765; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_transitions
    ADD CONSTRAINT fk_rails_e10d6cb765 FOREIGN KEY (import_id) REFERENCES public.imports(id);


--
-- Name: mappings fk_rails_eff9d46a25; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mappings
    ADD CONSTRAINT fk_rails_eff9d46a25 FOREIGN KEY (import_id) REFERENCES public.imports(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200127213631'),
('20200127213632'),
('20200127213633'),
('20200127213634'),
('20200127213635'),
('20200127213636'),
('20200127213637'),
('20200127213638'),
('20200322214159'),
('20200326193145'),
('20200326212815'),
('20200428184517'),
('20200428194419'),
('20200429182712'),
('20200501143805'),
('20200501153955'),
('20200522141137'),
('20200522154119'),
('20200529173739'),
('20200626194058');


