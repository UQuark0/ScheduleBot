--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

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

ALTER TABLE IF EXISTS ONLY public.teacher DROP CONSTRAINT IF EXISTS teacher_group_id_fk;
ALTER TABLE IF EXISTS ONLY public.subject DROP CONSTRAINT IF EXISTS subject_group_id_fk;
ALTER TABLE IF EXISTS ONLY public.slot DROP CONSTRAINT IF EXISTS slot_group_id_fk;
ALTER TABLE IF EXISTS ONLY public.room DROP CONSTRAINT IF EXISTS room_group_id_fk;
ALTER TABLE IF EXISTS ONLY public.class_type DROP CONSTRAINT IF EXISTS class_type_group_id_fk;
ALTER TABLE IF EXISTS ONLY public.class DROP CONSTRAINT IF EXISTS class_teacher_id_fk;
ALTER TABLE IF EXISTS ONLY public.class DROP CONSTRAINT IF EXISTS class_subject_id_fk;
ALTER TABLE IF EXISTS ONLY public.class DROP CONSTRAINT IF EXISTS class_slot_id_fk;
ALTER TABLE IF EXISTS ONLY public.class DROP CONSTRAINT IF EXISTS class_room_id_fk;
ALTER TABLE IF EXISTS ONLY public.class DROP CONSTRAINT IF EXISTS class_group_id_fk;
ALTER TABLE IF EXISTS ONLY public.class DROP CONSTRAINT IF EXISTS class_class_type_id_fk;
ALTER TABLE IF EXISTS ONLY public.teacher DROP CONSTRAINT IF EXISTS teacher_pkey;
ALTER TABLE IF EXISTS ONLY public.subject DROP CONSTRAINT IF EXISTS subject_pkey;
ALTER TABLE IF EXISTS ONLY public.slot DROP CONSTRAINT IF EXISTS slot_pkey;
ALTER TABLE IF EXISTS ONLY public.room DROP CONSTRAINT IF EXISTS room_pkey;
ALTER TABLE IF EXISTS ONLY public."group" DROP CONSTRAINT IF EXISTS group_pkey;
ALTER TABLE IF EXISTS ONLY public.class_type DROP CONSTRAINT IF EXISTS class_type_pkey;
ALTER TABLE IF EXISTS ONLY public.class DROP CONSTRAINT IF EXISTS class_pkey;
ALTER TABLE IF EXISTS public.teacher ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.subject ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.slot ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.room ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public."group" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.class_type ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.class ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.teacher_id_seq;
DROP TABLE IF EXISTS public.teacher;
DROP SEQUENCE IF EXISTS public.subject_id_seq;
DROP TABLE IF EXISTS public.subject;
DROP SEQUENCE IF EXISTS public.slot_id_seq;
DROP TABLE IF EXISTS public.slot;
DROP SEQUENCE IF EXISTS public.room_id_seq;
DROP TABLE IF EXISTS public.room;
DROP SEQUENCE IF EXISTS public.group_id_seq;
DROP TABLE IF EXISTS public."group";
DROP SEQUENCE IF EXISTS public.class_type_id_seq;
DROP TABLE IF EXISTS public.class_type;
DROP SEQUENCE IF EXISTS public.class_id_seq;
DROP TABLE IF EXISTS public.class;
DROP SCHEMA IF EXISTS public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: schedule_bot
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO schedule_bot;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: schedule_bot
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: class; Type: TABLE; Schema: public; Owner: schedule_bot
--

CREATE TABLE public.class (
    id integer NOT NULL,
    class_type_id bigint NOT NULL,
    group_id bigint NOT NULL,
    subject_id bigint NOT NULL,
    room_id bigint NOT NULL,
    teacher_id bigint NOT NULL,
    slot_id bigint NOT NULL,
    date date NOT NULL
);


ALTER TABLE public.class OWNER TO schedule_bot;

--
-- Name: class_id_seq; Type: SEQUENCE; Schema: public; Owner: schedule_bot
--

CREATE SEQUENCE public.class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_id_seq OWNER TO schedule_bot;

--
-- Name: class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: schedule_bot
--

ALTER SEQUENCE public.class_id_seq OWNED BY public.class.id;


--
-- Name: class_type; Type: TABLE; Schema: public; Owner: schedule_bot
--

