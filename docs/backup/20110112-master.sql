--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: catmaid_user
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO catmaid_user;

SET search_path = public, pg_catalog;

--
-- Name: double3d; Type: TYPE; Schema: public; Owner: catmaid_user
--

CREATE TYPE double3d AS (
	x double precision,
	y double precision,
	z double precision
);


ALTER TYPE public.double3d OWNER TO catmaid_user;

--
-- Name: integer3d; Type: TYPE; Schema: public; Owner: catmaid_user
--

CREATE TYPE integer3d AS (
	x integer,
	y integer,
	z integer
);


ALTER TYPE public.integer3d OWNER TO catmaid_user;

--
-- Name: rgba; Type: TYPE; Schema: public; Owner: catmaid_user
--

CREATE TYPE rgba AS (
	r real,
	g real,
	b real,
	a real
);


ALTER TYPE public.rgba OWNER TO catmaid_user;

--
-- Name: on_edit(); Type: FUNCTION; Schema: public; Owner: catmaid_user
--

CREATE FUNCTION on_edit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

    NEW."edition_time" := now();

    RETURN NEW;

END;

$$;


ALTER FUNCTION public.on_edit() OWNER TO catmaid_user;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bezierkey; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE bezierkey (
    key point NOT NULL,
    before point,
    after point,
    profile_id integer
);


ALTER TABLE public.bezierkey OWNER TO catmaid_user;

--
-- Name: COLUMN bezierkey.key; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON COLUMN bezierkey.key IS 'nanometer';


--
-- Name: profile; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE profile (
    id integer NOT NULL,
    z double precision NOT NULL,
    object_id integer
);


ALTER TABLE public.profile OWNER TO catmaid_user;

--
-- Name: profile_id_seq; Type: SEQUENCE; Schema: public; Owner: catmaid_user
--

CREATE SEQUENCE profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.profile_id_seq OWNER TO catmaid_user;

--
-- Name: profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catmaid_user
--

ALTER SEQUENCE profile_id_seq OWNED BY profile.id;


--
-- Name: profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catmaid_user
--

SELECT pg_catalog.setval('profile_id_seq', 1, false);


--
-- Name: bezierprofile; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE bezierprofile (
)
INHERITS (profile);


ALTER TABLE public.bezierprofile OWNER TO catmaid_user;

--
-- Name: broken_slice; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE broken_slice (
    stack_id integer NOT NULL,
    index integer NOT NULL
);


ALTER TABLE public.broken_slice OWNER TO catmaid_user;

--
-- Name: concept; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE concept (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    creation_time timestamp with time zone DEFAULT now() NOT NULL,
    edition_time timestamp with time zone DEFAULT now() NOT NULL,
    project_id bigint NOT NULL
);


ALTER TABLE public.concept OWNER TO catmaid_user;

--
-- Name: concept_id_seq; Type: SEQUENCE; Schema: public; Owner: catmaid_user
--

CREATE SEQUENCE concept_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.concept_id_seq OWNER TO catmaid_user;

--
-- Name: concept_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catmaid_user
--

ALTER SEQUENCE concept_id_seq OWNED BY concept.id;


--
-- Name: concept_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catmaid_user
--

SELECT pg_catalog.setval('concept_id_seq', 1501, true);


--
-- Name: class; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE class (
    class_name character varying(255) NOT NULL,
    uri character varying(2048),
    description text,
    showintree boolean DEFAULT true
)
INHERITS (concept);


ALTER TABLE public.class OWNER TO catmaid_user;

--
-- Name: COLUMN class.showintree; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON COLUMN class.showintree IS 'does the element appear in the class tree widget?';


--
-- Name: relation_instance; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE relation_instance (
    relation_id bigint NOT NULL
)
INHERITS (concept);


ALTER TABLE public.relation_instance OWNER TO catmaid_user;

--
-- Name: TABLE relation_instance; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON TABLE relation_instance IS 'despite the table names, it is an abstract table only used for inheritance';


--
-- Name: class_class; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE class_class (
    class_a bigint,
    class_b bigint
)
INHERITS (relation_instance);


ALTER TABLE public.class_class OWNER TO catmaid_user;

--
-- Name: TABLE class_class; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON TABLE class_class IS 'relates two classes';


--
-- Name: class_instance; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE class_instance (
    class_id bigint NOT NULL,
    name character varying(255) NOT NULL
)
INHERITS (concept);


ALTER TABLE public.class_instance OWNER TO catmaid_user;

--
-- Name: class_instance_class_instance; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE class_instance_class_instance (
    class_instance_a bigint,
    class_instance_b bigint
)
INHERITS (relation_instance);


ALTER TABLE public.class_instance_class_instance OWNER TO catmaid_user;

--
-- Name: TABLE class_instance_class_instance; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON TABLE class_instance_class_instance IS 'relates two class_instances';


--
-- Name: location; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE location (
    location double3d NOT NULL
)
INHERITS (concept);


ALTER TABLE public.location OWNER TO catmaid_user;

--
-- Name: connector; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE connector (
    confidence integer DEFAULT 5 NOT NULL
)
INHERITS (location);


ALTER TABLE public.connector OWNER TO catmaid_user;

--
-- Name: connector_class_instance; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE connector_class_instance (
    location_id bigint NOT NULL,
    class_instance_id bigint NOT NULL
)
INHERITS (relation_instance);


ALTER TABLE public.connector_class_instance OWNER TO catmaid_user;

--
-- Name: message; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE message (
    id integer NOT NULL,
    user_id integer NOT NULL,
    "time" timestamp with time zone DEFAULT now() NOT NULL,
    read boolean DEFAULT false NOT NULL,
    title text DEFAULT 'New message'::text NOT NULL,
    text text,
    action text
);


ALTER TABLE public.message OWNER TO catmaid_user;

--
-- Name: COLUMN message.action; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON COLUMN message.action IS 'URL to be executed (remember that this is not safe against man in the middle when not encrypted)';


--
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: catmaid_user
--

CREATE SEQUENCE message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.message_id_seq OWNER TO catmaid_user;

--
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catmaid_user
--

ALTER SEQUENCE message_id_seq OWNED BY message.id;


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catmaid_user
--

SELECT pg_catalog.setval('message_id_seq', 1, false);


--
-- Name: object; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE object (
    id integer NOT NULL,
    class character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    project_id integer NOT NULL,
    colour rgba DEFAULT ROW((1)::real, (0.5)::real, (0)::real, (0.75)::real) NOT NULL
);


