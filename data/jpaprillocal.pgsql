--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Ubuntu 11.2-1.pgdg18.04+1)
-- Dumped by pg_dump version 11.2 (Ubuntu 11.2-1.pgdg18.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: mainstats; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.mainstats (
    id integer NOT NULL,
    unit_id integer,
    stars integer DEFAULT 5 NOT NULL,
    type text DEFAULT 'attacker'::text NOT NULL,
    element text DEFAULT 'fire'::text NOT NULL,
    tier text DEFAULT '0 0 0 0'::text NOT NULL,
    CONSTRAINT mainstats_stars_check CHECK (((stars > 2) AND (stars < 6)))
);


ALTER TABLE public.mainstats OWNER TO lucin;

--
-- Name: mainstats_id_seq; Type: SEQUENCE; Schema: public; Owner: lucin
--

CREATE SEQUENCE public.mainstats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mainstats_id_seq OWNER TO lucin;

--
-- Name: mainstats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lucin
--

ALTER SEQUENCE public.mainstats_id_seq OWNED BY public.mainstats.id;


--
-- Name: profilepics; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.profilepics (
    id integer NOT NULL,
    unit_id integer,
    pic1 text DEFAULT 'blankunit.png'::text NOT NULL,
    pic2 text DEFAULT ''::text NOT NULL,
    pic3 text DEFAULT ''::text NOT NULL,
    pic4 text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.profilepics OWNER TO lucin;

--
-- Name: profilepics_id_seq; Type: SEQUENCE; Schema: public; Owner: lucin
--

CREATE SEQUENCE public.profilepics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profilepics_id_seq OWNER TO lucin;

--
-- Name: profilepics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lucin
--

ALTER SEQUENCE public.profilepics_id_seq OWNED BY public.profilepics.id;


--
-- Name: scstats; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.scstats (
    id integer NOT NULL,
    sc_id integer,
    pic1 text DEFAULT 'blankcard.jpg'::text,
    stars integer DEFAULT 5,
    normalstat1 text DEFAULT 'NA 0 0 0'::text NOT NULL,
    normalstat2 text DEFAULT 'NA 0 0 0'::text NOT NULL,
    prismstat1 text DEFAULT ''::text NOT NULL,
    prismstat2 text DEFAULT ''::text NOT NULL,
    restriction text DEFAULT 'none.'::text NOT NULL,
    ability text DEFAULT 'none.'::text NOT NULL,
    notes text DEFAULT ''::text NOT NULL,
    CONSTRAINT scstats_stars_check CHECK (((stars > 2) AND (stars < 6)))
);


ALTER TABLE public.scstats OWNER TO lucin;

--
-- Name: scstats_id_seq; Type: SEQUENCE; Schema: public; Owner: lucin
--

CREATE SEQUENCE public.scstats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scstats_id_seq OWNER TO lucin;

--
-- Name: scstats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lucin
--

ALTER SEQUENCE public.scstats_id_seq OWNED BY public.scstats.id;


--
-- Name: soulcards; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.soulcards (
    id integer NOT NULL,
    name text DEFAULT 'TBA'::text,
    created_on date DEFAULT CURRENT_DATE NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.soulcards OWNER TO lucin;

--
-- Name: soulcards_id_seq; Type: SEQUENCE; Schema: public; Owner: lucin
--

CREATE SEQUENCE public.soulcards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.soulcards_id_seq OWNER TO lucin;

--
-- Name: soulcards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lucin
--

ALTER SEQUENCE public.soulcards_id_seq OWNED BY public.soulcards.id;


--
-- Name: substats; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.substats (
    id integer NOT NULL,
    unit_id integer,
    leader text DEFAULT '_missing_'::text NOT NULL,
    auto text DEFAULT '_missing_'::text NOT NULL,
    tap text DEFAULT '_missing_'::text NOT NULL,
    slide text DEFAULT '_missing_'::text NOT NULL,
    drive text DEFAULT '_missing_'::text NOT NULL,
    notes text DEFAULT '_missing_'::text NOT NULL
);


ALTER TABLE public.substats OWNER TO lucin;

--
-- Name: substats_id_seq; Type: SEQUENCE; Schema: public; Owner: lucin
--

CREATE SEQUENCE public.substats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.substats_id_seq OWNER TO lucin;

--
-- Name: substats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lucin
--

ALTER SEQUENCE public.substats_id_seq OWNED BY public.substats.id;


--
-- Name: units; Type: TABLE; Schema: public; Owner: lucin
--

CREATE TABLE public.units (
    id integer NOT NULL,
    name character varying(60) DEFAULT 'TBA'::character varying NOT NULL,
    created_on date DEFAULT CURRENT_DATE,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.units OWNER TO lucin;

--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: lucin
--

CREATE SEQUENCE public.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.units_id_seq OWNER TO lucin;

--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lucin
--

ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;


--
-- Name: mainstats id; Type: DEFAULT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.mainstats ALTER COLUMN id SET DEFAULT nextval('public.mainstats_id_seq'::regclass);


--
-- Name: profilepics id; Type: DEFAULT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.profilepics ALTER COLUMN id SET DEFAULT nextval('public.profilepics_id_seq'::regclass);


--
-- Name: scstats id; Type: DEFAULT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.scstats ALTER COLUMN id SET DEFAULT nextval('public.scstats_id_seq'::regclass);


--
-- Name: soulcards id; Type: DEFAULT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.soulcards ALTER COLUMN id SET DEFAULT nextval('public.soulcards_id_seq'::regclass);


--
-- Name: substats id; Type: DEFAULT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.substats ALTER COLUMN id SET DEFAULT nextval('public.substats_id_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- Data for Name: mainstats; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.mainstats (id, unit_id, stars, type, element, tier) FROM stdin;
1	1	4	attacker	light	6 7 6 7
2	2	4	buffer	earth	5 5 5 5
3	3	4	attacker	light	6 6 7 8
4	4	4	debuffer	light	6 5 5 6
5	5	4	tank	light	5 5 5 5
6	6	4	healer	light	6 5 6 6
7	7	4	healer	light	7 6 7 6
8	8	4	buffer	fire	6 4 6 7
9	9	4	healer	water	6 6 6 6
10	10	4	debuffer	earth	7 7 4 5
11	11	4	buffer	earth	6 6 6 6
12	12	4	healer	earth	8 6 9 6
13	13	5	buffer	water	5 4 9 8
14	14	4	tank	earth	3 3 3 3
15	15	4	attacker	dark	4 4 4 4
16	16	4	tank	earth	3 3 3 3
17	17	4	healer	fire	7 5 7 6
18	18	3	buffer	water	6 6 7 9
19	19	3	tank	dark	4 3 3 1
20	20	3	attacker	fire	5 4 3 6
21	21	4	attacker	light	6 7 7 7
22	22	4	attacker	earth	7 6 8 10
23	23	4	attacker	water	7 9 8 9
24	24	5	debuffer	light	8 8 7 8
25	25	4	debuffer	fire	6 5 8 9
26	26	3	debuffer	fire	6 6 7 8
27	27	5	debuffer	dark	8 8 6 5
28	28	5	debuffer	light	7 8 3 3
29	29	4	buffer	fire	5 5 5 5
30	30	5	buffer	water	6 6 7 8
31	31	4	buffer	fire	5 5 7 7
32	32	5	attacker	dark	9 8 9 9
33	33	5	attacker	dark	6 6 7 8
34	34	5	attacker	dark	5 6 3 3
35	35	5	attacker	light	7 6 9 9
36	36	5	attacker	light	7 7 7 8
37	37	5	debuffer	earth	6 9 5 5
38	38	5	buffer	earth	7 8 9 6
39	39	5	debuffer	earth	6 7 5 5
40	40	5	attacker	earth	7 6 9 9
41	41	5	attacker	earth	7 8 7 8
42	42	5	attacker	earth	7 8 8 8
43	43	5	attacker	earth	7 7 8 9
44	44	5	tank	dark	6 6 6 3
45	45	5	tank	dark	6 5 6 4
46	46	5	tank	earth	6 7 3 3
47	47	5	tank	earth	6 7 4 3
48	48	5	tank	earth	7 7 7 5
49	49	5	tank	light	6 8 4 3
50	50	5	tank	light	6 7 4 3
51	51	5	tank	light	8 8 8 8
52	52	5	tank	water	8 8 8 10
53	53	5	tank	water	4 5 3 4
54	54	5	healer	dark	6 6 7 3
55	55	5	healer	dark	7 7 7 7
56	56	5	healer	earth	9 9 9 8
57	57	5	healer	earth	7 8 8 6
58	58	5	buffer	dark	3 4 8 8
59	59	5	buffer	fire	7 6 6 5
60	60	5	healer	light	10 8 9 10
61	61	5	buffer	earth	7 7 8 5
62	62	5	healer	light	7 8 7 7
63	63	5	healer	water	6 6 6 5
64	64	5	debuffer	water	4 4 5 7
65	65	5	tank	water	6 6 6 7
66	66	5	buffer	earth	10 9 10 10
67	67	5	buffer	dark	6 6 10 10
68	68	5	buffer	light	7 7 7 8
69	69	5	debuffer	fire	6 9 5 7
70	70	5	tank	water	8 8 7 6
71	71	5	attacker	light	7 7 7 7
72	72	5	buffer	light	9 9 10 9
73	73	5	buffer	water	7 8 7 7
74	74	5	attacker	earth	6 6 7 7
75	75	5	debuffer	light	5 3 4 3
76	76	5	buffer	dark	7 6 7 9
77	77	5	attacker	light	7 8 6 6
78	78	5	attacker	dark	8 8 8 8
79	79	5	debuffer	water	6 6 6 7
80	80	5	debuffer	water	7 9 5 5
81	81	5	healer	water	7 7 6 4
82	82	5	attacker	light	6 7 6 7
83	83	5	attacker	water	5 5 6 9
84	84	5	attacker	water	8 7 8 8
85	85	5	attacker	light	8 9 8 8
86	86	5	attacker	water	7 7 7 7
87	87	5	debuffer	dark	7 7 7 6
88	88	5	buffer	light	6 6 9 7
89	89	5	buffer	water	5 5 7 8
90	90	5	attacker	light	7 7 10 9
91	91	5	debuffer	light	7 6 8 10
92	92	5	debuffer	earth	6 6 8 9
93	93	5	buffer	light	4 4 4 9
94	94	5	debuffer	earth	7 6 7 7
95	95	5	debuffer	water	9 9 3 3
96	96	5	debuffer	fire	8 8 7 8
97	97	5	debuffer	water	6 8 5 5
98	98	5	debuffer	dark	6 6 3 3
99	99	5	attacker	earth	7 7 7 8
100	100	5	debuffer	fire	8 9 7 7
101	101	3	debuffer	light	0 0 0 0
102	102	3	debuffer	light	0 0 0 0
103	103	3	buffer	light	0 0 0 0
104	104	3	buffer	light	0 0 0 0
105	105	3	tank	light	0 0 0 0
106	106	3	tank	light	0 0 0 0
107	107	3	tank	light	0 0 0 0
108	108	3	tank	light	0 0 0 0
109	109	3	healer	light	0 0 0 0
110	110	3	attacker	dark	0 0 0 0
111	111	3	attacker	dark	0 0 0 0
112	112	3	attacker	dark	0 0 0 0
113	113	3	attacker	dark	0 0 0 0
114	114	3	attacker	dark	0 0 0 0
115	115	3	attacker	dark	0 0 0 0
116	116	3	debuffer	dark	0 0 0 0
117	117	3	debuffer	dark	0 0 0 0
118	118	3	attacker	dark	0 0 0 0
119	119	3	buffer	dark	0 0 0 0
120	120	3	buffer	dark	0 0 0 0
121	121	3	tank	dark	0 0 0 0
122	122	3	tank	dark	0 0 0 0
123	123	3	tank	dark	0 0 0 0
124	124	3	attacker	fire	0 0 0 0
125	125	3	attacker	fire	0 0 0 0
126	126	3	attacker	fire	0 0 0 0
127	127	3	attacker	fire	0 0 0 0
128	128	3	attacker	fire	0 0 0 0
129	129	3	debuffer	fire	0 0 0 0
130	130	3	debuffer	fire	0 0 0 0
131	131	3	buffer	fire	0 0 0 0
132	132	3	tank	fire	0 0 0 0
133	133	3	tank	fire	0 0 0 0
134	134	3	tank	fire	0 0 0 0
135	135	3	tank	fire	0 0 0 0
136	136	3	tank	fire	0 0 0 0
137	137	3	tank	fire	0 0 0 0
138	138	3	healer	fire	0 0 0 0
139	139	3	attacker	water	0 0 0 0
140	140	3	attacker	water	0 0 0 0
141	141	3	attacker	water	0 0 0 0
142	142	3	attacker	water	0 0 0 0
143	143	3	attacker	water	0 0 0 0
144	144	3	debuffer	water	0 0 0 0
145	145	3	debuffer	water	0 0 0 0
146	146	3	debuffer	water	0 0 0 0
147	147	3	buffer	water	0 0 0 0
148	148	3	tank	water	0 0 0 0
149	149	3	tank	water	0 0 0 0
150	150	3	tank	water	0 0 0 0
151	151	3	tank	water	0 0 0 0
152	152	3	tank	water	0 0 0 0
153	153	3	healer	water	0 0 0 0
154	154	3	attacker	earth	0 0 0 0
155	155	3	attacker	earth	0 0 0 0
156	156	3	attacker	earth	0 0 0 0
157	157	3	debuffer	earth	0 0 0 0
158	158	3	buffer	earth	0 0 0 0
159	159	3	buffer	earth	0 0 0 0
160	160	3	buffer	earth	0 0 0 0
161	161	3	tank	earth	0 0 0 0
162	162	3	tank	earth	0 0 0 0
163	163	3	tank	earth	0 0 0 0
164	164	3	tank	earth	0 0 0 0
165	165	3	tank	earth	0 0 0 0
166	166	3	healer	earth	0 0 0 0
167	167	3	healer	earth	0 0 0 0
168	168	3	healer	dark	0 0 0 0
169	169	3	tank	dark	0 0 0 0
170	170	3	attacker	fire	0 0 0 0
171	171	3	attacker	fire	0 0 0 0
172	172	3	attacker	light	0 0 0 0
173	173	3	debuffer	light	0 0 0 0
174	174	3	tank	light	0 0 0 0
175	175	3	healer	light	0 0 0 0
176	176	3	tank	dark	0 0 0 0
177	177	3	healer	dark	0 0 0 0
178	178	3	tank	fire	0 0 0 0
179	179	3	attacker	light	0 0 0 0
180	180	3	attacker	light	0 0 0 0
181	181	3	tank	light	0 0 0 0
182	182	5	attacker	earth	7 6 10 9
183	183	5	buffer	earth	5 6 5 6
184	184	5	attacker	light	10 9 10 8
185	185	5	healer	water	7 8 7 7
186	186	5	attacker	water	8 8 7 8
187	187	4	debuffer	earth	7 7 5 5
188	188	5	healer	fire	7 7 7 6
189	189	4	buffer	light	6 6 8 7
190	190	5	attacker	fire	8 8 8 9
191	191	5	tank	light	10 10 10 8
192	192	5	buffer	light	6 7 7 10
193	193	5	tank	fire	5 3 8 8
194	194	5	buffer	fire	6 6 7 10
195	195	5	tank	fire	6 7 6 3
196	196	5	buffer	fire	6 6 7 7
197	197	5	attacker	fire	8 8 8 8
198	198	5	healer	fire	7 7 7 7
199	199	5	attacker	fire	8 9 8 9
200	200	5	attacker	fire	7 5 7 8
201	201	5	attacker	dark	7 6 6 8
202	202	5	attacker	fire	6 6 6 7
203	203	5	attacker	fire	6 6 9 9
204	204	5	attacker	fire	8 9 9 9
205	205	5	buffer	fire	6 6 7 9
206	206	5	healer	fire	8 8 8 7
207	207	5	attacker	fire	7 6 7 10
208	208	5	buffer	fire	6 6 7 7
209	209	5	debuffer	earth	9 10 9 10
210	210	5	debuffer	fire	8 9 6 7
211	211	5	attacker	water	6 4 4 6
212	212	5	attacker	water	7 6 7 8
213	213	5	attacker	earth	7 7 9 9
214	214	5	attacker	earth	8 9 8 9
215	215	5	buffer	earth	6 5 9 9
216	216	5	tank	fire	7 8 7 6
217	217	5	debuffer	water	7 8 7 9
218	218	5	debuffer	fire	8 8 7 8
219	219	5	attacker	fire	7 6 9 8
220	220	5	buffer	dark	6 8 6 5
221	221	5	attacker	water	7 7 8 9
222	222	5	debuffer	fire	6 6 7 10
223	223	5	tank	fire	7 6 7 7
224	224	5	debuffer	earth	7 8 6 6
225	225	5	healer	water	7 7 6 6
226	226	5	tank	fire	6 7 8 5
227	227	5	buffer	dark	8 8 7 7
228	228	5	debuffer	dark	6 8 6 6
229	229	5	buffer	light	8 6 9 9
230	230	5	attacker	dark	7 8 7 8
231	231	5	attacker	fire	7 8 7 8
232	232	5	buffer	water	7 7 7 9
233	233	5	buffer	light	7 8 6 7
234	234	4	debuffer	fire	6 8 6 7
235	235	5	buffer	fire	7 6 9 8
236	236	5	attacker	earth	7 8 7 7
237	237	5	tank	dark	5 5 3 3
238	238	4	buffer	dark	6 6 5 5
239	239	5	tank	water	6 8 6 6
240	240	3	buffer	water	0 0 0 0
241	241	5	buffer	earth	6 7 5 8
242	242	5	healer	earth	7 7 6 6
243	243	5	attacker	water	8 9 9 10
244	244	5	attacker	water	8 8 9 9
245	245	5	attacker	water	10 9 9 9
246	246	5	attacker	water	7 6 6 8
247	247	5	debuffer	earth	6 9 6 6
248	248	5	debuffer	dark	8 10 5 7
249	249	5	attacker	dark	7 8 9 9
250	250	5	debuffer	fire	7 9 5 7
251	251	5	attacker	dark	7 7 10 9
252	252	5	attacker	earth	 8 8 10 9
253	253	5	debuffer	water	6 8 6 6
254	254	5	attacker	earth	7 6 8 9
255	255	5	healer	water	6 8 6 7
256	256	4	attacker	dark	7 7 8 8
257	257	3	healer	light	5 6 5 5
258	258	4	tank	light	5 6 5 5
259	259	4	attacker	dark	5 5 6 6
260	260	4	debuffer	dark	5 6 5 7
261	261	4	buffer	light	9 8 9 9
262	262	4	buffer	water	7 8 7 6
263	263	4	debuffer	water	6 8 3 3
264	264	4	debuffer	water	6 8 5 5
265	265	4	debuffer	dark	7 6 8 9
266	266	4	buffer	water	6 7 5 6
267	267	4	tank	water	5 6 5 6
268	268	4	buffer	light	7 7 8 7
269	269	4	buffer	dark	6 7 7 7
270	270	4	debuffer	dark	6 7 7 9
271	271	4	attacker	water	7 8 7 9
272	272	4	attacker	earth	7 8 7 7
273	273	4	attacker	fire	5 7 7 7
274	274	4	attacker	dark	7 7 6 6
275	275	4	attacker	light	6 6 6 6
276	276	4	attacker	dark	6 7 7 7
277	277	4	attacker	earth	6 7 7 7
278	278	4	attacker	fire	6 6 6 7
279	279	4	attacker	fire	6 6 6 5
280	280	4	attacker	dark	7 6 7 8
281	281	4	attacker	light	6 5 6 8
282	282	4	attacker	earth	6 5 7 8
283	283	4	attacker	earth	6 5 6 8
284	284	4	attacker	water	6 6 6 7
285	285	4	attacker	fire	6 6 5 7
286	286	4	tank	water	3 6 3 3
287	287	4	tank	light	6 5 6 5
288	288	4	tank	fire	6 5 6 4
289	289	4	tank	fire	3 6 3 3
290	290	4	tank	fire	4 5 4 4
291	291	4	tank	dark	3 5 3 3
292	292	4	tank	fire	3 4 3 3
293	293	4	tank	dark	3 5 3 3
294	294	4	tank	earth	5 4 5 5
295	295	4	tank	dark	6 6 6 6
296	296	4	healer	dark	6 5 6 6
297	297	4	healer	dark	5 6 5 5
298	298	5	attacker	water	8 7 10 9
299	299	5	buffer	water	6 5 7 9
300	300	5	buffer	water	8 7 9 9
301	301	5	healer	light	10 10 8 8
302	302	5	buffer	water	10 10 9 10
303	303	5	buffer	water	9 10 10 9
304	304	5	buffer	fire	8 7 9 9
305	305	5	attacker	fire	6 7 10 8
306	306	5	attacker	fire	8 9 7 8
307	307	5	tank	earth	7 8 6 6
308	308	5	debuffer	earth	7 6 7 10
309	309	5	buffer	water	7 7 8 9
310	310	5	buffer	earth	8 6 10 10
311	311	5	attacker	fire	7 6 9 9
312	312	5	buffer	dark	0 0 0 0
313	313	5	debuffer	dark	7 7 5 8
314	314	5	attacker	light	0 0 0 0
\.


--
-- Data for Name: profilepics; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.profilepics (id, unit_id, pic1, pic2, pic3, pic4) FROM stdin;
1	1	/images/4maidendetective0.png			emptyunit0.png
2	2	/images/4rednose0.png			emptyunit0.png
3	3	/images/4titania0.png			emptyunit0.png
4	4	/images/4ishtar0.png			emptyunit0.png
5	5	/images/4frigga0.png			emptyunit0.png
6	6	/images/4pomona0.png			emptyunit0.png
7	7	/images/4merlin0.png			emptyunit0.png
8	8	/images/4fortuna0.png			emptyunit0.png
9	9	/images/4isis0.png			emptyunit0.png
10	10	/images/4muse0.png			emptyunit0.png
11	11	/images/4flora0.png			emptyunit0.png
12	12	/images/4selene0.png			emptyunit0.png
13	13	/images/hatsunemiku0.png			emptyunit0.png
14	14	/images/4hat-trick0.png			emptyunit0.png
15	15	/images/4guillotine0.png			emptyunit0.png
16	16	/images/4ankh0.png			emptyunit0.png
17	17	/images/4daphne0.png			emptyunit0.png
18	18	/images/3lisa0.png			emptyunit0.png
19	19	/images/3mona0.png			emptyunit0.png
20	20	/images/3davi0.png			emptyunit0.png
21	21	/images/4victrix0.png			emptyunit0.png
22	22	/images/4amor0.png			emptyunit0.png
23	23	/images/4elysium0.png			emptyunit0.png
24	24	/images/nirrti0.png			emptyunit0.png
25	25	/images/4freesia0.png			emptyunit0.png
26	26	/images/3tiamat0.png			emptyunit0.png
27	27	/images/lanfei0.png			emptyunit0.png
28	28	/images/moa0.png	/images/moa1.png		emptyunit0.png
29	29	/images/4rudolph0.png			emptyunit0.png
30	30	/images/princessmiku0.png			emptyunit0.png
31	31	/images/4creature0.png			emptyunit0.png
32	32	/images/frey0.png			emptyunit0.png
33	33	/images/elizabeth0.png			emptyunit0.png
34	34	/images/darkmaat0.png			emptyunit0.png
35	35	/images/freylight0.png			emptyunit0.png
36	36	/images/hildr0.png			emptyunit0.png
37	37	/images/lovesitri0.png			emptyunit0.png
38	38	/images/botan0.png	/images/botan1.png		emptyunit0.png
39	39	/images/ruin0.png			emptyunit0.png
40	40	/images/krampus0.png	/images/krampus1.png		emptyunit0.png
41	41	/images/serval0.png	/images/serval1.png		emptyunit0.png
42	42	/images/gkouga0.png			emptyunit0.png
43	43	/images/magicianohad0.png	/images/magicianohad1.png		emptyunit0.png
44	44	/images/ai0.png			emptyunit0.png
45	45	/images/redcross0.png			emptyunit0.png
46	46	/images/hera0.png	/images/hera1.png		emptyunit0.png
47	47	/images/mammon0.png			emptyunit0.png
48	48	/images/marierose0.png	/images/marierose1.png	/images/marierose2.png	emptyunit0.png
49	49	/images/athena0.png			emptyunit0.png
50	50	/images/diablo0.png	/images/diablo1.png		emptyunit0.png
51	51	/images/slimeking.png			emptyunit0.png
52	52	/images/maris0.png			emptyunit0.png
53	53	/images/eshu0.png			emptyunit0.png
54	54	/images/metis0.png			emptyunit0.png
55	55	/images/darkmidas0.png			emptyunit0.png
56	56	/images/syrinx0.png			emptyunit0.png
57	57	/images/astraea0.png			emptyunit0.png
58	58	/images/warwolf0.png	/images/warwolf1.png		emptyunit0.png
59	59	/images/fennec0.png	/images/fennec1.png		emptyunit0.png
60	60	/images/maat0.png	/images/maat1.png		emptyunit0.png
61	61	/images/epona0.png			emptyunit0.png
62	62	/images/innocentvenus0.png			emptyunit0.png
63	63	/images/rusalka0.png			emptyunit0.png
64	64	/images/tethys0.png			emptyunit0.png
65	65	/images/raccoon0.png	/images/raccoon1.png		emptyunit0.png
66	66	/images/newbiemona0.png			emptyunit0.png
67	67	/images/pantheon0.png			emptyunit0.png
68	68	/images/aria0.png			emptyunit0.png
69	69	/images/maruru0.png			emptyunit0.png
70	70	/images/bes0.png	/images/bes1.png		emptyunit0.png
71	71	/images/ashtoreth0.png	/images/ashtoreth1.png		emptyunit0.png
72	72	/images/hardworkerneptune0.png			emptyunit0.png
73	73	/images/anemone0.png	/images/anemone1.png		emptyunit0.png
74	74	/images/abaddon0.png			emptyunit0.png
75	75	/images/horus0.png			emptyunit0.png
76	76	/images/durandal0.png			emptyunit0.png
77	77	/images/bastet0.png	/images/bastet1.png		emptyunit0.png
78	78	/images/khepri0.png			emptyunit0.png
79	79	/images/santa0.png			emptyunit0.png
80	80	/images/isolde0.png	/images/isolde1.png		emptyunit0.png
81	81	/images/snowmiku0.png			emptyunit0.png
82	82	/images/charlotte0.png			emptyunit0.png
83	83	/images/calypso0.png			emptyunit0.png
84	84	/images/kasumi0.png	/images/kasumi1.png	/images/kasumi3.png	emptyunit0.png
85	85	/images/mafdet0.png	/images/mafdet1.png		emptyunit0.png
86	86	/images/bari0.png			emptyunit0.png
87	87	/images/rita0.png			emptyunit0.png
88	88	/images/nevanlight0.png			emptyunit0.png
89	89	/images/myrina0.png			emptyunit0.png
90	90	/images/purehildr0.png			emptyunit0.png
91	91	/images/kagurawarwolf0.png			emptyunit0.png
92	92	/images/midas0.png			emptyunit0.png
93	93	/images/luna0.png			emptyunit0.png
94	94	/images/cammy0.png			emptyunit0.png
95	95	/images/orga0.png			emptyunit0.png
96	96	/images/jupiter0.png	/images/jupiter1.png		emptyunit0.png
97	97	/images/babel0.png	/images/babel1.png		emptyunit0.png
98	98	/images/medusa0.png			emptyunit0.png
99	99	/images/siren0.png			emptyunit0.png
100	100	/images/demeter0.png	/images/demeter1.png		emptyunit0.png
101	101	/images/noisesource3.png			emptyunit0.png
102	102	/images/lightreveng3.png			emptyunit0.png
103	103	/images/morgana3.png			emptyunit0.png
104	104	/images/leuce3.png			emptyunit0.png
105	105	/images/teddy3.png			emptyunit0.png
106	106	/images/arms3.png			emptyunit0.png
107	107	/images/liyuga3.png			emptyunit0.png
108	108	/images/wangkuni3.png			emptyunit0.png
109	109	/images/berit3.png			emptyunit0.png
110	110	/images/genius3.png			emptyunit0.png
111	111	/images/jeonseol3.png			emptyunit0.png
112	112	/images/idun3.png			emptyunit0.png
113	113	/images/medeia3.png			emptyunit0.png
114	114	/images/kratos3.png			emptyunit0.png
115	115	/images/giftbag3.png			emptyunit0.png
116	116	/images/purplereveng3.png			emptyunit0.png
117	117	/images/skuld3.png			emptyunit0.png
118	118	/images/valkyrie3.png			emptyunit0.png
119	119	/images/elias3.png			emptyunit0.png
120	120	/images/cynthia3.png			emptyunit0.png
121	121	/images/messenger3.png			emptyunit0.png
122	122	/images/darkwarcher3.png			emptyunit0.png
123	123	/images/blackdaron3.png			emptyunit0.png
124	124	/images/pyro3.png			emptyunit0.png
125	125	/images/vesta3.png			emptyunit0.png
126	126	/images/rune3.png			emptyunit0.png
127	127	/images/sekhmet3.png			emptyunit0.png
128	128	/images/shamash3.png			emptyunit0.png
129	129	/images/firereveng3.png			emptyunit0.png
130	130	/images/treasurechest3.png			emptyunit0.png
131	131	/images/hypnos3.png			emptyunit0.png
132	132	/images/blazewatcher3.png			emptyunit0.png
133	133	/images/scarletdaron3.png			emptyunit0.png
134	134	/images/phoenix3.png			emptyunit0.png
135	135	/images/angerdragon3.png			emptyunit0.png
136	136	/images/tartarus3.png			emptyunit0.png
137	137	/images/judas3.png			emptyunit0.png
138	138	/images/demeters3.png			emptyunit0.png
139	139	/images/seshet3.png			emptyunit0.png
140	140	/images/goga3.png			emptyunit0.png
141	141	/images/atalanta3.png			emptyunit0.png
142	142	/images/jeannedarc3.png			emptyunit0.png
143	143	/images/vulcanus3.png			emptyunit0.png
144	144	/images/bluereveng3.png			emptyunit0.png
145	145	/images/mnemosyne3.png			emptyunit0.png
146	146	/images/hecate3.png			emptyunit0.png
147	147	/images/djhertz3.png			emptyunit0.png
148	148	/images/frozenwatcher3.png			emptyunit0.png
149	149	/images/aquadaron3.png			emptyunit0.png
150	150	/images/crueltydragon3.png			emptyunit0.png
151	151	/images/baphomet3.png			emptyunit0.png
152	152	/images/bluewyvern3.png			emptyunit0.png
153	153	/images/deino3.png			emptyunit0.png
154	154	/images/menti3.png			emptyunit0.png
155	155	/images/freyja3.png			emptyunit0.png
156	156	/images/atropos3.png			emptyunit0.png
157	157	/images/greenreveng3.png			emptyunit0.png
158	158	/images/ptah3.png			emptyunit0.png
159	159	/images/wool3.png			emptyunit0.png
160	160	/images/diana3.png			emptyunit0.png
161	161	/images/sylvanwatcher3.png			emptyunit0.png
162	162	/images/leafdaron3.png			emptyunit0.png
163	163	/images/bellboy3.png			emptyunit0.png
164	164	/images/basilisk3.png			emptyunit0.png
165	165	/images/eris3.png			emptyunit0.png
166	166	/images/poisonampule3.png			emptyunit0.png
167	167	/images/apollon3.png			emptyunit0.png
168	168	/images/alecto3.png			emptyunit0.png
169	169	/images/baal3.png			emptyunit0.png
170	170	/images/bazooka3.png			emptyunit0.png
171	171	/images/fighter3.png			emptyunit0.png
172	172	/images/choeoyong3.png			emptyunit0.png
173	173	/images/nymph3.png			emptyunit0.png
174	174	/images/photwatcher3.png			emptyunit0.png
175	175	/images/salmacis3.png			emptyunit0.png
176	176	/images/chainkiller3.png			emptyunit0.png
177	177	/images/chaser3.png			emptyunit0.png
178	178	/images/redwyvern3.png			emptyunit0.png
179	179	/images/boxer3.png			emptyunit0.png
180	180	/images/jana3.png			emptyunit0.png
181	181	/images/lightfeatherdaron3.png			emptyunit0.png
182	182	/images/jiseihi0.png			emptyunit0.png
183	183	/images/yanagi0.png			emptyunit0.png
184	184	/images/cleopatra0.png	/images/cleopatra2.png		emptyunit0.png
185	185	/images/makoto0.png	/images/makoto1.png		emptyunit0.png
186	186	/images/noel0.png	/images/noel1.png	/images/noel2.png	emptyunit0.png
187	187	/images/4agamemnon0.png			emptyunit0.png
188	188	/images/aurora0.png	/images/aurora1.png		emptyunit0.png
189	189	/images/4erato0.png			emptyunit0.png
190	190	/images/morgan0.png			emptyunit0.png
191	191	/images/dana0.png			emptyunit0.png
192	192	/images/sitri0.png			emptyunit0.png
193	193	/images/dinashi0.png	/images/dinashi1.png		emptyunit0.png
194	194	/images/ganesh0.png			emptyunit0.png
195	195	/images/hades0.png	/images/hades1.png		emptyunit0.png
196	196	/images/hermes0.png	/images/hermes1.png		emptyunit0.png
197	197	/images/hestia0.png			emptyunit0.png
198	198	/images/honoka0.png	/images/honoka1.png	/images/honoka2.png	emptyunit0.png
199	199	/images/kouka0.png			emptyunit0.png
200	200	/images/magicianailill0.png			emptyunit0.png
201	201	/images/kubaba0.png	/images/kubaba1.png		emptyunit0.png
202	202	/images/maoudavi0.png			emptyunit0.png
203	203	/images/medb0.png			emptyunit0.png
204	204	/images/oiranbathory0.png			emptyunit0.png
205	205	/images/partystarmedb0.png	/images/partystarmedb1.png		emptyunit0.png
206	206	/images/profdana0.png	/images/profdana1.png		emptyunit0.png
207	207	/images/tyrfing0.png			emptyunit0.png
208	208	/images/verdel0.png			emptyunit0.png
209	209	/images/bathory0.png	/images/bathory1.png		emptyunit0.png
210	210	/images/nine0.png			emptyunit0.png
211	211	/images/busterliza0.png			emptyunit0.png
212	212	/images/chunli0.png			emptyunit0.png
213	213	/images/daphnis0.png	/images/daphnis1.png		emptyunit0.png
214	214	/images/nicole0.png	/images/nicole1.png		emptyunit0.png
215	215	/images/bikinilisa0.png	/images/bikinilisa1.png		emptyunit0.png
216	216	/images/keino0.png	/images/keino1.png	/images/keino2.png	emptyunit0.png
217	217	/images/billy0.png	/images/billy4.png	/images/billy2.png	emptyunit0.png
218	218	/images/tamamo0.png	/images/tamamo1.png	/images/tamamo2.png	emptyunit0.png
219	219	/images/tiamatwb0.png	/images/tiamatwb1.png		emptyunit0.png
220	220	/images/pallas0.png			emptyunit0.png
221	221	/images/mafdettoo0.png	/images/mafdettoo1.png		emptyunit0.png
222	222	/images/scubamona0.png	/images/scubamona1.png		emptyunit0.png
223	223	/images/brigette.png			emptyunit0.png
224	224	/images/katherine0.png	/images/katherine1.png	/images/katherine2.png	emptyunit0.png
225	225	/images/rin0.png	/images/rin1.png		emptyunit0.png
226	226	/images/catherine0.png	/images/catherine1.png		emptyunit0.png
227	227	/images/laima0.png	/images/laima1.png		emptyunit0.png
228	228	/images/alterdavi0.png	/images/alterdavi1.png		emptyunit0.png
229	229	/images/lightmona0.png	/images/lightmona1.png		emptyunit0.png
230	230	/images/ophois0.png	/images/ophois1.png	/images/ophois2.png	emptyunit0.png
231	231	/images/ziva0.png	/images/ziva1.png	/images/ziva2.png	emptyunit0.png
232	232	/images/guiltine0.png	/images/guiltine1.png	/images/guiltine2.png	emptyunit0.png
233	233	/images/snoweshu0.png	/images/snoweshu1.png		emptyunit0.png
234	234	/images/flince0.png	/images/flince1.png		emptyunit0.png
235	235	/images/failnaught00.png	/images/failnaught01.png		emptyunit0.png
236	236	/images/piercingruin00.png			emptyunit0.png
237	237	/images/twosidedmoa0.png			emptyunit0.png
238	238	/images/typhon0.png			emptyunit0.png
239	239	/images/pakhet0.png	/images/pakhet1.png		emptyunit0.png
240	240	/images/euros3.png	/images/pakhet2.png		emptyunit0.png
241	241	/images/brownie0.png			emptyunit0.png
242	242	/images/heqet0.png			emptyunit0.png
243	243	/images/serket0.png	/images/serket1.png		emptyunit0.png
244	244	/images/eve0.png	/images/eve1.png		emptyunit0.png
245	245	/images/salome0.png			emptyunit0.png
246	246	/images/thanatos0.png			emptyunit0.png
247	247	/images/pan0.png			emptyunit0.png
248	248	/images/banshee0.png	/images/banshee1.png		emptyunit0.png
249	249	/images/prettymars0.png	/images/prettymars1.png		emptyunit0.png
250	250	/images/studenteve0.png			emptyunit0.png
251	251	/images/mysterioussaturn0.png			emptyunit0.png
252	252	/images/annie0.png	/images/annie1.png		emptyunit0.png
253	253	/images/methuselah0.png	/images/methuselah1.png		emptyunit0.png
254	254	/images/Hel0.png			emptyunit0.png
255	255	/images/pakhet2.png			emptyunit0.png
256	256	/images/4pietas0.png			emptyunit0.png
257	257	/images/3angel0.png			emptyunit0.png
258	258	/images/4Gomorrah0.png			emptyunit0.png
259	259	/images/4Gungnir0.png			emptyunit0.png
260	260	/images/4Hydra0.png			emptyunit0.png
261	261	/images/4leda0.png			emptyunit0.png
262	262	/images/4mayahuel0.png			emptyunit0.png
263	263	/images/4arges0.png			emptyunit0.png
264	264	/images/4yaga0.png			emptyunit0.png
265	265	/images/4persephone0.png			emptyunit0.png
266	266	/images/4kirinus0.png			emptyunit0.png
267	267	/images/4thoth0.png			emptyunit0.png
268	268	/images/4bast0.png			emptyunit0.png
269	269	/images/4melpomene0.png			emptyunit0.png
270	270	/images/4nevan0.png			emptyunit0.png
271	271	/images/4sonnet0.png			emptyunit0.png
272	272	/images/4korra0.png			emptyunit0.png
273	273	/images/4yuna0.png			emptyunit0.png
274	274	/images/4artemis0.png			emptyunit0.png
275	275	/images/4calchas0.png			emptyunit0.png
276	276	/images/4morrigu0.png			emptyunit0.png
277	277	/images/4tristan0.png			emptyunit0.png
278	278	/images/4fenrir0.png			emptyunit0.png
279	279	/images/4hector0.png			emptyunit0.png
280	280	/images/4inanna0.png			emptyunit0.png
281	281	/images/4orora0.png			emptyunit0.png
282	282	/images/4tisiphone0.png			emptyunit0.png
283	283	/images/4ambrosia0.png			emptyunit0.png
284	284	/images/4danu0.png			emptyunit0.png
285	285	/images/4neid0.png			emptyunit0.png
286	286	/images/4halloween0.png			emptyunit0.png
287	287	/images/4heracles0.png			emptyunit0.png
288	288	/images/4eldorado0.png			emptyunit0.png
289	289	/images/4fairy0.png			emptyunit0.png
290	290	/images/4lady0.png			emptyunit0.png
291	291	/images/4bakje0.png			emptyunit0.png
292	292	/images/4chimaera0.png			emptyunit0.png
293	293	/images/4aten0.png			emptyunit0.png
294	294	/images/4europa0.png			emptyunit0.png
295	295	/images/4cybele0.png			emptyunit0.png
296	296	/images/4zelos0.png			emptyunit0.png
297	297	/images/unknown0.png			emptyunit0.png
298	298	/images/dino0.png			emptyunit0.png
299	299	/images/bikinidavi0.png	/images/bikinidavi1.png		emptyunit0.png
300	300	/images/leo2.png	/images/leo1.png		emptyunit0.png
301	301	/images/purepomona0.png	/images/purepomono1.png		emptyunit0.png
302	302	/images/kouga0.png			emptyunit0.png
303	303	/images/tisbe0.png	/images/tisbe1.png	/images/tisbe2.png	emptyunit0.png
304	304	/images/christmasleda0.png			emptyunit0.png
305	305	/images/firedavi00.png			emptyunit0.png
306	306	/images/caine0.png	/images/caine1.png		emptyunit0.png
307	307	/images/raffles0.png	/images/raffles1.png		emptyunit0.png
308	308	/images/navi0.png	/images/navi1.png		emptyunit0.png
309	309	/images/naiad0.png			emptyunit0.png
310	310	/images/fancysitri0.png	/images/fancysitri1.png		emptyunit0.png
311	311	/images/sweetleda0.png	/images/sweetleda1.png		emptyunit0.png
312	312	/images/lupin0.png	/images/lupin1.png		emptyunit0.png
313	313	/images/iphis0.png	/images/iphis1.png	/images/iphis2.png	emptyunit0.png
314	314	/images/deborah0.png			emptyunit0.png
\.


--
-- Data for Name: scstats; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.scstats (id, sc_id, pic1, stars, normalstat1, normalstat2, prismstat1, prismstat2, restriction, ability, notes) FROM stdin;
1	1	/images/sc/afternoontrain.jpg	3	hp 765 1350 1836	agility 756 1350 1836			Light	Curse +20	
2	2	/images/sc/marineidol.jpg	3	HP 510 800 1220	Agility 135 425 648			Water	Poison +30 (120).	
3	3	/images/sc/kokoro.jpg	3	Attack 270 0 0	Defense 250 0 0			none.	Increase Final critical by +100.	
4	4	/images/sc/misaki.jpg	3	Defense 260 0 0	Critical 145 0 0			none.	Increase HoT received by +15.	
5	5	/images/sc/scupgrade3.jpg	3	NA 0 0 0	NA 0 0 0			None.	Increase + EXP by 28.	
6	6	/images/sc/goodmoa.jpg	4	HP 765 1350 1836	Agility 202 787 1070			None.	Poison +50 (250 at lvl40 +4).	
7	7	/images/sc/hero.jpg	4	Attack 390 975 1326	Agility 202 787 1070			None.	Absorb 100HP in Devil Rumble.	
8	8	/images/sc/highjump.jpg	4	Attack 390 975 1326	Critical 202 787 1070			None.	Bleed +70.	
9	9	/images/sc/lookupatclouds.jpg	4	Attack 430 0 0	Agility 206 0 0			none.	Add 3% of your Final attack power to your Final agility power.	
10	10	/images/sc/lacia.jpg	4	HP 790 0 0	Defense 400 0 0			none.	Add 2% of your Final attack power to your Final critical power.	
11	11	/images/sc/runa.jpg	4	Defense 395 0 0	Agility 210 0 0			None.	Increase Blind Resist by +15% in Devil Rumble.	
12	12	/images/sc/onnatengu.jpg	4	HP 775 0 0	Critical 210 0 0			Light.	Increase Curse damage by +75.	
13	13	/images/sc/scupgrade4.jpg	4	NA 0 0 0	NA 0 0 0			none.	Increases + EXP by 84.	
14	14	/images/sc/strategistnight.jpg	4	HP 775 1340 1849	Defense 395 980 1332			Tank.	Final Defense +10%.	
15	15	/images/sc/timeover.jpg	4	HP 765 1350 1836	Attack 390 975 1326			None.	Silence Resist +10% (16% at lvl40 +4) in Devil Rumble.	
16	16	/images/sc/scupgrade5.jpg	5	NA 0 0 0	NA 0 0 0	NA 0 0 0	NA 0 0 0	None.	Increases + EXP by 480.	
17	17	/images/sc/secretdate.jpg	3	HP 510 800 1220	Critical 135 425 648			Grass.	HP +200.	
18	18	/images/sc/seriousworker.jpg	3	Attack 260 550 838	Critical 135 425 648			Dark.	Final Defense +200.	
19	19	/images/sc/smallassailant.jpg	3	Attack 260 550 838	Agility 135 425 648			Attacker.	Final Attack +300 (600 at lvl30 +3).	
20	20	/images/sc/sweetpropose.jpg	3	HP 510 800 1220	Attack 260 550 839			None.	Bleed +20.	
21	21	/images/sc/azuregirl.jpg	5	Attack 520 0 0	Agility 270 0 0	Attack 520 620 720	Agility 270 370 470	Nothing is restricted	I can do anything. (Especially if I am a 5*)	
22	22	/images/sc/lostdream.jpg	5	HP 1100 2080 3640	Defense 600 1580 2765	HP 1118 2098 3671	Defense 616 1596 2793	Fire.	"Deadly poison" damage +200 (250) [+10 if Prism]	
23	23	/images/sc/dive.jpg	5	HP 1090 2070 3622	Def 540 1520 2660	HP N/A N/A N/A	Def N/A N/A N/A	Attacker	In PvP only, upon using Tap Skill, 25% (40%) chance of gaining 800 (1300) Barrier for 10s to self	
24	24	/images/sc/eternaloath.jpg	5	Attack 590 1570 2747	Defense 630 1610 2817	Attack 616 1586 2775	Defense 646 1626 2845	none	Debuff Evasion +10%(15%) [+1% if Prism]	
25	25	/images/sc/runaway.jpg	5	Attack 560 1540 2695	Critical 290 1270 2222	Attack 576 1556 2723	Critical 302 1282 2243	Light.	Increase Critical stat by 800(1300)[+25 if prism] in Raid Boss.	
26	26	/images/sc/handsomeadventure.jpg	5	Attack 620 1600 2800	Agility 350 1330 2328	Attack 636 1616 2828	Agility 362 1342 2348	Water attacker.	Increase critical rate by 6%(16%)[+0.5 if prism]	
27	27	/images/sc/afternoonnap.jpg	5	HP 1040 2020 3535	Critical 270 1250 2188	HP 1058 2038 3566	Critical 278 1258 2201	Fire.	DoT Accuracy +30% (55%)[+5 if prism] in WorldBoss	
28	28	/images/sc/ayane.jpg	5	HP 1070 2050 3587	Agility 300 1280 2240	HP 1088 2068 3619	Agility 312 1292 2261	None.	Increase Petrify resist +30%(50%)[+1.5 if prism] in Devil Rumble.	
29	29	/images/sc/azuregirl.jpg	5	Attack 520 1500 2625	Agility 270 1250 2187	Attack 526 1506 2635	Agility 278 1258 2201	Water type.	Poison +1000 (1500)[+100 if prism] in WorldBoss.	
30	30	/images/sc/believe.jpg	5	Defense 520 1500 2625	Critical 270 1250 2187	Defense 526 1506 2635	Critical 278 1258 2201	Wood type.	Reduce poison damage received by 250 (500)[+15 if prism] in Devil Rumble.	
31	31	/images/sc/cakeaesthetics.jpg	5	Attack 610 1590 2782	Critical 340 1320 2310	Attack 626 1606 2810	Critical 352 1332 2331	Fire attacker.	Slide skill critical damage +10%(20%)[+0.5 if prism]	
32	32	/images/sc/christmasgift.jpg	5	Attack 590 1570 2747	Agility 330 1310 2292	Attack 606 1586 2775	Agility 342 1322 2313	Attacker.	Slide skill damage +350(500)[+15 if prism]	
33	33	/images/sc/crossedheart.jpg	5	HP 1050 2030 3552	Defense 560 1540 2695	HP 1065 2045 3578	Defense 566 1546 2705	none.	Increase Stun Ignore by 30%(50%)[+1.5 if prism] in Devil Rumble.	
34	34	/images/sc/dangerousgambler.jpg	5	Attack 610 1590 2782	Agility 340 1320 2310	Attack 626 1606 2810	Agility 352 1332 2331	Light attacker.	Slide skill critical damage +10%(20%)[+0.5 if prism]	
35	35	/images/sc/darktownleader.jpg	5	Attack 610 1590 2782	Agility 340 1320 2310	Attack 626 1606 2810	Agility 352 1332 2331	Dark attacker.	Increase critical hit chance by 5%(15%)[+0.5 if prism].	
36	36	/images/sc/endosiblings.jpg	5	Attack 570 1550 2712	Agility 320 1300 2275	Attack N/A N/A N/A	Agility N/A N/A N/A	none.	9%(14%) of agility is added to attack.	
37	37	/images/sc/fluffymelons.jpg	5	HP 520 N/A N/A	Defense 1020 N/A N/A	HP 536 1516 2653	Defense 1038 2018 3531	none. Note Only comes in Prism form, only obtainable from April fools event.	Instant heal increased by 850(1350)	
38	38	/images/sc/glossypeach.jpg	5	HP 1020 N/A N/A	Defense 520 N/A N/A	HP 536 1516 2653	Defense 1038 2018 3531	none. Note* Only comes in Prism form, only obtainable from April fools event.	Sustained recovery (HoT) increased by 145(245)	
39	39	/images/sc/forbiddenfruit.jpg	5	Attack 560 1540 2695	Agility 290 1270 2222	Attack 576 1556 2723	Agility 302 1282 2243	none.	30%(80%)[+2.5 if Prism] chance to ignore Death Heal in Raid Boss.	
40	40	/images/sc/ganryudavi.jpg	5	Attack 550 N/A N/A	Defense 590 N/A N/A	Attack 566 1546 2705	Defense 606 1586 2775	None. Note* Only comes in Prism form, only obtainable from a collab event.	Add 9.5%(14.5%) of your defense to your attack power.	
41	41	/images/sc/godhavemercy.jpg	5	Attack 610 1590 2782	Agility 340 1320 2310	Attack 626 1606 2810	Agility 352 1332 2331	Light attacker.	Increase critical hit chance by 5%(15%)[+0.5 if Prism].	
42	42	/images/sc/halloweendiva.jpg	5	Defense 550 1530 2677	Agility 310 1290 2257	Defense 566 1546 2705	Agility 322 1302 2278	none.	Increase Final HP +1500(2500)[+20 if Prism]	
43	43	/images/sc/higginsdaughters.jpg	5	Attack 570 1550 2712	Critical 320 1300 2275	Attack N/A N/A N/A	Critical N/A N/A N/A	none.	9%(14%) of critical is added to attack.	
44	44	/images/sc/callthecops.jpg	5	HP 1090 2070 3622	Defense 590 1570 2747	HP 1108 2088 3654	Defense 606 1586 2775	None.	9%(14%)[+0.5 if Prism] of defense stat is added to critical.	
45	45	/images/sc/icedamericano.jpg	5	HP 1060 2040 3570	Def 570 1550 2712	HP 1078 2058 3601	Def 586 1566 2740	Attacker.	Using slide skill grants a 40% (45%)[+0.5 if Prism]chance to get 700HP(1200HP)[+50 if Prism] barrier for 10 seconds in Underground.	
46	46	/images/sc/inspiration.jpg	5	Attack 590 1570 2747	Critical 310 1290 2257	Attack 606 1586 2775	Critical 322 1302 2278	Dark.	Ignore Damage +350(500)[+15 if Prism] added to Tap Skill in Raid Boss.	
47	47	/images/sc/meltychristmas.jpg	5	Attack 610 1590 2782	Critical 340 1320 2310	Attack 626 1606 2810	Critical 352 1332 2331	Grass attacker.	Slide skill critical damage +10%(20%)[+0.5 if Prism]	
48	48	/images/sc/nobalnewyear.jpg	5	Attack 600 1580 2765	Critical 340 1320 2310	Attack 616 1596 2793	Critical 352 1332 2331	Light.	Attack stat +1150(1900)[+25 if Prism] at WorldBoss.	
49	49	/images/sc/queenofnight.jpg	5	HP 1020 2000 3500	Critical 270 1250 2187	HP 1038 2018 3531	Critical 282 1262 2208	None.	Attack +500(1000)[+25 if Prism]	
50	50	/images/sc/ppponstage.jpg	5	HP 1110 2090 3657	Atk 610 1590 2782	HP 1128 2108 3689	Atk 626 1606 2810	none.	Deal 350(600)[+15 if Prism] Ignore Defense damage when using Slide Skill in PVE.	
51	51	/images/sc/piercingbluesky.jpg	5	Attack 520 1500 2625	Critical 270 1250 2187	Attack 526 1506 2635	Critical 278 1258 2201	Light Attacker.	50% (65%)[+1 if Prism] chance to ignore Taunt.	
52	52	/images/sc/kitakubunewyear.jpg	5	Defense 590 1570 2747	Agility 330 1310 2292	Defense 606 1586 2775	Agility 342 1322 2313	none.	9%(14%)[+0.5 if Prism] of Agility is added to HP	
53	53	/images/sc/ilovesake.jpg	5	HP 1100 2080 3640	Defense 600 1580 2765	HP 1118 2098 3671	Defense 616 1596 2793	Light.	Defense +800(1300)[+25 if Prism]	
54	54	/images/sc/seasidegoddess.jpg	5	HP 1040 2020 3535	Def 550 1530 2677	HP 1058 2038 3566	Def 556 1536 2688	None.	Bleed +220 (320)[+10 if Prism] in Devil Rumble.	
55	55	/images/sc/vacation.jpg	5	Defense 550 1530 2677	Agility 280 1260 2205	Defense 606 1586 2775	Agility 288 1268 2219	None.	Poison evasion +35% (50%)[+0.5 if Prism] in Devil Rumble.	
56	56	/images/sc/wanderingdoctor.jpg	5	Attack 500 1480 2590	Defense 540 1520 2660	Attack 505 1485 2598	Defense 547 1527 2672	Attacker.	Vampirism/HP Absorb +200 (450)[+15 if Prism] in Underground.	
57	57	/images/sc/wisteriatree.jpg	5	HP 1030 2010 3517	AGI 270 1250 2187	HP 1048 2028 3549	AGI 278 1258 2201	Wood type.	Bleed Evasion +35% (50%)[+0.5 if Prism]	
58	58	/images/sc/undertherose.jpg	5	Defense 590 1570 2747	Agility 320 1300 2275	Defense 606 1586 2775	Agility 332 1312 2296	None.	"Dancing Blade" debuff damage +170(270)[+10 if Prism] in Devil Rumble	
59	59	/images/sc/togetherwithmeat.jpg	5	HP 1020 2000 3500	Attack 520 1500 2625	HP 1038 2018 3531	Attack 526 1506 2635	None.	Heal block Resist +40%(65%)[+1 if Prism]	
60	60	/images/sc/stf.jpg	5	Attack 530 1510 2642	Critical 270 1250 2187	Attack 536 1516 2653	Critical 278 1258 2201	Light.	Curse damage +200(300)[+20 if Prism]	
61	61	/images/sc/brieftranquility.jpg	5	Attack 620 1600 2800	Critical 350 1330 2327	Attack 636 1616 2828	Critical 362 1342 2348	Water attacker.	Slide skill critical damage + 11%(21%)[+0.5 if Prism]	
62	62	/images/sc/treasurehunter.jpg	5	Attack 610 1590 2782	Agility 340 1320 2310	Attack 626 1606 2810	Agility 352 1332 2331	Fire attacker.	Increase Critical hit chance by 5%(15%)[+0.5 if Prism]	
63	63	/images/sc/powerofsmile.jpg	5	HP 1020 2000 3500	Attack 520 1500 2625	HP 1038 2018 3531	Attack 526 1506 2635	Grass Attacker.	Poison Resist +35% (50%)[+0.5 if Prism]	
64	64	/images/sc/tamaki.jpg	5	Attack 580 1560 2730	Defense 540 1520 2660	Attack 596 1576 2758	Defense 556 1536 2688	Attacker.	Heal 1500(3000)[+120 if Prism] when defeating an Enemy	
65	65	/images/sc/showtime.jpg	5	HP 1080 2060 3605	Critical 300 1280 2240	HP 1098 2078 3636	Critical 312 1292 2261	Fire.	+15%(30%)[+1.5 if Prism] chance to debuff in WorldBoss.	
66	66	/images/sc/sow.jpg	5	Attack 500 1480 2590	Agility 270 1250 2187	Attack 505 1485 2598	Agility 278 1258 2201	Light	+350(600)[+15 if Prism] Agility	
67	67	/images/sc/starrystage.jpg	5	HP 1090 2070 3622	Agility 330 1310 2292	HP 1108 2088 3654	Agility 342 1322 2313	None.	Instant Heal received +800(1150)[+75 if Prism]	
68	68	/images/sc/summerfestivalnight.jpg	5	HP 1000 1980 3465	Agility 260 1240 2170	HP 1018 1998 3296	Agility 268 1248 2184	None.	Freeze evasion +8% (18%)[+0.5 if Prism]	
69	69	/images/sc/shakingfeeling.jpg	5	HP 1040 2020 3535	ATk 530 1510 2642	HP 1058 2038 3566	ATK 536 1516 2653	None.	+12%(27%)[+1.5 if Prism] chance to stun in Devil Rumble.	
70	70	/images/sc/straylamb.jpg	5	Attack 520 N/A N/A	Critical 270 N/A N/A	Attack 536 1516 2653	Critical 282 1262 2208	none.	+265(765) Agility	
71	71	/images/sc/extremecarnage.jpg	5	Defense 520 N/A N/A	Agility 270 N/A N/A	Defense 536 1516 2653	Agility 278 1258 2201	None.	Max HP +1120(1620)	
72	72	/images/sc/onsen.jpg	5	Defense 610 1590 2782	Agility 360 1340 2345	Defense 626 1606 2810	Agility 372 1352 2366	None.	In Devil Rumble, 250(550)[+25 if Prism] HP Recovery when attacked	
73	73	/images/sc/racingsuit.jpg	5	Attack 620 1600 2800	Critical 350 1330 2327	Attack 636 1616 2828	Critical 362 1342 2348	Dark attacker.	Slide skill critical damage +11%(21%)[+0.5 if Prism]	
74	74	/images/sc/importantttreasure.jpg	5	Attack 610 1590 2782	Agility 340 1320 2310	Attack 626 1606 2810	2782 Agility 352 1332 2331	Grass attacker.	Increase Critical hit chance by 5%(15%)[+0.5 if Prism]	
75	75	/images/sc/moonnightspa.jpg	5	HP 1110 2090 3657	AGI 360 1340 2345	HP 1128 2108 3689	AGI 372 1352 2366	None.	Curse Evasion +30%(45%)[+0.5 if Prism]	
76	76	/images/sc/beachrelax.jpg	5	Attack 540 1200 2660	Critical 280 1260 2205	Attack 546 1526 2670	Critical 288 1268 2219	Wood type.	Attack +700(1200)[+25 if Prism] in Ragna	
77	77	/images/sc/herooflegends.jpg	5	HP 1030 2010 3517	Defense 520 1500 2625	HP 1048 2028 3549	Defense 526 1506 2635	Attacker.	Ignore Defense Damage +200(450)[+15 if Prism] on Slide Skill in Devil Rumble.	
78	78	/images/sc/huntingdevil.jpg	5	Attack 530 1510 2642	Agility 270 1250 2187	Attack 536 1516 2653	Agility 278 1258 2201	Dark.	Critical damage +4000(6500)[+100 if Prism] in Ragna.	
79	79	/images/sc/throne.jpg	5	HP 1020 2000 3500	Defense 520 1500 2625	HP 1038 2018 3531	Defense 526 1506 2635	None.	Silence Evasion +25%(50%)[+0.5 if Prism] in Devil Rumble.	
80	80	/images/sc/trainingexpert.jpg	5	HP 1030 2010 3517	DEF 520 1500 2625	HP 1048 2028 3549	DEF 526 1506 2635	Tank.	When less than 3000(5000)[+100 if Prism] Hp, Evasion +20%(27.5%)[+1 if Prism] in Devil Rumble.	
81	81	/images/sc/princesscarry.jpg	5	HP 1020 2000 3500	ATK 520 1500 2625	HP 1038 2018 3531	ATK 526 1506 2635	None.	Bleed +200(400)[+10 if Prism] in Underground.	
82	82	/images/sc/judgementday.jpg	5	HP 1020 2000 3500	Defense 530 1500 2625	HP 1038 2018 3531	Defense 526 1506 2635	Light.	Poison damage received -250(500)[+15 if Prism] in Devil Rumble.	
83	83	/images/sc/underseadate.jpg	5	Defense 540 1520 2660	Agility 280 1260 2205	Defense 546 1526 2670	Agility 288 1268 2219	Water type.	Poison +500 (+750)[+15 if Prism] in Underground.	
84	84	/images/sc/latenightpartner.jpg	5	HP 1000 1980 3465	DEF 530 1510 2642	HP 1018 1998 3496	DEF 536 1516 2653	Tank.	Effectiveness of Reflect +3% (11.5%)[+0.5 if Prism] in Devil Rumble.	
85	85	/images/sc/castlepleasure.jpg	4	HP 775 1340 1849	DEF 395 980 1332			Wood type.	Instant Heal Received +400 (800 at lvl40 +4).	
86	86	/images/sc/baptismgoddess.jpg	4	HP 765 1350 1836	DEF 390 975 1326			None.	Regeneration Received +25 (125 at lvl40 +4).	
87	87	/images/sc/dreamteam.jpg	4	Attack 415 1000 1360	Defense 365 960 1305			None.	Heal 700 (1500 at lvl40 +4) HP when enemy is killed.	
88	88	/images/sc/godsdream.jpg	5	attack 610 1590 2782	agility 360 1340 2345	attack 626 1606 2810	agility 372 1352 2366	none	Sleep Evasion +30%(50%)[+1.5% if Prism] in Devil Rumble only.	
89	89	/images/sc/3friends.jpg	5	hp 1110 2090 3657	critical 360 1340 2345	hp 1128 2108 3689	critical 372 1352 2366	none	Evasion +15%(22.5)[+1% if prism] in Devil Rumble only.	
90	90	/images/sc/pc0.pck.56.56.jpg	5	attack 620 1600 2800	critical 370 1350 2362	attack 620 1600 2800	critical 370 1350 2362	Wood	Critical damage +4000(6500)[+100 if prism] in Ragna.	
91	91	/images/sc/twinds.png	5	attack 520 1500 2625	defense 520 1500 2625	attack 536 1516 2653	defense 536 1516 2653	None	Increase Vampirism and Absorption by 100(300)[+15 if prism] (only works for Childs with these skills)	
92	92	/images/sc/ontogyou.jpg	5	hp 1110 2090 3657	attack 620 1600 2800	hp 1142 2122 3689	attack 648 1628 2828	Water types.	Increase Weakpoint Skill Damage by 1000(2000)[+100 if Prism] in WB.	
93	93	/images/sc/bladesun.jpg	5	Attack 560 1540 2695	Agility 270 1250 2187	Attack 576 1556 2723	Agility 278 1258 2201	Fire Type.	Attack stat +700 (1200)[+25 if prism] in Underground.	
94	94	/images/sc/assbaringdevil.jpg	5	Attack 520 1500 2625	Critical 270 1250 2187	Attack 526 1506 2635	Critical 278 1258 2201	Fire Type.	Bleed + 200 (400)[+10 if prism] in WorldBoss.	
95	95	/images/sc/angel'ssmile.jpg	5	hp 1110 2090 3657	defense 580 1560 2730	hp 1128 2108 3689	defense 596 1576 2758	Water	Final defense +800(1300)[+25 if prism]	
96	96	/images/sc/nightmare.jpg	4	attack 430 1015 1380	critical 206 791 1075			None	Final attack +400(800)	
97	97	/images/sc/anniversary.jpg	5	HP 1058 N/A N/A	DEFENSE 558 N/A N/A	HP 1058 2038 3566	DEFENSE 558 1536 2688	None	In PvP Attack +545 (1045)	
98	98	/images/sc/strategymeeting.jpg	4	hp 775 1555 1849	def 400 1180 1339			Wood Attackers.	When equipped, reduces bleed damage received by 70(150)	
99	99	/images/sc/checkproceed.jpg	5	attack 620 1600 2800	defense 610 1590 2782	attack 620 1600 2800	defense 610 1590 2782	Wood Attackers	In WorldBoss Final attack power +1150(1900)	
100	100	/images/sc/pc1.pck.19.19.png	5	attack 620 1600 2800	defense 370 1350 2362	attack 620 1600 2800	defense 370 1350 2362	Water Attacker	In Raid, Final Attack power +700 (1200).	
101	101	/images/sc/competativegamer.jpg.png	5	attack 620 1600 2800	agility 370 1350 2362	attack 620 1600 2800	agility 370 1350 2362	Wood	For PvP only, Increase “Erode” damage by 10(50) (AKA for Piercing Ruin only)	
102	102	/images/sc/growingfeelings.jpg	5	attack 620 1600 2800	agility 370 1350 2362	attack 636 1616 2828	agility 382 1362 2383	Fire Attacker	For Ragna only, slide skills deal an additional 400(850)[+15 if prism] ignore DEF damage.	
103	103	/images/sc/prayinggirl.jpg	5	attack 0 1600 2800	critical 0 1350 2362	attack 0 1600 2800	critical 0 1350 2362	Dark Attacker	In WB, final attack +1150(1900)	
\.


--
-- Data for Name: soulcards; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.soulcards (id, name, created_on, enabled) FROM stdin;
1	afternoon train	2020-04-24	t
2	marine idol	2020-04-24	t
3	kokoro	2020-04-24	t
4	misaki	2020-04-24	t
5	sc booster 3	2020-04-24	t
6	good moa	2020-04-24	t
7	hero	2020-04-24	t
8	high jump	2020-04-24	t
9	in the clouds	2020-04-24	t
10	lacia	2020-04-24	t
11	luna	2020-04-24	t
12	nyotengu	2020-04-24	t
13	sc booster 4	2020-04-24	t
14	strategist night	2020-04-24	t
15	time over	2020-04-24	t
16	sc booster 5	2020-04-24	t
17	secret date	2020-04-24	t
18	serious worker	2020-04-24	t
19	small assailant	2020-04-24	t
20	sweet propose	2020-04-24	t
21	test	2020-04-24	t
22	lost dream	2020-04-24	t
23	dive	2020-04-24	t
24	eternal oath	2020-04-24	t
25	7th runaway	2020-04-24	t
26	adventure of the genius	2020-04-24	t
27	afternoon nap	2020-04-24	t
28	ayane	2020-04-24	t
29	azure girl	2020-04-24	t
30	believe	2020-04-24	t
31	cake aesthetics	2020-04-24	t
32	christmas gift	2020-04-24	t
33	crossed hearts	2020-04-24	t
34	dangerous gambler	2020-04-24	t
35	dark town mistress	2020-04-24	t
36	endo siblings	2020-04-24	t
37	fluffy melons	2020-04-24	t
38	glossy peach	2020-04-24	t
39	forbidden fruit	2020-04-24	t
40	ganryu davi	2020-04-24	t
41	god have mercy	2020-04-24	t
42	halloween diva	2020-04-24	t
43	higgins daughters	2020-04-24	t
44	home-made chocolate	2020-04-24	t
45	iced americano	2020-04-24	t
46	inspiration	2020-04-24	t
47	melty christmas	2020-04-24	t
48	nobalman's new year	2020-04-24	t
49	queen of the night	2020-04-24	t
50	ppp on stage	2020-04-24	t
51	piercing blue sky	2020-04-24	t
52	go-home club	2020-04-24	t
53	i love sake!	2020-04-24	t
54	seaside goddess	2020-04-24	t
55	vacation	2020-04-24	t
56	wandering doctor	2020-04-24	t
57	wisteria tree	2020-04-24	t
58	under the rose	2020-04-24	t
59	meat together	2020-04-24	t
60	s. t. f.	2020-04-24	t
61	tranquil peace	2020-04-24	t
62	treasure hunter	2020-04-24	t
63	the power of a smile	2020-04-24	t
64	tamaki	2020-04-24	t
65	show time!	2020-04-24	t
66	sow	2020-04-24	t
67	starry stage	2020-04-24	t
68	summer night	2020-04-24	t
69	feeling tremors	2020-04-24	t
70	stray lamb	2020-04-24	t
71	extreme carnage	2020-04-24	t
72	onsen	2020-04-24	t
73	racing suit	2020-04-24	t
74	important present	2020-04-24	t
75	moon-night spa	2020-04-24	t
76	beach relaxation	2020-04-24	t
77	hero of legends	2020-04-24	t
78	hunting devil	2020-04-24	t
79	throne	2020-04-24	t
80	training expert	2020-04-24	t
81	princess carry	2020-04-24	t
82	judgement day	2020-04-24	t
83	a subaquatic date	2020-04-24	t
84	midnight partners	2020-04-24	t
85	a castle of pleasure	2020-04-24	t
86	baptism of the goddess	2020-04-24	t
87	the dream team	2020-04-24	t
88	god's dream	2020-04-24	t
89	three best friends	2020-04-24	t
90	pool-side	2020-04-24	t
91	dominus duo	2020-04-24	t
92	karma	2020-04-24	t
93	blade of hot sun	2020-04-24	t
94	ass baring devil	2020-04-24	t
95	angel's smile	2020-04-24	t
96	nightmare	2020-04-24	t
97	anniversary	2020-04-24	t
98	strategy meeting	2020-04-24	t
99	check before proceeding	2020-04-24	t
100	hug the prince	2020-04-24	t
101	competitive gamer	2020-04-24	t
102	growing feelings	2020-04-24	t
103	praying girl	2020-04-24	t
\.


--
-- Data for Name: substats; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.substats (id, unit_id, leader, auto, tap, slide, drive, notes) FROM stdin;
1	1	Attack +500 to Light units	Deals 80 damage.	Deals 295 damage to enemy with lowest HP with 100 additional damage if Dark type.	Deals 572 damage and Healing -25% for 12s to 3 enemies with lowest HP.	Deals 1409 damage and Bleeding (160 continuous damage every 2 seconds) for 10s to 4 random enemies.	
2	2	Defense +7% to all allies.	Deals 73 damage.	Deals 229 damage to target, and Defense +10% for 10s to 1 random ally.	Deals 419 damage to target, 50% chance to remove bleeding and poison.	Deals 1072 damage to 3 random enemies, and +1200 HP Barrier for 18s to 3 allies with lowest hp.	
3	3	Agility +400 to Light units	Deals 81 damage.	Deals 300 damage to enemy with lowest HP with 100 additional damage if Dark type.	Deals 90 damage plus Tap damage 3 times to 1 enemy with priority to Dark units and gains Reflect (returns 7% of damage received) for 15s.	Deals 1324 damage to 4 random enemies, 90% chance to apply heal block (Excludes Lifesteal and HP absorption) for 10s.	
4	4	Critical rate -20% to Dark enemies.	Deals 73 damage.	Deals 236 damage to target，if Dark gives weakness Defense -3% for 6s.	Deals 437 damage to 2 enemies and agility -700 for 12s.	Deals 1149 damage to 3 random enemies and Blind (-35% Accuracy) for 10s.	
5	5	Evasion rate +10% to Light units.	Deals 68 damage.	Deals 194 damage to target and Defense +530 for 10s.	Deals 357 damage to target, and gain a 1000HP barrier, Taunt(84% provocation) for 10s.	Deals 820 damage to 2 random enemies and gains Fury (Up to 100% of damage is received and returned).	
6	6	Regeneration (Heal every 2s) +50 to Light units.	Deals 70 damage.	Deals 205 damage to target, and Healing +30% to 2 ally with lowest HP.	Heals 291HP to 3 allies with lowest HP, and gives 101HP Regeneration (Heal every 2s) for 10s .	Gives 1100HP instant heal to 3 allies with lowest HP.	
7	7	Regeneration (Heal every 2seconds) +50 to all units.	Deals 71 damage.	Deals 210 damage to target, and Healing -40% for 12s.	Deals 372 damage to target, instant heal 516HP and Regeneration (Heal every 2s) 140 for 12s to 2 allies with lowest HP.	Deals 854 damage to 2 random enemies, 110HP Regeneration (Heal every 2s) and 50HP additional Regeneration (Heal every 2s) in the case of a damage debuff for 18s to 3 allies lowest HP.	
8	8	Attack +8% to all allies.	Deals 73 damage.	Deals 229 damage to target and attack +200 for 8s to 1 random ally.	Deals 431 damage to target and attack +700 for 22s to 2 allies with highest attack and 70% chance to remove confusion.	Deals 1058 damage to 2 random enemies and skill damage +25% for 16s to 3 random allies.	
9	9	Regeneration (Heal every 2seconds) +50 to Water units.	Deals 70 damage.	Deals 209HP to target, and Heals 181 to ally with lowest HP.	Gives 111HP Regeneration (Heal every 2seconds) with additional 41HP if ally is debuffed for 12s to 3 allies with lowest HP.	Heals 1100 HP to 3 allies with lowest HP.	
10	10	Attack -10% to Water enemies.	Deals 74 damage.	Deals 239 damage to target, and weakness Defense -3% for 6s if Water unit.	Deals 439 damage and skill gauge charge rate -22.5% for 14s to 2 enemies with highest attack.	Deals 1154 damage to 3 random enemies, weakness Defense -15% for 16s if Water unit.	
11	11	Defense +7% to all allies.	Deals 73 damage.	Deals 231 damage to target and 50% chance to remove stun to 1 stunned ally.	Deals 408 damage to target and gives a +600HP barrier and Defense +450 for 16s to 2 allies with lowest HP.	Deals 1076 damage to 3 random enemies, and gives a +1200HP barrier for 18s for 3 allies with lowest HP.	
12	12	Healing +8% to grass units.	Deals 70 damage.	Heals 184 HP to 2 allies with lowest hp.	Heals 381HP and 110HP Regeneration (Heal every 2seconds) for 10s to 3 allies with lowest HP.	Deals 841 damage to 2 random enemies, and gives 110HP Regeneration (Heal every 2s) for 18s to 3 allies with lowest HP. If debuffed additional 60HP Regeneration (Heal every 2seconds)	
13	13	  +8% tap damage for water allies. Additional +8% in Ragna.	Deals 99 damage.	Deal 368 damage to target and grant +30% heal/regen rate to 3 water allies for 10 seconds.	Deal 604 damage to target and apply +1200 attack to 3 allies with the highest attack for 16 seconds and 70% chance to grant "Cheer" to 5 water allies for 14 seconds (+15% weakness skill damage and increase attack based on number of buffs).	Deal 1715 damage to 2 random enemies and apply +50% drive damage to 5 water allies for 33 seconds and +300 to ally drive gauge.	
14	14	HP +800 for grass units.	Deals 68 damage.	Deals 189 damage to target and gains Lifesteal (Absorbs 6% of damage per hit) for 12s .	Gains 1100HP barrier and Taunt (84% provocation) for 10s.	Deals 897 damage to target, and including self gives 2500HP barrier to 3 allies with lowest HP.	
15	15	Critical +400 to Dark units.	Deals 80 damage.	Deals 80 damage plus Auto damage 3 times to target.	Deals 286 (110%) damage to 2 random enemies.	Deals 1399 damage to 3 random enemies.	
16	16	Defense +7% to grass Allies.	Deals 68 damage.	Deals 196 damage and give +15% Defense to 2 grass Allies and Apply "Taunt" (84% Provocation) to self for 10seconds.	Deals 404 damage and Absorb 20% of the damage as HP and gives +100 Skill Damage Defense to 3 grass Allies for 10seconds.	Deals 912 damage to 2 random enemies and gives +1500 Barrier to 4 lowest HP Allies for 18seconds.	
17	17	Regeneration (Heal every 2seconds)s +50 to all allies.	Deals 70 damage.	Deals 206 damage to target, instant heal 189 to 2 allies with lowest HP.	Gives continous heal 120 HP and 500 HP barrier for 14s to 3 allies with lowest HP .	Gives 1000 HP instant heal to 3 allies with lowest HP, additional 240 HP instant heal if Fire type.	
18	18	Attack +8% to all allies.	Deals 54 damage.	Deals 149 damage to target and skill gauge charge rate +20% for 8s to 1 ally with highest attack.	Deals 307 damage to target and attack +500 for 14s to all allies.	Deals 753 damage to 2 random enemies and skill gauge charge rate +45% and skill gauge charge +40% for 23s to 2 allies with highest attack.	
19	19	Maximum HP +400 to Dark units.	Deals 51 damage.	Deals 126 damage to target and gains Lifesteal (Absorbs 50HP per hit) for 2 turns.	Deals 281 damage to target and gives +30% Defense and Taunt (84% provocation) for 10s to self.	Deals 622 damage to 3 random enemies and +1200 HP barrier for 15s to all allies.	
20	20	Slide damage +60 to Fire units.	Deals 58 damage.	Deals 193 damage and Bleeding (70 continuous damage) for 6s to target.	Deals 405 damage to all enemies.	Deals 949 damage to all enemies and Bleeding (120 continuous damage) for 10s to 3 enemies with highest HP.	
21	21	Tap Damage +80 to Light units.	Deals 80 damage.	Deals 298 damage and Healing -25% for 8s to target.	Deals 587 damage 3 enemies priority to Dark, ignore 300 Defense power and gains Reflect (returns 9% of damage received) for 15s.	Deals 1460 damage, Bleeding (200 continuous damage every 2s) for 10s and block heals (excludes absorption and lifesteal) for 14s to 3 enemies with lowest HP.	
22	22	Auto damage +40 to grass units.	Deals 80 damage.	Deals 297 damage to target and gives Lifesteal (absorb 3% of the damage as HP) for 16s to self.	Deals 537 damage to 3 enemies with priority to Water units, deals additional 200 damage if Water unit.	Deals 1314 damage to 4 random enemies.	
23	23	Tap damage +80 to Water units.	Deals 80 damage.	Deals 295 damage to enemy with lowest HP with 100 additional damage if Fire type.	Deals 560 damage and Poison (Deals 350 damage when enemy attacks and recieves attacks) for 3 turns to 3 enemies with lowest HP.	Deals 1422 damage to 3 enemies with lowest HP.	Not the strongest poison dealer, but hits more targets than Eve or Sonnest, which makes her great for PVP teams.
24	24	Debuff evasion rate -15% to all dark enemies	Deals 101 damage.	Deals 391 damage and removes one buff to target.	Deals 610 damage to 2 enemies with highest attack and 75% chance Confuse for 10s to target with highest attack.	Deals 2017 damage, removes one buff and enemy drive gauge -10% to 3 enemies with the highest attack.	A very good unit that can steal buffs and cause enemies to attack themselves. Good in PVP and PVE, and sometimes useable in Raids and WorldBoss.
25	25	Defense -8% to grass enemies.	Deals 74 damage.	Deals 240 damage to target with least Defense, and Defense -300 for 8s to enemy with highest defense.	Deals 441 damage and Defense -350 for 12s to 2 enemies with highest attack.	Deals 1101 damage to 3 enemies with highest Defense, and Defense -1000 for 16s.	4 star version of Jupiter with some decrease in debuff power, but still a great unit and is easier to uncap.
26	26	Defense -7% to all enemies.	Deals 54 damage.	Deals 156 damage and Defense -250 for 8s to target.	Deals 306 damage and Defense -4% for 12s to 2 random enemies.	Deals 831 damage and Defense -17% for 14s to 3 random enemies.	Cheap version of Freesia and Jupiter, but easier to uncap and does great debuff work in all content - cheap, but good.
27	27	Attack -15% to Light enemies	Deals 101 damage.	Deals 387 damage and attack -700 for 10s to target.	Deals 608 damage plus 500 ignore Defense damage to 2 enemies with highest attack and enemy drive gauge -8%.	Deals 2012 damage to 3 enemies with the highest Defense, removes one buff and enemy drive gauge -10%.	Her special skills only worked on early raid bosses. Good for PVP and PVE.\r\n
28	28	Dark enemy debuff evasion rate -10%	Deals 100 damage.	Deals 381 damage to target, and debuff evasion rate -10% for 8s.	Deals 595 damage to 2 enemies with highest attack, and 70% chance to petrify (unable to act for 10s or after being hit 2 times).	Deals 2096 damage to 2 random enemies, and 90% chance to petrify (unable to act for 15s or after being hit 3 times).	A PVP cc unit and great in combination with Wola. Also great with DoT teams and Gkouga. Moa is great at stalling the enemies to get to fever/drive first. Useless in Raids and WorldBoss.
29	29	Attack +8% to all allies.	Deals 73 damage.	Deals 234 damage to target, 70% chance to remove freeze from ally.	Deals 449 damage to target, 80% chance to swap attack and Defense for 20s to 2 allies with lowest HP.	Deals 1086 damage to 3 random units, attack +25% for 25s to 3 units with highest attack.	
30	30	Skill Gauge Charge Speed +10% for Water type allies.	Deal 99 auto attack damage.	Deal 368 damage to target, skill gauge +13% for 2 water type allies (excluding self).	Deal 603 damage to target, attack +1200 and crit rate +30% to 3 water type allies with the highest attack for 16 seconds.	Deal 1713 damage to 3 random enemies, grant barrier (absorbs +2000 damage before HP is affected) to up to 5 water type allies for 20 seconds, and heal 1224HP for them.	
31	31	Attack + 8% to fire type allies.	Deal 73 damage.	Deal 233 damage to target and apply a 60% chance to remove one debuff from one ally.	Deal 448 damage to 2 targets and +1000 attack to 2 allies with the highest attack for 16 seconds.	Deal 1084 damage to 3 random targets. Attack and defense +20% for 20 seconds.	
32	32	Drive skill damage +1000 to Dark Units	Deals 113 damage.	Deals 485 damage to enemy with lowest HP and critical rate +40% for 12s to self.	Deals 612 (135%) damage to 3 enemies with lowest HP.	Deals 2484 damage and Debuff Explosion (removes last applied debuff and damage enemy according to debuff) to all enemies.	A really good damage dealer and can self-crit boost. Although he may seem lackluster early, with higher unbinds he becomes probably the strongest attacker in the game. Passive skill on Drive can give nice added damage. Best Dark attacker found on the normal pool.
33	33	Slide skill damage +4% to Dark units	Deals 111 damage.	Deals 120 damage plus Auto damage 4 times to target.	Deals 528 (120%) damage to 3 random enemies.	Deals 2992 (250%) damage to target and Bleeding (200 damage every 2s) for 12s to 4 random enemies.	Overshadowed by Frey.
34	34	  +5% slide damage to Dark allies	Deal 113 damage.	Attack 2 targets twice each, dealing auto-attack damage plus 40 additional damage per hit (prioritizes enemies with buff effects).	Deal 1329 damage to all enemies, plus 500 defense ignoring damage, with a 70% chance to apply Chaser (upon killing an enemy, deal 1500 additional fixed damage to 1 random remaining enemy) to self for 14 seconds.	Deal 2285 damage to all enemies and apply Resurrect to self for 10 seconds (upon dying, revive with 50% HP, fully charge skill gauge, and Attack Up (stacks up to 5 times)).	At higher uncaps and crit-boosted, her slide can make quick work of enemy teams in pvp.
35	35	+8% Tap Skill Damage to Light Allies | Additional +8% in Ragna.	Deal 113 damage.	Deal 441 (105%) damage & +350 Ignore Defense Damage if enemy is Dark Attribute.	Deal Tap Skill Damage 2 times, plus 150 additional damage to 2 enemies prioritizing Debuffer type. During Ragna+660 Additional damage if enemy is Dark Attribute).	Deal 3114 (250%) damage to 2 enemies & apply "Curse" (300 damage every 2 seconds and additional damage when Curse ends) for 8 seconds.	Very good on Dark events but has been completely overshadowed by both Cleo and Wedding Hildr.
36	36	+8% slide skill damage for Light type allies	Deal 113 auto attack damage.	Deal 486 damage and has a 65% chance to apply "Long-Range Attack" (ignore Taunt and Reflect) to self for 13 seconds. In Underground, 430 additional damage to target.	Attack 2 enemies twice each (prioritizing Dark type), dealing 755 damage. If the target is a Debuff type, deal 150 additional damage. If the target is a Dark type, deal 200 additional piecing damage.	Deal 2588 damage to all enemies.	Average attacker that performs decent in all content. T H I C C
37	37	Weakness Defense -8% to Water Types enemies	Deal 101 auto attack damage	Prioritizing Debuffers, Deal 390 damage and, if the target is a Debuffer type, deal 160 Bonus damage.	Prioritizing Attackers, Deal 669 damage to 2 targets, skill gauge charge speed -30% and a 70% chance to apply "Attraction" (invalidates buffs, can't be dispelled) for 12 seconds.	Prioritizing Debuffers, Deal 1967 damage to 3 targets, skill gauge charge amount -33% for 16 seconds and a 80% chance of "Stun" (target is unable to attack, Stun duration increases by 1 second when hit, up to 5 additional seconds) for 4 seconds.	A PVP annoyance - great if she's on your team, not when she's on the enemy.
52	52	Tap Skill defense +5% to Water units.	Deals 92 damage.	Deals 314 damage to target and absorb 26% of the damage as HP.	Deals 573 damage to target and gives +1200HP barrier to all allies and 118HP Regeneration (Heal every 2seconds) to self for 14s.	Deals 1466 damage to 3 random enemies and drive Skill defense +20% for 15s to all allies.	The best tank in WorldBoss as she covers all allies with a barrier, regardless of element. Pretty hard to kill as well due to her self regen.
38	38	Skill gauge speed +12% to wood allies [For UG only, all allies +15% attack]	Deals 100 damage	Deals 385 damage to target. 70% chance to remove Defense down debuffs from 2 allies.	Deals 675 damage to target. For 16 seconds, apply Max HP +1600 (Priority: Lowest HP) to 2 allies, 70% chance to apply “Time distortion” (removes -gauge speed debuffs and increases skill gauge speed +40%) and[For UG only, gives +15% attack 2 allies with highest attack.]	Deals 1764 damage to 3 enemies. To the ally with the highest attack, gives Berserk (Increase attack by +90% and becomes immune to damage, afterwards unit will be stunned for 5s) for 20s and prioritizing grass allies, 3 allies Skill Gauge Charge Amount +50%	
39	39	Defense -15% to Water Types Enemies.	Deals 101 damage.	Deals 390 damage to the enemy with highest attack. Defense -350 to target for 8s.	Deals 619 damage to 2 lowest HP enemies. \r\nApply "Anti-Barrier" (Removes "Barrier" and 70% of the remaining barrier is dealt as damage) to target. \r\nApply "Fortitude Explosion" (Removes up to 2stacks of "Invincibility" and if 3 or more stacks was removed, deals 500 damage per stacks) to target.	Deals 1916 to 3 enemies (Prioritizing enemies with "Fortitude" buff). \r\nApply "Fortitude Explosion" (Removes up to 2 stacks of "Fortitude" and if 3 or more stacks was removed, deals 1500 damage per stacks) to target.	
40	40	Tap skill damage +5% to Wood units.	Deals 113 damage	Deals 483 damage to target, On Water type targets, deal 150 bonus damage.	Deals 100 damage plus Tap skill, 2 times to two random enemies, and Absorbs 20% of damage as HP.	Deals 2290 damage to all enemies.	Decent damage from slide and life steal makes her very hard to kill.
41	41	Wood type allies critical rate +15%	Deals 113 damage	Deals 482 damage to target, Apply "Vampirism" (restores 15% of damage dealt as HP) to self for 20 seconds.	Prioritizing Supporter types, deal 902 damage and 570 Ignore defense damage, 3 times to 1 target.  Gain +25% evasion to self for 12s if a critical hit occurs.	Deals 2479 damage to 4 enemies with lowest HP.	Only available during Kemono Friends 2 collab. Not available anymore.
42	42	+5% to Tap damage for all allies. 	Deals 113 damage.	Deal 527 damage to target and additional 300 damage if target is Petrified or Frozen and 200 piercing damage if target is Water type.	Deals 400 damage + Tap damage, 3 times to 1 enemy  (Prioritizing Attacker types) and absorb 200 damage dealt as HP.	Deals 2329 damage to 3 enemies with lowest hp	Has the highest cooldown among all childs on her slide (11s).
43	43	+12% attack for Wood type allies.	Deal 113 attack damage.	Deal 482 damage to target. Apply "Vampirism" (restore 15% of damage dealt as HP) to self for 20 seconds.	Prioritizing Water type enemies, deal 852 damage to 3 enemies. On Water type enemies, deal 800 ignore defense damage and to 2 random enemies apply "Stigma" (Continuous damage every 4 seconds [total buffs +1] x50 continuous damage, maximum 6 buffs [Final tick 7]) for 20 seconds.	Deal 2227 damage to 4 random enemies , on enemies with a "Stigma" debuff, deal 500 Bonus damage.	
44	44	Gives Reflect (returns 3% of damage received) to Dark units (bonus +3% on Ragnas)	Deals 90 damage.	Deals 294 damage to target and Defense +900 to self and gains Taunt (85% provocation) for 11s.	Deals 539 damage to target, gives Reflect (returns 13% of damage received) to self and gives Defense +850 to 3 units with priority to Dark Units (including self).	Deals 1386 damage to 2 random enemies and gives Reflect (returns 20% of damage received) for 18s to 5 allies.	An offense based tank that utlizes reflect to deal damage back. 
45	45	Tap Skill defense +5% to Dark units	Deals 91 damage	Deals 301 damage to target and gives +850 Defense and +600 barrier for 10s to 1 ally with lowest HP	Deals 540 damage and gives Reflect (return 12% of received damage) to 3 allies with priorities to Dark types for 15s and gives +12% Skill Damage Defense (for 24s or at 3 hits received) to 2 lowest health allies.	Deals 1405 damage to 2 random enemies and gives Reflect (returns 25% of damage received) for 20s to self and 1 ally with the lowest HP(if own HP is the lowest, it will only be applied to self, no second target).	Support tank type less element restricted than AI.
46	46	Tap Skill defense +5% to Wood units	Deals 91 damage.	Deals 306 damage to target and gives "Vampirism" (restores 10% of damage dealt as HP) and decrease "Poison" damage received by 25% to 2 lowest HP allies.	Deals 545 damage to target and gives Skill Defense +10% (for 32 seconds or 4 hits) and decrease "Poison" damage received by 35% for 15 seconds to 3allies (prioritizing Wood allies).	Deals 1419 damage to 2 random enemies and gives "Vampirism" (restores 20% of damage dealt as HP, effect doubled for Wood types) to all allies.	Specializes in poison mitigation and giving life steal to allies. Better off using cleanse than relying on her poison mitigation. Feels more like a buffer than a tank.
47	47	Tap Skill defense +5% to Wood units.	Deals 91 damage	Deals 311 damage to target and Gives +25% defense for 15s to self.	Deals 564 damage to target and Gives Skill defense +20% to self and Taunt (90% provocation) for 12s.	Deals 1456 damage to 2 random enemies and drive Skill defense +30% for 15s to 5 allies.	Pull him, lock him, then forget him, but don't diss him. The Living Meme -Chiyu. One of the better taunt tanks in pvp :3.
48	48	+8% skill damage defense for wood type allies.	Deal 92 damage.	Deal 575 damage, increase 20% all skill damage defense (Cancels after 24 seconds or receiving 3 attacks).	Deal 575 damage, apply "Fortitude" to 4 allies except self (Cancels after 14 seconds or receiving 2 attacks) and gives Silence evasion +20% to self for 14 seconds.	Deal 1443 damage to 2 random enemies , +40% of Defense  and DoT Evasion+50% to 5 allies for 20 seconds.	Limited collab child from Dead or Alive Xtreme Venus Vacation
49	49	+1500 max HP for all allies (Additional +2000 in Devil Rumble)	Deal 91 damage.	Deal 310 damage to target, a 70% chance to apply "Debuff Provocation" on self (receive 1 debuff instead of ally) for 20 seconds and reduce debuff duration -20% (Except "Wither", "Water Balloon", and "Petrify") for 20 seconds.	Deal 532 damage to target, increase Defense Power +40% and apply "Taunt" (90% activation) to self for 12 seconds.	Deal 1427 damage to 2 enemies randomly, and apply "Reflect" (Return 30% of the damage receive) to self and 2 lowest health allies (if Athena has one of the lowest health, it will only apply to 1 more ally instead of 2) for 20 seconds.	Decent taunt tank with a unique tap skill. 
50	50	Tap Skill defense +5% to Light units	Deals 91 damage.	Deals 297 damage to target and Skill defense +18% for ( for 24s or upon receiving 3 hits) and Taunt (88% provocation) for 10s to self.	Deals 487 damage to 2 random enemy and gains Immortality (HP won't go under 1) and Fury (saves up to 350% damage and returns).	Deals 1397 damage to 2 random enemies and Skill defense +25% for 20s to 5 Light units.	A good PVP tank and okay in PVE content.
51	51	+12% Defense to all allies.	Deals 92 damage.	Deals 316 damage to target, and gives a +800HP barrier for 10s to 2 allies with the lowest HP.	Deals 563 damage to target, gains Fury (saves up to 350% damage and returns) to self and +35% defense to all allies for 14s.	Deals 1469 damage to 2 enemies, gives +2500 barrier and drive defense +30% for 15s to 5 allies with the lowest HP.	a.k.a Slime boie. H A I L S L I M E K I N G.
53	53	Slide skill damage +5% to Water allies.	Deals 91 Damage.	Deals 305 Damage, Gives +500 barrier to 5 Water allies for 8 seconds.	Deals 547 Damage, Gives Taunt (88% provocation) for 12 seconds and Reflect (24% damage returned to enemy for 24sec or upon receiving 2-7 hits (random number of hits applied)) to self.	Deals 1436 Damage to 2 random enemies, Gives Reflect (22% damaged returned to enemy) for 16seconds or upon receiving 2 hits) to 9 allies prioritizing the front row.	Really bad tank with skills all over the place. Slide is a worse version of Hades. Drive is a complete joke to use on any WB. Cute but that's not gonna save her from being a meme.
54	54	Heal and Regeneration (Heal every 2seconds) amount +5% to Dark units	Deals 96 damage.	Deals 335 damage to target and heals 201HP to ally with lowest HP.	Gives 1.5%HP+21HP Regeneration (Heal every 2seconds) for 10s and Immortality (HP won't go under 1) for 10s to 2 allies with lowest HP.	Gives Berserk (Increase attack by +70% and becomes immune to damage, afterwards unit will be stunned for 5s) for 14s to 2 allies with lowest HP.	Goth Loli. Similar to Rusalka, but Metis' Berserk buff on drive is very useful in UndergroundEx and even raids - The downside is that her drive is hard to get the attacker buffed because she only buffs the lowest HP units, and then stuns for 5 seconds. With RNG on your side she can be quite good. With Botan's more reliable berserk drive, Metis usefulness has been reduced.
55	55	Weakness Skill Final Damage -8% to Light Types enemies	Deal 96 auto attack damage	Deals 335 damage to target and Heal effectiveness -40% ("Instant Heal" and "Regeneration") to 2 random enemies for 12 seconds	Deal 511 damage, Give "Regeneration" (Heal 171 HP per 2 seconds) to 2 lowest HP allies and Apply "Poetic Justice" (On 2 "buffed" allies, Instant Heal (total buffs+1)x150 HP; On 2 "debuffed" enemies, deal (total debuffs+1)x200 damage [total max buff/debuff counted per target is 4]) for 14 seconds	Deal 1537 damage to 2 random enemies and Apply "Poetic Justice" (On 3 allies with lowest HP, "Instant Heal" (total buffs+1)x350 HP; On 3 enemies with lowest HP, deal (total buffs+1)x400 damage [total max buff/debuff counted per target is 4])	Poetic Justice is pretty similar to how Bari's Stigma functions. So 2 allies with 4+ buffs get healed 750HP and 2 enemies with 4+debuffs get hit by max 1000 damage on his slide.
56	56	Recovery amount (Heal and Regen) +5% to Wood type allies	Deals 96 damage.	Deals 335 damage to target and gives Fortitude (removed after 10 seconds or upon taking 2 hits) to 1 ally with highest attack.	Gives 141HP Regeneration (Heal every 2seconds) for 14s and Fortitude (removed after 20 seconds or upon taking 4 hits) to 2 allies with lowest HP.	Gives 199HP Regeneration (Heal every 2seconds) for 16s and Fortitude (removed after 15 seconds or upon taking 3 hits) to 3 allies with lowest HP.	Syrinx doesn't have the strongest heals per tick, but her Fortitude bubbles is her greatest asset that it completely negates any damage no matter how high. In PVP her buff can help negate damage but when faced with DoTs, they destroys Fortitude stacks much faster. Best healer/tank combo.
57	57	Instant Heal rate +8% to Wood Allies	Deals 96 damage.	Deals 337 damage to target and Instant Heal for 214 HP and Apply "Secret Healing" (Heals 200 damages when attack and receives attacks) for 2 turns to 2 lowest HP allies.	Deals 515 damage to target and Instant Heal for 1091 HP and 75% chance to remove "Heal Block" to 3 lowest HP allies.	Deals 1548 damage to 2 random enemies and Apply "Regeneration" (Heal 300 Hp per 2 seconds) to 3 lowest HP allies and prioritizing allies affected by poison, apply "Secret Healing" (Heals 1200 damages when attack and receives attacks) for 16 seconds.	Very unique healing buff. Healing version of the poison debuff. Drive makes 3 Allies literally un-killable for 16s. Most effective when played manually.
58	58	Attack +10% to Dark Allies (Additional +5% in Ragna)	Deals 253 damage.	Deals 376 damage to target and Give +12% Attack to highest attack ally and 70% chance to remove "Curse" from 1 ally.	Deals 650 damage to 2 random enemies and Gives +1200 Attack and 70% chance to "Awaken"(+30% Critical Damage and Slide Skill damage (increase by the number of buffs)) to 3 Dark Attacker type allies for 16 seconds.	Deals 1751 damage to 3 random enemies and Give +30% Attack and +50% Critical Rate to 3 Allies (Prioritizing Dark Attacker types).	
59	59	+18% Evasion for fire type allies.	Deals 100 damage.	Deals 385 damage to target, critical rate +35% for 10s to 1 ally with highest attack.	Deals 675 damage to target, attack +1500 and defense +1500 for 16s to 2 allies with highest attack.	Deals 1765 damage to 3 enemies, Max HP +1500 and agility +2000 for 20s to 3 allies with highest attack.	Limited collab child from Kemono Friends 2 Collab
60	60	Heal and Regeneration (Heal every 2seconds) amount +5% to Light units	Deals 95 damage.	Deals 330 damage to target, and removes freeze and petrification from 1 ally.	Gives 146HP Regeneration (Heal every 2seconds) for 20s to all allies.	Revives 1 dead ally to 1000HP and gives 300HP Regeneration (Heal every 2seconds) for 16s to 3 allies with lowest HP.	Only child that can heal the whole team in WB. Maat + Leda combos are really strong, especially with Leda's leader skill. Maat is very useful in PVE and can be a real annoyance for the enemy in PVP. Her auto taps too much unfortunately.
61	61	Defense +8% to Wood type allies	Deals 99 damage	Deals 363 damages to target and Gives +20% Defense and +15% Debuff Evasion to 2 lowest HP allies for 10secs.	Gives +1800 Barrier and Apply "Vampirism" (restores 15% of damage dealt as HP) for 22 seconds to 3 lowest HP allies.	Deals 1703 damage to 2 random enemies and Defense +35% and +2000HP barrier for 25 sseconds to 3 allies with lowest HP	
62	62	Increase HP recovery of all allies (instant or HoT) +10%.	Deal 96 auto attack damage.	Prioritizing allies with the lowest HP remaining, heal 314 to 2 allies.	For 8 seconds to 4 allies except herself, apply "Immortal" (HP cannot drop below 1 when being attacked). \r\nPrioritizing allies with least HP, HoT 231 (once every 2 seconds) to 2 allies for 12 seconds. 	Deal 1597 damage to 2 random enemies. \r\nPrioritizing allies with least HP remaining, apply "Debuff Immunity" to 3 allies (cleanses all current debuff, cancels after 14 seconds or 2 debuff attacks) and heals 1691 HP.	An improved Rusalka. Seems more geared towards pvp because of her immortality buff affecting most of the party.
63	63	Heal and Regeneration (Heal every 2seconds) amount +5% to Water units.	Deals 96 damage.	Heals 233HP to 2 allies with lowest HP.	Gives 1.8%HP+21HP Regeneration (Heal every 2seconds) for 12s and Immortality (HP won't go under 1) for 10s to 2 allies with lowest HP.	Heals 12%HP+90HP and gives Immortality (HP won't go under 1) for 14s to 3 allies with lowest HP.	Her immortality can be a lifesaver sometimes, but her overall healing is not very strong. Power creeped by Venus.
76	76	Critical Rate +15% to all allies (Critical Damage +30% in Devil Rumble).	Deals 100 damage.	Deals 375 damage to target. \r\nGives +30% Critical Rate to self and 1 Attack Type ally for 10s.	Deals 856 damage to 2 random enemies. Gives 35% Skill Gauge Charge Amount to 3 Allies (Prioritizing Dark Attacker Types) for 15s.\r\nGives +1200 Slide Skill Damage to 3 Allies (Prioritizing Dark Attacker Types) for 15s.	Deals 2021 damage to 3 enemies (Prioritizing Light Types), apply "Blind" (Attack Accuracy -60%) to target for 25s. Gives +30% Attack to 3 highest attack allies for 25s.	
64	64	Drive Gauge Charge -5% to all enemies (Additional 8% on Worldboss).	Deals 101 damage	Deals 381 damage to target and Apply "Poison" (causes 200 damage each time target acts; triggers 30% of poison damage when they receives an attack) for 2 turns. Within 8s debuff effect on 2 enemies will have it's duration extended by 30% (from current remaining duration).	Deals 617 damage to 2 random enemies and 70% chance to remove 1 buff from the target (last applied buff).\r\nApply "Debuff Explosion" (removes first applied debuff and deals damage according to the debuff type x200 modifier).	Deals 1983 damages to 3 random enemies and Apply "Poison" (causes 800 damage each time target acts; triggers 30% of poison damage when they receives an attack) for 3 turns.	Similar to Nirrti, but more offensive than defensive in terms of skills.
65	65	+15% Defense for water type allies.	Deals 92 damage.	Deals 315 damage to target, gains +800 barrier for 10 seconds to self.	Deals 575 damage to target, gains +35% evasion and Taunt (90% provocation) for 12s.	Deals 1469 damage to 2 enemies, buffs all allies with +50% evasion.	Only available during the Kemono Friends 2 collab. An Evasion based tank. Pump all your AGI and HP gear on her.
66	66	Skill Gauge Charge Speed +8% to all Allies (Additional +8% in Devil Rumble).	Deals 101 damage.	Deals 379 damage to target. 50% chance to cleanse DoTs from 2 allies. Gives "Vampirism"(restores 15% of damage dealt as HP) for 14s to 2 allies.	Deals 667 damage to 2 random enemies. +30% Skill Gauge Charge Speed for 2 turns to 2 highest attack allies. 70% chance to Apply "Cheer" (15% weakness skill damage and increase attack based on the current number of buffs) for 2 turns to 2 highest attack allies.	Deals 1803 damage to 3 random enemies.\r\n+40% Skill Gauge Charge Amount for 3 turns to 3 allies (prioritizing Wood types). \r\nApply "Cheer" (15% weakness skill damage and increase attack based on the current number of buffs) for 3 turns to 3 allies (prioritizing Wood types).	Great in all content and can easily replace Kouga when skill cooldown isn't as important as speed buff and damage buff. Can be used with Kouga to get a really speedy team.
67	67	Critical rate +15% to Dark allies	Deals 99 damage.	Deals 364 damage to target and critical rate +35% for 7s to 1 random ally.	Critical rate +40% and critical damage +30% for 18s to 2 allies with highest attack.	Deals 1705 damage to 2 random enemies, critical damage +50% and critical rate +70% for 22s to 2 allies with highest attack.	Can be used in all content, but is better in Raids and Worldboss events.
68	68	Max HP +800 for all Allies (in raids +600 added)	Deal 99 damage to target	Deal 370 damage, grant Barrier (absorbs +400 damage before HP is affected) on 1 random Ally for 8 seconds	Deal 555 Damage to 2 random Enemies and 300 of Ignore DEF Damage, Ally Drive Gauge +100	Deal 1751 Damage to 2 random Enemies, Regen 80 HP (once per 2 seconds) for 2 Allies (Lowest HP) for 26 seconds and Drive Gauge + 10% for allies	Aria is an important child for helping you to reach 3rd fever in world boss (may requires uncaps). VA: Rie Takahashi (Megumin)
69	69	Defense -15% to all enemies	Deals 102 damage	Deals 396 damage to target, 60% chance to apply “Robbery” (steals a buff from the target and apply it to herself)	Prioritizing 2 highest defense enemies, deals 677 damage, 75% chance apply Transition (attack and defense are swapped) for 20 seconds & 75% chance to confuse for 10 seconds	Prioritizing enemies with buffs, deal 2038 damage to 3 targets, 70% chance to apply “Robbery” (steals a buff from the target and apply it to herself) & Skill Gauge Charge Amount -35% for 16 seconds	
70	70	Water allies Max HP +2000 & own Max  HP +1000.	Deal 92 auto damage.	Deal 315 damage to target and apply Max HP +700 to herself and 1 ally with the lowest HP (if her HP is the lowest, Max HP will only be applied to her) for 8 sec	Deal 588 damage to target, Apply DoT debuff evasion 25.4% to herself and 2 lowest HP allies (if her HP is the lowest, buff will only apply to 1 other ally) and grant Barrier +1600 to 5 lowest HP allies for 14 sec.	To 2 allies with less than 50% HP remaining, apply "Emergency Transfusion" (Consumes 40% of own current HP and distributes to target allies, "Heal block" and "Death Heal" will not prevent this effect) and apply Max HP +2000 to self and 3 lowest HP allies (if her own HP is the lowest, Max HP will only be applied to herself and 2 allies) for 20 sec.	(call-the-cops).
71	71	Tap Skill Damage +5% to Light Allies	Deals 113 damage	Deals 505 damage to highest attack enemy. 65% chance to Apply "Direct Hit" (Ignore "Fortitude") to self for 13 seconds	Deals 830 damage to 3 highest attack enemies plus 800 Ignore Defense damage.  On "Confused" or has "Fortitude" buff targets, deal 800 Bonus damage	Deals 2339 damage to 4 highest attack enemies. 70% chance to Apply "Confuse" to 1 target for 10 seconds. 90% chance to Apply "Direct Hit" (Ignore "Fortitude") to self for 18 seconds.	
72	72	+8% Skill Gauge Charge Speed for all allies (In Ragna only, Increase heal amount by +10%).	Deal 101 auto attack damage.	Deal 387 damage to target. \r\nPrioritizing allies with least HP remaining, Heal +30% of HP to 2 allies for 20 seconds. For Ragna only, remove target stacking buff (Attack/defense power) by 5 stacks.	Deal 676 damage to target. Prioritizing 2 allies with the lowest HP, Skill Gauge Charge Speed +30% and heal 1251 HP for 16 seconds. For Ragna only, to the ally with the highest attack, apply "Double-Edge Sword" (Increase Attack by 30% but decrease Defense) for 16 seconds.\r\n	Deal 1816 damage to 3 enemies randomly. \r\nApply "Life Bind" up to 5 allies (Convert 50% of the damage received into healing, the rest of the HP buff is spread to 2 allies with the least HP) for 20 seconds. 	One of the best supporters for ANY Ragna. Can heal, speed buffs (stacks with Kouga) and buff attack to highest attacker. Very unique drive that could help sustaining your team without running a healer
73	73	+10% Skill Gauge Charge Amount to Water type allies	Deal 100 auto attack damage.	Deal 380 damage to the target, prioritizing an ally 2 with least HP, recover 280 HP 2 times, plus a 60% chance to purify 2 bleeding allies (Convert Bleeding into Regen).	Deal 660 to target. Prioritizing 2 alles with highest ATK, grants Skill Gauge Charge Amount +35% and ATK +1600 for 14 seconds. Grants "Patience" (Grants "Fortitude" stacks depending on the number of debuffs on the target +1, [Maximum 3] for 10 seconds).	Deal 1734 to 3 random enemies. Prioritizing 2 allies with lowest HP, Heal 1230 HP. Prioritizing 2 allies with highest ATK, grants Skill Gauge Charge Speed +30% for 16 seconds	
74	74	Drive Skill Damage +1000 for Wood type allies. (In Ragna only, +1000 Drive Skill Damage to all allies)	Deals 112 damage.	Deals 120 damage plus Auto damage 4 times to target.	Deals 771 damages to 3 random enemies and Absorb 350 damage as HP.	Deals 2237 damages to 4 lowest HP enemies and Gives +50% Skill Gauge Charge Speed for 2 turn to self.	Worse version of Siren. Looks kinda cool tho.
75	75	Attack -15% to Dark Type Enemies	Deals 101 damage.	Deals 386 damage and -700 Attack for 8 seconds and 60% chance to apply "Curse Amplification" (Curse damage and duration increase) for 8 seconds to target.	Deals 604 damage and 500 Ignore Defense damage to 2 highest attack enemies and Apply "Blind" (Attack Accuracy -40%) for 12seconds.	Deals 1910 damage to 3 random enemies and Apply "Blind" (Attack Accuracy -60%) for 14 seconds. For 6 seconds, increase DoTs debuff duration by 50%.	
77	77	Drive skill damage +1000 to Light units. 	Deals 111 damage. 	Deals 135 damage plus Auto damage 4 times to target. \r\nApply "Blind" (Attack Accuracy -20%) to target for 6 seconds.	Deals 761 damage to 3 highest attack enemies. \r\nApply "Blind" (Attack Accuracy -30%) to target for 12 seconds.	Deals 2161 damage to 4 enemies with highest attack.	Good only for normal content. Blind is decent for pvp. Doesn't do amazing damage so falls flat in event content.\r\n
78	78	Tap Skill Damage +5% to Dark Allies	Deals 113 Damages.	Deals 486 damage plus 100 Ignore defense damage. On Debuffer type targets, deal 100 Bonus damage	Deals 100 Bonus Damage + Tap damage 2 times to 2 enemies (Prioritizing Debuffer Types). Apply "Blind" (Attack Accuracy -20%) for 6seconds.	Deals 2586 damage to 4 random enemies and 70% to apply Confuse to 2 random enemies for 6 seconds.	Deals decent damage and inflicts CC on enemies. 
79	79	Skill Gauge Charge Speed -18% to Water type enemies.	Deals 101 damage to target.	Deals 385 damage to target. On Wood type targets, deal 150 Bonus damage.	Deals 672 damage to 2 random enemies, 70% chance to apply "Freeze" (Skill gauge speed and charge amount decreased and takes increased DoT damage) for 10s.	Deals 1875 damage to 2 random enemies, 90% chance to apply "Freeze" (Skill gauge speed and charge amount decreased and takes increased DoT damage) for 16s.	Freeze increases DoT damage by around ~15%
80	80	-15% attack for Fire type enemies	Deal 101 auto attack damage.	Deal 387 damage to target with a 60% chance to apply "Freeze" (Skill gauge speed and charge amount decreased and takes increased DoT damage) for 8 seconds.	Deal 645 damage to 2 enemies with the highest attack. Skill Gauge Speed -20% and Apply "Water Balloon" (Deals 300 Damage when receives an attack, Reset Skill Gauge after 10 seconds or 2 attacks) for 14 seconds.	Prioritizing healer types, Deal 1994 damage to 3 enemies with a 90% chance to apply "Freeze" (Skill gauge speed and charge amount decreased and takes increased DoT damage) for 16 seconds.	Water Balloon's damage is pure damage (will hit for the amount said on the skill) and at +6, it does 1.3k damage. Freeze increases DoT damage by around 15%.\r\n 
81	81	+800 max hp to all allies. (Additional +800 in Ragna)	Deal 95 damage.	Deal 331 damage to target and heals 1 ally with the lowest hp for 318 HP.	Deal 507 damage to target and heal 3 allies with the lowest hp for 989 HP and 75% chance to apply "Purification" to 2 allies with the Bleeding status (convert Bleed to Regen).	Deal 1528 damage to 2 random enemies and heals 5 allies with the lowest hp for 1259 HP and 90% chance to apply "Purification"(convert Bleed to Regen)	Only available during 2018 Miku Collab event. Only good at content with bleed heavy mechanics, otherwise other healers are better.
82	82	 +5% Slide Skill damage to light type allies	Deals 113 damage.	Deals 150 damage plus auto damage 3 times to target.	Deals 955 damage plus 1000 Defense Ignore damage to 2 enemies with lowest HP.\r\nIf target has barrier, deal 1800 Bonus damage.	Deals 2539 damage to 4 enemies with lowest HP.	Weakest Light Attacker. Even with the additional damage on shielded targets, her slide only hits twice.
83	83	Attack +10% to Water Allies (Additional +8% attack to all allies (not limited to water) on Worldboss)	Deals 113 damage.	Deals 530 damage to target. On Debuffer types, deal 350 bonus damage	Prioritizing Debuffer Type, deals 400 damage + Tap Damage 3times to 1 enemy. On "Poisoned" targets, deal 500 Ignore Defense damage. On WorldBoss only, apply "Tsunami" (deal 700 Bonus damage for every Water Allies in the party, max 10 times).	Deals 2589 damage to 3 lowest HP enemies.	Excels only on Fire WB.
84	84	+12% attack for Water type allies	Deal 112 damage.	Deal 475 damage and on poisoned targets, deal 150 bonus damage.	Prioritizing 3 enemies with the highest attack power, deal 820 damage and 620 Ignore Defense damage. On a critical hit, 60% chance to apply "Stun" for 4 seconds (target is unable to attack, Stun duration increases by 1 second when hit up to 5 additional seconds)	Deal 2357 damage and 700 bonus damage to 4 random enemies. Apply +40% Evasion buff to self for 20 seconds.	Only available during Dead or Alive Venus Vacation Collab.
85	85	Drive skill damage +10% to Light type allies	Deals 112 damage.	Deals 477 damage to enemy with lowest HP. On Dark type targets, deal 150 Bonus damage	Deals 797 damage plus 350 Bonus damage and apply Heal Block (prevent recovery except Vampirism and Absorption) for 16s to 3 enemies with lowest HP.	Deals 2341 damage to all enemies and apply Heal Block (prevent recovery except Vampirism and Absorption) for 25s to 3 enemies with lowest HP.	A very good damage dealer and very useful in PVP against teams with healers. Has the best tap in-game for pvp that targets low health; good for finishing up near dead targets or for setting up slides that hit a single target.
86	86	+5% Slide Skill Damage for Water type allies	Deal 112 auto attack damage.	Deals 476 damage to target with a 70% chance to inflict Heal Block (prevent recovery except Vampirism and Absorption) for 8 seconds.\r\n	Prioritizing enemies with buffs, deals 821 to 2 enemies. On Tank type targets, apply 800 Ignore Defense damage. Apply "Stigma"  (Deal (Total buffs + 1) x 50 continuous damage for every 4 seconds [maximum 6 buffs [Final Tick 7] ] for 20 seconds. 	Deal 2212 damage to 4 random enemies and apply Debuff Explosion (remove 1 debuff and deal damage depending on the debuff type) if the target is debuffed.	Decent child, but there are better water attackers. Stigma effect is that the more buffs a target has, the stronger the DoT; lowest damage is 50dot (0 buffs) for every 4s while highest  is 350dot (6 buffs+initial 50dmg). dat A S S 
87	87	-10% Debuff Evasion to all enemies.	Deal 101 damage.	Deal 392 damage to 1 enemy with highest attack, target's attack -15% for 10 seconds.	Deal 647 damage to 2 enemies with lowest HP, then 70% chance to inflict Death Heal (enemy receives damage equal to the HP heal received, Vampirism/HP Absorb excluded) for 14 seconds, and reduces skill gauge by -35%.	Deal 2024 damage to 3 random enemies, and apply Decomposition (500 damage every 2 seconds, duration can't be reduced or extended) for 14 seconds.	
88	88	+10% Debuff Evasion for Light Allies | Additional +10% in Ragna.	Deal 100 damage.	Deal 380 damage & 70% chance to remove "Death Heal" from 2 allies.	Deal 660 damage to target. Attack +1680 and Slide Skill Damage +1280 for 3 Light Allies (Prioritizing Highest ATK) for 16 seconds. In Ragna only, Skill Gauge +20% for 2 Light type Allies.	Deal 1758 damage to 3 enemies. Attack +40% for 20 seconds and apply "Silence Immunity" for 10 seconds to 2 Allies (Prioritizing highest ATK).	
89	89	 +10% Weak Point damage for water allies. (Additional 20% in Ragna)	Deal 100 damage.	Deal 385 damage, apply +250 Tap Skill Damage to 1 water type ally with the highest attack for 8 seconds.	Deal 660 damage, apply +1500 attack for 14 seconds and Skill Gauge Charge Amount +30%  for 16 seconds to 3 water allies with the highest attack.	Deal 1982 damage to 3 random enemies and apply +25% Weak Point damage to 3 allies with the highest attack. Additional 40% in Ragna.	
106	106	Maximum HP +300 to Light units	Deals 50 damage	Deals 121 damage to target and gains Fury (saves up to 200% damage received and returns 1 time)	Deals 252 damage to target, Defense +10% and taunt (80% provocation) for 8s	Deals 571 damage to 3 random enemies and Absorbs 200 damage as HP	
90	90	Light type allies +15% Attack. [During Ragna, Weak Point Skill Damage +10%]	Deals 113 damage. 	Deals 491 damage to target. On Dark type targets, deal 250 Bonus damage	Prioritizing lowest HP enemies, deal 958 damage to 2 target, 1300 Ignore Defense damage. On Dark type targets, deal 1050 Bonus damage.	Deals 1764 damage to all enemies. Apply "Concentration" (100% Critical Rate and Hit Rate) to self. 	Very good child against Dark attribute bosses due to being able to use Crit Fever when her drive is used. Slightly beats Cleo for use in Dark Ragna
91	91	-15% Defense against Dark type enemies. [For WorldBoss only, -10% Weak Point defense]	Deal 102 auto attack damage.	Deal 394 to target and apply -400 Tap Defense for 8 seconds. For WorldBoss only, 75% chance to cancel "Rage" buff to enemy.	Deal 675 damage amd 600 Ignore Defense damage to 2 random enemies. Apply Slide Skill Defense -500 to targets for 12 seconds. For WoldBoss only, apply Skill Defense -500 to target for 12 seconds.	Deal 2030 damage to 3 random enemies. Apply Debuff Evasion -20% and Skill Defense -20% for 16 seconds.	
92	92	Weak Point Defense -8% to all enemies.	Deals 101 damage.	Deals 379 damage to target and Weak Point Defense -10% for 8s.	Deals 599 damage and 450 Ignore Defense damage and Weak Point Defense -10% for 14s to 2 enemies (prioritizing Water Types).	Deals 1836 damage and Apply "Poison" (causes 620 damage each time target acts; triggers 30% of poison damage when they receive an attack) for 2 turns and removes 1 buff to 3 lowest HP enemies.	Solid WorldBoss Debuffer
93	93	Skill Gauge Charge Amount +8% to Light Types Allies (Additional +8% on Worldboss only)	Deals 100 damage.	Deals 382 damage to target. \r\n70% chance to remove "Petrify" from 2 "Petrified" allies.	Deals 660 damage to target. \r\nGive Skill Gauge Charge Speed +30% to 3 random allies for 16s. \r\nFor WorldBoss only, apply "Sharp Blade" (Weak Point Skill damage +3% multiplied by the amount of buffed allies up to 7) to 7 light allies for 2 turns.	Deals 1733 damage to 2 random enemies. \r\nFor 10s, all allies are immune to "Petrify". \r\nGives Weak Point Skill Damage +25% to 5 light allies for 22s. \r\nFor Worldboss only, +30% attack to the back row for 22s.	
94	94	Weak Point Defense -8% to Water Types enemies	Deals 101 Damages.	Deals 389 Damage and on Support type targets, deal 160 Bonus damage	Deals 669 Damage to 2 highest attack enemies, 60% chances to apply Stun (target is unable to attack, Stun duration increases by 1 second when hit up to 5 additional seconds.) and -1200 attack for 12s.	Deals 1965 Damage to 3 enemies (prioritizing Water types) and -33% Skill Gauge Speed for 16s.	Limited collab child from Street Fighter collab
95	95	Skill Gauge Charge Speed -15% to all enemies	Deals 100 damage.	Deals 375 damage and Skill Gauge Charge Speed -20% for 10s to target.	Deals 600 damage and 60% chance Silence (skill use blocked and Skill Gauge reset) for 5s to 2 random enemies.	Deals 1827 damage and Skill Gauge Charge Speed -45% for 22s and reduce Skill Gauge by 45% to 3 random enemies.	Wola is great for CC in PVP. His Leader skill is great helps you get to drive before enemy does. Even though his debuffs aren't 100%, they are still high enough for him to be a very useful unit to use in PVP and PVE. His debuffs are useless in Raids and WorldBoss modes. Some SoulCards can counter his "Silence" debuff.
96	96	Defense -10% to all enemies	Deals 100 damage.	Deals 369 damage and Defense -5% for 6s to target.	Deals 588 damage and apply Bleed (100 damage every 2s) for 14s to 2 enemies with lowest Defense.	Deals 1806 damage, removes one buff and Defense -25% for 20s to 3 random enemies.	
97	97	Debuff Evasion -15% to Fire type enemies.	Deals 102 damage.	Prioritizing highest attack enemy, deal 394 damage and 75% chance of removing one buff from target.	Prioritizing healer types, deal 677 damage to 2 enemies and Skill Gauge Charge Speed -30% for 12s and enemy drive gauge -8%.	Deals 2012 damage to 3 enemies, removing one buff from targets and 80% chance of silence (skill use blocked and Skill Gauge reset) for 5s.	
98	98	Debuff Evasion -15% for Light Types Enemies.	Deals 101 damage.	Deals 390 damage to target. \r\nAttack -12% to target for 10s.	Deals 619 to 2 random enemies. \r\nApply "Taunt" (20% Provocation) to self for 12s. Apply "Counter Petrification" (70% chance to apply "Petrify" (unable to act for 10seconds or after being hit 1 time) enemies that attack Medusa) to self for 12s.	Deal 4837 damage to 3 enemies plus 500 additional damage to "Petrified" targets and 90% change to "Petrify" (unable to act for 15 seconds or after being hit 2 times) to targets.	
99	99	Drive skill damage +10% to grass units.	Deals 111 damage.	Deals 140 damage plus Auto damage 4 times to target and gives "Lifesteal" (recover 10% of damages dealt as health) for 2 turns to self.	Deals 523 (120%) damage to 3 enemies (prioritizing Water types) .	Deals 2184 damage to 4 enemies with lowest HP.	Her slide's target priority makes her better than Abaddon.
100	100	Defense -15% to Wood enemies.	Deals 101 damage.	Deals 390 damage, 75% chance of removing one buff from target.	Prioritizing enemies with the lowest HP, deal 647 to 2 targets, and Deadly Poison (deals 200 damage every 2 seconds and reduce healing by 50%, duration cannot be shorten/extended) for 10 seconds.	Prioritizing enemies with deadly poison, deals 1998 damage to 3 enemies, Defense -30% and 90% chance of Deadly Poison amplification (increases damage of Deadly Poison and further reduces healing amount) for 16 seconds.	At +6, Deadly Poison deals 904 damage per tick and with her SC (Lost Dream) at +5 it add another 260 on top of that. One of the scariest DoTs in PvP and can only be countered with cleanse or Bathory.
101	101	Debuff evasion rate -5% to Dark enemies	Deals 53 damage	Deals 143 damage to target	Deals 321 damage and Agility -400% for 12s to 2 random enemies	Deals 801 damage, and blindness (Accuracy -30%) for 14s to 2 random enemies	
102	102	Healing -10% to all enemies	Deals 54 damage	Deals 151 damage to target, and gives blindness (Accuracy -20%) for 6s	Deals 351 damage to 2 enemies with priority to Dark units, if Dark unit apply weakness Defense -3% for 12s	Deals 851 damage, Defense -15% and Bleeding (-100 HP every 2s) for 14s to 2 random enemies	
103	103	Healing +2.5% to Light units	Deals 53 damage	Deals 144 damage to target and gives a +150HP barrier for 8s to 1 random ally	Deals 325 damage to 1 random enemy and gives Regeneration (Heal every 2seconds) 35HP for 14s to 2 allies with lowest HP	Deals 666 damage to 2 random enemies and Regeneration (Heal every 2seconds) +40% for 20s to 2 allies with lowest HP	
104	104	Attack +7% to Light units	Deals 54 damage	Deals 146 damage to target and gives a +150HP barrier for 8s to 1 random ally	Deals 327 damage to 1 random enemy, gives a 350HP barrier for 14s to 2 allies with lowest HP and attack +450 for 18s to 2 allies with highest attack	Deals 743 damage to 3 random enemies and gives 101HP Regeneration (Heal every 2seconds) for 23s to 2 allies with lowest HP	
105	105	Evasion rate +8% to Light units	Deals 50 damage	Deals 116 damage to target and Skill defense +30 for 10s to self	Deals 249 damage to target and gains Taunt (80% provocation) and Fury (saves up to 250% damage received and returns 1 time) for 12s	Skill defense +10% for 16s to 3 Light units	
107	107	Defense +200 to Light units	Deals 50 damage	Deals 122 damage to target and gains Fury (saves up to 200% damage received and returns 1 time)	Deals 254 damage to target and Defense +500 for 12s to 3 Light units	Deals 575 damage and Bleeding (60 HP every 2s) for 10s to 3 random enemies	
108	108	HP +400 to Light units	Deals 51 damage	Deals 123 damage to target and +400 HP barrier for 8s to self	Deals 244 damage to 2 enemies with lowest HP and gains Taunt (80% provocation) and Fury (saves up to 250% damage received and returns 1 time) for 6s	Skill defense +10% for 14s to 3 units with lowest HP	
109	109	Heal amount +80 to Light units	Deals 52 damage	Deals 139 damage and heals 80HP to ally with lowest HP	Deals 247 damage to 1 random enemy, 213 HP instant heal and 40 HP Regeneration (Heal every 2seconds) for 10s to 1 allies with lowest HP	Heals 800HP to 2 allies with lowest HP	
110	110	Attack +200 to Dark units	Deals 58 damage damage 2 times to target	Deals 60 damage plus	Deals 160 (105%) damage to 2 enemies with priority to Light units	Deals 890 damage to 3 random enemies	
111	111	Tap damage +40 to Dark units	Deals 58 damage	Deals 188 damage to target and ignore 80 Defense damage	Deals 70 damage plus additional Tap damage 2 times to target (100 ignore Defense damage) with priority to Light units	Deals 931 damage to 3 random enemies	
112	112	Tap damage +40 to Dark units	Deals 58 damage	Deals 188 damage to target	Deals 70 damage plus additional Tap damage 2 times (150 ignore Defense damage) to target with lowest HP	Deals 930 damage to 3 random enemies	
113	113	Attack +200 to Dark units	Deals 58 damage	Deals 189 damage to target and critical rate +20% for 10s to self	Deals 163 (105%) damage to 2 enemies with lowest HP	Deals 819 damage to 3 random enemies	
114	114	Auto damage +30 to Dark units	Deals 58 damage	Deals 60 damage plus additional Auto damage 2 times to target	Deals 164 (105%) damage to 2 random enemies	Deals 899 damage to 3 random enemies	
115	115	Tap skill damage +40 to Dark units	Deals 58 damage to target	Deals 184 damage to target, if light unit deal 30 additional damage	Deals 20 damage and Tap skill once to 3 random units	Deals 810 damage to 3 random units	
116	116	Attack -5% to all enemies	Deals 54 damage	Deals 151 damage and -250 attack for 6s to target	Deals 329 damage to 2 enemies with priority to Light units, if Light unit apply weakness Defense -3% for 12s	Deals 850 damage, Defense -15% and Bleeding (100 continuous damage) for 14s to 2 random enemies	
117	117	Attack -5% to Light enemies	Deals 54 damage	Deals 154 damage to target, and -250 attack for 6s	Deals 331 damage and attack -450 for 12s to 2 enemies with highest attack	Deals 856 damage and attack -20% for 14s to 2 random enemies	
118	118	Slide skill damage +60 to Dark units	Deals 58 damage	Deals 190 damage to target and critical rate +20% for 10s to self	Deals 165 (105%) damage to 2 random enemies and 200 ignore Defense damage	Deals 934 damage and Bleeding (120 continuous damage) for 10s to 3 enemies with lowest HP	
119	119	Critical rate +8% to Dark units	Deals 53 damage	Deals 145 damage to target	Critical rate +25% for 14s and critical damage +20% for 14s to 2 random allies	Deals 712 damage to 2 random enemies	
120	120	Attack +7% to Dark units	Deals 54 damage	Deals 145 damage to target and critical +300 for 8s to 1 random ally	Critical rate +25% for 18s and critical damage +15% for 14s to 2 allies with highest attack	Deals 720 damage to 1 random enemy and attack +800 for 16s to 2 allies with highest attack	
121	121	Gives Reflect (returns 30 damage recieved) to Dark units	Deals 50 damage	Deals 116 damage to target and Defense +350 for 8s to self	Deals 254 damage to target, and gains Reflect (returns 7% of damage received) and Taunt (80% provocation) for 8s	Gives Reflect (returns 7% of damage received) for 16s to 3 Dark units	
122	122	Defense +200 to Dark units	Deals 50 damage	Deals 118 damage to target and Skill defense +30 for 10s to self	Deals 247 damage to target and gains Reflect (returns 6% of damage received) and Taunt (80% provocation) for 8s	Gives Reflect (returns 15% of damage received) for 16s to 2 units	
123	123	Evasion rate +5% to Dark units	Deals 50 damage	Deals 115 damage to target and Defense +350 for 8s to self	Deals 244 damage to target, and gains Reflect (returns 6% of damage received) and Taunt (80% provocation) for 8s	Gives 10% HP Barrier for 16s to 3 Dark units	
124	124	Tap damage +40 to Fire units	Deals 58 damage	Deals 189 damage and Bleeding (50 continuous damage) for 6s to target	Deals 370 damage to 2 enemies with lowest HP	Deals 816 damage to 3 random enemies	
125	125	Tap damage +40 to Fire units	Deals 58 damage	Deals 187 damage to target	Deals 50 damage, additional Tap damage 2 times and Bleeding (50 continuous damage) for 10s to target with priority to Grass units	Deals 929 damage to 3 random enemies	
126	126	Slide Damage +60 to Fire Allies	Deals 58 damage	Deals Auto Damage and Additional 45 damage 3times to target	Deals 282 damage to 2 highest attack enemies. Additional 250damage IF Grass Type	Deals 821 damage to 3 random enemies and Apply "Bleed" (80 damage per 2seconds) for 12seconds	
127	127	Auto damage +30 to Fire units	Deals 58 damage	Deals 187 damage and Bleeding (50 continuous damage) for 4s to target	Deals 20 damage and additional Auto damage twice to 2 enemies with lowest HP	Deals 813 damage to 3 random enemies	
128	128	Slide damage +60 to Fire units	Deals 58 damage	Deals 189 damage to target with highest attack	Deals 50 damage, additional Tap skill damage twice, and Bleeding (50 continuous damage) for 10s to target with highest attack	Deals 933 damage to 3 random enemies	
129	129	Defense -5% to all enemies	Deals 54 damage	Deals 149 damage and Defense -250 for 6s to target	Deals 276 damage to 2 enemies with priority to Grass units, if Grass unit apply weakness Defense -3% for 12s	Deals 803 damage, Defense -15% and Bleeding (-100 HP every 2s) for 14s to 2 random enemies	
130	130	Agility -5% to Grass enemies	Deals 53 damage	Deals 145 damage to target	Deals 323 damage and 10% chance to confuse for 5s to 2 enemies with highest Defense	Deals 791 damage and Defense -15% for 14s to 2 random enemies	
131	131	Attack +7% to Fire units	Deals 53 damage	Deals 144 damage to target and critical +250 for 8s to 1 random ally	Deals 330 damage to 1 random enemy and attack +450 for 14s to 2 allies with highest attack	Deals 666 damage to 2 random enemies and attack +15% for 16s to 2 random allies	
132	132	Defense +200 to Fire units	Deals 50 damage	Deals 120 damage to target and Defense +350 for 8s to self	Deals 243 damage and gains a +500HP barrier and Taunt (80% provocation) for 8s	Gives a +10%HP barrier for 16s to 3 Fire units	
133	133	Evasion rate +5% to Fire units	Deals 50 damage	Deals 116 damage to target and Skill defense +30 for 10s to self	Deals 240 damage and +10% Defense and Taunt (80% provocation) for 8s	Gives a +1000HP barrier for 12s to 3 Fire units	
134	134	HP +400 to Fire units	Deals 50 damage	Deals 118 damage to target and Reflect (returns 30 damage recieved) for 6s to self	Deals 244 damage to 1 random enemy and gains a +500HP barrier and Taunt (80% provocation) for 8s	Gives a +15%HP barrier for 16s to 2 units with lowest HP	
135	135	Maximum HP +300 to Fire units	Deals 51 damage	Deals 122 damage to target and	Skill defense +80 for 6s to self Deals 247 damage to 1 random enemy and gains a +500HP barrier and Taunt (80% provocation) for 8s	Gives Reflect (returns 10% damage received) for 16s to 3 Fire units	
136	136	Defense +200 to all allies	Deals 51 damage	Deals 126 damage to target and damage Defense +40 for 10s to self	Deals 252 damage to target, and Skill defense +100 and Taunt (84% provocation) for 8s to self	Deals 624 damage to 2 random enemies and gives +20% Defense for 16s to 3 Fire units	
137	137	Lifesteal (Absorbs 40 HP per hit) to Fire units	Deals 51 damage	Deals 125 damage to target and Defense +400 for 8s to self	Deals 236 damage, gains Reflect (returns 80 damage recieved) and Taunt (84% provocation) for 8s to self	Deals 582 damage to 2 random enemies and +1000 HP Barrier for 14s to 3 Fire units	
138	138	15 HP Regeneration (Heal every 2seconds) to all allies	Deals 52 damage	Deals 133 damage to target, and heals 71 HP to ally with lowest HP	45 HP Regeneration (Heal every 2seconds) for 14s to 2 allies with lowest HP	Heals 351 HP and gives 124HP Regeneration (Heal every 2seconds) for 16s to 3 allies with lowest HP	
139	139	Auto damage +30 to Water units	Deals 58 damage	Deals 60 damage plus additional Auto damage 2 times to target	Deals 203 damage and Poison (deals 130 damage when enemy attacks and receives attacks) for 3 turns to 2 enemies with priority to fire units	Deals 894 damage to 3 random enemies	
140	140	Attack +200 to Water units	Deals 58 damage	Deals 186 damage to target	Deals 291 damage and Poison (deals 120 damage when enemy attacks and recieves attacks) for 3 turns to 2 enemies with lowest HP	Deals 926 damage to 3 random enemies	
141	141	Tap damage +40 to Water units	Deals 58 damage	Deals 60 damage plus additional Auto damage 2 times to target	Deals 292 damage and 200 ignore Defense damage to 2 enemies with priority to fire units	Deals 897 damage to 3 random enemies	
142	142	Slide skill damage +60 to Water units	Deals 58 damage	Deals 188 damage and Poison (80 damage when enemy attacks and recieves attacks) for 3 turns to target	Deals 293 damage and 200 ignore Defense damage to 2 enemies with priority to Fire units	Deals 931 damage to 3 random enemies	
143	143	Attack +200 to Water units	Deals 58 damage	Deals 190 damage and Poison (90 damage when enemy attacks and receives attacks) for 2 turns to target	Deals 70 damage and additional Tap damage two times to target with priority to Fire units	Deals 822 damage to 3 random enemies	
144	144	Skill gauge charge speed -7% to all enemies	Deals 54 damage	Deals 150 damage to target and 5% chance to skill gauge reset	Deals 329 damage to 2 enemies with priority to Fire units, if Fire units apply weakness Defense -3% for 12s	Deals 815 damage and Bleeding (100 damage every 2s) and Defense -15% for 14s to 2 random enemies	
145	145	Skill gauge charge speed -7% to Fire enemies	Deals 54 damage	Deals 149 damage and agility -200 for 6s to target	Deals 339 damage and Skill gauge charge speed -20% to 2 random enemies	Deals 819 damage and skill gauge charge -28% for 14s to 2 random enemies	
146	146	Agility -5% to Fire enemies	Deals 54 damage	Deals 155 damage and 5% chance to reset skill gauge	Deals 344 damage and -15% skill gauge charge for 12s to 2 random enemies	Deals 880 damage, skill gauge charge rate -30% and sleep for 14s to 2 random enemies	
147	147	Skill gauge charge rate +4% to Water units	Deals 52 damage	Deals 136 damage to target	Deals 293 damage and Skill gauge charge speed +10% for 12s to 2 random allies	Deals 692 damage to 2 random enemies, and skill gauge charge +15%	
148	148	Defense +200 to Water units	Deals 50 damage	Deals 117 damage to target and Defense +350 for 8s to self	Deals 305 damage to target and Defense +10% and gains Taunt (80% provocation) for 8s	Skill defense +10% for 16s to 3 Water units	
149	149	Evasion rate +5% to Water units	Deals 50 damage	Deals 116 damage to target and Skill defense +30 for 10s to self	Deals 301 damage to target and Defense +10% and gains Taunt (80% provocation) for 8s to self	Drive Skill defense +20% for 14s to 3 Water units	
150	150	Maximum HP +300 to Water units	Deals 51 damage	Deals 122 damage to target and	Skill defense +80 for 6s to self Deals 310 damage to target and +500 HP Barrier and Taunt (80% provocation) for 8s to self	Reflect (Returns 10% of damage received) for 16s to 3 Water units	
151	151	Maximum HP +400 to Water units	Deals 50 damage	Deals 123 damage to target and Skill defense +30 to self for 2 hits recieved or 16s	Deals 309 damage to target and Defense +450 and Taunt (80% provocation) for 8s	Deals 576 damage to target and Skill defense +20% for 14s to 3 Water units	
152	152	Lifesteal (Absorbs 40HP per hit) to Water units	Deals 51 damage	Deals 123 damage to target and Reflect (returns 20 damage recieved) for 10s to self	Deals 310 damage to target and 500 HP barrier and gains Taunt (80% provocation) for 8s	Deals 577 damage to 3 random enemy and Absorbs 200 damage as HP	
153	153	Heal amount +40 to all allies	Deals 52 damage	Deals 140 damage to target and heals 81HP to ally with priority to Water units	Gives 57HP Regeneration (Heal every 2seconds) with additional 37HP if ally is debuffed for 14s to 2 allies with lowest HP	150HP Regeneration (Heal every 2seconds) for 16s to 2 allies with lowest HP	
154	154	Attack +200 to Grass units	Deals 58 damage damage 2 times to target and gain Lifesteal (Absorbs 30HP per hit) for 10s	Deals 55 damage plus additional	Deals 160 (105%) damage to 2 enemies with priority to Water units	Deals 889 damage to 3 random enemies	
155	155	Tap skill damage +40 to Grass units	Deals 58 damage	Deals 190 damage to target and absorb 10% of the damage as HP	Deals 70 damage plus additional Tap damage 2 times to target with priority to Water units	Deals 821 damage to 3 enemies with highest attack	
156	156	Tap skill damage +30 to Grass units	Deals 58 damage	Deals 189 damage to target and absorb 10% of the damage as HP	Deals 70 damage plus additional Tap damage 2 times to target with lowest HP	Deals 818 damage to 3 random enemies	
157	157	Weakness Defense -5% to all enemies	Deals 54 damage	Deals 149 damage to target and Absorbs 50 damage as HP	Deals 328 damage to 2 enemies with priority to Water units, if Water unit apply weakness Defense -3% for 12s	Deals 818 damage to 2 random enemies, -15% Defense and Bleeding (100 HP every 2s) for 14s	
158	158	Defense +5% to Grass units	Deals 53 damage	Deals 144 damage to target and Defense 350 for 8s to 1 ally with lowest Defense	Deals 291 damage and gives 300HP barrier for 14s and Lifesteal (Absorbs 5% of damage) for 14s to 2 allies with lowest HP	Deals 667 damage to 2 random enemies and Defense +20% for 16s to 2 random allies	
159	159	Attack +7% to Grass units	Deals 54 damage	Deals 147 damage to target and gives Lifesteal (Absorbs 40 HP per hit) for 8s to 1 ally with lowest HP	Deals 293 damage and gives a +350HP barrier and Defense +450 for 16s to 2 allies with lowest HP	Deals 749 damage to 2 random enemies and gives Reflect (returns 15% of damage received) and Lifesteal (Absorbs 15% of the damage as HP) for 20s to 2 allies with lowest HP	
160	160	Defense +5% to all allies	Deals 54 damage	Deals 148 damage to target and gives a +150HP barrier for 8s to 1 random ally	Gives a +400HP barrier for 16s to ally with lowest HP and attack +450 for 14s to ally with highest attack	Deals 675 damage to 2 random enemies and gives a +1000HP barrier for 16s to 2 allies with highest attack	
161	161	Defense +200 to Grass units	Deals 50 damage	Deals 119 damage to target and Defense +350 for 8s to self	Deals 268 damage and gains 26HP Regeneration (Heal every 2seconds) for 8s and Taunt (80% provocation) for 6s	Gives Lifesteal (Absorbs 20% of the damage as HP) for 16s to 3 units with lowest HP	
162	162	Evasion rate +5% to Grass units	Deals 50 damage	Deals 114 damage to target and gains Lifesteal (Absorbs 80HP per hit) for 2 turns	Deals 264 damage and gains 26HP Regeneration (Heal every 2seconds) and Taunt (80% provocation) for 8s	Gives Defense +20% for 16s to 3 Grass allies	
163	163	Gives Reflect (returns 20 damage recieved) to Grass units	Deals 50 damage	Deals 118 damage to target and gains Lifesteal (Absorbs 80HP per hit) for 2 turns	Deals 314 damage to target and gains +550 HP barrier and Taunt (80% provocation) for 8s	Gives Lifesteal (Absorbs 20% of the damage as HP) for 16s to 3 Grass units	
164	164	Gives Lifesteal (Absorbs 40HP per hit) to Wood allies	Deals 50 damage	Deals 119 damage to target and Defense +350 for 8s to self	Deals 314 damage to target with highest Defense and +500 Defense and Taunt (80% provocation) for 8s	Gives Barrier +1000 HP for 12s to 2 units with lowest HP	
165	165	Maximum HP +400 to Grass units	Deals 51 damage	Deals 124 damage to 1 enemy and gains fury (Saves up to 200% damage recieved and returns one time)	Deals 324 damage to 1 random enemy, and gives a +550 HP barrier and Taunt (80% provocation) for 8s to self	Deals 581 damage to 3 random enemies, and Absorbs 200 damage as HP	
166	166	Heal amount +80 to Grass units	Deals 51 damage	Deals 120 damage to target and heals 64 to 1 ally with priority to Grass units	Deals 296 damage to 1 random enemy, and heals 350HP to 1 ally with lowest HP	Heals 800 to 2 units with lowest HP	
167	167	20HP Regeneration (Heal every 2seconds) to Grass units	Deals 52 damage	Deals 128 damage to target and gives 25 HP Regeneration (Heal every 2seconds) for 8s to ally with lowest HP	Deals 308 damage to 2 random enemies, and heals 198HP and 40 HP Regeneration (Heal every 2seconds) for 10s to 2 allies with lowest HP	Gives 150HP Regeneration (Heal every 2seconds) for 16s to 2 allies with lowest HP	
168	168	20 HP Regeneration (Heal every 2seconds) to Dark units	Deals 52 damage	Deals 130 damage to target and Bleeding or Poison removal +40% to ally	Deals 241 damage to 1 random enemy and 55HP Regeneration (Heal every 2seconds) to 2 allies with lowest HP	Gives 150HP Regeneration (Heal every 2seconds) for 16s to 2 allies with lowest HP	
169	169	Gives Lifesteal (Absorbs 40 HP per hit) to Dark units	Deals 51 damage	Deals 123 damage to target and gains +10% Defense for 8s	Deals 260 damage to 1 enemy and gives +550 HP Barrier and Taunt (80% provocation) for 8s to self	Gives +200 Skill defense for 14s to 3 Dark units	
170	170	Attack +200 to Fire units	Deals 57 damage	Deals 184 damage to target	Deals 289 damage and Bleeding (60 continuous damage) for 10s to 2 random enemies	Deals 920 damage to 3 random enemies	
171	171	Tap damage +40 to Fire allies	Deals 58 damage	Deals 55 damage plus 2 Auto damage times to target	Deals 327 damage and Bleeding (80 continuous damage) for 8s to 2 enemies with priority to Grass units	Deals 890 damage to 3 random enemies	
172	172	Attack +200 to Light units	Deals 57 damage	Deals 184 damage to target	Deals 351 damage and Healing -20% for 10s to 3 enemies with lowest HP	Deals 920 damage to 3 random enemies	
173	173	Defense -6% to Dark enemies	Deals 53 damage	Deals 147 damage to target and gives blindness (Accuracy -20%) for 6s	Deals 323 damage to 2 random enemies and attack -400 for 10s	Deals 839 damage and agility -20% for 14s to 2 random enemies	
174	174	Defense +200 to Light units	Deals 50 damage	Deals 120 damage to target and Lifesteal (Absorbs 80 HP every attack) for 2 turns to self	Deals 250 damage to target and gains Taunt (80% provocation) and Fury (saves up to 250% damage received and returns 1 time) for 12s	Skill defense +10% for 14s to 2 units with lowest HP	
175	175	Regeneration (Heal every 2seconds) +20HP to Light units	Deals 52 damage	Deals 139 damage and gives 50HP Regeneration (Heal every 2seconds) for 8s to ally with lowest HP	Deals 246 damage to target and 50HP Regeneration (Heal every 2seconds) for 14s to 2 allies with lowest HP	Gives 150HP Regeneration (Heal every 2seconds) for 16s to 2 allies with lowest HP	
176	176	Gives Reflect (returns 30 damage recieved) to Dark units	Deals 50 damage	Deals 121 damage to target and Skill defense +40 for 10s to self	Deals 264 damage to target with highest Defense and gains a +500HP barrier and Taunt (80% provocation) for 8s	Gives 15% HP Barrier for 16s to 3 units with lowest HP	
177	177	Gives Lifesteal (Absorbs 30HP per hit) to all allies	Deals 52 damage	Deals 123 damage to target and heals 80HP to 1 Dark ally	Deals 236 damage to target and heals 350HP to ally with lowest HP	Heals 800HP to 2 allies with lowest HP	
178	178	Reflect (returns 20 damage recieved) to Fire units	Deals 50 damage	Deals 121 damage to target and Lifesteal (Absorbs 80HP per hit) for 2 turns to self	Deals 247 damage to 1 random enemy, and gains a +550HP barrier and Taunt (80% provocation) for 8s	Deals 501 damage to 3 random enemies and Absorbs 20% of damage as HP	
179	179	Tap skill damage +40 to Light units	Deals 58 damage	Deals 2 Auto hits plus 60 additional damage to target	Deals 367 damage and Healing -20% for 10s to 2 enemies with lowest HP	Deals 891 damage to 3 random enemies	
180	180	Slide skill damage +60 to Light units	Deals 58 damage	Deals 193 damage and Healing -25% for 8s to enemy with lowest HP	Deals 50 damage plus Tap damage 2 times to target and gains Reflect (returns 5% of damage received) for 10s	Deals 928 damage to 3 random enemies and Bleeding (150 continuous damage every 2s) 10s to 3 enemies with lowest HP	
181	181	Reflect (returns 20 damage recieved) to Light units	Deals 50 damage	Deals 116 damage to target and Defense +350 for 8s to self	Deals 246 damage to target and gains Taunt (80% provocation) and Barrier +500 HP for 8s	Drive Skill defense +20% for 14s to 3 Light units	
182	182	·Tap Damage +10% to Wood Types Allies (Additional +10% In Ragna)	·Deals 113 damage	Deals 491 damage and on Water type targets, deal 250 bonus damage. Apply Weak Point Damage +1000 to self for 16seconds	Deals 958 damage to 3 random enemies, absorbs 350 HP. On Water type targets, deal 1200 Bonus damage.	Deals 2498 damage to 4 random enemies. \r\nOn Water type targets, deal 700 Bonus damage.\r\nIn Ragna, on Water type targets deal 4000 Ignore Defense damage.	Buffed on May 16th, 2019. Best Wood attacker for any pve content involving water.
196	196	Attack +10% to Fire type allies.	Deals 99 damage.	Deals 363 damage and gives +10% attack for 8s to 1 random ally.	Deals 552 damage to 2 random enemies and gives +800 attack and Tap skill attack +100 for 18s to 3 allies with highest attack.	Deals 1696 damage to 3 random enemies and gives +30% attack and Slide skill attack +300 for 25s to 3 allies with the highest attack.	
183	183	+8% Skill Gauge Charge Speed to all Allies	Deal 99 auto attack damage.	Heal 330 HP to 2 allies with the lowest HP.	Deal 578 damage to the target, Defense +700, Regen 79 HP (once  every 2 seconds) for 14 seconds to 2 allies with the lowest HP. 70% chance to apply "Detoxification" (Cleanse poison and heal 1 tick worth of poison damage) to 2 poisoned allies	Heal 1224 HP to all allies and 90% chance to apply "Detoxification" (Cleanse poison and heal 1 tick worth of poison damage) to 3 poisoned allies.	
184	184	Attack +10% to Light Allies	Deals 113 damage.	Deals 477 damage to target. On Dark type targets, deal 100 Bonus damage. 55% chance to Apply "Concentration" (100% Critical Rate and Hit Rate) to self for 13 seconds.	Deals 927 damage plus 800 Ignore Defense damage to 2 lowest HP enemies and apply "Curse" (80 damage every 2 seconds and additional damage when "Curse" ends) for 8 seconds 	Deals 2327 damage to 4 lowest HP enemies and on "Cursed" targets, deal 500 Bonus damage	A strong attacker in all content. Great against Dark Raids where her self-crit buff will allow all damage during fever to crit - Damage monster (downside is that buff is purely rng). Her slide also inflicts DoT and targets lowest health making her very good in pvp as well. Best Light attacker overall.
185	185	Regen Amount +15% for all water type allies [For PvP only, Skill CD -1s]	Deals 96 damage	Deals 335 damage to target, 70% chance to remove Heal block from 2 allies affected by it and apply Regen 101 HP (once per 2 seconds) to 2 lowest health allies for 8s	Deal 513 damage to target, prioritizing 3 allies with the lowest HP, apply Regen 352 HP (once per 2 seconds) for 8s and if affected by a DoT debuff, apply an additional 120 HP regen (once per 2 seconds) for 14s	Deal 1543 damage to 2 enemies, prioritizing 3 allies with the lowest HP, Regen 220 HP (once per 2 seconds) for 16s and Regen Amount +50%	Limited Blazblue Centralfiction event collab. Only decent in PvP, meh everywhere else. 
186	186	Skill Gauge Charge Amount +12% for all water type allies [For PvP only, Skill Gauge Charge Amount +8% to self]	Deals 113 damage	Deals 486 damage to target, Skill Gauge Charge Speed +40% to self for 20s	Prioritizing Fire type enemies, deal 930 damage 2 times and 1145 Ignore Defense damage to 1 target. If speed buffs are active on herself, she deals 1500 fixed true damage	Deal 2539 damage to all enemies; to 1 random target, deal 500 fixed true damage	Limited Blazblue Centralfiction collab event. True damage does not bypass Fortitude buff from Syrinx, etc. True damage at max uncap is 3615
187	187	Skill Gauge Charge Speed -10% to Water Type Enemies.	Deals 74 damage.	Deals 240 damage to target and reduce -400 attack for 8s and 40% chance to remove 1 buff from target.	Deals 454 damages to 2 enemies (prioritizing enemies with Speed Charge type buffs) and 300 ignore defense. 40% chance to apply "Time Alteration" (remove all speed related buffs from the target and reduce Skill Gauge Charge Speed by 40%) for 12s.	Deals 1194 to 3 random enemies and -30% Skill Gauge Charge Amount for 16s.	
188	188	Heal and Regeneration (Heal every 2seconds) amount +8% to Fire units.	Deals 95 damage.	Deals 330 damage, Heal Amount +30% to 5 Fire type allies for 20 seconds 	Heals 1811HP to 2 allies with lowest HP and 75% chance to remove all skill damage reduction type debuffs to 2 debuffed allies.	Regen 272HP (Heal every 2 seconds) for 18s to 3 allies with the lowest HP, heals an additional 319HP if the target is affected by DoT debuff(s), and 80% chance to cleanse the all DoT debuffs	
189	189	Max HP +500 to all allies	Deals 73 damage	Deals 230 damage to target, and 50% chance to remove silence from 1 ally.	Gives 60 HP Regeneration for 16s to 2 allies with lowest HP and 70% chance to cleanse the all DoT debuffs from 2 allies.	Deals 1070 damage to 2 random enemies, grant Reflect (returns 10% of damaged received) for 20s to 2 allies with lowest HP.	
190	190	+8% Slide Skill Damage to Fire allies	Deal 113 damage.	Deal 485 damage to 1 target. Prioritizing Wood enemies inflict Bleed (50 damage every 2 seconds) to 2 targets. Buff own Critical Rate +35% for 12 seconds.\r\n\r\n	Prioritizing enemies with Bleed, targets 3 enemies and deal 902 damage plus 650 Ignore Defense damage. On Bleeding targets, deal 800 Bonus damage. 	Prioritizing enemies with the least HP, targets 4 enemies and deal 2480 damage. For 2 lowest HP targets, inflict Bleed (200 damage every 2 seconds). 	Buffed in around March 2019. 
191	191	Slide Skill defense +5% to Light Allies	Deals 92 damage.	Deals 319 damage to target and gain debuff immunity for 3s.	Deals 578 damage to target and grant Barrier (adsorbs +1400 HP before HP is affected) and +35% Defense for 14s to 5 allies with lowest HP.	Deals 1480 damage to 2 random enemies and give drive Skill defense +30% for 15s to all allies.	Dana is the best tank in the game in all modes, except WorldBoss where Maris (water tank) is better. Her shields + defense up helps to survive against raid drives. Running Dana with a single healer like Maat or Leda will give your team high survivability. VA: Risa Taneda\r\n
192	192	Maximum hp +1000 to all Light Allies (+3000 additional hp on Worldboss)	Deals 100 Damages.	Deals 380 Damages to 1 enemy. On Worldboss Only, removes 5 Attack and Defense stacks.	Deals 656 Damage and apply +1600 Attack to 9 allies (prioritizing Light type allies). On Worldboss Only, Apply -2s Slide Skill Cooldown for 2 Turns and +1000 Slide Skill Damage for 20 seconds to 5 highest attack Allies (prioritizing back row).	Deals 1745 Damages to 2 random enemies and grant Barrier (adsorbs +2000 HP before HP is affected) to 9 allies lowest HP (Prioritizing front row) and +1500 Tap Skill Damage to 9 highest attacks allies (Prioritizing back row).	One of the best buffers made specifically for WB
193	193	Tap Skill defense +5% to Fire units	Deals 92 damage.	Deals 326 damage to target and gives +500HP barrier for 8s to 5 Fire type allies.	Deals 572 damage to target and gives Double-Edge Sword (increase attack by 50% but decreases Defense) for 16s to 5 Fire type allies.	Deals 1474 damage to 2 random enemies and Drive Skill defense +30% for 15s to 5 allies.	Double-edge - attack buffed scales with uncap while defense reduced stays a set amount. OK in Wood WB, but she loses effectiveness as the buff randomly targets 5 fire allies. 
194	194	+15% critical rate to fire type allies (In WB +20% critical damage).	Deals 101 damage.	Deals 385 damage to target, grants +15% evasion for 10s to 2 lowest HP allies.	Deal 663 damage to target, for 16s, all allies in front row, +1000 Defense and 2 allies with the highest attack +43% critical rate. For WB only, 5 highest attack fire allies, +43% critical rate and +25% critical damage for 16s.	Deals 1742 damage to 3 enemies, for 20s, 5 highest attack fire allies +40% attack. For WB only, grants Attack stance (only these 5 childs will attack during fever) to 5 highest attack fire allies.	Set her to drive on 3/6 in WB
195	195	Tap Skill defense +5% to Fire units	Deals 91 damage.	Deals 313 damage to target and gains +600 barrier for 4s and Fury (saves up to 300% damage received and returns 1 time).	Deals 517 damage to 2 random enemies and gains Reflect (returns 15% of damage received) and Taunt (88% provocation) for 10s.	Deals 1409 damage to 2 random enemies and gives a +15%HP barrier for 20s to 3 allies with lowest HP, including self (if own HP is the lowest, barrier will only be applied to 2 targets).	Decent taunt PvP tank but requires higher uncaps to perform well or else he get's blown up quickly. 
197	197	Drive skill damage +10% to Fire type allies	Deals 112 damage.	Deals 477 damage to enemy with lowest HP. On Wood type targets, deal 150 Bonus damage	Deals 797 damage and apply Bleed (100 damage every 2s) for 12s to 2 enemies with lowest HP. On Debuffer types, deal 120 Bonus damage.	Deals 2317 damage to all enemies.	A good Fire attacker with good damage and bleed on slide. Good for eating through Syrinx' buffs in PVP.
198	198	+15% Critical rate for Fire allies (Additional +25% to self on Devil Rumble).	Deal 96 damage.	Deals 335 damage and heal 320 HP to a ally with the lowest HP	Prioritizing the 3 allies with the lowest HP, Regen 150 HP for 14s and if a critical hit occurs, +35% skill gauge.	Deal 1537 damage to 2 random enemies, prioritizing the 5 allies with least HP, Regen 268 HP for 16 seconds and Critical +2000 for 20 seconds .	Only available during the Dead or Alive Venus Vacation collab. Unique healer that relies on crits to speed up her party. 
199	199	+15% attack for Fire type allies	Deal 113 auto attack damage.	Prioritizing debuffer types, Deal 484 damage to target and apply "Bleed" (Deal 80 Damage over Time every 2 seconds) for 14 seconds.	Prioritizing enemies with "Bleed", Deal 829 damage to target plus 570 defense ignore damage 3 times (Deal 400 Bonus damage if enemy is Bleeding)	Deal 2484 damage to 4 random enemies and a 90% chance to apply itself "Awakening" (increase critical damage by 30% and increase Slide skill damage by the number of buffs you have) for 20 seconds.	With the right setup, can destroy a green dubeffer in pvp *coughBathorycough*. Only available during the Beatless collab. Not available anymore. 
200	200	+8% Slide skill damage to Fire type allies.	Deal 113 auto attack damage.	Deal 486 damage to target. For WorldBoss Only, apply "Fire Prison" (deal 1500 Bonus damage for every Fire type ally, up to 10).	Prioritizing Wood type enemies, deal 942 damage to 3 enemies plus 850 Ignore Defense damage. On wood type enemies, deal 600 Bonus damage	Deal 2386 damage to all enemies.	Decent in WB, meh everywhere else.
201	201	+15% Critical damage for Dark type allies (For WB only, Critical rate +30%)	Deals 114 damage	Deals 493 damage to target, critical rate +45% for 12s and For WorldBoss Only apply an (deal 1500 Bonus damage for every Dark type ally, up to 10).	Deals 960 damage and 650 Ignore defense damage to 3 random enemies. Deals 800 bonus damage to enemies with a defense up buff.	Deals 3130(250%) to one target, and For WorldBoss Only, on light type enemy, deal 4000 ignore defense damage.	Mostly excels on Light WB only, pretty subpar everywhere else. Nice ass tho.
202	202	Slide Skills Damage +8% to Fire Allies	Deals 113 damage.	Deals 50 plus Auto damage 3 times to target.	Deals 1205 damage to 2 highest attack enemies plus 700 Ignore defense damage. Deal 550 Bonus damage to targets with "Regen" buff. Gain "Double-Edge Sword"(Increase Attack by 35% but decreases Defense) to self for 23 seconds.	Deals 1488 damage to all enemies and Apply "Bleed"(250 damage per 2 seconds) to 2 lowest HP enemies for 12 seconds.	Doesn't specialize on anything. Probably the worst 5* fire attacker.
203	203	Tap Skill damage +5% to Fire type allies	Deals 112 damage.	Deals 475 damage to target with 150 Bonus damage if enemy is buffed.	Deals 100 damage plus Tap damage (including bonus damage effect on Tap skill) 2 times to 2 random enemies.	Deals 2355 damage to 3 enemies with lowest HP.	A good Fire attacker, but really shines in Raids and WB with her 4 hits to a single target. Unfortunately, she doesn't have a bleed debuff skill and her slide hits random targets.
204	204	+10% Slide Skill Damage for Fire type allies (Additional +30%  critical rate on self in Devil Rumble)	Deal 114 auto attack damage.	Deal 495 damage to target, apply "Yell" to self (Attack +15%, can be stacked up to 3 times) for 15 seconds and a 75% chance to apply "Direct Hit" (Attack ignoring "Fortitude" effect).	Prioritizing 2 enemies with the highest attack, deal 986 damage plus 480 Ignore Defense damage and 300 Bonus damage 2 times.	Prioritizing  4 enemies with the lowest HP, deal 2657 damage.	Hardest hitting fire attacker in game (her slide is a 4 hit)
205	205	+10% Skill Gauge Charge Amount for Fire type allies. (Increase Weak Point damage + 10% in WorldBoss)	deal 100 auto attack damage.	Deal 382 damage to target, +15% Skill Gauge to two Fire type Attackers	Deal 660 damage to target. Skill Gauge Charge Amount +35% to 3 highest attack Fire type allies for 16 seconds and Slide skill damage +1100. For WorldBoss Only, prioritizing 5 highest attack fire type allies, Weak Point damage +10% for 20 seconds	Deal 1733 damage to 3 random enemies. Prioritizing the allies with the lowest HP, heal 1525 HP to 5 allies. For WorldBoss only, +1500 Tap Skill damage for the back row for 20 seconds.	
206	206	Excluding self, resurrect the first ally that dies with 50% HP (1 time only)	Deals 96 damage.	Deal 337 damage to enemy, for 20 seconds Heal Amount +30% to 3 allies with lowest HP.	Heals 1291 HP and grants Barrier (adsorbs +1400 HP before HP is affected) to 3 allies with the lowest HP for 14 seconds.	Deals 1549 damage to 2 random enemies, and heals 1791 HP and Regen 220 HP (Heal every 2s) to 3 allies with lowest HP for 16 seconds.	Her leader skill doesn't work if used as a friend support.
207	207	Attack +5% to all Allies (Additional +8% on Worldboss)	Deals 113 Damages.	Deals 486 Damages to 1 enemy and apply Bleed (80 damage per 2 seconds) for 10seconds. On Worldboss Only, deal 500 Bonus Damage.	Deals 930 Damage and 500 Bonus damages to 3 random enemies. On targets effected by DoT debuff, deal 700 Ignore Defense damage. On Worldboss Only, Apply "Sever" 3 times (800 Bonus damage + inflicted DoT damage).	Deals 2238 Damages to 4 random enemies and Apply "Sever" 1 time (deal 1000 Bonus Damage + inflicted DoT damage).	She inflicts more damage the more DoTs are inflicted on the target. Can be good on all WB regardless of element. 
208	208	+50 Bleed damage dealt for all allies. (Additional +200 in Devil Rumble)	Deal 100 damage.	Deal 370 damage, gives +20% critical damage to 2 allies with the highest attack for 8 seconds.	Deal 568 damage to 2 enemies (prioritizes Bleeding enemies) with 70% chance to apply "Wounded" (increase Bleed duration and damage) for 14 seconds. Attack +1200 to 5 Fire type allies for 18 seconds.	Deal 1670 damage to 3 targets (prioritizes "Wounded" enemies), apply Bleed (120 damage every 2 seconds) for 6 seconds, and +35% skill gauge to 2 allies with the highest attack.	
209	209	Final drive skill damage for all enemies -25% (Additional, deduce DoT debuff damage -50% in Devil Rumble).	Deal 102 auto attack damage.	Prioritizing enemies with buffs, deal 399 damage to target, apply debuff evasion -10% for 20 seconds and defense -10% for 8 seconds.	Prioritizing enemies with the least HP, deal 702 damage to 2 enemies, apply "Dancing blade" (Defense -20% and deal 200 damage every 2 seconds) for 14 seconds and Defense -700 .	Prioritizing enemies with many buffs, deal 2089 to 3 enemies and apply "Stigma" (Continuous damage every 4 seconds [Buffs target number +1] x 250 continuous damage, maximum 6 buffs [Final tick 7]) for 20 seconds.	A must need in PvP
266	266	Skill gauge charge speed +5% to all allies.	Deals 73 damage.	Deals 231 damage to target, and agility +300 to 2 allies with highest attack.	Deals 408 damage to target and skill gauge charge speed 20% for 16s to 2 allies with highest attack.	Deals 1075 damage to 2 random enemies and Attack +1000 for 18s to 2 allies with highest attack.	Budget Kouga v2...
210	210	Skill Gauge Charge Amount -15% for all Debuffer type enemies [For PvP only, Skill Gauge Charge Amount -5% to all enemies]	Deals 102 damage	Deals 396 damage to target, apply Skill Gauge Charge Amount -20% for 10s	Prioritizing Debuffer types, deals 677 damage to 2 enemies, 70% to reset enemy skill gauge and apply Heal block (prevent recovery except Vampirism and Absorption) for 12s	Prioritizing targets with Debuffs, deal 2036 damage to 3 enemies, Debuff explosion (remove one Debuff and deal damage based on its effect) and for 16 seconds apply Burn (Skill Damage Defense -10%) and apply Scald(500 DoT every 2 seconds for 8 seconds) (During Burn's effect, Scald is reapplied every time the target receives an attack except during Fever Time). 	Limited Blazblue Centralfiction event collab. She is a 9 (hehe) in PvP, meh everywhere else. Good counter for grass debuffers (coughBathorycough).
211	211	Tap Skill Damage +5% to Water Allies	Deals 113 Damages.	Deals 140 Damages plus auto attack 3 times and Apply "Poison" (causes 100 damage each time target acts; triggers 30% of poison damage when they receive an attack) for 2 turns.	Deals 883 damages and 500 Ignore Defense damage to 3 Lowest HP enemies.\r\n66% chance to Apply "Overload" (all skills damages +30% except for Drives Skills and Skill Cooldown Increased + Skill Charge Speed decreased) to self for 23 seconds.	Deals 2496 damages to 4 Lowest HP enemies, inflict "Buff Explosion" (remove first applied debuff and damage target according to debuff) 	The overload "buff" is more of a debuff to DB Liza than a buff and what makes her a horrible unit.
212	212	Slide Skill Damage +5% to Water Allies	Deals 113 Damages.	Deals 477 damage to target and on Tank type targets, deal 180 Bonus damage	Prioritizing stunned enemies, Deals 70 Bonus damage +  Tap Skill 2 times to 2 targets. On stunned targets, deal 100 Ignore Defense damage.	Deals 2130 Damages to all enemies and On stunned targets, deal 500 bonus damage	Limited child from Street Fighter Collab. Not available anymore.
213	213	+15% attack for Wood type allies.	Deals 113 damage.	Deals 485 damage to target, if the target is a Tank type, deal 150 bonus damage.	Prioritizing Tank types, deal 855 to 2 targets 2 times,  if the target is a defense type, deal 400 bonus damage and absorbs 350 damage as HP.	Deals 2489 damage to all enemies, 70% chance apply Stun to 2 random enemies for 4s (target is unable to attack, Stun duration increases by 1 second when hit up to max of 5 additional seconds.).	
214	214	+8% Final slide skill damage for Wood element allies. 	Deal 113 auto damage. 	Deal 200 damage plus auto damage 3 times to target and absorb 200 of damage as HP. 	Prioritizing lowest HP enemies, deal 928 damage to 2 enemies, plus 800 Ignore Defense damage and apply 148 damage per buff (up to 8 applications). 	Deal 2480 damage to 4 random enemies and apply "Snow Bomb" to 1 random enemy (After 10 seconds, deal 1500 damage and reset skill gauge)	The more buffs she has, the stronger her slide damage is.
215	215	+10% Weak Point Damage for Wood Types (Additional +10% on Raid Boss)	Deal 100 auto attack damage.	Deal 381 damage to target. Prioritizing allies with lowest HP. Regen 104 HP to 2 allies (once per 2 Seconds) for 8 seconds, and a chance of 70% to remove "Water Balloon" debuff.	Deal 662 damage to target. Grant +25% Defense to 3 wood type allies with highest attack. +10% Weak Point Skill Damage and 70% chance to remove "Freeze" debuff for 16 seconds.	Deal 1763 damage to 3 random enemies. Prioritizing 2 allies with highest attack power, Attack +30% and Tap Skill Damage +800 for 20 seconds.	
216	216	Fire type allies Slide Skill Defense +12%\r\n	Deals 92 damage	Deals 317 damage to target, apply Taunt (88% chance to activate) and +800 Slide Skill Defense for 10 seconds	Deals 588 damage to 2 random targets, for only 3 fire type allies, (Priority: highest attack) 70% chance to remove and be invulnerable to disabling debuffs (Petrify, Silence, Confuse, Stun, Sleep) and gives +1800HP Barrier for 14 seconds	Deal 1496 damage to 2 random targets, apply Taunt (98% chance to activate) and Reflect (returns 40% of damage received) for 20 seconds	Requires running at least 2 other fire type allies on a team to maximize her usefulness
217	217	Skill Gauge Charge Amount -15% for all Fire type enemies	Deals 102 damage	Deals 394 damage to target, Skill Gauge -30%	Prioritizing lowest HP enemies, deals 675 damage and 600 Denfese Ignore damage to 2 enemies. Apply “Water Snake” (Skill Gauge Charge Amount -40% and when attacked by a water type child, deals 500 damage [damage changes according to the debuffed target's attribute]) for 12s	Deal 2031 damage to 3 random enemies, apply Heal Block and "Tsunami" (deal 700 Bonus damage for every Water Allies in the party, max 10 times).	Water Snake debuff damage explanation: +40% damage if the debuffed target is a Fire type, while -40% damage if the debuffed target is a Wood type; otherwise, its the damage written on the skill. At +6 Water Snake debuff hits for 1605 damage. Very likely to be useful in the upcoming Fire WB
218	218	Wood type enemies Debuff accuracy -15%	Deals 102 damage	Prioritizing enemies with Bleed, deal 396 damage to 1 target. 65% chance to inflict "Wounded" (increase Bleed duration and damage) for 12 seconds.	Prioritizing Support type enemies, deals 677 damage and 600 Defense ignore damage to 2 targets, apply Bleed (200 damage every 2 seconds) for 12 seconds.	Prioritizing Attacker type enemies, deals 2036 damage to 3 targets. Remove one buff from enemy and 80% chance to apply "Attraction" (invalidates buffs, can't be dispelled) for 16 seconds.	A slightly better version of Jupiter
219	219	Tap Skill damage +12% for Fire allies. (During Race, Weak Point Skill damage +12% for Fire allies).	Deals 114 damage	Deal 495 damage to target, and deal an additional 500 ignore defense damage if target is a Wood type. Grant Weakness Final Damage +1000 to self for 20 seconds.	Deal 961 damage and 850 ignore defense damage to 3 random targets. During Race only, deal an additional 800 Bonus damage.	Deal 2607 damage to 4 random targets, deal an additional 700 Bonus damage to Wood type targets.	Designed to be used in Race Challenge. Dat Ass.
220	220	-10% duration of debuffs (Except "Decomposition") (Additional -10% in Devil Rumble).	Deal 100 damage.	Deal 337 damage to target and a 70% change to apply "Target" (Concentrate attacks on one target) for 12 seconds.	Deal 660 damage to target, prioritizing 2 allies with less HP, Regen 144 HP (once every 2 seconds) for 16 seconds, and 75% chance to Cleanse DoTs from 2 allies 	Deal 3307 damage to 3 enemies randomly, prioritizing 3 allies with the least HP apply Skill Damage Defense +30% (Cancels after 32 seconds or 4 attacks) and apply "Immortality" (HP won't go under 1) for 14 seconds.	
221	221	ATK +15% to Water allies (For WB only, ATK +15% to all allies)	Deals 114 damage	Deal 494 damage to target, 70% to apply Heal Block (prevent recovery except Vampirism and Absorption) for 8s. For WB only, 70% chance to gain "Awaken"(+30% Critical Damage and Slide Skill damage (increase by the number of buffs)) to self for 15s	Prioritizing enemies with debuffs, deals 960 damage and 400 Ignore Defense damage 2 times to 2 targets, on Fire type targets, deal 350 Bonus damage 	Deals 2603 damage to 4 random enemies.	Best Lead for Fire WB at the moment
222	222	-15% skill charge speed for all enemies.	Deal 101 auto attack damage.	Deal 392 damage and -350 defense to target for 8 second.	Deal 673 damage to 2 enemies (Prioritizing the highest defense enemies). For 12 seconds apply "Burn" (Skill Damage Defense -5%). Apply "Scald" (100 DoT every 2 seconds for 8 seconds). (During Burn's effect, Scald is reapplied every time the target receives an attack except during Fever Time) 	Deal 2026 damage to 3 enemies randomly and apply "Blade Dancer" (Defense Power -20% and 300 DoT every 2 seconds) for 16 seconds.	At +6 Skill Damage Defense goes up to -15.4% and Scald deals 487 damage. Scald acts similar to poison on hit, where damage is applied when the target is hit; for the 12s that burn is active, every hit on the target will apply a tick of burn. For WB, Afternoon Nap SC does NOT help with Burn, use Show Time! SC instead
223	223	+10% Defense for Fire Type allies (in Underground, additional +10% Defense to all allies)	Deal 92 attack damage.	Prioritizing enemies with "Barrier", deal 320 damage to target and give "Anti-Barrier" (Cancel Barrier and do 50% damage of the remaining barrier).	Deal 525 damage to 2 random targets. For 14 seconds, prioritizing 4 Fire type allies, apply Pain Adaptation (Defense +850, Defense increase in proportion to HP allies loss [4% increase in defense per 2% decrease in HP, maximum increase to 160%) and Damage Reflect (reflects 20% of received damage for 14 seconds or upon receiving 3 hits). For PvE only, apply Regen 118 HP (heals every 2 seconds) to self for 14 seconds	Deal 1443 damage to 2 random targets, for 20s, prioritizing 5 fire type allies, Defense +2000 and grant Barrier (adsorbs 2000 HP before HP is affected). For PvE only, apply Pain Sublimation (attack +200 [increase in attack per 2% decrease in HP, maximum increase of 2400% in attack power])	Buffed in around March 2019. FYI: PvE includes Race Challenge
224	224	Water type enemies ATK -15% 	Deals 102 damage	Deal 394 damage to target, DEF -500 to target for 10s	Deal 675 damage to 2 random targets. 65% chance of to apply "Attraction" (invalidates buffs, can't be dispelled) for 12 seconds. To 1 target, 70% chance to apply “Target” (attacks will be focus on said child [However, “Taunt” will take priority over “Target”])	Deal 2031 damage to 3 random targets, apply "Blind" (Attack Accuracy -60%) to target for 16 seconds. Drive Skill Gauge -12%	
225	225	Water type allies Heal amount +15%	Deals 96 damage	Deal 335 damage to target, prioritizing 2 lowest HP allies, Heal amount +35% for 20s	Deal 513 damage to target, prioritizing 3 lowest HP allies, Heal 1290 HP and Debuff Duration -30% for 14s	Deal 1545 damage to 2 random targets, 3 lowest HP allies, Heal 1790 HP and if the ally is debuffed, apply Max HP +2000 for 16s	Trap
226	226	All Allies Def +15% (During Ragna, Weak Point Skill damage +12% for Fire allies)	Deals 92 damage	Deal 319 damage to target, prioritizing lowest HP allies, grant Barrier (adsorbs +800 HP before HP is affected) to 2 targets for 10s. During Ragna, Heal 9%+26HP to self	Deal 591 damage to target, gains Taunt (90% provocation) and Immortality (HP won't go under 1) for 10s. During Ragna, apply "Life Bind" (Convert 20% of the damage received into healing, the rest of the HP buff is spread to 2 allies with the least HP) to self for 12s	Deal 1501 damage to 2 random targets, prioritizing lowest HP allies, grants Reflect (returns 35% of damage received) to 5 allies for 20s	Only good in Fire Ragna for her lead, and if you need more survivability.
227	227	Dark type allies Skill gauge charge amount  +12%	Deals 100 damage	Deal 379 damage to target, for 2 debuffed allies, 60% chance to cleanse 1 debuff	Deal 663 damage to target, to 2 allies with the highest attack, skill gauge charge amount +36.5% and debuff EVA +20% for 16s	Deal 2040 damage to 3 random targets, prioritizing dark type childs, skill gauge charge amount +50% and tap skill damage +1500 to 3 allies for 20s	
228	228	Light type enemies Debuff Accuracy -15%	Deals 102damage	Deal 396 damage to the highest attack enemy, apply "Blind" (Attack Accuracy -30%) to target for 10 seconds.	Prioritizing Debuffer types, deal 677 damage to 2 targets, Apply "Blind" (Attack Accuracy -45%) and Debuff Accuracy -20% for 12s	Prioritizing lowest HP enemies, deal 2038 damage to 3 enemies, 80% chance to inflict Death Heal (enemy receives damage equal to the HP heal received, Vampirism/HP Absorb excluded) and 80% chance to apply "Attraction" (invalidates buffs, can't be dispelled) for 16s.	
229	229	Light type allies Skill gauge charge amount +12% (During Ragna, Light type allies Skill gauge charge amount +8% additional)	Deals 101 damage	Deal 390 damage to target, to 2 lowest HP allies, grant Barrier (adsorbs +900 HP before HP is affected) for 10s	Deal 679 damage to target, to 3 light type allies with the highest attack, skill gauge charge amount +40% and Final Weak point damage +20% for 16s. For Ragna, grant Vampirism (recovers 15% HP on attack) to 3 allies with the lowest HP for 16s	Deal 1828 damage to 3 random targets, to 5 allies, grant Barrier (adsorbs +2500 HP before HP is affected) for 20s and Drive gauge +120 for every Light type ally (up to 5)	
230	230	Slide Skill Damage for Dark type allies +10%	Deals 114 damage	Prioritizing 2 lowest HP enemies, deal 440 damage, apply “anti barrier”(removes barrier and inflict 70% of remaining barrier as damage)	Prioritizing Light types, deal 961 damage to 2 targets, 2 times, apply “protection buff explosion” (removes 1 protection type buff and deal 300 x "type of buff" as damage). For PvP only, deal 600 bonus damage	Prioritizing enemies with protection type buffs, deal 2605 damage to 4 enemies, apply “protection buff explosion” (removes 1 protection type buff and deal 600 x "type of buff" as damage).	Protection Type Buff includes. DEF Up,\r\nSkill Defense Up,\r\nTap Skill Defense Up,\r\nSlide Skill Defense Up,\r\nDrive Skill Defense Up,\r\nDEF Up stacks,\r\nImmortality,\r\nFortitude,\r\nBarrier,\r\nTaunt,\r\nDebuff Taunt,\r\nPain Adaptation,\r\nMax HP Up. More info on "type of buff" damage multiplier can be found here: https://ginmy.net/dc_ophois_inspection 
231	231	Fire type allies Agility +15%	Deals 113 damage	Deal 490 damage to target, +20% Agility to self for 14s	Prioritizing 3 lowest HP enemies, deal 933 damage, apply 148 damage per buff (up to 8 applications). Apply “heal buff explosion” (removes 1 heal type buff and deal 300x “type of buff” as damage).	Deal 2545 damage to all enemies, apply “heal buff explosion” (removes 1 heal type buff and deal 600x “type of buff” as damage).	
232	232	Water type allies Tap Skill Damage +12% (For WB only, water type allies Skill Gauge Amount +20%)	Deals 101 damage	Deal 393 damage to target, for 2 allies that are stunned, 70% chance to remove stun	Deal 706 damage to target, for 3 highest attack water type allies, +40% Skill Gauge Amount and +15% ATK. For WB only, prioritizing water type allies in the back row, Skill Damage +20% for 5 allies	Deal 1832 damage to 3 random enemies, prioritizing highest attack water type allies, Tap skill damage +50% for 5 allies for 20s. For WB only, grants Attack stance (only these 5 childs will attack during fever) to 5 highest attack water type allies	a.k.a - gilteen, guillotine, guiltine. 
267	267	HP +800 to Water units.	Deals 68 damage.	Deals 194 damage to target and Defense +520 for 12s to 2 Water units.	Deals 378 damage to target, gives Defense +20% and 800HP barrier to 5 Water units.	Deals 819 damage to 2 random enemies, skill damage Defense +20% for 16s to 3 Water units.	
233	233	Light type allies debuff received duration -12%	Deals 101 damage	Deals 391 damage to target, prioritizing 2 highest attack allies, give sleep immunity for 5s	Deals 680 damage to target, prioritizing 2 allies with debuffs, give debuff duration -30% and skill gauge charge speed +40% for 16s	Deal 1830 damage to 3 random enemies, prioritizing 3 allies inflicted with sleep, give sleep immunity for 20s	
234	234	Wood type enemies Def -10%	Deals 74 damage	Deal 245 damage to target, target’s Def -350 for 8s	Deal 446 damage to 2 random enemies, 42% to apply stun for 4s (target is unable to attack, Stun duration increases by 1 second when hit up to 5 additional seconds)	Prioritizing stunned enemies, deal 1115 damage to 3 targets, if the target is stunned, deal 500 ignore def damage.	
235	235	Fire type allies Skill Gauge Charge Speed +15%	Deals 101 damage	Deals 391 damage to target, 60% chance of remove DoT Debuffs from 2 allies	Deals 704 damage to 2 random enemies, for 2 highest attack Fire type allies apply "Double-Edge Sword"(Increase Attack by 65% but decreases Defense) and Skill Gauge +20%. For Ragna only, additional Tap skill damage +30% for 16s	Deal 1826 damage to 3 random enemies, for 3 highest attack Fire type allies, Skill Gauge Charge Speed +60%. For Ragna only, Final Tap skill damage +30% for 20s	Her Slide and Drive's Tap Skill damage stacks
236	236	Wood type allies Slide skill damage +10%	Deals 113 damage	Deals 487 damage to target, 70% chance to swap Attack and Defense for 14s to self	Prioritizing Debuffer types, deals 930 damage to 2 targets, apply “Erode” (depending on the number of debuffs + 1, deals 30 damage every 2s for every debuff, maximum of 4) for 20s. For PvP only, apply Shatter (deal 250 Bonus damage for every Wood type ally, up to 10)	Deal 2539 damage to 4 random enemies	
237	237	+12% Defense for dark type allies.	Deal 92 auto attack damage.	Deal 315 to target and apply "Reflect" on self (returns 15% of received damage) for 10 seconds.	Deals 563 to target; Apply "Rage" on self (Stores up to 350% damage and adds it to the next skill) and apply "Taunt" (with a 90% chance to activate) for 12 seconds.	Deal 1469 damage to 2 random enemies;  and apply to self +30% skill damage defense for 20 seconds and "Taunt" (with a 98% chance to activate) for 16 seconds.	An "offense" based tank that specialized on dealing damage back but without any defense buffs ends up being a useless tank.
238	238	Dark type allies Max HP +800	Deals 73 damage	Deal 233 damage to target, to the highest attack ally, critical rate +30% for 10s	Deal 448 damage to 2 random targets, prioritizing to 2 allies with the lowest HP, gives AGI +800 and Barrier +1000 HP	Deal 1120 damage to 3 random targets, prioritizing to 3 allies with the lowest HP, gives Barrier +1500 HP	
239	239	Water type allies Slide Skill Defense +12%	Deals 93 damage	Deals 322 damage to target, prioritizing 2 lowest HP allies, give Max HP +850 for 8s	Deals 606 damage to target, for 3 lowest HP Water type allies, apply Ice Shield (Def +35% and for 8s, when attacked, enemy Skill Gauge Charge speed -20%) and Max HP +1400 for 14s	Deal 1536 damage to 3 random enemies, grant taunt (98% provocation) to herself and apply Ice Shield (Def +45% and for 8s, when attacked, enemy Skill Gauge Charge speed -40%) for 16s	
240	240	Critical rate +6% to Water units	Deals 53 damage	Deals 144 damage to target and skill gauge charge speed +20% for 8s to 1 random ally	Deals 303 damage to target and skill gauge charge +20% for 14s to 2 random ally	Deals 666 damage to 2 random enemies and skill gauge charge rate +35% for 16s to 2 allies with highest attack	
241	241	Skill Gauge Charge Amount+8% to Wood Allies	Deals 99 damage.	Deals 368 damage to target and gives +150 skill gauge to 2 Wood type attackers.	Deals 578 damage to target and gives +30% skill gauge charge amount and debuff duration -20% (excluding petrification) for 15seconds to 3 wood type allies.	Deals 1673 damage to 3 random enemies and 70% chance to apply Stun for 14s (target is unable to attack, Stun duration increases by 1 second when hit up to 5 additional seconds) and gives "Vampirism" (restores 25% of damage dealt as HP) to 3 lowest HP allies. 	
242	242	Wood type allies Debuff Evasion +15%	Deals 242 damage	Deals 1124 damage to target, 62.7% chance to remove a debuff from 3 Wood type allies	Deals 1538 damage to target, prioritizing 2 lowest HP allies, apply regen 2.2% HP + 74 (heal every 2s) for 14s and 5 Wood type allies + 14.1% Debuff Evasion	Deal 3971 damage to 2 random enemies, prioritizing 3 lowest HP allies, heal 2018 HP and if allies are debuffed, apply regen 370HP (heal every 2s) for 16s	
243	243	Water type allies Slide Skill Damage +12%	Deals 113 damage	Prioritizing target with the lowest HP, deal 490 damage to 1 target, 70% chance to disable protection type buffs for 8s	Prioritizing debuffed enemies, deals 993 damage to 1 target 3 times, deals 400 Bonus damage and prioritizing 2 lowest HP enemies, apply Poison (causes 300 damage each time target acts; triggers 30% of poison damage when they receive an attack) for 3 turns	Deal 2547 damage to 4 random enemies, 80% chance to remove one buff	New Highest Poison for WB (1644 at +6)
244	244	Drive skill damage +10% to Water units	Deals 113 damage.	Deals 485 damage to target with lowest defense, on Fire type enemies, deal 250 Bonus damage	Deals 855 damage plus 450 bonus damage and Poison (causes 300 damage each time target acts; triggers 30% of poison damage when they receive an attack) for 3 turns to 2 enemies with lowest HP.	Deals 2437 damage to all enemies.	She is great starter pick all content. Though, at lower uncap levels she will not be as great as Ely or Sonnet in regards to poison, but she does more raw damage. 
245	245	Poison damage +200 for Water type allies	Deals 113 damage	Prioritizing poisoned target, to one target, deal 430 damage 2 times	Prioritizing lowest HP enemies, deal 905 damage and 700 Ignore Defense damage to 3 targets. Apply Poison (causes 400 damage each time target acts; triggers 30% of poison damage when they receive an attack) for 2 turns	Deal 2487 damage to 4 random enemies, on poisoned targets, deal 500 Bonus damage	Has higher poison damage than both Eve and Thanathos (on equal uncaps). 5* version of Elysiun (time for her to retire). Made Chiyu not f2p on JP anymore xAx. 2/13 update: poison damage dethroned by Serket
246	246	Drive skill damage +1000 to Water units	Deals 111 damage.	Deals 95 damage plus Auto damage 4 times to target.	Prioritizing highest attack power, Deals 733 damage and Poison (causes 300 damage each time target acts; triggers 30% of poison damage when they receive an attack) for 4 turns to 2 enemies with 175 bonus damage if Fire type.	Deals 2151 damage to 4 enemies with lowest HP.	
247	247	Water Type Enemies Skill Gauge Charge Amount-15%.	Deal 101 auto damage.	Inflict 392 damage, 65% chance to reset enemy gauge and for 8s, 70% chance to inflict Heal Block.	Deal 672 damage to 2 enemies with the highest attack, and for 12s, 70% chance to apply "Time Alteration" (remove all speed related buffs from the target and reduce Skill Gauge Charge Speed by 40%) and -35% skill gauge.	To 3 random targets, deal 2025 damage, 80% to reset enemy gauge and for 16s skill gauge charge speed -45%.	Counter to any speed buffer (Kouga/NMona/etc.)
248	248	-15% to debuff accuracy for enemy debuffer units. 	Deal 102 damage.	Prioritizing debuffers, Deals 394 damage to 1 target. Debuff accuracy -9.6%.	Deal 675 damage to 2 random targets with 70% chance to inflict Sleep (can't atttack and Def becomes 0) for 8 seconds, and Attack -1500 for 12 seconds.	Deal 2032 damage to 3 targets prioritizing enemy with highest Attack stat, then inflict Attack -40% and Defense -30% for 16 seconds.	
249	249	+15% increase attack power for dark type allies.	Deal 113 auto attack damage.	Deal 485 damage to target. \r\nIncrease own critical chance to +45% for 12 seconds.	Prioritizing Light type enemies, deal 904 damage plus 470 Defense Ignore damage 3 times to 1 target, and if the target is a light type, deal 400 additional damage. 	Prioritizing enemies with the least HP remaining, deal 2485 damage to 4 enemies.	5* version of Artemis. 
250	250	-15% Debuff Evasion for Wood enemies.	Deal 102 auto attack damage.	Prioritizing enemies with "Fortitude" buff, deal 394 to 2 enemies and a 75% chance to remove "Fortitude" buff from targets.	Prioritizing debuffer type enemies, deal 674 to 2 enemies, a 60% chance to apply "Stun" (target is unable to attack, Stun duration increases by 1 second when hit, up to 5 additional seconds) for 4 seconds, -800 Agility for 12 seconds. 	Deal 2029 to 3 random enemies. For 2 turns, apply +2 seconds on enemy Slide Skill Cooldown, and enemy's Drive Gauge -12%.	Leader Skill used in WB
251	251	+10% Weak Point Skill Damage for Dark type allies. [Additional +10% in Raid Boss]	Deal 113 auto attack damage.	Deal 491 to target. On Light type targets, deal 250 Bonus damage.	Prioritizing supporter enemies, deal 958 damage to 3 enemies, gives 800 Ignore Defense damage. On Light type targets, deal 600 Bonus damage.	Deal 2598 damage to 4 random enemies and Weak Point Skill Damage +50% to self for 20 seconds.	Best Dark attacker for Light Ragna. 
252	252	Wood type allies Critical Rate +18% [In Ragna only, Critical Damage +40%]	Deals 114 damage	Deals 494 damage to target, on water type enemies, deal 350 Bonus damage. On a critical hit, apply "Vampirism" (restores 10% of damage dealt as HP) to self for 20s	Prioritizing 1 target with the lowest HP, deals 960 damage and 680 Denfese Ignore damage 3 times and on a debuffed target, deal 550 bonus damage. In Ragna only, on a critical hit, deal 5000 fixed damage.	Deal 3756(300%) damage to a random enemy, Skill Damage +40% to self for 20s	Excels in Water Ragna. Successfully powercreeped JCB (Jiseihi) in Ragna when paired with crit 
253	253	Fire type enemies Skill Gauge Charge Amount -10%	Deals 102 damage	Deals 398 damage to target, apply Drive skill defense -20% for 10s	Prioritizing tanks, deal 690 damage to 2 enemies, skill gauge -35% and apply "Snow Bomb" (After 10 seconds, deal 700 damage and reset skill gauge).	Deal 2064 damage to 3 random enemies, enemy Drive gauge -15% and 80% chance to apply Stun (target is unable to attack, Stun duration increases by 1 second when hit up to 5 additional seconds) for 16s	
254	254	Wood type allies Attack +18% (For WB only, all allies Attack +20%)	Deals 114 damage	Deals 498 damage to target, for 2 turns, attack +20% to self	Deals 625(135%) damage to 3 random enemies, For WB only, deal additional 1900 Ignore Defense damage	Deal 2661 damage to 4 random enemies, apply "Vampirism" (restores 20% of damage dealt as HP) to self	Fact: Hel currently has the highest base attack stat in the game
255	255	Water type allies Slide Skill CD -1s  (For PvP only, debuff duration -40% for all allies)	Deals 96 damage	Deals 342 damage to target, for 2 lowest HP allies, apply Barrier +900 and Heal amount +35% for 10s	Deals 542 damage to target, for 2 lowest HP allies, apply Regen 2.1%+21 HP for 14s and for 3 lowest HP water type allies, 70% chance to apply invulnerability to disabling debuffs (Petrify, Silence, Confuse, Stun, Sleep)  for 14s	Deal 1606 damage to 2 random enemies, for 3 lowest HP allies, Instant heal 1892 and cleanse all debuffs	
256	256	All allies Critical stat +5%\r\n	Deal 81 damage\r\n	Deal 303 damage to target, gain Critical Rate +30% to self for 10s\r\n	Prioritizing lowest HP enemy, deal 477 damage 2 times to 2 enemies\r\n	Deal 1414 damage to 4 random enemies\r\n	
257	257	Light Type allies Heal Amount +6% \r\n	Deal 52 damage\r\n	Deal 146 Damage, Instant Heal 83 HP to 1 ally with the lowest HP\r\n	Prioritizing lowest HP allies, Instant Heal 207 HP and 35% chance to remove DOT Debuffs for 2 allies\r\n	Prioritizing lowest HP allies, Instant Heal 381 HP and 70% chance to remove DOT Debuffs for 3 allies	
258	258	Light type allies Skill Damage Defense +10% 	Deal 69 damage \r\n\r\n\r\n	Deal 190 damage 2 times to target. Inflict Blind (decrease Attack ACC 20%) to 1 Enemy with the highest attack for 6s	Deal 406 damage, grant Reflect (returns 12% of damage received) to self for 14s and Skill Damage Defense +12% (for 14s or 2 hits) to 3 allies excluding itself\r\n	Deal 835 damage to 2 random enemies, grant Reflect (returns 16% of damage received) to 5 random allies for 16s	
259	259	Dark type allies Critical stat +8%	Deal 81 damage	Prioritizing lowest HP enemy, deal 281 damage 2 times to 1 enemy	Deal 553 damage and 200 Bonus damage to 3 random enemies	Deal 1370 damage to 4 random enemies\r\n	
260	260	\r\nAll enemies Debuff EVA -8%\r\n	Deal 74 damage\r\n	Deal 246 damage to target, apply attack -10% for 8s\r\n	Deal 545 damage to 2 random enemies, apply Debuff EVA -10% for 10s\r\n	Deal 1404 to 2 random enemies, apply attack -30% and Debuff EVA -20% for 16s	
261	261	Healing +2.5% to all allies.	Deals 73 damage.	Deals 229 damage to target and gives a +250HP barrier for 8s to 1 random ally.	Gives Regeneration (Heal every 2s) ability +30% to all allies and 60HP Regeneration (Heal every 2s) for 16s to 2 allies with lowest HP.	Deals 1108 damage to 2 random enemies and give Lifesteal (Absorbs 20% of the damage as HP) for 20s to 2 allies with lowest HP.	She isn't a healer, but doesn't have the long cooldowns that healers do (7s CD). A great supportive healer in content where a ton of damage is dealt, but can easily be used as a solo healer. Arguably best "healer" in early game.
262	262	Skill gauge charge +4% to all allies.	Deals 73 damage.	Deals 232 damage to target and skill gauge charge speed 25% for 6s to 1 random ally.	Deals 435 damage to target and skill gauge charge +26% for 18s to 2 allies with highest attack.	Deals 1120 damage and 75% chance to Confuse for 10s to 2 random enemies and heal 250HP to 3 allies with lowest HP.	Budget Kouga...
263	263	Attack -10% to Fire enemies.	Deals 74 damage.	Deals 237 damage to target, and remove 30% of target skill gauge.	Deals 438 damage and skill gauge charge speed -20% for 12s to 2 random enemies.	Deals 1151 damage and skill gauge charge speed -30% for 16s to 3 random enemies.	
264	264	Skill gauge charge speed -10% to Fire enemies.	Deals 74 damage.	Deals 238 damage to target and remove 30% of target skills gauge.	Deals 427 damage and skill gauge charge speed -25% for 12s to 2 enemies with highest attack.	Deals 1157 damage and skill gauge charge speed -40% for 16s to 3 random enemies.	
265	265	Attack -10% to all enemies.	Deals 74 damage.	Deals 240 damage and critical -25% for 9s to target.	Deals 441 damage, attack -800 and weakness defense -3% for 12s to 2 enemies with highest attack.	Deals 1162 damage to 2 enemies with priority to Light units, attack -30% and weakness defense -20%.	Budget Midas...
268	268	Weak Point Defense +5% to Light Type Allies.	Deals 73 damage.	Deals 223 damage and 60% chance to remove "Confusion" from 1 allies.	Deals 446 damage to target and Give "Regeneration" (Heal 67HP per 2s) for 16s and 70% chance to cleanse the all DoT debuffs to 2 lowest HP allies.	Deals 1097 damge to 3 random enemies and Heal 516 HP to 3 allies with the lowest Hp 	Better version of Erato
269	269	Critical rate +10% to all allies.	Deals 73 damage.	Deals 233 damage to target and critical rate +30% for 10s to 1 random ally.	Critical rate +30% and critical damage +25% for 16s to 2 allies with highest attack.	Deals 1119 damage to 2 random enemies, skill damage +25% for 16s to 2 allies with highest attack and 75% confusion for 10s to 1 random enemy.	She's a cheaper version of Pantheon. She's not as good as he is, but is still good at higher uncaps.
270	270	Attack -15% to all enemies.	Deals 74 damage.	Deals 243 damage to target with highest attack and Attack -10% for 6s.	Deals 518 damage to 2 enemies with highest attack, Attack -700, and critical rate -25% for 12s.	Deals 1355 damage to 2 enemies with highest attack, drive skill gauge -5%, and Attack -30% for 15s.	
271	271	Auto damage +40 to Water units.	Deals 80 damage.	Deals 80 damage plus Auto damage 3 times to target.	Deals 531 damage and Poison (Deals 380 damage when enemy attacks and receives attacks) for 3 turns to 2 enemies with priority to fire units, if fire type deal 150 additional damage.	Deals 1389 damage to 3 random enemies.	Sonnet is good against single target fights such as Raids and WorldBoss, because she has the highest poison per tick compared with Elysium and Eve. Can easily be added to any element WB teams to give poison damage.
272	272	Attack +500 to grass units.	Deals 80 damage.	Deals 296 damage to enemy with lowest HP with 100 additional damage if Water unit.	Deals Tap damage 2 times, 150 additional damage if Water unit to 1 enemy with priority to Water unit.	Deals 1425 damage to 3 enemies with lowest HP.	
273	273	Critical +400 to Fire units.	Deals 80 damage.	Deals 295 damage to enemy with lowest HP with 100 additional damage if grass type.	Deals 560 damage 3 enemies with priority to grass type with 200 additional damage if grass type.	Deals 1310 damage to 4 random enemies.	
274	274	Attack +500 to Dark units.	Deals 81 damage.	Deals 300 damage to target and critical rate +25% for 10s to self.	Deals 75 damage plus Tap damage 3 times to target (500 ignore Defense damage).	Deals 1433 damage and Bleeding (160 continuous damage every 2s) for 8s to 3 random enemies.	
275	275	Tap attack damage +40 to Light units	Deals 80 damage.	Deals 80 damage plus Auto damage 3 times to target.	Deals 507 damage and Healing -25% for 14s to 2 enemies with lowest HP.	Deals 1406 damage and Bleeding (160 continuous damage every 2 seconds) for 8s to 3 random enemies.	
276	276	Damage +40 to Dark units.	Deals 80 damage.	Deals 294 damage to enemy with lowest HP with additional 100 damage if Light type.	Deals 271 (105%) damage to 3 enemies with priority to Light units.	Deals 1417 damage to 3 enemies with lowest HP.	
277	277	Slide skill damage +100 to wood allies.	Deal 81 damage.	Deal 301 damage to target and grant LifeSteal (Heals 3% HP per attack) to self for 16 seconds.	Deal 565 damage plus 3x tap to target, plus 500 ignore defense damage.	Deal 1278 damage to 4 random targets, plus 300 bonus damage if target is water type.	
278	278	Attack +500 to Fire units.	Deals 80 damage.	Deals 80 damage plus Auto damage 3 times to target.	Deals 458 damage to 2 enemies and Bleeding (60 continuous damage every 2s) for 10s, with 80 additional damage if grass type.	Deals 1395 damage to 3 enemies, and Bleeding (200 continuous damage every 2s) for 8s.	
279	279	Auto damage +40 to Fire units.	Deals 80 damage.	Deals 294 damage to enemy with lowest HP with 100 additional damage if grass type.	Deals 470 damage and Bleeding (120 continuous damage every 2s) for 8s to 2 enemies with priority to grass type.	Deals 1417 damage to 3 enemies with lowest HP.	
280	280	Tap skill damage +80 to Dark units.	Deals 80 damage.	Deals 296 damage to enemy with lowest HP with 100 additional damage if Light type.	Deals 95 damage plus Tap damage 2 times to target (450 ignore Defense damage).	Deals 1313 damage to 4 random enemies.	
281	281	Agility +400 to Light Units	Deals 80 damage.	Deals 293 damage to enemy with lowest HP with 100 additional damage if Dark type.	Deals 80 damage plus Tap damage 2 times to target and gains Reflect (returns 7% of damage received) for 15s, priority to Dark enemies.	Deals 1417 damage to 3 enemies with lowest HP.	
282	282	Tap skill damage +80 to grass units.	Deals 81 damage.	Deals 75 damage plus Auto damage 3 times to target and gains Lifesteal (Absorbs 40HP per hit) for 20s.	Deals 589 damage to 3 random enemies and absorb 8% of the damage as HP.	Deals 1432 damage to 3 enemies with lowest HP.	
283	283	Critical +400 to grass units.	Deals 80 damage.	Deals 293 damage to enemy with lowest HP with 100 additional damage if Water unit.	Deals 278 (108%) damage to 2 random enemies.	Deals 1393 damage to 3 random enemies.	
284	284	Critical +400 to Water units.	Deals 81 damage.	Deals 300 damage and Poison (Deals 150 damage when enemy attacks and recieves attacks) for 3 turns to target.	Deals 80 damage plus Tap damage 3 times to target and 300 ignore Defense damage.	Deals 1319 damage to 4 random enemies.	
285	285	Tap damage +80 to Fire units.	Deals 81 damage.	Deals 300 damage and Bleeding (45 continuous damage every 2s) for 6s to target.	Deals 50 damage plus Tap damage 3 times to target plus 300 ignore Defense damage.	Deals 1454 damage plus 500 ignore Defense damage and 90% chance to apply heal block for 10s to 3 enemies with lowest HP.	
286	286	Defense +300 to Water units.	Deals 68 damage.	Deals 187 damage to target and Defense +500 for 10s to self.	Deals 372 damage to target, and Defense +600 and gains Taunt (84% provocation) for 10s to self.	Defense +30% for 20s to 5 allies.	
287	287	Maximum Health +800 to Light units.	Deals 68 damage.	Deals 206 damage to target and gains Fury (saves up to 250% damage received and returns 1 time).	Deals 388 damage to target and drive Skill defense +15% to all allies and gains Taunt (84% provocation) for 10s.	Deals 797 damage to 2 random enemies and Skill defense +20% from 3 enemies for 16s to 3 allies with lowest HP.	
288	288	Defense +300 to Fire units.	Deals 68 damage.	Deals 193 damage to target and Skill defense by +45 for 10s to self.	Deals 340 damage to target, and gains a +680HP barrier and Taunt (84% provocation) for 10s.	Gives a +2500 HP barrier for 20s to 3 allies with lowest HP.	
289	289	Maximum HP +800 to Fire units.	Deals 67 damage.	Deals 187 damage to target, and Defense +580 for 10s to self.	Deals 383 damage to target, +1200 HP Barrier and Taunt (85% Provocation) for 10s to self.	Deals 851 damage to 2 random enemies, and gives +2000 HP Barrier for 20s to 2 allies with lowest hp.	
290	290	HP +800 to Fire units.	Deals 68 damage.	Deals 189 damage to target and Defense +540 for 10s to self.	Deals 337 damage to target and gains a +1000HP barrier and Taunt (84% provocation) for 8s.	Deals 834 damage to target, and gains a +3000HP barrier and Taunt (95% provocation) for 15s.	
291	291	Gives Reflect (50 damage per hit) to Dark units.	Deals 68 damage.	Deals 187 damage to target and Defense +540 for 10s to self.	Deals 397 damage to target, and gives Reflect (returns 10% of damage received) and Taunt (84% provocation) for 10s.	Deals 786 damage to target, and gives Reflect (returns 8% of damage received) for 20s to 5 allies.	
292	292	Reflect (50 damage per hit) to Fire units.	Deals 68 damage.	Deals 192 damage to target and Defense +480 for 12s to 2 Fire units.	Deals 337 damage to target and gives a +900HP barrier and Defense +500 for 12s to 3 Fire units.	Deals 897 damage to 1 random enemies and Defense +30% and Taunt (95% provocation) to self.	
293	293	Defense +300 to Dark Units.	Deals 67 damage.	Deals 187 damage to target and Skill defense +45 for 10s to self.	Deals 371 damage to target, and gains Reflect (returns 11% of damage received) and Taunt (84% provocation) for 10s.	Gives Reflect (returns 21% of damage received) for 20s to ally with lowest HP and self.	
294	294	Gives Lifesteal (Absorbs 3% of the damage as HP) to grass units.	Deals 68 damage.	Deals 193 damage to target and absorb 100HP.	Deals 376 damage to target, Lifesteal (Absorbs 10% of the damage as HP) to 5 units, and 900 HP barrier for 12s to 2 grass units.	Deals 901 damage to target, Defense +30% and Taunt (95% provocation) for 15s to self.	
295	295	Gives Reflect (returns 3% of damage received) to Dark units (bonus +3% on Ragnas).	Deals 68 damage.	Deals 195 damage to target and Defense +500 for 12s to 2 allies with priority to Dark units.	Deals 379 damage to target, gives Reflect (returns 9% of damage received) and 900 HP barrier for 10s to 5 Dark units.	Deals 823 damage to 2 random enemies, and 1500 HP barrier for 16s to 3 units with lowest HP.	
296	296	Gives +50 HP Regeneration (Heal every 2s).	Deals 71 damage.	Deals 206 damage to target and 50% chance to remove enemy regeneration, Lifesteal, and healing buffs.	Deals 378 damage to 2 random enemies and 167HP Regeneration (Heal every 2s) for 14s to 2 allies with lowest HP.	Heals 1000HP for 3 allies with lowest HP, additional healing of 200HP if Dark unit.	
297	297	Debuff evasion +8% to all Dark allies.	Deals 71 damage.	Deals 206 damage to target, heals 735HP to an ally with the lowest HP.	Deals 379 damage to target, heals 886 to 2 allies with the lowest HP and grants +10% debuff evasion for 12s.	Deals 854 damage to 2 enemies, heals 1102 to 3 allies with the lowest HP and 60% chance of removing 1 debuff.	
298	298	Slide final damage +8% for water allies and (during Ragna, +40% critical damage to self).	Deals 113 damage.	Deals 491 damage to enemy. On Fire type targets, deal 500 Ignore Defense damage	Prioritizing fire types, deal 958 to 3 targets plus 800 Ignore Defense damage. On Fire type targets, deal 600 bonus damage.	Deals 2598 damage to 4 random enemies, Gives Berserk (Increase attack by +90% and becomes immune to damage, afterwards unit will be stunned for 5s) to self for 14s.	
299	299	+8% defense for all allies (additional +12% on WorldBoss)	Deal 100 auto attack damage.	Deal 382 damage and a 70% chance to cancel 2 debuffs ('Burn' and 'Scald').	Deal 660 damage and apply "Double-Edge Sword" (Increase attack by 50%, but decrease defense) to 5 water allies for 16 seconds. For WorldBoss Only, Slide Skill Damage +1250 for 16 seconds to 5 allies in the back row with the highest attack.	Deal 1733 damage to 2 enemies randomly and allies drive gauge +400. For WorldBoss Only, Attack power +30% for 20 seconds to all Water type allies.	
300	300	Water type allies Weak Point damage +15%  (For Ragna only, Weak Point damage additional +20%)	Deals 101 damage	Deals 395 damage to target, skill gauge +18% to 2 water type allies, excluding itself and 60% chance to apply "Purification" to 2 allies with the Bleeding status (convert Bleed to Regen).	Deals 719 damage to target, for 3 highest attack water type allies, Skill gauge charge Speed +40% and Weak point damage +25% for 2 turns. For Ragna only, Slide skill damage +50%	Deal 1860 damage to 3 random enemies, for 3 lowest remaining allies, Regen 285 HP(once per 2s) for 16s. For Ragna only, for the highest attacker water ally, Tap skill damage +80%	trap costume :mmmm:
301	301	Light allies heal and regeneration amount +15%. 	Deals  96 damage. 	Deals 337 damage to target, gives +15% debuff evasion to 2 allies with the lowest HP. 	Prioritizing 2 allies with the lowest HP, Regen 191 HP (once per 2 seconds) and gain debuff immunity (cleanse all current debuffs and negate 1 incoming debuff after for 14 seconds). 	Revives 1 dead ally to 1000HP and Heal 1791HP to 3 allies with the lowest HP. 	Her ability to cleanse all manner of debuffs can make event bosses with nasty debuff mechanics difficulty trivial. She also has a revive in her drive in case a child dies.
302	302	Skill Gauge Charge Amount +8% to Water type Allies.	Deals 100 damage.	Deals 381 damage to target and 52.5% chance to fully charge skill gauge to random ally (excluding self).	Deals 663 damage to target and Skill Gauge Charge Amount +40% for 2 turns and Slide Skill Cooldown -2 seconds to 2 allies with highest attack.\r\n	Deals 1789 damage to 3 random enemies and 80% chance to stun (target is unable to attack, Stun duration increases by 1 second when hit up to 5 additional seconds) for 12s and +400 drive gauge.	Kouga is the best support unit in the game and a must have. Her buffs can help attackers deal more damage or help your team survive by targeting a healer on the team - Healers have long cooldowns, so Kouga is great at decreasing it with her slide. Her tap is usually more RNG even at +6 uncap, and even at 83% she will not activate her tap passive skill if spammed. The tap skill will also only fully charge an ally's skill gauge if they are not on a counter cooldown, so use it wisely. On drive, +400 drive gauge is 13% of the drive gauge (excluding during WB). VA: Kana Hanazawa\r\n
303	303	Skill Gauge Charge Speed +12% to all allies (For PvP only, additional Skill Gauge Charge Speed +8% to Water allies)	Deals 101 damage	Deal 391 damage to target, prioritizing highest attack, Skill Gauge Charge Amount +30% for 20 seconds and gives debuff immunity (cleanse all current debuffs and negate 1 incoming debuff after for 10 seconds) to 1 ally	Deal 704 damage to target, prioritizing childs with the least skill gauge charge, increase Skill Gauge by +35% and Slide Skill Cooldown -2 seconds for 16 seconds. In PvP only, for 2 allies with the lowest HP grant Immortality (HP won't go under 1) for 10s	Deals 1826 damage to 3 random enemies, prioritizing highest attack, Skill gauge charge amount +60% for 2 turns to 3 allies & Drive Gauge +500 	Applies -2s CD before skill gauge charge. One of the top tier speed buffer for Ranking comps in Ragna
304	304	+8% Tap Skill damage for fire type allies (Additional +8% in Raid Boss). 	Deal 100 auto damage. 	Deal 384 damage to target. Prioritizing the ally with highest ATK, Tap Skill damage +800 for 20 seconds and a 70% chance to remove "Snow Bomb" debuff from 2 allies.	Deal 663 damage to target. Prioritizing the ally with least HP, grant Barrier (adsorbs +1800 HP before HP is affected) to 3 allies and Increase Attack +19% to 3 Fire Type allies with highest ATK for 16 seconds.  For Raid Boss Only, Increase Slide Skill +1280  for 16 seconds.	Deal 1739 damage to 2 enemies randomly. Prioritizing 5 ally with least HP, grant Barrier (adsorbs +2000 HP before HP is affected) for 20 seconds and Prioritizing 3 allies with least HP, Regen 254 HP (heals every 2s) for 18 seconds. 	
305	305	Fire type allies Tap skill damage +15% (For Ragna only)	Deals 114 damage	Deals 492 damage to target 3 times, deal 500 Ignore defence damage, and for Wood type targets, deal 350 Bonus damage. For Ragna only, 70% chance to apply "Overload" (all skills damages +30% except for Drives Skills and Skill Cooldown Increased + Skill Charge Speed decreased) to self for 14s	Deals 961 damage to 3 random enemies, apply “Fortitude Explosion” (Removes Fortitude if the target has 2 or less stacks of it, for 3 or more stacks of Fortitude, deal 200 damage per stack removed)	Deal 2607 damage to all enemies, for Attacker types, deal 700 Bonus damage Lead	
306	306	Fire type allies Drive skill damage +12%	Deals 113 damage	Deals 492 damage to target, apply Debuff evasion +20% to self for 14s	Prioritizing Debuffed enemy, deal 958 damage 3 times to target and 530 Ignore defense damage. For PvP only, inflict 75 damage per buff (up to 8 applications)	Deal 2600 damage to 4 random enemies, inflict 200 damage per buff (up to 8 applications)	
307	307	Wood type allies Drive Defense +15% (for PvP only, additional +20%)	Deals 93 damage	Deals 322 damage to target, for the highest wood type ally, grant Immortality (HP won't go under 1) for 10s	Deals 593 damage to target, for 3 lowest HP allies, 56% chance to grant Immortality (HP won't go under 1) for 14s and for 3 lowest HP Wood allies, Max HP +1600 for 14s	Deal 1511 damage to 2 random enemies, 95% chance to give Immortality (HP won't go under 1) to self for 16s. Taunt (98% provocation) for 16s. 70% chance to give Debuff Taunt (receive 1 debuff in place of grant in an Ally) to self	
308	308	Water type enemies -15 Debuff Evasion [For WB only, Weak Point Defense -15%]	Deals 102 damage	Deal 394 damage to target, Weak Point Defense -13% for 10s	Prioritizing Water type enemies, deal 675 damage to 2 targets. Debuff Evasion -15%, Debuff duration extended by 23% for 12s. For WB only, Weak Point Defense -1.5% for every Wood allies in the party, max times 10) for 12s	Deal 2031 damage to 3 random enemies. Weak Point Defense -30% and Debuff duration extended by 40% for 16s	
309	309	Skill Gauge Charge Speed +10% for Water type allies.	Deals 99 damage.	Deals 365 damage to target and Skill Gauge Charge Amount +25% for 1 random ally for 10 seconds.	Deals 550 damage and Skill Gauge Charge Speed -30% for 2 turns to 2 random enemies. Gives Skill Cooldown -1s to 3 random allies for 2 turns.	Deals 1705 damage to 2 random enemies. Skill Gauge +20% to all allies. Gives Skill Gauge Charge Speed +20% to all allies for 20 seconds.	Not as good as Kouga in some aspects, but her slide and drive are really useful in WorldBoss events.
310	310	Wood type allies Skill Gauge Charge Amount +15%(For Ragna only, Skill Gauge Charge Amount additional +10%)	Deals 101 auto damage.	Deals 393 damage to target, for 2 highest attack allies, skill gauge +17%. \r\nFor Ragna only, for one highest attack wood ally, 45% chance to Apply "Concentration" (100% Critical Rate and Hit Rate) for 20s	Deals 705 damage to target, for 3 highest attack wood allies, Slide Skill damage +25% and Skill Gauge Charge Amount +45% for 16s. \r\nFor Ragna only, prioritizing 3 allies with time speed debuffs, 70% chance to apply “Time distortion” (removes -gauge speed debuffs and increases skill gauge speed +40%)	Deal 1830 damage to 3 random enemies, for 3 allies with the lowest HP, heal 2029 HP and Drive gauge +150 for every Wood type ally (up to 5).	:sitriLick:
311	311	Fire type allies Slide Skill Damage +12%(For WB only, Slide Skill Damage additional +12%)	Deals 113 damage	Deals 492 damage to target, for WB only, grant Skill Damage +25% to self for 14s	Deals 959 damage 2 times and 400 Ignore Defense damage to 2 random enemies. If the target is Wood type, deal 350 Bonus damage. For WB only, apply “protection buff explosion” (removes 1 protection type buff and deal 700x "type of buff" as damage).	Deal 2601 damage to all enemies, for WB only, apply “protection buff explosion” (removes 1 protection type buff and deal 1200 x "type of buff" as damage).	Same type of buff explosion as "Ophois"
312	312	Dark type allies critical rate +20% (For WB only, critical damage +40%)	Deals 259 damage	Deals 1275 damage to target, 72.7% chance to apply "Awaken"(+30% Critical Damage and Slide Skill damage [increased by the number of buffs]) for 2 attacker type allies for 15s and for 2 allies with the most HP, there is a 72.7% chance to apply immunity to stun for 8s	Deals 1787 damage to 2 random enemies, for 3 attacker type allies, critical rate +50.9% and critical damage +52.6% for 2 turns. For WB only, Slide skill damage +55.3% to 5 dark attacker type allies	Deal 4492 damage to 3 random enemies, for 5 attacker type allies, tap skill damage +80% for 20s. For WB only, grant Attack stance (only these 5 childs will attack during fever) to 5 dark type attacker allies	
313	313	All enemies debuff evasion -12%	Deals 102 damage	Deals 394 damage to target, target’s debuff evasion -15% for 10 seconds. 	Prioritizing 2 lowest HP targets, deal 674 damage, apply “damage resonance” (Causes damage to two other childs (priority: lowest HP) equal to 20% of the damage received by the childs afflicted by this debuff) for 12 seconds and 70% chance of remove one buff from target. 	Deal 2029 damage to 3 enemies, apply “damage resonance” (Causes damage to two other childs (priority: lowest HP) equal to 35% of the damage received by the childs afflicted by this debuff) for 16 seconds. 	Good lead for any WB and slide remove a buff.
314	314	Attack type allies slide skill cooldown reduced by 1 second	Deals 113 damage	Deals 492 damage to target, 65% chance to grant Cheer (15% weakness skill damage and increase attack based on the current number of buffs) to self for 15s	Deals 958 damage to 2 enemies with the lowest HP, deals 1300 ignore DEF damage. For WB only, deal “Hope passage” (deal maximum 5000 Bonus damage in proportion to the number of light type allies, up to 10)	Deal 2600 damage to all enemies	
\.


--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: lucin
--

COPY public.units (id, name, created_on, enabled) FROM stdin;
1	maiden detective	2018-11-28	t
2	rednose	2018-11-28	t
3	titania	2018-11-28	t
4	ishtar	2018-11-28	t
5	frigga	2018-11-28	t
6	pomona	2018-11-28	t
7	merlin	2018-11-28	t
8	fortuna	2018-11-28	t
9	isis	2018-11-28	t
10	muse	2018-11-28	t
11	flora	2018-11-28	t
12	selene	2018-11-28	t
13	hatsune miku	2018-11-28	t
14	hat-trick	2018-11-28	t
15	guillotine	2018-11-28	t
16	ankh	2018-11-28	t
17	daphne	2018-11-28	t
18	lisa	2018-11-28	t
19	mona	2018-11-28	t
20	davi	2018-11-28	t
21	victrix	2018-12-25	t
22	amor	2018-11-28	t
23	elysium	2018-11-28	t
24	nirrti	2018-11-28	t
25	freesia	2018-11-28	t
26	tiamat	2018-11-28	t
27	lan fei	2018-11-28	t
28	cube moa	2018-11-28	t
29	rudolph	2018-11-28	t
30	princess miku	2019-01-31	t
31	creature	2019-02-13	t
32	frey	2018-11-28	t
33	elizabeth	2018-11-28	t
34	dark maat	2018-11-28	t
35	frey (light)	2018-11-28	t
36	hildr	2018-11-28	t
37	love sitri	2018-11-28	t
38	botan	2019-05-24	t
39	ruin	2018-11-28	t
40	krampus	2018-11-28	t
41	serval	2019-04-13	t
42	guardian kouga	2018-11-28	t
43	ohad	2018-11-28	t
44	ai	2018-11-28	t
45	redcross	2018-11-28	t
46	hera	2018-11-28	t
47	mammon	2018-11-28	t
48	marie rose	2018-11-28	t
49	athena	2018-11-28	t
50	diablo	2018-11-28	t
51	aurora king	2019-04-30	t
52	maris	2018-11-28	t
53	eshu	2018-11-28	t
54	metis	2018-11-28	t
55	dark midas	2018-11-28	t
56	syrinx	2018-11-28	t
57	astraea	2018-11-28	t
58	warwolf	2018-11-28	t
59	fennec	2019-04-13	t
60	maat	2018-11-28	t
61	epona	2018-11-28	t
62	venus	2018-12-05	t
63	rusalka	2018-11-28	t
64	tethys	2018-11-28	t
65	raccoon	2019-04-13	t
66	newbie mona	2018-11-28	t
67	pantheon	2018-11-28	t
68	aria	2018-11-28	t
69	maruru	2019-06-12	t
70	bes	2019-02-07	t
71	ashtoreth	2018-11-28	t
72	neptune	2018-12-05	t
73	anemone	2018-11-28	t
74	abaddon	2018-11-28	t
75	horus	2018-11-28	t
76	durandal	2018-11-28	t
77	bastet	2018-11-28	t
78	khepri	2018-11-28	t
79	santa	2018-11-28	t
80	isolde	2018-11-28	t
81	snow miku	2018-11-28	t
82	charlotte	2018-11-28	t
83	calypso	2018-11-28	t
84	kasumi	2018-11-28	t
85	mafdet	2018-11-28	t
86	bari	2018-11-28	t
87	rita	2018-11-28	t
88	nevan (light)	2018-11-28	t
89	myrina	2018-11-28	t
90	pure bride hildr	2019-05-31	t
91	kagura warwolf	2019-01-03	t
92	midas	2018-11-28	t
93	luna	2018-11-28	t
94	cammy	2018-11-28	t
95	orga (wola)	2018-11-28	t
96	jupiter	2018-11-28	t
97	babel	2019-03-14	t
98	medusa	2018-11-28	t
99	siren	2018-11-28	t
100	demeter	2019-02-28	t
101	noise source	2019-04-21	t
102	light revenger	2019-04-21	t
103	morgana	2019-04-21	t
104	leuce	2019-04-21	t
105	teddy	2019-04-21	t
106	arms	2019-04-21	t
107	liyuga	2019-04-21	t
108	wangkuni	2019-04-21	t
109	berit	2019-04-21	t
110	genius	2019-04-21	t
111	jeonseoi	2019-04-21	t
112	idun	2019-04-21	t
113	medeia	2019-04-21	t
114	kratos	2019-04-21	t
115	gift bag	2019-04-21	t
116	purple revenger	2019-04-21	t
117	skuld	2019-04-21	t
118	valkyrie	2019-04-21	t
119	elias	2019-04-21	t
120	cynthia	2019-04-21	t
121	messenger	2019-04-21	t
122	dark watcher	2019-04-21	t
123	black daron	2019-04-21	t
124	pyro	2019-04-21	t
125	vesta	2019-04-21	t
126	rune	2019-04-21	t
127	sekhmet	2019-04-21	t
128	shamash	2019-04-21	t
129	red revenger	2019-04-21	t
130	treasure chest	2019-04-21	t
131	hypnos	2019-04-21	t
132	blaze watcher	2019-04-21	t
133	scarlet daron	2019-04-21	t
134	phoenix	2019-04-21	t
135	anger dragon	2019-04-21	t
136	tartarus	2019-04-21	t
137	judas	2019-04-21	t
138	demeters	2019-04-21	t
139	seshet	2019-04-21	t
140	goga	2019-04-21	t
141	atalanta	2019-04-21	t
142	jeanne d'arc	2019-04-21	t
143	vulcanus	2019-04-21	t
144	blue revenger	2019-04-21	t
145	mnemosyne	2019-04-21	t
146	hecate	2019-04-21	t
147	dj hertz	2019-04-21	t
148	frozen watcher	2019-04-21	t
149	aqua daron	2019-04-21	t
150	cruelty dragon	2019-04-21	t
151	baphomet	2019-04-21	t
152	water wyvern	2019-04-21	t
153	deino(3)	2019-04-21	t
154	manti	2019-04-21	t
155	freyja	2019-04-21	t
156	atropos	2019-04-21	t
157	green revenger	2019-04-21	t
158	prah	2019-04-21	t
159	wool	2019-04-21	t
160	diana	2019-04-21	t
161	sylvan watcher	2019-04-21	t
162	leaf daron	2019-04-21	t
163	bellboy	2019-04-21	t
164	basilisk	2019-04-21	t
165	eris	2019-04-21	t
166	poison ampule	2019-04-21	t
167	apollon	2019-04-21	t
168	alecto	2019-04-21	t
169	baal	2019-04-21	t
170	bazooka	2019-04-21	t
171	fighter	2019-04-21	t
172	cheoyong	2019-04-21	t
173	nymph	2019-04-21	t
174	photic watcher	2019-04-21	t
175	salmacis	2019-04-21	t
176	chain killer	2019-04-21	t
177	chaser	2019-04-21	t
178	blood wyvern	2019-04-21	t
179	boxer	2019-04-21	t
180	jana	2019-04-21	t
181	light daron	2019-04-21	t
182	jiseihi	2018-11-28	t
183	willow	2018-11-28	t
184	cleopatra	2018-11-28	t
185	makoto	2019-07-10	t
186	noel	2019-07-10	t
187	agamemnon	2018-11-28	t
188	aurora	2018-11-28	t
189	erato	2018-11-28	t
190	morgan	2018-11-28	t
191	dana	2018-11-28	t
192	sitri	2018-11-28	t
193	dinashi	2018-11-28	t
194	ganesh	2019-03-29	t
195	hades	2018-11-28	t
196	hermes	2018-11-28	t
197	hestia	2018-11-28	t
198	honoka	2018-11-28	t
199	kouka	2018-11-28	t
200	ailill	2018-11-28	t
201	kubaba	2019-04-30	t
202	maou davi	2018-11-28	t
203	medb	2018-11-28	t
204	oiran bathory	2019-01-03	t
205	party star medb	2018-11-28	t
206	prophet dana	2019-03-14	t
207	tirfing	2018-11-28	t
208	verdel	2018-11-28	t
209	bathory	2018-12-05	t
210	nine	2019-07-10	t
211	buster lisa	2018-11-28	t
212	chun-li	2018-11-28	t
213	daphnis	2019-03-29	t
214	nicole	2018-12-25	t
215	bikini lisa	2018-11-28	t
216	kei'no	2019-08-15	t
217	billy	2019-07-30	t
218	tamamo	2019-08-29	t
219	sole sword tiamat	2019-09-16	t
220	pallas	2018-11-28	t
221	justice mafdet	2019-08-29	t
222	scuba mona	2018-11-28	t
223	brigette	2018-11-28	t
224	katherine	2019-09-30	t
225	rin	2019-09-30	t
226	catherine	2019-09-30	t
227	laima	2019-10-17	t
228	alter davi	2019-10-31	t
229	light mona	2019-10-31	t
230	ophois	2019-11-14	t
231	ziva	2019-11-28	t
232	giltine	2019-11-28	t
233	snow eshu	2019-12-12	t
234	flince	2019-12-12	t
235	failnaught	2019-12-31	t
236	piercing ruin	2019-12-31	t
237	two-sided moa	2019-01-03	t
238	typhon	2019-10-17	t
239	pakhet	2020-01-15	t
240	euros	2019-04-21	t
241	brownie	2018-11-28	t
242	heqet	2020-01-30	t
243	serket	2020-02-13	t
244	eve	2018-11-28	t
245	salome	2019-06-26	t
246	thanatos	2018-11-28	t
247	pan	2019-01-28	t
248	banshee	2019-02-26	t
249	pretty mars	2018-12-05	t
250	student eve	2018-12-05	t
251	saturn	2018-12-05	t
252	annie	2019-07-30	t
253	methuselah	2020-02-27	t
254	hel	2020-02-27	t
255	cute euros	2020-03-14	t
256	pietas	2020-03-17	t
257	angel lot	2020-03-17	t
258	gomorrah	2020-03-17	t
259	gungnir	2020-03-17	t
260	hydra	2020-03-17	t
261	leda	2018-11-28	t
262	maya	2018-11-28	t
263	arges	2018-11-28	t
264	yaga	2018-11-28	t
265	persephone	2018-11-28	t
266	kirinus	2018-11-28	t
267	thoth	2018-11-28	t
268	bast	2018-11-28	t
269	melpomene	2018-11-28	t
270	neman	2018-11-28	t
271	sonnet	2018-11-28	t
272	korra	2018-11-28	t
273	yuna	2018-11-28	t
274	artemis	2018-11-28	t
275	calchas	2018-11-28	t
276	morrigu	2018-11-28	t
277	tristan	2018-12-05	t
278	fenrir	2018-11-28	t
279	hector	2018-11-28	t
280	inanna	2018-11-28	t
281	orora	2018-11-28	t
282	tisiphone	2018-11-28	t
283	ambrosia	2018-11-28	t
284	danu	2018-11-28	t
285	neid	2018-12-25	t
286	halloween	2018-11-28	t
287	heracles	2018-11-28	t
288	el dorado	2018-11-28	t
289	fairy	2018-11-28	t
290	lady	2018-11-28	t
291	bakje	2018-11-28	t
292	chimaera	2018-11-28	t
293	aten	2018-11-28	t
294	europa	2018-11-28	t
295	cybele	2018-11-28	t
296	zelos	2018-11-28	t
297	unknown	2019-04-30	t
298	deino	2019-02-28	t
299	bikini davi	2018-11-28	t
300	leo	2020-03-26	t
301	pure bride pomona	2019-05-31	t
302	kouga	2018-11-28	t
303	tisbe	2019-09-11	t
304	christmas leda	2018-12-25	t
305	fire davi	2019-12-31	t
306	cain	2020-03-27	t
307	raffles	2020-04-11	t
308	navi	2019-06-26	t
309	naiad	2018-11-28	t
310	fancy sitri	2020-02-13	t
311	sweet leda	2020-01-30	t
312	lupin	2020-04-24	t
313	iphis	2019-05-31	t
314	deborah	2020-04-24	t
\.


--
-- Name: mainstats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lucin
--

SELECT pg_catalog.setval('public.mainstats_id_seq', 314, true);


--
-- Name: profilepics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lucin
--

SELECT pg_catalog.setval('public.profilepics_id_seq', 314, true);


--
-- Name: scstats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lucin
--

SELECT pg_catalog.setval('public.scstats_id_seq', 103, true);


--
-- Name: soulcards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lucin
--

SELECT pg_catalog.setval('public.soulcards_id_seq', 103, true);


--
-- Name: substats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lucin
--

SELECT pg_catalog.setval('public.substats_id_seq', 314, true);


--
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lucin
--

SELECT pg_catalog.setval('public.units_id_seq', 314, true);


--
-- Name: mainstats mainstats_pkey; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.mainstats
    ADD CONSTRAINT mainstats_pkey PRIMARY KEY (id);


--
-- Name: profilepics profilepics_pkey; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.profilepics
    ADD CONSTRAINT profilepics_pkey PRIMARY KEY (id);


--
-- Name: scstats scstats_pkey; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.scstats
    ADD CONSTRAINT scstats_pkey PRIMARY KEY (id);


--
-- Name: soulcards soulcards_pkey; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.soulcards
    ADD CONSTRAINT soulcards_pkey PRIMARY KEY (id);


--
-- Name: substats substats_pkey; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.substats
    ADD CONSTRAINT substats_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: mainstats mainstats_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.mainstats
    ADD CONSTRAINT mainstats_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- Name: profilepics profilepics_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.profilepics
    ADD CONSTRAINT profilepics_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- Name: scstats scstats_sc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.scstats
    ADD CONSTRAINT scstats_sc_id_fkey FOREIGN KEY (sc_id) REFERENCES public.soulcards(id);


--
-- Name: substats substats_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: lucin
--

ALTER TABLE ONLY public.substats
    ADD CONSTRAINT substats_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- PostgreSQL database dump complete
--