CREATE TABLE public.class_type (
    id integer NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.class_type OWNER TO schedule_bot;

--
-- Name: class_type_id_seq; Type: SEQUENCE; Schema: public; Owner: schedule_bot
--

CREATE SEQUENCE public.class_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_type_id_seq OWNER TO schedule_bot;

--
-- Name: class_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: schedule_bot
--

ALTER SEQUENCE public.class_type_id_seq OWNED BY public.class_type.id;


--
-- Name: group; Type: TABLE; Schema: public; Owner: schedule_bot
--

CREATE TABLE public."group" (
    id integer NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    chat_id bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public."group" OWNER TO schedule_bot;

--
-- Name: group_id_seq; Type: SEQUENCE; Schema: public; Owner: schedule_bot
--

CREATE SEQUENCE public.group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_id_seq OWNER TO schedule_bot;

--
-- Name: group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: schedule_bot
--

ALTER SEQUENCE public.group_id_seq OWNED BY public."group".id;


--
-- Name: room; Type: TABLE; Schema: public; Owner: schedule_bot
--

CREATE TABLE public.room (
    id integer NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.room OWNER TO schedule_bot;

--
-- Name: room_id_seq; Type: SEQUENCE; Schema: public; Owner: schedule_bot
--

CREATE SEQUENCE public.room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.room_id_seq OWNER TO schedule_bot;

--
-- Name: room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: schedule_bot
--

ALTER SEQUENCE public.room_id_seq OWNED BY public.room.id;


--
-- Name: slot; Type: TABLE; Schema: public; Owner: schedule_bot
--

CREATE TABLE public.slot (
    id integer NOT NULL,
    start time without time zone NOT NULL,
    "end" time without time zone NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.slot OWNER TO schedule_bot;

--
-- Name: slot_id_seq; Type: SEQUENCE; Schema: public; Owner: schedule_bot
--

CREATE SEQUENCE public.slot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.slot_id_seq OWNER TO schedule_bot;

--
-- Name: slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: schedule_bot
--

ALTER SEQUENCE public.slot_id_seq OWNED BY public.slot.id;


--
-- Name: subject; Type: TABLE; Schema: public; Owner: schedule_bot
--

CREATE TABLE public.subject (
    id integer NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.subject OWNER TO schedule_bot;

--
-- Name: subject_id_seq; Type: SEQUENCE; Schema: public; Owner: schedule_bot
--

CREATE SEQUENCE public.subject_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subject_id_seq OWNER TO schedule_bot;

--
-- Name: subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: schedule_bot
--

ALTER SEQUENCE public.subject_id_seq OWNED BY public.subject.id;


--
-- Name: teacher; Type: TABLE; Schema: public; Owner: schedule_bot
--

CREATE TABLE public.teacher (
    id integer NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.teacher OWNER TO schedule_bot;

--
-- Name: teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: schedule_bot
--

CREATE SEQUENCE public.teacher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teacher_id_seq OWNER TO schedule_bot;

--
-- Name: teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: schedule_bot
--

ALTER SEQUENCE public.teacher_id_seq OWNED BY public.teacher.id;


--
-- Name: class id; Type: DEFAULT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class ALTER COLUMN id SET DEFAULT nextval('public.class_id_seq'::regclass);


--
-- Name: class_type id; Type: DEFAULT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class_type ALTER COLUMN id SET DEFAULT nextval('public.class_type_id_seq'::regclass);


--
-- Name: group id; Type: DEFAULT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public."group" ALTER COLUMN id SET DEFAULT nextval('public.group_id_seq'::regclass);


--
-- Name: room id; Type: DEFAULT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.room ALTER COLUMN id SET DEFAULT nextval('public.room_id_seq'::regclass);


--
-- Name: slot id; Type: DEFAULT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.slot ALTER COLUMN id SET DEFAULT nextval('public.slot_id_seq'::regclass);


--
-- Name: subject id; Type: DEFAULT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.subject ALTER COLUMN id SET DEFAULT nextval('public.subject_id_seq'::regclass);


--
-- Name: teacher id; Type: DEFAULT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.teacher ALTER COLUMN id SET DEFAULT nextval('public.teacher_id_seq'::regclass);


--
-- Name: class class_pkey; Type: CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_pkey PRIMARY KEY (id);


--
-- Name: class_type class_type_pkey; Type: CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class_type
    ADD CONSTRAINT class_type_pkey PRIMARY KEY (id);


--
-- Name: group group_pkey; Type: CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- Name: room room_pkey; Type: CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.room
    ADD CONSTRAINT room_pkey PRIMARY KEY (id);


--
-- Name: slot slot_pkey; Type: CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.slot
    ADD CONSTRAINT slot_pkey PRIMARY KEY (id);


--
-- Name: subject subject_pkey; Type: CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id);


--
-- Name: teacher teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (id);


--
-- Name: class class_class_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_class_type_id_fk FOREIGN KEY (class_type_id) REFERENCES public.class_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: class class_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_group_id_fk FOREIGN KEY (group_id) REFERENCES public."group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: class class_room_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_room_id_fk FOREIGN KEY (room_id) REFERENCES public.room(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: class class_slot_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_slot_id_fk FOREIGN KEY (slot_id) REFERENCES public.slot(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: class class_subject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_subject_id_fk FOREIGN KEY (subject_id) REFERENCES public.subject(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: class class_teacher_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_teacher_id_fk FOREIGN KEY (teacher_id) REFERENCES public.teacher(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: class_type class_type_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.class_type
    ADD CONSTRAINT class_type_group_id_fk FOREIGN KEY (group_id) REFERENCES public."group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: room room_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.room
    ADD CONSTRAINT room_group_id_fk FOREIGN KEY (group_id) REFERENCES public."group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: slot slot_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.slot
    ADD CONSTRAINT slot_group_id_fk FOREIGN KEY (group_id) REFERENCES public."group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: subject subject_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_group_id_fk FOREIGN KEY (group_id) REFERENCES public."group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: teacher teacher_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: schedule_bot
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_group_id_fk FOREIGN KEY (group_id) REFERENCES public."group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: schedule_bot
--

REVOKE ALL ON SCHEMA public FROM postgres;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO schedule_bot;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