ALTER TABLE public.object OWNER TO catmaid_user;

--
-- Name: object_id_seq; Type: SEQUENCE; Schema: public; Owner: catmaid_user
--

CREATE SEQUENCE object_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.object_id_seq OWNER TO catmaid_user;

--
-- Name: object_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catmaid_user
--

ALTER SEQUENCE object_id_seq OWNED BY object.id;


--
-- Name: object_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catmaid_user
--

SELECT pg_catalog.setval('object_id_seq', 1, false);


--
-- Name: project; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE project (
    id integer NOT NULL,
    title text NOT NULL,
    public boolean DEFAULT true NOT NULL
);


ALTER TABLE public.project OWNER TO catmaid_user;

--
-- Name: project_id_seq; Type: SEQUENCE; Schema: public; Owner: catmaid_user
--

CREATE SEQUENCE project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.project_id_seq OWNER TO catmaid_user;

--
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catmaid_user
--

ALTER SEQUENCE project_id_seq OWNED BY project.id;


--
-- Name: project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catmaid_user
--

SELECT pg_catalog.setval('project_id_seq', 3, true);


--
-- Name: project_stack; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE project_stack (
    project_id integer NOT NULL,
    stack_id integer NOT NULL,
    translation double3d DEFAULT ROW((0)::double precision, (0)::double precision, (0)::double precision) NOT NULL
);


ALTER TABLE public.project_stack OWNER TO catmaid_user;

--
-- Name: COLUMN project_stack.translation; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON COLUMN project_stack.translation IS 'nanometer';


--
-- Name: project_user; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE project_user (
    project_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.project_user OWNER TO catmaid_user;

--
-- Name: relation; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE relation (
    relation_name character varying(255) NOT NULL,
    uri text,
    description text,
    isreciprocal boolean DEFAULT false NOT NULL
)
INHERITS (concept);


ALTER TABLE public.relation OWNER TO catmaid_user;

--
-- Name: COLUMN relation.isreciprocal; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON COLUMN relation.isreciprocal IS 'Is the converse of the relationship valid?';


--
-- Name: stack; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE stack (
    id integer NOT NULL,
    title text NOT NULL,
    dimension integer3d NOT NULL,
    resolution double3d NOT NULL,
    image_base text NOT NULL,
    comment text,
    trakem2_project boolean DEFAULT false NOT NULL
);


ALTER TABLE public.stack OWNER TO catmaid_user;

--
-- Name: COLUMN stack.dimension; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON COLUMN stack.dimension IS 'pixel';


--
-- Name: COLUMN stack.resolution; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON COLUMN stack.resolution IS 'nanometer per pixel';


--
-- Name: COLUMN stack.image_base; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON COLUMN stack.image_base IS 'base URL to the images';


--
-- Name: COLUMN stack.trakem2_project; Type: COMMENT; Schema: public; Owner: catmaid_user
--

COMMENT ON COLUMN stack.trakem2_project IS 'States if a TrakEM2 project file is available for this stack.';


--
-- Name: stack_id_seq; Type: SEQUENCE; Schema: public; Owner: catmaid_user
--

CREATE SEQUENCE stack_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.stack_id_seq OWNER TO catmaid_user;

--
-- Name: stack_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catmaid_user
--

ALTER SEQUENCE stack_id_seq OWNED BY stack.id;


--
-- Name: stack_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catmaid_user
--

SELECT pg_catalog.setval('stack_id_seq', 3, true);


--
-- Name: textlabel; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE textlabel (
    id integer NOT NULL,
    type character varying(32) NOT NULL,
    text text DEFAULT 'Edit this text ...'::text NOT NULL,
    colour rgba DEFAULT ROW((1)::real, (0.5)::real, (0)::real, (1)::real) NOT NULL,
    font_name text,
    font_style text,
    font_size double precision DEFAULT 32 NOT NULL,
    project_id integer NOT NULL,
    scaling boolean DEFAULT true NOT NULL,
    creation_time timestamp with time zone DEFAULT now() NOT NULL,
    edition_time timestamp with time zone DEFAULT now() NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    CONSTRAINT textlabel_type_check CHECK ((((type)::text = 'text'::text) OR ((type)::text = 'bubble'::text)))
);


ALTER TABLE public.textlabel OWNER TO catmaid_user;

--
-- Name: textlabel_id_seq; Type: SEQUENCE; Schema: public; Owner: catmaid_user
--

CREATE SEQUENCE textlabel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.textlabel_id_seq OWNER TO catmaid_user;

--
-- Name: textlabel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catmaid_user
--

ALTER SEQUENCE textlabel_id_seq OWNED BY textlabel.id;


--
-- Name: textlabel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catmaid_user
--

SELECT pg_catalog.setval('textlabel_id_seq', 23, true);


--
-- Name: textlabel_location; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE textlabel_location (
    textlabel_id integer NOT NULL,
    location double3d NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.textlabel_location OWNER TO catmaid_user;

--
-- Name: treenode; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE treenode (
    parent_id bigint,
    radius double precision DEFAULT 0 NOT NULL,
    confidence integer DEFAULT 5 NOT NULL
)
INHERITS (location);


ALTER TABLE public.treenode OWNER TO catmaid_user;

--
-- Name: treenode_class_instance; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE treenode_class_instance (
    treenode_id bigint NOT NULL,
    class_instance_id bigint NOT NULL
)
INHERITS (relation_instance);


ALTER TABLE public.treenode_class_instance OWNER TO catmaid_user;

--
-- Name: user; Type: TABLE; Schema: public; Owner: catmaid_user; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    pwd character varying(255) NOT NULL,
    longname text
);


ALTER TABLE public."user" OWNER TO catmaid_user;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: catmaid_user
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO catmaid_user;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catmaid_user
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catmaid_user
--

SELECT pg_catalog.setval('user_id_seq', 3, true);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: catmaid_user
--

ALTER TABLE concept ALTER COLUMN id SET DEFAULT nextval('concept_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: catmaid_user
--

ALTER TABLE message ALTER COLUMN id SET DEFAULT nextval('message_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: catmaid_user
--

ALTER TABLE object ALTER COLUMN id SET DEFAULT nextval('object_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: catmaid_user
--

ALTER TABLE profile ALTER COLUMN id SET DEFAULT nextval('profile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: catmaid_user
--

ALTER TABLE project ALTER COLUMN id SET DEFAULT nextval('project_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: catmaid_user
--

ALTER TABLE stack ALTER COLUMN id SET DEFAULT nextval('stack_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: catmaid_user
--

ALTER TABLE textlabel ALTER COLUMN id SET DEFAULT nextval('textlabel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: catmaid_user
--

ALTER TABLE "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Data for Name: bezierkey; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY bezierkey (key, before, after, profile_id) FROM stdin;
\.


--
-- Data for Name: bezierprofile; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY bezierprofile (id, z, object_id) FROM stdin;
\.


--
-- Data for Name: broken_slice; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY broken_slice (stack_id, index) FROM stdin;
\.


--
-- Data for Name: class; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY class (id, user_id, creation_time, edition_time, project_id, class_name, uri, description, showintree) FROM stdin;
14	1	2010-08-26 19:19:57.046457+02	2010-08-26 19:19:57.046457+02	3	skeleton	\N	\N	t
5	1	2010-08-26 18:23:53.551017+02	2010-08-26 18:23:53.551017+02	3	neuron	http://flybase.org/.bin/cvreport.html?cvterm=FBbt:00005106+childdepth=2+parentdepth=all	\N	t
106	3	2010-10-12 09:42:55.856494+02	2010-10-12 09:42:55.856494+02	3	group	\N	A group helps to organize the data, i.e. it can contain neuron or other groups.	t
33	3	2010-08-27 17:28:08.713582+02	2010-08-27 17:28:08.713582+02	3	label	\N	\N	f
107	3	2010-10-12 10:11:23.015507+02	2010-10-12 10:11:23.015507+02	3	neurongroup	\N	a group of neurons	t
112	3	2010-10-12 11:29:38.385393+02	2010-10-12 11:29:38.385393+02	3	root	\N	\N	f
12	1	2010-08-26 19:18:02.355176+02	2010-08-26 19:18:02.355176+02	3	soma	http://flybase.org/cgi-bin/cvreport.html?rel=is_a&id=FBbt:00005107	\N	t
7	3	2010-08-26 18:30:53.288021+02	2010-08-26 18:30:53.288021+02	3	synapse	http://flybase.org/.bin/cvreport.html?cvterm=GO:0045202	\N	t
755	3	2010-12-20 16:17:48.122167+01	2010-12-20 16:17:48.122167+01	3	presynapticterminal			t
756	3	2010-12-20 16:18:07.231631+01	2010-12-20 16:18:07.231631+01	3	postsynapticterminal			t
\.


--
-- Data for Name: class_class; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY class_class (id, user_id, creation_time, edition_time, project_id, relation_id, class_a, class_b) FROM stdin;
\.


--
-- Data for Name: class_instance; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY class_instance (id, user_id, creation_time, edition_time, project_id, class_id, name) FROM stdin;
1463	3	2011-01-09 13:18:52.783614+01	2011-01-09 13:18:52.80048+01	3	14	skeleton 1463
1464	3	2011-01-09 13:18:52.808709+01	2011-01-09 13:18:52.8171+01	3	5	neuron 1464
1469	3	2011-01-09 13:20:26.171649+01	2011-01-09 13:20:26.185588+01	3	14	skeleton 1469
1470	3	2011-01-09 13:20:26.193329+01	2011-01-09 13:20:26.201875+01	3	5	neuron 1470
1475	3	2011-01-09 13:20:26.360488+01	2011-01-09 13:20:26.367774+01	3	756	postsynapticterminal 1475
1479	3	2011-01-09 13:22:32.076811+01	2011-01-09 13:22:32.094304+01	3	14	skeleton 1479
1480	3	2011-01-09 13:22:32.10216+01	2011-01-09 13:22:32.110595+01	3	5	neuron 1480
1485	3	2011-01-09 13:22:32.28184+01	2011-01-09 13:22:32.284663+01	3	756	postsynapticterminal 1485
1489	3	2011-01-09 13:22:38.282834+01	2011-01-09 13:22:38.288766+01	3	7	synapse 1489
1490	3	2011-01-09 13:22:38.296926+01	2011-01-09 13:22:38.305359+01	3	755	presynapticterminal 1490
1443	3	2011-01-09 13:13:55.728496+01	2011-01-09 13:13:55.728496+01	3	112	neuro
1444	3	2011-01-09 13:14:04.520646+01	2011-01-09 13:14:04.536713+01	3	14	skeleton 1444
1445	3	2011-01-09 13:14:04.54453+01	2011-01-09 13:14:04.552903+01	3	5	neuron 1445
1447	3	2011-01-09 13:14:04.570086+01	2011-01-09 13:14:04.570086+01	3	106	Fragments
1456	3	2011-01-09 13:14:16.311384+01	2011-01-09 13:14:16.320776+01	3	7	synapse 1456
1457	3	2011-01-09 13:14:16.328475+01	2011-01-09 13:14:16.337086+01	3	755	presynaptic terminal 1457
\.


--
-- Data for Name: class_instance_class_instance; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY class_instance_class_instance (id, user_id, creation_time, edition_time, project_id, relation_id, class_instance_a, class_instance_b) FROM stdin;
1465	3	2011-01-09 13:18:52.825172+01	2011-01-09 13:18:52.825172+01	3	10	1463	1464
1466	3	2011-01-09 13:18:52.833961+01	2011-01-09 13:18:52.833961+01	3	9	1464	1447
1471	3	2011-01-09 13:20:26.209872+01	2011-01-09 13:20:26.209872+01	3	10	1469	1470
1472	3	2011-01-09 13:20:26.218585+01	2011-01-09 13:20:26.218585+01	3	9	1470	1447
1477	3	2011-01-09 13:20:26.384159+01	2011-01-09 13:20:26.384159+01	3	24	1475	1456
1478	3	2011-01-09 13:20:26.393154+01	2011-01-09 13:20:26.393154+01	3	9	1475	1469
1481	3	2011-01-09 13:22:32.118655+01	2011-01-09 13:22:32.118655+01	3	10	1479	1480
1482	3	2011-01-09 13:22:32.127342+01	2011-01-09 13:22:32.127342+01	3	9	1480	1447
1487	3	2011-01-09 13:22:32.301124+01	2011-01-09 13:22:32.301124+01	3	24	1485	1456
1488	3	2011-01-09 13:22:32.318295+01	2011-01-09 13:22:32.318295+01	3	9	1485	1479
1494	3	2011-01-09 13:22:38.338375+01	2011-01-09 13:22:38.338375+01	3	23	1490	1489
1495	3	2011-01-09 13:22:38.347311+01	2011-01-09 13:22:38.347311+01	3	9	1490	1479
1446	3	2011-01-09 13:14:04.561087+01	2011-01-09 13:14:04.561087+01	3	10	1444	1445
1448	3	2011-01-09 13:14:04.578493+01	2011-01-09 13:14:04.578493+01	3	9	1447	1443
1449	3	2011-01-09 13:14:04.585976+01	2011-01-09 13:14:04.585976+01	3	9	1445	1447
1461	3	2011-01-09 13:14:16.37003+01	2011-01-09 13:14:16.37003+01	3	23	1457	1456
1462	3	2011-01-09 13:14:16.378791+01	2011-01-09 13:14:16.378791+01	3	9	1457	1444
\.


--
-- Data for Name: concept; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY concept (id, user_id, creation_time, edition_time, project_id) FROM stdin;
\.


--
-- Data for Name: connector; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY connector (id, user_id, creation_time, edition_time, project_id, location, confidence) FROM stdin;
1458	3	2011-01-09 13:14:16.345145+01	2011-01-09 13:14:16.345145+01	3	(5687.8815999999997,5557.4255999999996,60)	5
1491	3	2011-01-09 13:22:38.313452+01	2011-01-09 13:22:38.313452+01	3	(4044.136,4122.4096,60)	5
\.


--
-- Data for Name: connector_class_instance; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY connector_class_instance (id, user_id, creation_time, edition_time, project_id, relation_id, location_id, class_instance_id) FROM stdin;
1460	3	2011-01-09 13:14:16.361697+01	2011-01-09 13:14:16.361697+01	3	10	1458	1456
1493	3	2011-01-09 13:22:38.330012+01	2011-01-09 13:22:38.330012+01	3	10	1491	1489
\.


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY location (id, user_id, creation_time, edition_time, project_id, location) FROM stdin;
1331	3	2010-12-29 18:34:29.322328+01	2010-12-29 18:34:29.322328+01	3	(3704.9504000000002,1278.4688000000001,120)
1337	3	2010-12-29 18:37:09.306273+01	2010-12-29 18:37:09.306273+01	3	(2348.2080000000001,6888.0767999999998,60)
1349	3	2010-12-29 18:37:09.746111+01	2010-12-29 18:37:09.746111+01	3	(2348.2080000000001,6888.0767999999998,60)
1370	3	2010-12-29 18:37:49.943599+01	2010-12-29 18:37:49.943599+01	3	(6940.2592000000004,9627.6527999999998,120)
1385	3	2010-12-29 18:38:10.33665+01	2010-12-29 18:38:10.33665+01	3	(2556.9376000000002,8818.8256000000001,120)
1265	3	2010-12-29 18:30:39.83259+01	2010-12-29 18:30:39.83259+01	3	(5335.6504000000004,6757.6207999999997,120)
1355	3	2010-12-29 18:37:43.217698+01	2010-12-29 18:37:43.217698+01	3	(5635.6992,8779.6887999999999,120)
1391	3	2010-12-29 18:39:19.75276+01	2010-12-29 18:39:19.75276+01	3	(4931.2367999999997,11206.170400000001,120)
1253	3	2010-12-29 18:30:39.442699+01	2010-12-29 18:30:39.442699+01	3	(4957.3280000000004,3939.7712000000001,120)
1319	3	2010-12-29 18:34:28.990594+01	2010-12-29 18:34:28.990594+01	3	(2661.3024,3652.768,120)
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY message (id, user_id, "time", read, title, text, action) FROM stdin;
\.


--
-- Data for Name: object; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY object (id, class, name, project_id, colour) FROM stdin;
\.


--
-- Data for Name: profile; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY profile (id, z, object_id) FROM stdin;
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY project (id, title, public) FROM stdin;
1	Default Project	t
2	Evaluation data set	t
3	Focussed Ion Beam (FIB)	t
\.


--
-- Data for Name: project_stack; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY project_stack (project_id, stack_id, translation) FROM stdin;
1	1	(0,0,0)
3	2	(0,0,0)
\.


--
-- Data for Name: project_user; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY project_user (project_id, user_id) FROM stdin;
1	1
3	1
1	3
3	3
2	3
\.


--
-- Data for Name: relation; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY relation (id, user_id, creation_time, edition_time, project_id, relation_name, uri, description, isreciprocal) FROM stdin;
35	3	2010-08-27 17:30:10.480635+02	2010-08-27 17:30:10.480635+02	3	labeled_as	\N	\N	f
24	1	2010-08-26 21:21:35.859377+02	2010-08-26 21:21:35.859377+02	3	postsynaptic_to	\N	\N	f
23	1	2010-08-26 21:20:51.55492+02	2010-08-26 21:20:51.55492+02	3	presynaptic_to	\N	\N	f
11	1	2010-08-26 19:15:41.060476+02	2010-08-26 19:15:41.060476+02	3	element_of	\N	\N	f
10	1	2010-08-26 19:15:31.939089+02	2010-08-26 19:15:31.939089+02	3	model_of	\N	\N	f
9	1	2010-08-26 19:15:22.408939+02	2010-08-26 19:15:22.408939+02	3	part_of	\N	\N	f
8	1	2010-08-26 19:08:19.488588+02	2010-08-26 19:08:19.488588+02	3	is_a	\N	\N	f
\.


--
-- Data for Name: relation_instance; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY relation_instance (id, user_id, creation_time, edition_time, project_id, relation_id) FROM stdin;
\.


--
-- Data for Name: stack; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY stack (id, title, dimension, resolution, image_base, comment, trakem2_project) FROM stdin;
1	Original data.	(4096,4096,16)	(3.2614000000000001,3.2614000000000001,60)	http://fly.mpi-cbg.de/map/evaluation/original/	<p>&copy;2007 by Stephan Saalfeld.</p>\n<p>Rendered with <a href="http://www.povray.org/">POV-Ray&nbsp;v3.6</a> using this <a href="http://fly.mpi-cbg.de/~saalfeld/download/volume.tar.bz2">scene-file</a>.</p>	f
3	Focussed Ion Beam (FIB) stack of Rat Striatum\t	(2048,1536,460)	(5,5,9)	http://incf.ini.uzh.ch/image-stack-fib/	<p>&copy;2009 <a href="http://people.epfl.ch/graham.knott">Graham Knott</a>.</p>\n<p>Public INCF data set available at the <a href="http://www.incf.org/about/nodes/switzerland/data">Swiss INCF Node</a>.</p>	f
2	TrickStack	(4096,4096,16)	(3.2614000000000001,3.2614000000000001,60)	http://fly.mpi-cbg.de/map/evaluation/original/	<p>&copy;2009 <a href="http://people.epfl.ch/graham.knott">Graham Knott</a>.</p>\n<p>Public INCF data set available at the <a href="http://www.incf.org/about/nodes/switzerland/data">Swiss INCF Node</a>.</p>	f
\.


--
-- Data for Name: textlabel; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY textlabel (id, type, text, colour, font_name, font_style, font_size, project_id, scaling, creation_time, edition_time, deleted) FROM stdin;
3	text	Schoen	(1,0.49803922,0,1)	\N	bold	978	1	t	2010-08-27 12:38:40.980952+02	2010-08-27 12:39:00.6389+02	f
2	text	Edit this text...	(1,0.8509804,0,1)	\N	bold	1196	1	t	2010-08-26 12:36:48.24755+02	2010-08-26 12:36:50.836827+02	t
5	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	250	3	t	2010-09-13 11:50:47.159475+02	2010-09-13 11:50:49.604793+02	t
6	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-10-11 14:15:31.168282+02	2010-10-11 14:15:33.854817+02	t
7	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-10-11 14:16:05.826567+02	2010-10-11 14:16:08.769985+02	t
8	text	MYTEST\n	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-10-18 09:38:47.088904+02	2010-10-18 09:39:33.143551+02	t
9	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-10-18 09:44:24.225973+02	2010-10-18 09:44:29.548195+02	t
4	text	Test	(1,0.49803922,0,1)	\N	bold	250	3	t	2010-08-27 15:19:17.197702+02	2010-12-20 09:31:47.015919+01	t
13	text	Myelinated axon	(0,0,1,1)	\N	bold	150	3	t	2010-12-01 09:43:16.700626+01	2010-12-20 09:36:28.343518+01	t
15	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-12-20 09:37:38.285231+01	2010-12-20 09:37:44.347119+01	t
14	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-12-20 09:36:39.000766+01	2010-12-20 09:38:43.094581+01	t
16	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-12-20 10:10:26.269007+01	2010-12-20 10:10:29.762499+01	t
17	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-12-20 10:10:53.579777+01	2010-12-20 10:14:46.224959+01	t
18	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-12-20 10:10:54.103042+01	2010-12-20 10:15:57.32196+01	t
19	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-12-20 10:16:12.935654+01	2010-12-20 10:16:21.208902+01	t
21	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-12-20 10:16:14.335655+01	2010-12-20 10:16:25.638116+01	t
10	text	*	(0,0,1,1)	\N	bold	260	3	t	2010-12-01 09:41:45.68728+01	2010-12-01 09:42:08.359032+01	f
20	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-12-20 10:16:13.782039+01	2010-12-20 10:16:29.660556+01	t
22	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	160	3	t	2010-12-20 10:19:56.8591+01	2010-12-20 10:19:56.8591+01	f
11	text	Mitochondria	(0,0,1,1)	\N	bold	160	3	t	2010-12-01 09:42:09.159965+01	2010-12-20 12:37:54.40121+01	f
1	text	Guten Tag!	(1,0.8509804,0,1)	\N	bold	864	1	t	2010-08-26 12:35:10.72796+02	2010-12-20 17:38:32.970317+01	f
12	text	*	(0,0,1,1)	\N	bold	260	3	t	2010-12-01 09:42:35.406046+01	2010-12-01 09:42:56.152671+01	f
23	text	Edit this text...	(1,0.49803922,0,1)	\N	bold	104	3	t	2011-01-09 10:56:18.363413+01	2011-01-09 10:56:18.363413+01	f
\.


--
-- Data for Name: textlabel_location; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY textlabel_location (textlabel_id, location, deleted) FROM stdin;
3	(8580.7433999999994,5945.5321999999996,60)	f
2	(7501.2200000000003,7798.0074000000004,60)	t
5	(4820,2375,9)	t
6	(3420,3640,153)	t
7	(2175,4200,9)	t
8	(1440,4145,99)	t
9	(2035,4005,9)	t
10	(5240,2380,45)	f
12	(5725,2360,45)	f
4	(2690,2767.5,9)	t
13	(5150,3705,45)	t
15	(3605,4185,9)	t
14	(4085,4015,0)	t
16	(1665,3065,0)	t
17	(2115,4135,0)	t
18	(4885,4135,0)	t
19	(3105,3195,0)	t
21	(4055,4705,0)	t
20	(5495,4145,0)	t
22	(3225,3725,0)	f
11	(5680,1785,45)	f
1	(4393.1058000000003,3701.6889999999999,60)	f
3	(8580.7433999999994,5945.5321999999996,60)	f
2	(7501.2200000000003,7798.0074000000004,60)	t
5	(4820,2375,9)	t
6	(3420,3640,153)	t
7	(2175,4200,9)	t
8	(1440,4145,99)	t
9	(2035,4005,9)	t
10	(5240,2380,45)	f
12	(5725,2360,45)	f
4	(2690,2767.5,9)	t
13	(5150,3705,45)	t
15	(3605,4185,9)	t
14	(4085,4015,0)	t
16	(1665,3065,0)	t
17	(2115,4135,0)	t
18	(4885,4135,0)	t
19	(3105,3195,0)	t
21	(4055,4705,0)	t
20	(5495,4145,0)	t
22	(3225,3725,0)	f
11	(5680,1785,45)	f
1	(4393.1058000000003,3701.6889999999999,60)	f
23	(4419.1970000000001,6338.5308999999997,840)	f
3	(8580.7433999999994,5945.5321999999996,60)	f
2	(7501.2200000000003,7798.0074000000004,60)	t
5	(4820,2375,9)	t
6	(3420,3640,153)	t
7	(2175,4200,9)	t
8	(1440,4145,99)	t
9	(2035,4005,9)	t
10	(5240,2380,45)	f
12	(5725,2360,45)	f
4	(2690,2767.5,9)	t
13	(5150,3705,45)	t
15	(3605,4185,9)	t
14	(4085,4015,0)	t
16	(1665,3065,0)	t
17	(2115,4135,0)	t
18	(4885,4135,0)	t
19	(3105,3195,0)	t
21	(4055,4705,0)	t
20	(5495,4145,0)	t
22	(3225,3725,0)	f
11	(5680,1785,45)	f
1	(4393.1058000000003,3701.6889999999999,60)	f
3	(8580.7433999999994,5945.5321999999996,60)	f
2	(7501.2200000000003,7798.0074000000004,60)	t
5	(4820,2375,9)	t
6	(3420,3640,153)	t
7	(2175,4200,9)	t
8	(1440,4145,99)	t
9	(2035,4005,9)	t
10	(5240,2380,45)	f
12	(5725,2360,45)	f
4	(2690,2767.5,9)	t
13	(5150,3705,45)	t
15	(3605,4185,9)	t
14	(4085,4015,0)	t
16	(1665,3065,0)	t
17	(2115,4135,0)	t
18	(4885,4135,0)	t
19	(3105,3195,0)	t
21	(4055,4705,0)	t
20	(5495,4145,0)	t
22	(3225,3725,0)	f
11	(5680,1785,45)	f
1	(4393.1058000000003,3701.6889999999999,60)	f
23	(4419.1970000000001,6338.5308999999997,840)	f
3	(8580.7433999999994,5945.5321999999996,60)	f
2	(7501.2200000000003,7798.0074000000004,60)	t
5	(4820,2375,9)	t
6	(3420,3640,153)	t
7	(2175,4200,9)	t
8	(1440,4145,99)	t
9	(2035,4005,9)	t
10	(5240,2380,45)	f
12	(5725,2360,45)	f
4	(2690,2767.5,9)	t
13	(5150,3705,45)	t
15	(3605,4185,9)	t
14	(4085,4015,0)	t
16	(1665,3065,0)	t
17	(2115,4135,0)	t
18	(4885,4135,0)	t
19	(3105,3195,0)	t
21	(4055,4705,0)	t
20	(5495,4145,0)	t
22	(3225,3725,0)	f
11	(5680,1785,45)	f
1	(4393.1058000000003,3701.6889999999999,60)	f
3	(8580.7433999999994,5945.5321999999996,60)	f
2	(7501.2200000000003,7798.0074000000004,60)	t
5	(4820,2375,9)	t
6	(3420,3640,153)	t
7	(2175,4200,9)	t
8	(1440,4145,99)	t
9	(2035,4005,9)	t
10	(5240,2380,45)	f
12	(5725,2360,45)	f
4	(2690,2767.5,9)	t
13	(5150,3705,45)	t
15	(3605,4185,9)	t
14	(4085,4015,0)	t
16	(1665,3065,0)	t
17	(2115,4135,0)	t
18	(4885,4135,0)	t
19	(3105,3195,0)	t
21	(4055,4705,0)	t
20	(5495,4145,0)	t
22	(3225,3725,0)	f
11	(5680,1785,45)	f
1	(4393.1058000000003,3701.6889999999999,60)	f
23	(4419.1970000000001,6338.5308999999997,840)	f
\.


--
-- Data for Name: treenode; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY treenode (id, user_id, creation_time, edition_time, project_id, location, parent_id, radius, confidence) FROM stdin;
1496	3	2011-01-09 13:22:43.561876+01	2011-01-09 13:22:43.561876+01	3	(3678.8591999999999,6079.2496000000001,60)	1483	4	5
1498	3	2011-01-09 13:22:44.252598+01	2011-01-09 13:22:44.252598+01	3	(2843.9407999999999,5505.2431999999999,60)	1496	4	5
1500	3	2011-01-09 13:22:44.822662+01	2011-01-09 13:22:44.822662+01	3	(2530.8463999999999,4905.1455999999998,60)	1498	4	5
1450	3	2011-01-09 13:14:04.594226+01	2011-01-09 13:14:04.594226+01	3	(5453.0608000000002,7722.9952000000003,60)	\N	4	5
1454	3	2011-01-09 13:14:06.886502+01	2011-01-09 13:14:06.886502+01	3	(7879.5424000000003,5922.7024000000001,60)	1452	4	5
1452	3	2011-01-09 13:14:06.289417+01	2011-01-09 13:14:06.289417+01	3	(6548.8912,6548.8912,60)	1450	4	5
1467	3	2011-01-09 13:18:52.841882+01	2011-01-09 13:18:52.841882+01	3	(6757.6207999999997,4200.6832000000004,60)	\N	4	5
1473	3	2011-01-09 13:20:26.226569+01	2011-01-09 13:20:26.226569+01	3	(5113.8752000000004,4618.1423999999997,60)	\N	4	5
1483	3	2011-01-09 13:22:32.135331+01	2011-01-09 13:22:32.135331+01	3	(4018.0448000000001,5609.6080000000002,60)	\N	4	5
\.


--
-- Data for Name: treenode_class_instance; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY treenode_class_instance (id, user_id, creation_time, edition_time, project_id, relation_id, treenode_id, class_instance_id) FROM stdin;
1451	3	2011-01-09 13:14:04.602751+01	2011-01-09 13:14:04.602751+01	3	11	1450	1444
1453	3	2011-01-09 13:14:06.302903+01	2011-01-09 13:14:06.302903+01	3	11	1452	1444
1455	3	2011-01-09 13:14:06.900034+01	2011-01-09 13:14:06.900034+01	3	11	1454	1444
1459	3	2011-01-09 13:14:16.353637+01	2011-01-09 13:14:16.353637+01	3	10	1452	1457
1468	3	2011-01-09 13:18:52.850402+01	2011-01-09 13:18:52.850402+01	3	11	1467	1463
1474	3	2011-01-09 13:20:26.235161+01	2011-01-09 13:20:26.235161+01	3	11	1473	1469
1476	3	2011-01-09 13:20:26.375897+01	2011-01-09 13:20:26.375897+01	3	10	1473	1475
1484	3	2011-01-09 13:22:32.144967+01	2011-01-09 13:22:32.144967+01	3	11	1483	1479
1486	3	2011-01-09 13:22:32.292929+01	2011-01-09 13:22:32.292929+01	3	10	1483	1485
1492	3	2011-01-09 13:22:38.321931+01	2011-01-09 13:22:38.321931+01	3	10	1483	1490
1497	3	2011-01-09 13:22:43.579918+01	2011-01-09 13:22:43.579918+01	3	11	1496	1479
1499	3	2011-01-09 13:22:44.259875+01	2011-01-09 13:22:44.259875+01	3	11	1498	1479
1501	3	2011-01-09 13:22:44.831875+01	2011-01-09 13:22:44.831875+01	3	11	1500	1479
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: catmaid_user
--

COPY "user" (id, name, pwd, longname) FROM stdin;
1	saalfeld	84789cbcbd2daf359a9fa4f34350e50f	Stephan Saalfeld
2	test	098f6bcd4621d373cade4e832627b4f6	Theo Test
3	gerhard	494524b27acdc356fb3dcb9f0b108267	Stephan Gerhard
\.


--
-- Name: broken_layer_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY broken_slice
    ADD CONSTRAINT broken_layer_pkey PRIMARY KEY (stack_id, index);


--
-- Name: class_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY class
    ADD CONSTRAINT class_id_key UNIQUE (id);


--
-- Name: class_instance_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY class_instance
    ADD CONSTRAINT class_instance_id_key UNIQUE (id);


--
-- Name: class_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY class_instance
    ADD CONSTRAINT class_instance_pkey PRIMARY KEY (id);


--
-- Name: class_instance_relation_instance_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY class_instance_class_instance
    ADD CONSTRAINT class_instance_relation_instance_id_key UNIQUE (id);


--
-- Name: class_instance_relation_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY class_instance_class_instance
    ADD CONSTRAINT class_instance_relation_instance_pkey PRIMARY KEY (id);


--
-- Name: class_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY class
    ADD CONSTRAINT class_pkey PRIMARY KEY (id);


--
-- Name: class_relation_instance_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY class_class
    ADD CONSTRAINT class_relation_instance_id_key UNIQUE (id);


--
-- Name: class_relation_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY class_class
    ADD CONSTRAINT class_relation_instance_pkey PRIMARY KEY (id);


--
-- Name: concept_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY concept
    ADD CONSTRAINT concept_id_key UNIQUE (id);


--
-- Name: concept_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY concept
    ADD CONSTRAINT concept_pkey PRIMARY KEY (id);


--
-- Name: connector_class_instance_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY connector_class_instance
    ADD CONSTRAINT connector_class_instance_id_key UNIQUE (id);


--
-- Name: connector_class_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY connector_class_instance
    ADD CONSTRAINT connector_class_instance_pkey PRIMARY KEY (id);


--
-- Name: connector_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY connector
    ADD CONSTRAINT connector_id_key UNIQUE (id);


--
-- Name: connector_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY connector
    ADD CONSTRAINT connector_pkey PRIMARY KEY (id);


--
-- Name: location_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_id_key UNIQUE (id);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: message_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- Name: object_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_id_key UNIQUE (id);


--
-- Name: object_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_pkey PRIMARY KEY (class, name);


--
-- Name: profile_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY profile
    ADD CONSTRAINT profile_pkey PRIMARY KEY (id);


--
-- Name: project_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: project_stack_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY project_stack
    ADD CONSTRAINT project_stack_pkey PRIMARY KEY (project_id, stack_id);


--
-- Name: project_user_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY project_user
    ADD CONSTRAINT project_user_pkey PRIMARY KEY (project_id, user_id);


--
-- Name: relation_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY relation
    ADD CONSTRAINT relation_id_key UNIQUE (id);


--
-- Name: relation_instance_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY relation_instance
    ADD CONSTRAINT relation_instance_id_key UNIQUE (id);


--
-- Name: relation_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY relation_instance
    ADD CONSTRAINT relation_instance_pkey PRIMARY KEY (id);


--
-- Name: relation_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY relation
    ADD CONSTRAINT relation_pkey PRIMARY KEY (id);


--
-- Name: stack_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY stack
    ADD CONSTRAINT stack_pkey PRIMARY KEY (id);


--
-- Name: textlabel_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY textlabel
    ADD CONSTRAINT textlabel_pkey PRIMARY KEY (id);


--
-- Name: treenode_class_instance_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY treenode_class_instance
    ADD CONSTRAINT treenode_class_instance_id_key UNIQUE (id);


--
-- Name: treenode_class_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY treenode_class_instance
    ADD CONSTRAINT treenode_class_instance_pkey PRIMARY KEY (id);


--
-- Name: treenode_id_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY treenode
    ADD CONSTRAINT treenode_id_key UNIQUE (id);


--
-- Name: treenode_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY treenode
    ADD CONSTRAINT treenode_pkey PRIMARY KEY (id);


--
-- Name: users_name_key; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT users_name_key UNIQUE (name);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: catmaid_user; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: apply_edition_time_update; Type: TRIGGER; Schema: public; Owner: catmaid_user
--

CREATE TRIGGER apply_edition_time_update
    BEFORE UPDATE ON class_instance
    FOR EACH ROW
    EXECUTE PROCEDURE on_edit();


--
-- Name: on_edit; Type: TRIGGER; Schema: public; Owner: catmaid_user
--

CREATE TRIGGER on_edit
    BEFORE UPDATE ON textlabel
    FOR EACH ROW
    EXECUTE PROCEDURE on_edit();


--
-- Name: on_edit; Type: TRIGGER; Schema: public; Owner: catmaid_user
--

CREATE TRIGGER on_edit
    BEFORE UPDATE ON concept
    FOR EACH ROW
    EXECUTE PROCEDURE on_edit();


--
-- Name: bezierkey_profile_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY bezierkey
    ADD CONSTRAINT bezierkey_profile_fkey FOREIGN KEY (profile_id) REFERENCES profile(id);


--
-- Name: broken_layer_stack_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY broken_slice
    ADD CONSTRAINT broken_layer_stack_id_fkey FOREIGN KEY (stack_id) REFERENCES stack(id);


--
-- Name: class_class_class_a_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY class_class
    ADD CONSTRAINT class_class_class_a_fkey FOREIGN KEY (class_a) REFERENCES class(id) ON DELETE CASCADE;


--
-- Name: class_class_class_b_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY class_class
    ADD CONSTRAINT class_class_class_b_fkey FOREIGN KEY (class_b) REFERENCES class(id) ON DELETE CASCADE;


--
-- Name: class_instance_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY class_instance
    ADD CONSTRAINT class_instance_class_id_fkey FOREIGN KEY (class_id) REFERENCES class(id);


--
-- Name: class_instance_relation_instance_relation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY class_instance_class_instance
    ADD CONSTRAINT class_instance_relation_instance_relation_id_fkey FOREIGN KEY (relation_id) REFERENCES relation(id);


--
-- Name: class_instance_relation_instance_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY class_instance_class_instance
    ADD CONSTRAINT class_instance_relation_instance_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: class_instance_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY class_instance
    ADD CONSTRAINT class_instance_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: class_relation_instance_relation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY class_class
    ADD CONSTRAINT class_relation_instance_relation_id_fkey FOREIGN KEY (relation_id) REFERENCES relation(id);


--
-- Name: class_relation_instance_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY class_class
    ADD CONSTRAINT class_relation_instance_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: class_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY class
    ADD CONSTRAINT class_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: concept_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY concept
    ADD CONSTRAINT concept_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: connector_class_instance_class_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY connector_class_instance
    ADD CONSTRAINT connector_class_instance_class_instance_id_fkey FOREIGN KEY (class_instance_id) REFERENCES class_instance(id);


--
-- Name: connector_class_instance_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY connector_class_instance
    ADD CONSTRAINT connector_class_instance_location_id_fkey FOREIGN KEY (location_id) REFERENCES connector(id) ON DELETE CASCADE;


--
-- Name: connector_class_instance_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY connector_class_instance
    ADD CONSTRAINT connector_class_instance_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: connector_class_instance_relation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY connector_class_instance
    ADD CONSTRAINT connector_class_instance_relation_id_fkey FOREIGN KEY (relation_id) REFERENCES relation(id);


--
-- Name: connector_class_instance_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY connector_class_instance
    ADD CONSTRAINT connector_class_instance_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: message_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: object_project_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_project_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: profile_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY profile
    ADD CONSTRAINT profile_object_fkey FOREIGN KEY (object_id) REFERENCES object(id);


--
-- Name: project_stack_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY project_stack
    ADD CONSTRAINT project_stack_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: project_stack_stack_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY project_stack
    ADD CONSTRAINT project_stack_stack_id_fkey FOREIGN KEY (stack_id) REFERENCES stack(id);


--
-- Name: project_user_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY project_user
    ADD CONSTRAINT project_user_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: project_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY project_user
    ADD CONSTRAINT project_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: relation_instance_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY relation_instance
    ADD CONSTRAINT relation_instance_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: relation_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY relation
    ADD CONSTRAINT relation_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: textlabel_location_textlabel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY textlabel_location
    ADD CONSTRAINT textlabel_location_textlabel_id_fkey FOREIGN KEY (textlabel_id) REFERENCES textlabel(id);


--
-- Name: textlabel_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY textlabel
    ADD CONSTRAINT textlabel_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: treenode_class_instance_class_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY treenode_class_instance
    ADD CONSTRAINT treenode_class_instance_class_instance_id_fkey FOREIGN KEY (class_instance_id) REFERENCES class_instance(id);


--
-- Name: treenode_class_instance_relation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY treenode_class_instance
    ADD CONSTRAINT treenode_class_instance_relation_id_fkey FOREIGN KEY (relation_id) REFERENCES relation(id);


--
-- Name: treenode_class_instance_treenode_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY treenode_class_instance
    ADD CONSTRAINT treenode_class_instance_treenode_id_fkey FOREIGN KEY (treenode_id) REFERENCES treenode(id) ON DELETE CASCADE;


--
-- Name: treenode_class_instance_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY treenode_class_instance
    ADD CONSTRAINT treenode_class_instance_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- Name: treenode_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: catmaid_user
--

ALTER TABLE ONLY treenode
    ADD CONSTRAINT treenode_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES treenode(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: stephan
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM stephan;
GRANT ALL ON SCHEMA public TO stephan;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: bezierkey; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE bezierkey FROM PUBLIC;
REVOKE ALL ON TABLE bezierkey FROM catmaid_user;
GRANT ALL ON TABLE bezierkey TO catmaid_user;


--
-- Name: profile; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE profile FROM PUBLIC;
REVOKE ALL ON TABLE profile FROM catmaid_user;
GRANT ALL ON TABLE profile TO catmaid_user;


--
-- Name: bezierprofile; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE bezierprofile FROM PUBLIC;
REVOKE ALL ON TABLE bezierprofile FROM catmaid_user;
GRANT ALL ON TABLE bezierprofile TO catmaid_user;


--
-- Name: broken_slice; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE broken_slice FROM PUBLIC;
REVOKE ALL ON TABLE broken_slice FROM catmaid_user;
GRANT ALL ON TABLE broken_slice TO catmaid_user;


--
-- Name: message; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE message FROM PUBLIC;
REVOKE ALL ON TABLE message FROM catmaid_user;
GRANT ALL ON TABLE message TO catmaid_user;


--
-- Name: message_id_seq; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON SEQUENCE message_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE message_id_seq FROM catmaid_user;
GRANT ALL ON SEQUENCE message_id_seq TO catmaid_user;


--
-- Name: object; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE object FROM PUBLIC;
REVOKE ALL ON TABLE object FROM catmaid_user;
GRANT ALL ON TABLE object TO catmaid_user;


--
-- Name: project; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE project FROM PUBLIC;
REVOKE ALL ON TABLE project FROM catmaid_user;
GRANT ALL ON TABLE project TO catmaid_user;


--
-- Name: project_stack; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE project_stack FROM PUBLIC;
REVOKE ALL ON TABLE project_stack FROM catmaid_user;
GRANT ALL ON TABLE project_stack TO catmaid_user;


--
-- Name: project_user; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE project_user FROM PUBLIC;
REVOKE ALL ON TABLE project_user FROM catmaid_user;
GRANT ALL ON TABLE project_user TO catmaid_user;


--
-- Name: stack; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE stack FROM PUBLIC;
REVOKE ALL ON TABLE stack FROM catmaid_user;
GRANT ALL ON TABLE stack TO catmaid_user;


--
-- Name: textlabel; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE textlabel FROM PUBLIC;
REVOKE ALL ON TABLE textlabel FROM catmaid_user;
GRANT ALL ON TABLE textlabel TO catmaid_user;


--
-- Name: textlabel_id_seq; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON SEQUENCE textlabel_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE textlabel_id_seq FROM catmaid_user;
GRANT ALL ON SEQUENCE textlabel_id_seq TO catmaid_user;


--
-- Name: textlabel_location; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE textlabel_location FROM PUBLIC;
REVOKE ALL ON TABLE textlabel_location FROM catmaid_user;
GRANT ALL ON TABLE textlabel_location TO catmaid_user;


--
-- Name: user; Type: ACL; Schema: public; Owner: catmaid_user
--

REVOKE ALL ON TABLE "user" FROM PUBLIC;
REVOKE ALL ON TABLE "user" FROM catmaid_user;
GRANT ALL ON TABLE "user" TO catmaid_user;


--
-- PostgreSQL database dump complete
--


