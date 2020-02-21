PGDMP                          x            jpdestinydb     11.2 (Ubuntu 11.2-1.pgdg18.04+1)     11.2 (Ubuntu 11.2-1.pgdg18.04+1) 6    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    17010    jpdestinydb    DATABASE     }   CREATE DATABASE jpdestinydb WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE jpdestinydb;
             lucin    false            ^           1247    17193 
   class_type    TYPE     r   CREATE TYPE public.class_type AS ENUM (
    'attacker',
    'healer',
    'debuffer',
    'buffer',
    'tank'
);
    DROP TYPE public.class_type;
       public       lucin    false            [           1247    17180    element_type    TYPE     k   CREATE TYPE public.element_type AS ENUM (
    'water',
    'fire',
    'earth',
    'light',
    'dark'
);
    DROP TYPE public.element_type;
       public       lucin    false            X           1247    17038 	   starcount    TYPE     D   CREATE TYPE public.starcount AS ENUM (
    '3',
    '4',
    '5'
);
    DROP TYPE public.starcount;
       public       lucin    false            �            1259    17425 	   mainstats    TABLE     S  CREATE TABLE public.mainstats (
    id integer NOT NULL,
    unit_id integer,
    stars public.starcount DEFAULT '5'::public.starcount NOT NULL,
    type public.class_type DEFAULT 'attacker'::public.class_type NOT NULL,
    element public.element_type DEFAULT 'fire'::public.element_type NOT NULL,
    tier text DEFAULT '0 0 0 0'::text
);
    DROP TABLE public.mainstats;
       public         lucin    false    600    606    603    600    603    606            �            1259    17423    mainstats_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mainstats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.mainstats_id_seq;
       public       lucin    false    203            �           0    0    mainstats_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.mainstats_id_seq OWNED BY public.mainstats.id;
            public       lucin    false    202            �            1259    17405    profilepics    TABLE     �   CREATE TABLE public.profilepics (
    id integer NOT NULL,
    unit_id integer,
    pic1 text DEFAULT 'emptyunit0.png'::text,
    pic2 text DEFAULT ''::text,
    pic3 text DEFAULT ''::text,
    pic4 text DEFAULT ''::text
);
    DROP TABLE public.profilepics;
       public         lucin    false            �            1259    17403    profilepics_id_seq    SEQUENCE     �   CREATE SEQUENCE public.profilepics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.profilepics_id_seq;
       public       lucin    false    201            �           0    0    profilepics_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.profilepics_id_seq OWNED BY public.profilepics.id;
            public       lucin    false    200            �            1259    17529    scstats    TABLE     �  CREATE TABLE public.scstats (
    id integer NOT NULL,
    sc_id integer,
    pic1 text DEFAULT 'blankcard.jpg'::text,
    stars public.starcount DEFAULT '5'::public.starcount,
    normalstat1 text DEFAULT 'NA 0 0 0'::text NOT NULL,
    normalstat2 text DEFAULT 'NA 0 0 0'::text NOT NULL,
    prismstat1 text,
    prismstat2 text,
    restriction text DEFAULT 'none.'::text NOT NULL,
    ability text DEFAULT 'none.'::text NOT NULL
);
    DROP TABLE public.scstats;
       public         lucin    false    600    600            �            1259    17527    scstats_id_seq    SEQUENCE     �   CREATE SEQUENCE public.scstats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.scstats_id_seq;
       public       lucin    false    207            �           0    0    scstats_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.scstats_id_seq OWNED BY public.scstats.id;
            public       lucin    false    206            �            1259    17471 	   soulcards    TABLE     �   CREATE TABLE public.soulcards (
    id integer NOT NULL,
    name text DEFAULT 'TBA'::text,
    created_on date DEFAULT CURRENT_DATE,
    enabled boolean DEFAULT true NOT NULL
);
    DROP TABLE public.soulcards;
       public         lucin    false            �            1259    17469    soulcards_id_seq    SEQUENCE     �   CREATE SEQUENCE public.soulcards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.soulcards_id_seq;
       public       lucin    false    205            �           0    0    soulcards_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.soulcards_id_seq OWNED BY public.soulcards.id;
            public       lucin    false    204            �            1259    17363    substats    TABLE     I  CREATE TABLE public.substats (
    id integer NOT NULL,
    unit_id integer,
    leader text DEFAULT '_missing_'::text,
    auto text DEFAULT '_missing_'::text,
    tap text DEFAULT '_missing_'::text,
    slide text DEFAULT '_missing_'::text,
    drive text DEFAULT '_missing_'::text,
    notes text DEFAULT '_missing_'::text
);
    DROP TABLE public.substats;
       public         lucin    false            �            1259    17361    substats_id_seq    SEQUENCE     �   CREATE SEQUENCE public.substats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.substats_id_seq;
       public       lucin    false    199            �           0    0    substats_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.substats_id_seq OWNED BY public.substats.id;
            public       lucin    false    198            �            1259    17338    units    TABLE     �   CREATE TABLE public.units (
    id integer NOT NULL,
    name character varying(60) DEFAULT 'tba'::character varying NOT NULL,
    created_on date DEFAULT CURRENT_DATE,
    enabled boolean DEFAULT true NOT NULL
);
    DROP TABLE public.units;
       public         lucin    false            �            1259    17336    units_id_seq    SEQUENCE     �   CREATE SEQUENCE public.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.units_id_seq;
       public       lucin    false    197            �           0    0    units_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;
            public       lucin    false    196            -           2604    17428    mainstats id    DEFAULT     l   ALTER TABLE ONLY public.mainstats ALTER COLUMN id SET DEFAULT nextval('public.mainstats_id_seq'::regclass);
 ;   ALTER TABLE public.mainstats ALTER COLUMN id DROP DEFAULT;
       public       lucin    false    203    202    203            (           2604    17408    profilepics id    DEFAULT     p   ALTER TABLE ONLY public.profilepics ALTER COLUMN id SET DEFAULT nextval('public.profilepics_id_seq'::regclass);
 =   ALTER TABLE public.profilepics ALTER COLUMN id DROP DEFAULT;
       public       lucin    false    201    200    201            6           2604    17532 
   scstats id    DEFAULT     h   ALTER TABLE ONLY public.scstats ALTER COLUMN id SET DEFAULT nextval('public.scstats_id_seq'::regclass);
 9   ALTER TABLE public.scstats ALTER COLUMN id DROP DEFAULT;
       public       lucin    false    207    206    207            2           2604    17474    soulcards id    DEFAULT     l   ALTER TABLE ONLY public.soulcards ALTER COLUMN id SET DEFAULT nextval('public.soulcards_id_seq'::regclass);
 ;   ALTER TABLE public.soulcards ALTER COLUMN id DROP DEFAULT;
       public       lucin    false    204    205    205            !           2604    17366    substats id    DEFAULT     j   ALTER TABLE ONLY public.substats ALTER COLUMN id SET DEFAULT nextval('public.substats_id_seq'::regclass);
 :   ALTER TABLE public.substats ALTER COLUMN id DROP DEFAULT;
       public       lucin    false    198    199    199                       2604    17341    units id    DEFAULT     d   ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);
 7   ALTER TABLE public.units ALTER COLUMN id DROP DEFAULT;
       public       lucin    false    197    196    197            �          0    17425 	   mainstats 
   TABLE DATA               L   COPY public.mainstats (id, unit_id, stars, type, element, tier) FROM stdin;
    public       lucin    false    203   &<       �          0    17405    profilepics 
   TABLE DATA               J   COPY public.profilepics (id, unit_id, pic1, pic2, pic3, pic4) FROM stdin;
    public       lucin    false    201   �E       �          0    17529    scstats 
   TABLE DATA               �   COPY public.scstats (id, sc_id, pic1, stars, normalstat1, normalstat2, prismstat1, prismstat2, restriction, ability) FROM stdin;
    public       lucin    false    207   fS       �          0    17471 	   soulcards 
   TABLE DATA               B   COPY public.soulcards (id, name, created_on, enabled) FROM stdin;
    public       lucin    false    205   :f       �          0    17363    substats 
   TABLE DATA               W   COPY public.substats (id, unit_id, leader, auto, tap, slide, drive, notes) FROM stdin;
    public       lucin    false    199   tj       �          0    17338    units 
   TABLE DATA               >   COPY public.units (id, name, created_on, enabled) FROM stdin;
    public       lucin    false    197   R�       �           0    0    mainstats_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.mainstats_id_seq', 299, true);
            public       lucin    false    202            �           0    0    profilepics_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.profilepics_id_seq', 299, true);
            public       lucin    false    200            �           0    0    scstats_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.scstats_id_seq', 98, true);
            public       lucin    false    206            �           0    0    soulcards_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.soulcards_id_seq', 98, true);
            public       lucin    false    204            �           0    0    substats_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.substats_id_seq', 299, true);
            public       lucin    false    198            �           0    0    units_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.units_id_seq', 298, true);
            public       lucin    false    196            F           2606    17437    mainstats mainstats_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.mainstats
    ADD CONSTRAINT mainstats_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.mainstats DROP CONSTRAINT mainstats_pkey;
       public         lucin    false    203            D           2606    17417    profilepics profilepics_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.profilepics
    ADD CONSTRAINT profilepics_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.profilepics DROP CONSTRAINT profilepics_pkey;
       public         lucin    false    201            J           2606    17543    scstats scstats_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.scstats
    ADD CONSTRAINT scstats_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.scstats DROP CONSTRAINT scstats_pkey;
       public         lucin    false    207            H           2606    17482    soulcards soulcards_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.soulcards
    ADD CONSTRAINT soulcards_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.soulcards DROP CONSTRAINT soulcards_pkey;
       public         lucin    false    205            B           2606    17377    substats substats_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.substats
    ADD CONSTRAINT substats_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.substats DROP CONSTRAINT substats_pkey;
       public         lucin    false    199            >           2606    17457    units uniq_name 
   CONSTRAINT     J   ALTER TABLE ONLY public.units
    ADD CONSTRAINT uniq_name UNIQUE (name);
 9   ALTER TABLE ONLY public.units DROP CONSTRAINT uniq_name;
       public         lucin    false    197            @           2606    17346    units units_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.units DROP CONSTRAINT units_pkey;
       public         lucin    false    197            M           2606    17438     mainstats mainstats_unit_id_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.mainstats
    ADD CONSTRAINT mainstats_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);
 J   ALTER TABLE ONLY public.mainstats DROP CONSTRAINT mainstats_unit_id_fkey;
       public       lucin    false    197    203    2880            L           2606    17418 $   profilepics profilepics_unit_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.profilepics
    ADD CONSTRAINT profilepics_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);
 N   ALTER TABLE ONLY public.profilepics DROP CONSTRAINT profilepics_unit_id_fkey;
       public       lucin    false    201    2880    197            N           2606    17544    scstats scstats_sc_id_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.scstats
    ADD CONSTRAINT scstats_sc_id_fkey FOREIGN KEY (sc_id) REFERENCES public.soulcards(id);
 D   ALTER TABLE ONLY public.scstats DROP CONSTRAINT scstats_sc_id_fkey;
       public       lucin    false    2888    205    207            K           2606    17378    substats substats_unit_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.substats
    ADD CONSTRAINT substats_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);
 H   ALTER TABLE ONLY public.substats DROP CONSTRAINT substats_unit_id_fkey;
       public       lucin    false    197    2880    199            �   f	  x�}ZI�$7<3_Q/0Dj��_�v��ÇA���RnZ�Љ���B\�ʒRHJ�H__����I����I�J��ʛ�P�����������͓_�6V�@���0�o�~������w����%J�3*)�?>��h#Ӗ)����G�θ*=p�Ŏ�����w�:�ۘ	� ��(�3|��T�2��	m�эq�o��`�U^e�H��VĿ��Ɖ8uHz��T%�k��ـe�|_K=�PGb-��,Q�m�H܄w��&L��1V,��8�k���I|���	$/�}|�����$�ܼ�bl"I3��%��s���$?����5\C��w3�;E���}K�XZܼ��1��y��IT#>�׆�1�ظH�⫣�z�4�^�lټ���n�b=T���~E�o�B��6��qS0�@��@�,#!��އN��5߉+#iZ�Ze�ܼgO���� :��ec{1(1�W6��#<���P��[d�㧰3<mQ(.�r�>[���
��@1����=�-�s��-��(�^,}mQ)���me�gE��R3�o��B-��N��X_�%�kD[�&&<q�S� $!<��v�vL�S�C";�Q <qu��5R�C�=���缒����#�R�2�|�����B�,Vk�:�3�P��+���W��G�T&��������cPi�P���Hz�HƓ&�Gw��g%_Wp���I;�:^^���fֺa�G٭�j��r��*��,�e7gΞ�_ÖTr�Vp]ܖ#ec�^���o9QNk��JY�ڊO�4�3*�K5n!�w@G��uTa*<B�E�H�}��S��"�AH,%P	=j[�T��Qݨ͖���=���6W=�֒���l��6��R栏5o�3��.x/M��d��=�t�����̏� �����ama6����x]'�xta4h>	�� ݍʻ��CF�t��� Z�`-�?�S�:HI�ǵ���U�]�l��ۇ:���.��%�e76��2�W��&�����m4��0N^��qꦾy�Uu�������dߔ8�k� 6-�]+v/x��Mu���5��f����`���W��)@��јƏ�e�s����t�s3�tO��nF�j�
`(�bp���nFq���{��g���kg��S�`� z7��t(v3Z���iޚ?)ղa�A���>�{�
}X�isD�w��=w?��7����UCƛբ��Zbތ�M4���L��z�*4�M�`�T{Y({3��Ђ}o6_�͕�u�~:��+��7������7��a��p��gV��7�y#�5��%�����ߢ���ja�V���;�6�:j�]���Ȩ�G�S���y�:l���81�?I�[^L���$k���mͶ�U�v�����2vͩ�@x��Fs�����e������$��;�G���8��Ip{�{x���|���؅I8%�.�}�c��HH���h�&A��-!z``,��P���Y�����e�͊o�⊱��	�L���[*4�f3'�vu"�.t�4��&�F�lVx�󃶘��k8x����P0G_k�`n��f1F���G�l���ڴ�MI�<����N�pD�if��R�A�)i��R���dWb����O3Z��J ZPI:��>Ԍ&��Y����M�_lS�u�o�.�ݨh���)��E�E{FBK*}�zR�8(�[�����R�%�G�k�4M.:SQ6�{ �RYu����R{ׅT2��[�8����hM��^/��]�����T�x�G!@c*�y7�le�-߄���E�*���Z��X]ځ���Ǎ���ףc�\���X<�V3�/���U�Vݫ�9�ՌRqW����X��������5|���	�����P���C�(��U�6F��z�h �Vo#`��z%� C���w��!Ԣ�kGx��`� B�����	C���nv�,�g��l�qV�#�p0��ʒ���Z��p���>�7�})]':�`/�#
�RO���5��=`�K�K�_*op���4�����7�}bK���1�788�|1ڣ��f�o����ZvX�����,���S9<``)�+��t�p�2N����R�o�����*�(+|?�� �yg �g K��\0H,gZApX���>��)7�A�;�R�@E�Sa�Dׅ�~�w�,:yg����;�E�e�� ��ŋ�Fut���p�CR���d�^�@��@����3�'|��d���g\�-H�D+��t�O��g�� ��3n��.:��,���������g"O%_����;�Hx��~= gD{_���	���3 k�����rs�>�~�e۶���z      �   �  x��[��(�ͼ����.�Kآ���P�z���v�U�]ڈލ���ER���I���wb����՟�f����m�6�*D�:������R����`�`���4L�JTk�hfε��l��rcnD���yL:2��hW��D�;�M���{��|�/?�k��g}��Ϻl&:�9_%$��z��~!	rS���9�B�&��:�a!+!	p:vȵ���v4���� �۸�a![!	r'��0���E�O��U�r���J
Ep;��v��P8���YE`3n���]
Ep�i���� v����[]UUӭ|��b�����,�o+TK7�l�X�:�pz:�0���8��@w�YW)
��6�J���	����%�+�[���6cO��PT�X�u�o&{��rQ����ͧ�6gш� 7h�vڊ�FJ�����/�{'
��s�˰A�<��@w^,��e����$�i9O%J��Q_>�NQңnĿ�v�Î x�6r[��DI�^Cb�[��`�c��qۈ�	��ȯX+ʖv|f����]��̭Au�
[�s�URT+`Š?-�DE ��=x��\���T��Y�����=*�$�9xo�[���e�m���97�"p93��Պj���\����c�YDM�JVO��Z-E�"�?n��
�~>O��pۮ5A/.CpWngԥ�W �8�z3�;a��D����_\���[��2�9�A�nD����}2�W��6m{kEM6�d�E�0�;Q��htZ"��D�~�~�y��=B��J��q��J��o}4l�k
Ѭ�:^&��)EC�7)�&7k�ڙ�T�Yـ<��[v�j��O�v�<���ec��h��E���
��ت��݉fE��|2��m{�{\�E+E�|�z�.���12R�]q�M�����ƴ.D���|	����hW����ڇQ�`C~�|����-[�v%n�=rO��l�<�jaF�hKF?��>҉�#�њ��-���{���D��E�Ѱy'E�f����������]�����3�Bt��؋y)��f�3��D�b?��wY��~Qv`���݊�|��ĥ,]+�p=���؝�H�X+��N����.Y�X����+��s'?F�)���h����m\{%$A�O���e!r���!�P���8p.R���ΐT*��z��އ���i��<�"�[C�݅i#r�?�	G�����k��!l΂#7�N�^	��:Z�+IeƬ̻j���&�-a� �TfKR.�%��T����u4��	f�Y�"ꗞ��#!y1s��Du�B����5-�8�5/"��k2k^D �>�	�?Fn���ͼ����,��L�0�*Ѐ(gc��P� QΆ%j?hN2�*+�+��f�6f�
� ��e4W6��
l ��:�x(`N$5;7l�۸�{"�͸u�\R��Dj��1Rb�� 6�z�nיS��Dp��y�6���&�؊w��,�	EӐӰ�nc֧ O
z'�a+�"�EˣVd�[����^�.P��uS>����	"��d/ϗ8@$��"G�yΗ5v��Q�.��M�tZ�i>	o/I��@D<��ղ�D�둗rW?YQ�ޅ�����c�Z��3{~�}J M�#���Ƿ�k��9�fXXqK�@�H|�s`�>���F�u�2J�NT��F�5��D����
����D
���fK�M�|��"���"f��lP�(�S�׬7XA�Ag��� �&37�hyP�if]�{VI�xÑ�:^"~i��׬;�%*�� ������g���H���l���k�H�B;,�u~D)�>1�]���O"��:?"��)5ˣ�O�ՙ}��@���eq��&W ?���`�WH"g5?O IT���zg	�$Q'3Ϙ���(����8'�q��R����K����z��u�D��4sbg� Q��EdѬ+�$��l.#��,��7�zBz�z�f��!��Ӫ�D�C�C��|�T��7ޮ��- �z�ӿ͗N{�����|s��Ѥ]T[�J��a�a�,��t���y��K$��#~��b"�},��Z L���C�w�D��7��is5	���-@%��N�����V��}��D=� �1�sq���
v �rG���;`J4�)_-��; Jd���:����(q�؛~��@��q�~�/�� +����K��i���q�O�.׋�5�	yT�רL�n�&r�����q8[=[�A	E�����%�PE���p��SJ��X�SW6:�C%������3u��"��5i.�C#Qþ�èC+��˧���	ET���p)ܧ�������W�z)���ȱj�;.!U`�'��:;_Xw�I�/�,>h�늤>��n㸽�$ %▾�v&
8���].�b�(Ѵ�Z��J Jī���TR"_��M�3�r���an��l��"��MW���]Oi�j��.�X��M��͕]D��Gm��:�� J��\���<�LͰ�r�ѩ�៝��)Ѩ>v�h��"����d�T��w�%*��v�$U X�9�0�3�d���_�[<�Ң�\��b�;������Y1� ��ʕ�;\�^З�KH����2�@�*�zJ����wDU�%��L��d&�*̪ U�|ue�.T��J/k�򳍙g	�В��.s�*�Z�f�u_��u�:Xg��W��+MpQ�)Re���|�i	2�j��@� ��T���/m��c�h�
�F��~H�j���5���}
��
�azi�mc�W@�HX��ƾQ�
��j>\���6���~cT 	��.aaU��k��h��[�[�$D�,G}܌�n�(��0��"=U�<}I��+XB�`��GD���K�
\�hT��6�"�~������;D&��pZ�����Q�?D;��2 7�5�"
Z�œ�g�� ⁯�����J�d-7Fn6 ��<_h�j���i�%?e��.�A.�H�[�ciT�5-���~[M�c�����>��N�q�A���vn__abZ7�E���Xf_�\?`Q�.�F�ټ�$_M��M>����%H6��&�?P�(|IOz��n�olL�� ﵨ_�����-�Ik�s��j@L"�)Sxɕ~��'��:Y�GP}-1y��^�Z�&�=㣆98��Wܜ�m��ü}��1����������2E%�g����|4[�`��&f$�lKK�<�r��#�%���?/�k/` �*��?�{�6q��="]j��e{Wx��^@J"j~�^��0s���D���n���&��4�_��m?7c��ba:��f���#����*�Z�w܁�D]��k����,^���re�sw��%
�	y��K.=�t����	�&�l~��f�:�H�Wkb�$�ܗm��6}��fx��i��6��_l��`"�g��2n�C�6n	@;"�濡�QH��37�.������I�����L��������ׯ�Յ��      �      x��[]s�8�}�~k�\k�g$��茝Mjws]Ivs���H�$�)RKR�h�=�O�������$�Dj�F���a{���V�o����T��yV2ɖ?��e����r\a[N��Ln�4�NV |�S���lw��X�ʺ���3�?|/�$SI����?Z±���8��]�\<��|/�S�J����3�ֵ�k��7˅�'hOʟ�"o�|WUr�d����?�W��).�3��Z�ٺP_�K2�Z�"��5��:Y��m/�$�|J�1����C�~����(��/V��*yVq3�X.���x�2Vn;��;�y~��>�Ͻ��������g���m���\��(��Rv!�6��0�;�b�k
����9�l��C���T}����V�h����Ve^���̺W�Ij}:�W�Z.B!�~>��bv���B�o�o�"��i�?�Z��1.�<���0�X�8��++�X��X�%��=�/������}N��r���t_�:ї-2Sٳ����W��z7��
�c�ߍ�F��s&!ߦI[�T��U��W�uu8s�ȳ{=��i��\Ø5�h�6�Kz\=h����qg���2���}[,��H�9*� �Jm1׬v�p�q=�j^dD1
��r��EfOK�,Jg��@�96T�^��X�s�yf+tk�9IU�Vݢ� R����3k�3ǟ����3��˹xz!6�0ǀ�R����3D1@��.dY.��C��.��X���SŁ*��������e1]�f��9��{��pF&�̪�#�3^c�����}�b ҭ F@��Rա�yy.�_�1<r̋;�������^��⷏|��-�j_��p���o/���vI����ݔ�+��ZfV�[2;��/��� �iz������{KZ�7��M(/��o=E �`[���I)�������sB�E!�g�s�vD��.r�2b�ý�qJ NL�C�>�5e�X��N#_�����xCh.��H��1m	�� �}�l>���~������^���<KO?Z�X�XR��ȃ��)I�!�� �}uc�w��ܱ��#3ʓk�vc��E��>6y�J��R���7`P�t�i.��(;"�A@��!�H_�Gpx��ߚ61)ƁL=|�s|z�g|�:n6�ó,�(��k�L�+=ނq1��yy蓇�8א㔨����(�E�do�Bi8<���)7ufe%kFD�������j	�?�$���@��苅��|��{VY��h΃6�C����~����"���ao�RL�)pYG��Y�@�Zy�"�Ш�N/��h:�q	&c/��,x�x0[_d�g=�ކ�p��xϝ0l�L;S���B2�w�vڭy�}�^�>t"م G���iL�^ ܠy���9)lAn���S	?�g7v!y�~�z;�2$��bzT��͉�g�{-lr�Y�6	�G�G�ю���!t�"��ᐷ�wuS=�MjT��V& ^	5D�Մ��qF�f3� ��J��`��M�g�"Ќu��d�WC�ӟT|�5���^����\.���0� ɵ|R<�S��P��D �\Cy�@�u�a7��)���y\�k�[�Ivm�~N�XY%!��K;V"���t�B��y�w����r�l�K`��6��K`����u0�M=r�����I���a ��,\����䕊wJ��_)Il����C�`_�AEsU�+�P�#�=r��R�su̬�,/j�����z�5X3�����J�(.���W�e�~=YjZ���E0W�S(���%KAK�y$�/�.�:9�e�(� ��3��U��y��P�nG�R�!��G� A?�Aoj��P��I�>y*P[] �W�1`ڪ�\�kP�&��9�U�g�ㄑ��ױ�Ɇ�^���լ\b)�������ĕ�_��*�������������U�(��֦������ OKK�,�u���*2�3�E�Q5�{ ��~\�m���%�Y�w����������a���%�`N�*�O����ˍ9Y����k�\��1�*��g�☌����~_ע� ѥh�uPa��y�}��$^Ҁ
�jg�oNע�6�A�[��c,����bf�"{T���u(�t����M�%��[1�EKo)��Ww��v�;���0i�y�o�x'��^���+T�Z�{l�����f	���/y�c�E���J�4r��Q�q.�3�8 #M¦���v٩=C�������c$�gP�.�n�����P�Et$�k��[^��>�s �y��Lٗ��|��P^*���0���7AhR� �Kۡsp���o��u����M^�䝬_�:�u�}��#��M#uS�ς|���&$}�׳5q����Pjrc[� ��Qe�MSw@��������P�匵2:V�%@�L(���du�Ř��<���V�l�g�4�U�>��Z�����r����mg�/Zߪq�<C@T�^��z���f	���y�g�J��z9A��&`t�^��ѡ;3��5��H�Un�dI��c�Ũ��Ջ�g������|3���©���
��А(�aH�S��awD���	8��y�6=��d�V�`8T�$e(��	R��NYhW�Qcc$F�����M��q
w���Q�/;�u!�����˅p�0���=���*=��iܱ����l?�Lk������_ÒsI/}�Gȋ�Ka��SRɧ��h&�<��W��0_Fg�0��L���q�,�MR��R>���5o7_z2i�v��1a��A@ g �bU�g[�5"f�5ll�+�R"G�x�5�����OKy!�0��Y�u2�,��a����;'[�T�2Չ̳y�5�]��)����3a���$��N��u�������:#g�9��� SA�Z��4��sM�C���p���� М�xb�(c.x	�_@~���
etl)�C�A��0�e�� �76g��M�<���0��H�WtE��t9��P��@�KP�]D~�?��jߦ2V?@��%=1���k9��U9���T�=*ų�7�SʛE�fu	�Js|ݝYC*N!y�����j3�a�U:���_#��p�,�̸q@�{�N+�a��k+��M���c�~��p43����8�l/�\l@q(6g��>g��o�t�B�@߹�7jqOվ�^�.���K�|S�T}�<n��x-dw�|=|���UX��q����ZE<p_�刼
5���^������Ff:z:7*�
MP�Ef�C���D�o^d��/taE-���u-?=@�(�I	��0��9棫E�Tk�O�Z�}���o^l�_.1��3���O̚ˑ�g$s�3?`�y�Bu{�x��0��]�y�؝D6-�z��s�F�95!F���7���{UlTY%�(��Œ.=�����trp��ʉHC�vH�i'�Z߁�����u�pf3E�7��찗��F)���U�w_Ƽ1U�w_�2��7l�hp)'K:?�H3D!QY!O�ܯ��Ϥ�E�9!3��lj�[�\C����ĥ~���Zِ�s=y}�L:��K�[�����/M� t�o����`��z��P��5�y�	h����c����}-Ĥc �?uG5V��/��Z99 ��%����r�� <���yA�QuR�wdo�+�q��7Jh���=�H!�*�|����E3���ɞF)���L�s�,0HiE�a�J�/# �0r��ymc�EeoK;�nO��a��Z��u��~>����m&�f���|������l6�cZ�����ʨ�t���
au�F����faK51Y]*'.�o@��9��x#z�LT;�e����f}�+�켚�zC�·޼H�'3W��xm�f�\7T��yq�L��w�'Km�{�ܫ�J�*�FT �Y7ݧA}�Q������7���B�iY$NY�I���*H8�VR�6����s���\o4J ����?�-H<�by޿��K������ժ?��s�il]��&J�d1\��{.��L<���]o�8\C�ڜ�F�L�
�AU�W�Sa\g�Tt�� �  ؃(nltXi2�a�Qk�o�Q���@�
M���r�731,4�q-�*U�Tc��W����P���S_Z�,ס=~�(�Yhr�<T�Vo�μ�и0���'�#��i����nb<x�B���+�Uw�|x	Ь��f<�j��tcz+�nF��[`�FTTBSs��IQ
�,4/��q�_g�s"K�j]9'��ԭ�V�L��_m�:�<�5x�Р$wS$��ƺj=�V����W�����"8؈��.����k�Ea��fk{yX?-�O��X�\s�n���_eK[�x�0���a�A;�KB!>d��&�ĳ�/�dJ<[�Q6����[2������at��o�g��{:��MY���KҸ���rVe[��7���hT�U������l�k3��Λ�� PP�M�4`}�U_�|:�	`����{e�������[���"��Vԃ/��[���fe��=��w닮����zt����c�A[��V�8����W��V�X�a��qf/�#v�AYt�6�C��u�	���F�bNog�P�W���L�ٳ���,8;2��{�ө^0�}�f�{�A��m��T��v'!�(�M�"�uT���L�Ԣ�yߖyx����%��f�L5+�ش{Ѩ�����t�1
YdrX�������4�Fϣ7���=�6�g��w�pSCg�BTL��r@�qB���A��V�=�o@z����b��?�      �   *  x�uV˖�8\+_�Y�*}���l8�cӶI:��S����Q2[�R�T���tp�;�G�);O�cVQ:d4s0N+3x��t�W��גb�:�#����h�~P����5MZ�ih2�~����d��Uo�:�g�|"˽��g���3r��W�?K(XPMI�&&�bJJf���tH�3n)����Nj@p�5���kTw�/q[�3[�8F6���(;Q�kD^�_|���,2RC�<(����������s�XR�&@������vi`粷p�ά��Y�C��E�����N&����M�*=Q��Ѳ��L=_�b�I2�H#Ϩ��<sD؋ 5ϩ>F=�IsH�vA��F�F�;+���8�*��S3�t�A*�n�*��7J���]/�����N���k|�Es/ڔ�t�3à���Ո����c�oF`g1��ƏC/�\d4A��s
�CW��X��E�^1<:�ċ�&?���F|�/Q�dz0�H���u,".cj��&Е�Osސ�ۙ��Q9}W�W�i�s�����7.P�hY�ģH�<�b@z�:�j���2�Ǎ���	0'�,�EE�/4G�Ц�ESeI7��SVtg7�Pd5�>yQuY��l�e�B˚Z��;!��e��s��G�"t��P�C]>p&���\��u,�V`T�M����7�-�j[�X��X���3_��+,����f��
F����;q�w�`�����J�a�z����ˁ�O��y(Й��v	2aX��o��A�N�9��_&�.�̋	[�B�<Q�g>��U^�na8*h�_otV/��V��������]��f���-:����D��e���D�&��1SA�[�ѯu�����Ds�p֎?W�ӿY�MA��Y�܋�5%b���w�b�U+�;^�����n��zW���Uz��M�4���Fov��V��߼��¹����Br����a����6�+�Y��ͩ������C-�C[-���?�n�֨E9oF��h'OT���/!��v���o�=x��???^[��K��q8�&���      �      x�Ľkr#׵.�;kٌ(�t�����R�-����'t�#I$I��4(��@O�#���ӿ�P<��B��~?`���>�H s��^�o��'yr~�\-��r:M�}����f��m���ˮ]i3M�m{ݝ�_��B��Э�ۇ�~��IW�}7l�7��?3xb�X,��~ݮ�W�W��v�1�>ܩ'�W�w�ݐ~h����vy���m���i�^���r=��wW��r�o��n��=M�+��Mw�-?u����ߤY5LһͲ��f�i�\���2�2�;+�ߝݝ%O��Hp��v�^~��j��H�l�|_�(���TS�8����r}����S�bI_ʣ������s���n�:��izٯ�����E��t���<u��o����L�<���t|R&er�DyVM%G>��0GU�|�X�0~ĊX��L�lJ�*}jUI/���0p/|�]��W�
�Z�ܠ3Ʉ����M��������1ezL߼�iח��Mw����m|�]�����TS:���gY'����l�݆�&���k���P�N�x��)s�SL�_���Q�d\��|�'ihş/����46���j_{w�zHo�p�=���W�\�vX��+ ���ǻ����Cq-��,�%/`'�K���vp��Oc�gբ�x����oI�k�$|�~\wà���`�Ճ���Z���[�"�38Pq���r>�N/��� �//w����$A�4�w�/���-�8�g�Ǎ�u�`��`��;�C�������
:�@_���ӝ(~o���j���D�BI��3�Z>��5�dS>�?�������ah�Y�j���Y�% ��y2O^}jX3	�	���0]���������Ed+�(mQjL�\� �0����ɧ�Hf��߈�U�PX!v !�ʦ	�|�]�7���yU*$�D��#��y�xZE� �賂�!'�����3�T��]IdS����>;K��dt@�mlKRn���,���wH�-H�w�&��j�l��P����+�
Kc�oY���E2<h�$`���Lۺ`ªa�	t���*���8G� wf{ӥ�-�7`�V.`�]쮮�v�udy?�p�(��n��f��jmYֿ���bYU���Xiy��7�;���ҳbD�#�~^Z>�A[/ں��L�N���p��i��$�&��O@��cee�)g�T~����Q�/�.�_/�����y��*Ky�'ҫ;E-�OP��1PԽ�6q��]�c�)R���;�jz-(p�k�Ԫ��p&��f��Yjr����x!^V�G1t�+-ϲ��u�,l��W�� ,��g�g��r^s@U�+y/O�:������m����_�Dx�^�߷��v8�O|-��'��v1����������㘳�va�mL�*$��bT���*�Hi2}Q0K�����5��1[<�����/�h��7s#�<*3������ s���o�N�~!nii!/�G��u����$��q^/A���ωi�U��v�e,Ԣ�	o��(��MR��fYa����S�z�]�{C�z����q���ޡ�:j���+g�4bW�!ڣ��<X���~T\Aw"�o��ˮ������Xx�����,�y��䐈xR.H3,|�m=CFU��M��,$J�ۮv���a�WH�&����v�Y��I�'� �3>;�:��PP��r�{����fO��
3X�׾i4�~�bb?��>{^�l��hT$��Z�����D�ċ�QC����jWu��a��[���2���u��������ĥ�;�D{�"����x�����/U�1�r<CtYN�@�:��*h��5CbU	�D��̍2�D�c΃��J.�<�~��	D���[=�%�tV�]R��0�����	����<��~ti	*n�_%��gy���-K��-[eV�J�i��+A�S�,������%�sx ��v�d_�tίu���d����C�{��rAn����~�g/V�3�r���C�Rs�bM?�8�<���^3;j6�*A����1Au�wV{r��*�^s��|%�.҆e�M��n����֌۲�~<[6D�/�Ќ�#tF�+B�^�*F��8�i?�/x��~c��ߚh�`0a��Gs��[�2:�H�����7b��\h�*e1ߣ�E�6?ŉDM�r�C&��f����I�'���������ݚO�m��2S��L�kiG֞a�RA�qk�G�Lg�(���f��^�AG�:H�"��"YY��I�n�J8��k�Т�i|U��{G����,>������/I;-O�2���d�<�b���*5�!�ny#r��B�M�EQ�B��F���}ݟ�ۇ؁צo��bH������~R������{#BL�����٥�+F�[|�u��o0�J������e�I�4�*/�]���42`��Dt�#� '���E�$P�%�������z�1>����7|�r}��09+������zw{O�{J�mSO�Y���['AP���-
k���#���.<�'E���R���ܟ��X��T�6�������&�1��tb�!�>�<\@VT��/`ژ���z:��PHߖb?�,)f��pn� u��w� L�Ų+����>lj�2��\v����'B�q��K
���aOW̱X��
`�&�;���c�è�R��6ˇA�� }Q [����Kp�W;
��rr#fƋF]�b���:pO�L�8���%�C`�۵H�b3�oF���!�r���<����I��M�ȝ}�1O�%�����疹0�,�8�
���\��I���	�3O@P^���G�,/�w��\�T4L��� �K�����^d���,ߧ�䛐M��Rά��F��I�'��`
��T �T�s�F�Q�Ad�߀���	�#�l��8��Y$𳇬�6"S��5�j<$��yܭt�E(j_bӃ=��e?
�<�;;8�H檉�c��d�P�d�ʑ'�'7աn�G���|w��,���1hu��F�<�F�ب��&��ܸ��
�z�QjY��+Ad=�IY'e�Zs�tà�m<�\���(:�7����љeQ�z����eR��<$1�Xd'H�g B�ւ��:�bEŻ�M��T�!�V9�`mq�Dk[�%�s�_]^��b�œ�I�ƍ����I�x���������F,�L��{Ӵ�<��}���%�]53��7R,E"Mt�+X.�u�B�� �WcX��Ֆ��h�R��␄m5M��T�Q�r�]��V���O}��]�H�\(<�)���\�Z�c�~v��%$*��TY?�W˅������H`ږʳ�P>1����*t	����E0>p�Ή��9�ZWyRq��K+���m���
]�P%�����\<�DjFTʒg�@@oƠ�(�[�X*���@K$'���o�qǝ�j�E�����B'������"�����p��=12���ڻ�oV����'���J�̣oD��}-%��E�2�� $��$�OeH�����%i��������`/軦}bU�R�E6V��T��	P)d��^�eb�ݢ9 ��-��#��+u�&H�+i�]�	}M�Qt�Y�_��E�Cz��� C!F��U'�
������ۥH=��oV��� ��.[D������'5>�G�ܷw��1���ðS ��Sw��h������s�����x��i��n;п?>O��o�rl��R�	��R���̀i���S�$�ߞ�ߓ!?��~K7l7���8:�4�ݽ�mђ�[��x�pbpt),�j ���f	�r�~��+��@�ni��~xǧ�4K�G�	q�]Fr_�VǨ
��e�q���B�*����ek-i� �M������n$�{�7H�����므����i/��~{��K��+����j�߯��������\������7[\+��Ψ���������]�����7_Zb`�Y�v�W�x$�ms�k/�#��#���,��noQ4	������,�7S��;�B�x&�����i��(�뫍�*dMP�0� �3���    !UQ2�o`�b䉕���?�~����Ӥ+*�Ǐ'żH�o�?�6�D���Mw�'%|����B�@��WH�ێ�0<��c���v�l�I�sl�&��E�iW�v[i�����*1��$� �+���8F?�r��a�,�N�A
�[ê1=_�y�<L�p���[�n�G!�a#�\��srf�v[��/P�t�;�������;{RO�Q+�6���JUi�WӨ�VL��)�$5E����S�r��$ϝI�כ��-=FЖ	琇>�BVPRP��i��3�LRh��d���c�
i���\�;�{EYc�6�}�K%ʹr��$���yjH���N��!�N�����Ė(,����3��k7��;�%��#D�������:O�G��y����Su ��Y"Q|�c�rJ���#�0>N��n�W��nM"/��V1���B	qѡ�V���#�0��D����V����t
��Z��";��b�fc���c�j�ZX����e�A���o>��k��w}K}-�-�L�zd:C���@�������7�g��@�!x,���"���W/k܂�W ~~������ĩ'����u�>S
bFJ�n�0^�C�JJ�_��ō�2�e��7t�_p��=�O���.��&9���bR6w�X��g�@���g�@F�$TH"��i(a+7�8G��Q�Bb�;�?j��X��D`"�o$�A2�+�x�]�`�<0��Uw���VX%��\��������-@<�*�+�*7��R�Bҝ`"B���b@q�6r+��8�n���i��=����q�s�#�̢�SH�ɍ��r?�翰�W�����x;�N���vR�	�{���w�	т1K�����}P�~��ts��`rٴ���s����3p��E Lĵ��*Z(���n#:R#v��Y)7K����]8Gz��Z�K+E��!!����?����Tj^�'M�q�o�+jn����j��LD�����O�K�52�?��?���������bd��f�Bೌ9�A��$���㼳]P��.�e?D�j����j�$j3Ֆl�i��ԗ0AS>�|��Cf�|����K�6N�I�$�c��|��Q�� Rm�?T�;����a�Rl8��R}X�1o���(!�C��)��Ǝȁ�,��H���_����u��8��1t	�].8I�z�o[^ц�8���I��)�2��$�s��d�nMy��<�(�/^�om큱g�e����S���Wp�&X�&�t&����8P��(y2�&�#]X��V4���n�
�r���%:��,k��s���K獧���4���뒜D1�
_�I��W]w�_�X�Z65�Lz�qM��6��S�����Sq+tgR ���5&�z�KK!���S��̲~^e���tSS��ae�7��hF�Hr�:Ίі{�	�������ꗻUO��XV�[��gN�-�Ԝ����7�(f>�^�p��2%y"�ϙB]��N�C��{t-�W�pSoP0ݶ����t�l*�Š��8o�)�/H�I����6��=|�9T��� !�A1ЂO�G����R���Ѧ�).C�|�U�[SX��-��]߯Ξ��~B�*�p�� �U<`P<�[FS�yC8�Q�|>��N�'aAm�2�H�<������n�p%Y�7�ХH�'�� ����4a�-$�q��-�{�GԵ�7l7Rcr ѩݍ�HW���A�l���`�(�i�KԥoE��Td���,wnp+�C���[ww�O�1�i�/�D�ŭ�\-Qj�p���Z�J�g)]��7������f�0�YS]dH+_<�[1l�	��K �y�C� ��:a醿�j8O,]r��ap�1O�=%A�-&��e�«�����;��S�L#�e �p����L��j[�JH�:�N��m� �Fc0��jc�o�{�����'��jH�
�}Y5�̧6��I��V��0$���K�	�+٦+�:�2p�</��i(��C��r�V�$oԑ�#� ����]��(��_��[�s�����M��|������dV%�*z;���A�Q��k��U#eŪ^Ȋ���E�ef�DG��~�@���l3��؉�=A��xǧ�NŻ����˳�������x����5k�2�"�O�T+��q@�������R@l�
�5Ŏ~ho�p{�ϰ�0P�#����р�0-5Qn�a����p�r3��%`�c�:ݳ)�j7U��5��[;�RzX�Io���,�����V����P�L�R,���R�(NJ_�H�ю������b�
�*-2�D����;�=G/v����+<#Ċ���!N�o�C��-PP�� )���Ø'a��.��/w�n��RzǨ��A��Xu=gC�]�7 �6�Vf	�����+1D�k���+|C����ѷ` �~߮Q�у��"�Ȁo����:B��9o���,���m�IZƑv�2�TVIj��E<%5ꉶ�f���I�ZH�0�
C�ߕ���V`w��R�j�2������@� ��U	$�� �%&��|�Y�!}��M_�/�̳~�=U�3�m�s/UCƺ�>�%�9DQR��5�����u��a� e��`�������mK��c�@�F� �W���I(�1	�J4Z�?~I��z[�s	�k���?�_J��W�,�̚~~��	ہ����[!;Y�~ۆ�K;Ɠsn9	Yh����D�s#A�ؐ���o�k;�����G$|����~{���g�	�tU5I9�tx	\�T�@��u	��k�=�fa$���{h���Z#G_�`��Z,� �3;x�u�@�9�H�+�#�Ȏ���mȗ�P��ޣ�(3��u��1J��Y��ɚ�?��u���LLX(�G��=���{��`6_�k�b�u��o�X�v�R>��u~2U�]��_e�����~|��F`��tˇ�-��ў���-2XvjRP.�]/��|J�h���l�*ARv<��>���TJ釞��N�8~�s�D���n��,S�k-�k���ݚ^�Rs�a�o7��`��S�֐��Au�i��gD�<���d�K(y�L��@މ�)l_9��ī����$HrݨլS������ɠ�/zc����SQm��{�XG�Wҏ�9͑��*F���{�FĻ^#ow`~����J1kL\P�]�9p�dt���h1>^|���E^�Z�jj�^��Qf�����^�����o.5vg<�;��o�I�%M�Z�8�=G9�ʊ
!k��6�?v�M�K��RY�Ѣ&�l��>�es����0ۢ�u��+����Ay�ޏ���j]DA�\t*��e�=i�~~t�n��~���~A�k��l4�\#3�gq�{.'�cq� �j��y�1	����;A��*����Ss�V�"=��t����]�b9��"P���.Wd�,���3܄u����VR��
>p�bY��t�~�;'W$�#���ݽ�H����YZ届pm1V��6��q\��Xq�k�����w�1�;��?@�?�όm8��Z�_��D>`���}�����0
��=��q*�d�
Z��2@o���.:~�e�3=iʤ�Xw��L��W�n���:�^��v2�v7UP}�N�K1�VЇ䭽�.�o[�׋H)�n��Ӷߪ�g���/U��yr����?�^"�SM����,"ac]7��N�m�O��&� 5��tȓ�J��O��A��7��8sλ��p���Rd:�l�kvߞ~��g�a����zC���d����fbn�՟w��e�iխ��1"&tP�O�nP�j�]Q�s#^@~޻ K�IS'M�Xy9m�Ru,�})��f_
��:f6QL�Xu�A��(��'�n�	mcT���_E�7=��`�c#��nE���.�1 `���v�;T<�A����gg�ۨH{�æ��&�������D<�2��L/,%�}(���@�A���0֐jp�߂Қ%�e<m]�"�Et��H��n}g)-N�	������\*�#��
s?���52S�W&ʜ�N�T����t�    ��e2�\�f�Ob�-?�G2b�b �g�b���E��w`X.l�dP�#I��\�D�Ӿ\�}k�nU�kq�?����vK-����H/W]K�#��6����)�=�,}�u+Q;�Z~�`�������M�4�p�YLvf�)�!"�-�����`�:�i�1X�B4��A�����Ѿ���*��Hr�M�����V���NRn���F ?�4�~�e�K^,A�����7XRNG�Ȗ�����a��a'#+|�[����(���	�P���M2�3��<�8~���ĄZ��V����$��Z��4ﻙ��oj�(���w�\vw[>`�mY�m�n�`�������w19'�7�J���#�B�I��a�!s੭��%�����(�vW�!�h����2���� k�С��C�L�d>M��[��rD�v`�c3�OF�7/�O�U���$׉`��$<+<�<�N���
">1!�Uucho<�uD�l��T�j!����%�M��ȃz����:b7��(�T��S��}G��g���]�)�|�]~
5v1�Y��	@�G�V��Я&�	�,��"���h)�F�(�Z���Z�XwL%^���9xr�>�<D\
�iQ%;P�uTeD����&Y5��ŸåRhl=�5>�H�j�aE#"�~~�Eg��'h��� ���<O���m�˳_Z�aԡ㍈[j�t<R,��k(�����im���Z�6)�TF3�y���E4���{�op���ǳ6}��,�E����7�y�6�6}�{�~��J���K��ٓy�̋��o_8��|X�G�xU�H!����&�N7�,k�b�=�p�F ō��>��?��2Y �G�b��e�%��̽�!6�(��v� ���쁝���Ȏ��3�;\ڎ�@qE�)K�C.�	���Sv�g&<e��U�7i֚L��͋�;��� =���Q<��!St^>�� o&{��}w ��3v���!�*�k�"��%��'��ʜ�\��.�%��Lڌs�)|F��\�����6�ń.y�|�u���>���2}�n�^�D`^ d�}�<���]���5���K�{�����v�}{H|~���m;2�1\%*ڮ�5h]��Ďd�qO�6���KҼJ��n*����Ts$�U��)6�+��i&
�G�>�UO߼{�8��l�R�`�2F� �/
�7��DU~ۯ��E`ǯZ����v��e_�n��R�&s�$Gр��v�7!��~�*�h�6�8%O�Z	��6�yRR��']��9F�|���jF,҆��
Ü�h}������E�<o�Hѿ����^9���=\ȯDbӭ������-L�`�"�VS�V�	p[�~��U�#�X�6F��mp=��=7����>�Rz5��������?2/��I�{���pJT�Ũ� qղY&k�����
�q��=�w=��2��n� N��k��sƑB���I���г����߼�c�_��ӎ�ĕ�� ������8����Z8y�(ЀC�S�Jy�?�8����n����mG�;g�n��ۏU5�$P�,?� ����[>��:7�=�X���Zz�[���{W����ŧ���Â�t���$z��X[�����X��G,�Fm
Wt��qb �vR[��Ċ*����(1��5�F`�2L4M]�b�~t���.�B��Q}%3atQytQ�^�]���XQ�gEF��YQ�W���a�\������lj�N���)��^���T�@�L�-�s�N�;\n�:�58[���3�=�&EK�J�IRq �To�$uӭ���U�p'��W`.T����X��{y0M`�n�;�U�E�����a~M(6���N4	�Xҕ�A�.��#��d�g�,�R�=�[����������[7:<��&�f��h�(��To��t�ɥ�s����>�c�G̀��fU�����Z�:o�Z������PBrFE�#�=��> T$"k7�hb�3�[�pg��M��S��0ȭ�Ea+�H�p��
F2�d��;,fT�/����m��Q�'�y2眄��0#�F\�bd�8�ӑ�a��Yscӗ�)����������_ч�zٮ�R���&�2�M���W��{���	9�����Ȍ�ر�<5�м���������Z)z ���lfBU�K4@ ���.�L�YQ��p*�d�G��q^Hx��f�1��\-�~�E�8��'۷�&<\��cT�LQ�u���m𬲈�q����f%H��u~��gV�����@��X�١�~���=\���1QR5	z�y�d��c��M�ܩ�B��*G��p�B�Wپ� k쉲_j�߫A��L�yUv(�x#K�T��h�n�n��+��צ�r�4ŭ�x���a�uq��%�N���(��,U?"��^�>�l6���n���=D��H�d�!V��<;'�|\�ߢ�&�a�Jܾ��l�7��� ���"b�f�`�@�N����G1}�L�:p8.ʙOC���)d7�q{,���[��?���g���v���M��d�ղ	>I;�sW26~��l�䜔�G��),(lEcPѳ��/�]R�R���FȆ��`l��M��>�ݭ[4�π���J�G�¹�Q�,wԲ��8c��pXn2������� �	Đ1Vհ(�'f�M�8b�Φ�8�Z�ia$�a��� ��ЭA��Z!�hR62�h������P8�,�$����B�y�lZ&�b,yĖo� ۘV�*88��7��t����>�{�^���G',_�6	��ǫ�x,z���ȻD���䬷�Y(��Q��n�&�v���_4�x�\�F:���HZ�yh���bͦ�\��C�D�p~�<q���C�jy	���
��n�O�!����hP �-�fT}��ey���	LU%�X�!�^1"����N/��M��\	�
E����(���47��)M^;K^��������>���Q���;�Ȧ��&wO���Z[�b��e3�	n?͋L0��Îx9�l�-�?p!&�l�[qY�,n�7g\���4Ø�\]!�&��t�	�Ō/b"{��u�"Wr��Ħm�y+���<fk���H��K�9�ZI��lI��	���q!0��V��RQ���<k�W̿d^Qbpsۦ;��Se�3�yBʆ��-&���EQ��&�:K�&9آ;�4�@�� �'<K�9�c)��;���p��A����S�ީ�.��>���fg>챂�U_��D�|}�H�t�抱ܡ8����`�=]��� �����2%���^b�^a�_����9��ѥ�w^�8�/(
��ތT0�����u��c��%�%�n��#]�O��m2i�2�e��$D��Y�R��_`��F����L�`$ r�Ϳ��9\����e��l�|�H�ra��ͳw.�<��[1ZoQ��M����9"�BQ���Dv�g�j6��F����1$��<Es�{be��G�R��r�t]Ȱ����P�߼e���=QЀg1O�<�C(���P̐[�Y�����g�҈/�DN?�x>��.�9Q���z(�%����Ý�[<���⦣���{����s��SD���Ew)<�x�S��t��IGj�[sr�6��J"�4�8��I�%�ȉ;�1�J�h���MG0���8^G4ޡ�jl1x�RX�~
�2�q�˜3z��M$����VE�����o�!���n�����<�}eZ����/A�^�}�1n��}��/�ܷ�f2u��n�(lFPm�E�?	�;�G�'K��d\�AdS�.%��]�鴬�ť��),��{�ܛ{c c"co�<Gֲ�9UU!P�+�2�/\8٨��k�����26Q���*y��4�h<���$�����`w��֐ʱJ�f�o�4�]wUD��Sh@j��K4��͂�d!��S�$=�����%*%nS���?��/������n���w���v�>�d����I(���e	4�cTO�����ˊ� Q���:W��
�7���4g    <�V�L��i@��༇%��Ff^>
��8��N+���h����*��7��O�O��R~��N�5�o'#l �IOU�Lqp,R$�&�]�JL��
��W�����R�Vw�Weh��Em��i���"q��B�گ��U�×�άB�ʐd�t�yu�}�ͥ�5��P���:�`X�;�d �栰�Y�����C��G��^�v�����-<���;�a�*I�!. f��u�m�J�(*c.�C�Z :����D��m8L��?	pI>ut�=���6��8T~�)���W�Sx��e�nL���� [�R�5��,��1�����yW���'����Z4�pc�ve��)��j5�͉��"����Gb���c��w��9-���jMT�M��k�y:��#�NF�<s:�<���Ҩz��$���;��/��ݗC�\�ʩ|4&q�I��G��p��T9_oU�*���-:��=2�W�*k����wq%R�,}�J��=���f٭�Bs��7E��*��4\����kP<���u���|ZJ~��䧓��o�'�Y�*���������jBS�@P����8�r[���Ӌ��E�ǔ��n���?��JP|bhg4�a���
ܘ�k��w�f����V�T�m���F���3�t�&N�5���=�0��y�H�(�������\%x�	�vY���-t,�<4-����bi��..���������4�L�a�4_J���<<q�Mf�ú0I+:�9���5�_�O\�\�-YP�9��5�Ꙉn�:q�8��cdf���0�@��W��&V3�� �@2����?��
��B&FhP�nt��M,#��[(�M�2'����V�;x6'UT�hzOǵ٭�\*ɐz��u�W����ל���^�`$�U�g��D��4E�c7R�=�9nMJ]���;��D��#���j�4	�ΙQ����=�Q�d/�4�,ḣ��M�f�dR�����)�L�@�C5↵٭a�������nCP��%L&��^��)Iw|,eW��RF_��{��}���BHQ�Wt�P��hP�$��y�X�I���9�3�U��ۦxJ%��u�K�2�yg��&�w��m��6E�y?��3d@YCL}��n0Σ (d���l�(z�(�=0HB���(uY ) z!�L5�b�@����p��=��߯�}�7d
X� Wy���P1��}�
no5bٲĬ���XQ�s����N'��a��Ѕ���*!5,�TW�u���'��<��GD��$��E �鷔~��8z"�4���2<A���]�^�vg6�]���d!�,��?}':�?;N�2�fEL,��A��X����m�;R�0��@[� �ƿ%cǁz�h�%k9X54��~��,����KW�N�̠{$f/8�3�`Z�pP���Z��f�­����}�k��{رPk��/�p��F���,�x�i��י'�,/��-��HV
x]�=?�?x����pa�5#t6�V�ڄ�o��RW���&R�:,���?�C�/7��,���AN�Fx�a�=F>M�@�xa���.2��%�C�Ng���J��_C�.]��{�R5���O�l7g$�X�Ԛ�[�~�< ?�|E��p`�s5���ЩS����yz��^�ީ1�E��C�ۣ�+)��%x�v�3#k�4�S�E"?�V���4l�ѣ�2,#S"��AH )�a��V�R����*����SE3�3cT1����'��T�}|�QF+�y�"�D��B�,�E�M}Qq�8O��Ʀ}�����%@ԯ����oD7����Jg�M�X\������V�p���F'���w�ъ��ŀl5
�V£l��!~�����^�η����pb�Z�8u�b�'��#��ȋO6��1�_��?F���(�����FY���)-ᔊ��\]����8B��l�Υ��3�����4��U�N$tBB+̦k(���VK0��/�Yغ2/<���ya(g�yh3?V���"����	�W�Y>"��聣�T^	��b#Ē5�NT�o[j% U$7�����j%kf㐩��{m5��pi�Z�O�no�9W����Sc.>�*M>`��H"A�AZr�B:8�
Ӻ��ɛ���"3/���H��ow�M�ף��j���F���1�j�ct�v�9o#�ub�|Z'O��ϕz�پRX~�����c�mXnUU�x��.����p!u���=ivV(�L�X/�J�b�� !6���s]g��-��fn=xZ��(�
#}ང����ai���s��xԼ��;�x��NU0A�boö��ʥn<.��m��6�b�p$j�A�[V��O���-?�D� �vΨ3��o(�G �蹰�O�@s�&�
0Ӎ�c��q��D7	�&�f!|3"���2�.B�D��u���OQ�EhQ��XR9���X��$(ћ�%�b������r��fA�Ƅ��)�����[��K�f�cCqY�Eu�o�"Éh���a���& e���W�"<R�?>ǃ�'x��L�HH�	B���6��r
�	Q��E|q�O�q�]"�l�C����=!/���~q���ߒ�c2�E53w��aR+d�K��r���`]��jaA�Қ�`C����&�+ao�@Յ Unಜ���jԭ㭗��X���E������~�� �F�:sQĭ�tH��(���Fb�*��+M5kև~���՞՜s�+���i�8�+	�4*��R�U���7�R9�P4 ���R>X���Eg��c����>C��p�ܷ�~��{���\�6�V|�"��7�b0������%Ȥ.�稜�#2-�A �:^	��v�W����a3a����I����l�;�L7����@�#���LC���%M54�112��O:L��5,�,��%rKwe��"�u�p�F��H�=ce[^5���D&�/y���J���؇3�>V�L�.����P�91�|��N���>J5]��u<5k�����r�5)~���.�vI6������M����p����i6��1��곝��yz�)�]���+ٕ��8��'8��/n昺l�����Ǽ&��'wߵ+�,x�}�+����5�M���0�:��q�Ѷ޸x��9�s��.rh@�dvl���cB���c�M�����l��BV����<~� <>~��Ч�#5}�l�[	*Θ:�����44��R`��������Cu�$-�>�8�ڇd}�^� ur�^f���Md�� �.<�6�X���3���*�n��*~�{ޕ���V�E��Y�!<���*�C��|�v��;��Ѥ^��$�� �SG���"�䧿b�����tR�7haw��t��#7�8P�|��߆�;�qA�8J����V	��g�s��\<ৗ���&�2\h�ӟ}�]&��y �>f��o����ʡ������uʣ��4��fVm����4T�c�|7%LM�\���3_R�0L�0��Js�k���zK��cwD(�b_���JT�5ͩX�C�X�𩪪Ō˪뉭	(�B�R'�1� ��hMK)~
���"�0����.�zd�k�g'�� أ|c4��D#���b�`��q��3[�׬r&(�<�A�L�x���r��a��V,�g`��/ju�~�<�i�g��t"�,�N1�FQ7��Kc#B�e8ž�~�v�J�D A�\�x���g1�X��ˮ���o��k���L�cQ��F�ұ�T.�y��
Y[�]� �竾�;�D3�c]\�օ�b!��.�j+�RY��j�#U�,��{���r�&-,�W��R��K��ZV�Lqv0����4.��té�<ٽE��Hp��?��}��ß�ɠ��]/G�J�^�b������/�K{н�*5��G������aw��U���cOP˸g�4�ݭ�K�L��L
�4�j��!�3Q�7��uzɇ:2�����̿`B��R�6�kQ�#ƕW���.�.4ѸM%������     r�i�9�5�Z_d.D�h�f�v`W5Y>`����q]��#��4����w��q:���z�+c4�ו���b�:=�(�`
��c�~��`߯�Q�Є��W ���KM�e�k�f�(��XZ�d��cj���{pP��_���Gf�d�S���u��4�v��v�L�fK8��:�B )��m&�
����g�-��tg&'�� ���m�l.����n����î?�ug5���~��D�$	"lC�c�����R��7������a� �p���P��-�oik�Z��N�r2�$x��+^��.�5�[N����i��{,sx��V/��-V��b0\���Q5��y��j�T�2fm�o��}*��>�]�_�x��̋b�#C�^�V�����&ʠ¹�*�-c�y�`%�"A�����"M[�:����mD$�anA�����p��3�	ڎ���K��#�U�RQq+�r@P��١.�=G��U�b��ϔGt`e��:0�'���j�w3�Y���$�:s�Yg��vnO�G����*��Fޛ!'������� �T�ǆqr��q}����#���'��<����W(�8���_["���i���a�.����������9{`@ܙ]�Yf�`��� �ؒQ"v2Q�ShĢ��J�.-(+�9��Z|�����c�7%J�!���	P�n���Ѩ>q�=tÅ��
T�j�˭/�>M�y��F����z��sy�9-W��ä�@s;9:��W?��yg��x���������GCzK�,^���U'�]c�%!�re��1�%��F���լ���
�)�����k���J�]�R�����3��+i"Wz{͟~��'Tb_�A-�Ӏ�jP��ӗƀh5�U�*����.J���s�C�ό<��SS8\��3�_�:F���U���������)����W�j8!�AA�o� �H��M;�$�7��9�9����Ӆ�'R{u.�ϦF�A�pf�yM��6�9N������5CY͘��F��ي})G��=�4Tƀ�I�_����H�&Aʻ�>��d�u�S��ozKw�2B+���� @d��a��0���g���&A����5�,����a�+�R}!�!�H�G�^�O�[�����,��c �d� ��mc-�r��KιH�~oc�k�t_z��[��6�EvK��Y���q�I{����M���h)�����fInVݢ���v-�1
R�>٣�ǚ	��78���'��/�Μ�|�Ԩ��]J5^RI���� �����b0����0��5�#����Q��c��r8��N5Mp�rl�[�Jgk���B1� �hO��z��<͘��QS9���7P����PdT��&�%�pѪ����vLO�]v��Y�T�|F���A6�;"�ʙ�-�=��l�߰\1�i�g�B��0;��d�5{�@x�Z]��}ӛx�}'�;O��V4����22��3�=�{�YxO��(�x)9�wwy:��M��+u��Y�ž)<�W����rֱL�c�"�"2Sj^�Ԍ� �2���'b�I�N9�O���f�q���f�UOS=�X���&	R�8�T�[	�7	 �*��l1�݆�.?F�<R����ez�^T͍���r�v�e�az�u�k��|.��V�dA*U	RJ�:?�D��,�"�Z-U���/ic%?�ީCZ'�E"�;�B*���\�D�
�#��Ϻhe\S�"�_~���͓Cֈa�"Ўg�IA�~�|����7��F���*ȼ�yVPq1�Q-�D�tg����7b���I{Hp���]��H��3jIF�������f>�'®� h�BuP��&GlZ�&c�HP���<8ktd���~��}��W��e�[�����E�Y��s�|�h�EfY��<HZ<F�!�I������-30Ύ����v4b\���M��c�}��/�:��XA���G��:9Ӑ��a�x���Bp����M9y�s��1g�X���z�8�<!��P��l����j�jV=�;ak?�FՊ�H�!M�(}4Pk� ž���
˻���@N��KPE��055��ӈ�0lfxk����)�fG�$�kdӑZ��A�'�l� ]� *E0C�;C��R�_�T��� �rM�,ARَc���"�� �
�]F�R)�8��8@�o����(c4�6��5@���$j�̦�(���{����ܝ	��v㳱��=иC�`a�|���8��6�3Rc�'�m���UA;����[���K#.l�B)�/��v�ؚ0�>�,w���o_��"�Dq�ߏ�m�:�:�"Ho�vhW��g`n��S���q���L`�Q/]���n�͙47>Kx�>��b�����o�%��ϋ}� ��aB�s��04/R> ��Y�f�;N����G�fj��M.��v������/�0���j�%�il�`5戉]Jkt��ǳk�-��	۴�s�V�;��y^��s�hB+��`�����|�"Q�r�d��3ߜ�i��C#.�!6��"l��4�[@-��\������f�(l�F����d��D� Qo���N��O�-X|�c#�{�&#N�AΚ��Q�8�:��_E�?��j��>�l�O#/���Q�f�$���"�'?�}2vK��l
O$躩(a"7D�R=��^�`�(p�h؉A�2H��u^���¤ؐYv�ؙ� ��X&�8�~Guۓ�j��YNc�� ����n��W5c�0)��y��]�ي�LE9�K��I���O�ei<�R���o�Df��Y��G�B2],�Ҁ�T�9>X��N�̧AD�@�i�@�V!ظ�Ⱥɞ�f��8Nڴ��܋���� !���m���~e�/���m���~�����%��{�#��M���_����hn��<���X�u<�r�y7�Cm~�i:*��<}���r�/P���`>�e�y�<��e�<���=��~�4�XW!$��@�k���ȥ]��3�����a�4����f{�'
��V���,�	V>�瞃i4�GOZ���2�T��h\��a�E��X1lf=f�s�7{	v4É����:������ɍ�V���)������� e		�s����< E�(��.#�c�q7����N]#y�`8D������G������zO��y�w$��?�RL�9b7��n�>ࡹ�0����PP�M�ƨJ�`��[�7��-�Q:80�`h11� �pP��"��`��C�?��h����8��d�C�D�.&Mʃ/DR����� �N��ݔ��%���nv5=�Hrɡ~ǁ%�s��)�$8��CX)B6/*�Gbx�[c��w,b$��f��$o>����,#�*W�����e�	L��< ��U�ÜzM�����|H���	I�B3�i� =��OO��f*H�\X�,8M>ڮ��d�g�H`�O��!�H�"AJx�L�V#��]%� -�<�g���@�j�s��#�� �|Z&H
�šd%��-d�s�͞#�����c{��睩���k������~��76�g�ڝ/=0�QF��	�O�'<�pǡ�U���I�z�Z;9���8�Z�)2��%VvPtWfag#d���|:��ͧ�)j'����/��#2�OM�ZW����j�k�<3� �#�|9�G���a#G->����i��A9,��!E����T����n�r�Ǡ��a���lDg���!��|:O����`}�s�g����e�5�7��z�ƭ�u��<� G*��γi�D�ۇ-VL4���l6�U�,?����c��{Vr4� (I�����K�b�$�U��XD��f7�@G����g�~)7U1�����Ab� c:��hd����'�]Fp�<����� rEe���%��h�2F�jb�y{3�����9���?M�y�8@�@��!�u���5o�1����C���%�a�I�E�38 ����0=��F>jo��941�B���}M�l�k�s�OcF�(���ѐ<<�C����xɋ�    *_V&r�ԤA���"A��5 /������o%)�7@�u��|��
ԄWZA���n�]F	Q��o$|l���دY��g�Sd:Ň�͜�7�F�����������ܒ��(J6|���6ڱ�'��%A�I�Gj4���d��CP�
q�g�9��q��B=>��.W}��2�hY�Ǖ���W�ZW����F��d]�1����<�0qS� {��ym�[7?��GDt�~.�p��`俴�L9n��`�-i�����/������)y�Cӣ��xX�_�8s���_�b:����8P�~�C�[���ոƸ�7�]��(\�u�0foحZ21pʰ����1�D�i���`��xP��Ǆ:\��Uc3�X>,�<}Do(3p,���T e,d�=#B �ESG�xۊ�����U���!�y�&�0�ݿ����VO9�&up������i���z��T�c�?7�Ϭ3_{{��9��@�C��o�_wH�]�#�^�B�*�v"��I�`#U����9v��d�xƧj�ުY���I�8&iig�p����B4�e�1�%�ĩ�)u#��gUc�5�n��
�"F�E��BC5�rt."�F{��}0~Au&��F'<&�����} �lo&8�b~�ҼE����Cz��������S��.�4��<�F�<�O�:�hp������dma�mHiZ����jf�� s�E!�r�F]:�ハq�i�vsvGC�{E�����+^�&�w�w2�r˸��}��'���E���F�1u20�t)�����<�KT�:C9�����RȞf�;��p>�Ԃ�+=zwj�q88���gJ��-��E��1�������IX�D�Ru������w�bT��fτ�eV4�0ء����l��8w�5l6�^ Q%��V��_,1�c[)u��\G8j5t��9S<qż�2�C{F;�/�,�o�J̻*�a�hq�,�&:(�yěW�A���f謶'���qI�8�۝���ה_b�.#������A��!qr��M�ܥ�w�|�cG��<���Q;R�-p~�[����Ib���M�p���S��o{x:��xa̡��<�H���ݦo��'g��S ozX��jy	��e��( 5cx>|���O���t���}��MH#2�+���
�=p��N؃S���Cд��a&%W�X�PBP�'+v2����ħVI�l��-���9S���3�VT3���rHe�7��^�q�D�+.z1"��Uys�h)���w튧��q��gH��^��%��DB�n���� ?>�]�@kh���>W���O�N{�y<����T%�Rl����^/Ͻ�Q�Kq��6�^��2H����W-�Z�I^K�M#��k����U��z�kǉ�Ģ^O����o�1zUD�*�[�M��Y6�VSTyt5��ƶZ��C6��:��^}:�-iKYU�qs���o�7��㯬�������S5������b��$ݹːU�'��y�)jg��d�������n��}�u��wd3N�{$��tF%�/O��(�>S�OiZc�#TcS��0&�g�^)*]3e���emz�%�O��p@^\Єw�F�����s�������D���?Z�:K�����I�|\╳��&��A7w���C�.���9���h�_&i����lM[bL-���f	2��hYsr�#�Q�3��ny$k#��P��hM,�C��Y`�`B�"uB��&+�[�#~#��N�+�E���Y��;?�:��X�(�E�`���*����tZD�ξ�rC�ܬy�Ց���Bt�?�$x���ƿ�n���iu�,y�!8�ҙ��u�*�Þ\���w���/Y;>G�(�[��ג��N�;���K�+Β�Ȯ;>K>��䦪�̈́����R��vP���9���~0�#��w����t��(<N�M�	�
�����i-5��(�B5�L��	��TDo�2��9C~�ݵ77�e�Y 6̫����6��t��Kz���L�VUh2<#��Y�6�I�jh�j��3^�Tds.�3�ni��ڒ:N�����-|nV��4���0����IN��M��!r��a��S��t��:e��B��b�L�L.<�g"Ŗ;6��P:�{Iٔ��dJް]]��a�����9��3}�OG�%x߁�F�l�,6s,�<�����}��LdM��3�
�}P��<�#)m�:��N�c������`�6��Z8���Ԅe� �)�N!��/�B\��{s�j�ӎ�����ʫX �ĉ�bf!���N �Y!{��oR&�72��>Qћ��f�P
�s�U,遑F�*��X�����Z!��Jiy��~6�Z�C����X���`Hn*h�~�n.oD�8�H�[�S��U�4$�����t|k��Xc����aXӖ�. 8����r
��?�y�O�!0�&�q������y{q$.m�Φu�F�O�/�̤�N>�Q/�]!���Ӫ�Ē����b�f�B���!����p�$Ě�0)q�: r�'��p _��}�8�YnS���M��Q�ɧ��	��x�C�NX0����qJZM(��e���$�"d2XI�(�/V�B��񖷷h@>p�0�.�����g�������r�Zr־����l�4�쥋B���j�U=<�]��G߹m�e���E�n�j����̛Ղx�cH ��!�"(�8���XaܿYv+`�gjY�;�EWw���m>QYd%6xGh/����kd-Z+7p �b}��i�����#���"���n�rʂ(���`I]{K7S��� ��Y�����C�l�Cu�W%�~����N��&ߥ��_���P`�(t�bXS������u�� �.�KM�I)�L�@���S�6��,������ V(��fh���j8�p���z��+���������z��&t���e^�_6������2I� �'�Lji�lI=P]�h\��0Z�ZEjSo��oP��.�Ac�1]P������^_& <%����	����m���-��f������
��!�HkY�ȵ���b՝�Z`@��,��j�<����x��l-n��/"+g{�!V� ��sy���T����NE
t���߀S���!���\bЅCp���r���Oh��w��X�I8�VoTd� PVm�&�X.Z����RR� �m0/߮�@3g���z���&����7p2LN۶p�a�8hN�yOL�PL�É:&�9��YY8Tq��t2�;	|��A^y�ӁR%����%.���9���w�,�.$?Π3����2��K�̜�0.#���&_%ﻭ̗�g[|]�@jd�G$���D����)�D��B�8p"��[��#t�XW	�l@j�Z^M��쿟O�@#v�#o��f�Kv�Y��h�D=�8�X�#�bɘ@> �Q���c6�J`���;8h���L<~����zo	��f$S�?��WX҄��ワ_~D�8j� W9(��ܟ�]v��T�I��3�:�?WT{���g6:�/A�j8�,�
�n�;�آ����6__�-Qi��:��C�*;v�$��	� �J�9	�Zr-S¬4aaV9���[X~6�E�&�^��3�3ҭ�\�c�Kx�ܳ䜱J���$z!��X�-*����o��5�A�M�ǆ��_���xwg�%x^�v확�#�hǒ�J��{����
�[X������,>���E.!����R��9 ?�U�?D��Z��,��
HT�^BL�9�1��:p�xp�nԚj+B�Ͼ������ȔO�r�^������+�k?t�e?��/��o���w�&�ݦ�u�6X�gI�8�7�GEIZ�	��!�����!��u�玈 v��Jkϗ{��\�1!N/�����H�W<\���!
=W���������N�9�%�M�>Q�7s�.�MDHC�o85�|G�����G�O䚓�I(��'Z�����t�A�WBX<����$7�w��(/�    ����&�e��3ę"��z��/v���_����s��m��/�HA>�l�����[�cG[$ȴ:�b���YQ���;�V�.}~�� ���������Oac4��8|����R
��<�2��<�v��̯�E	Kg�T02�IC(28�2��ՍA�Z��V�����*|�9��y�/t�s�*k%�D5,p�)Z��OQ�4�
F.k@� QA8�K��]��YkFP�N��K�O\�qx��]鈟(��G���ϒ��a$�P��TG�!ށ�}H��hi�����2�1U�\cDUf <��& ��.��+
��Q������O4`�!X�T�	�_'�YG|T�7�w8��]G�n�	Ez�wYXG�"+�&|����Թ�F���Q�ँ��}7���r0�]-%�D��d&����{`����"� L_�:A^���c=�@~:�Y��6�tP+Z"{��f�rTw������5/��PUA��f�B.�Dx�dZ@n�q=5\J�$�dK.�&[\�O����u�[���LxUq�h��	3�A��/�6�ễ1�S�%x��F ��rDЬq�:�B��K�/�z����PhR����V�#u��Upk��������t�-Z�i�*T��E��r{��@b��H�m�;����D��'���a�,a���l���H�3�LԪ��Y��,�F`�%Wպ�x|�`<�<�yf�`�&A�a�E�z_����8���<˵ֆ'�*W�rNф�"��c.�voJ�s��AF�}��V�����QAĢ�v��d�˰e{gcB�^�}�ee��B(�����0�c���[��gWl���8è���H�y���<A|��%�L���%��Y�F+�n�w/Ԫ1Y�yB(�jN����V��&n� �[�Dv�$Z�r�ه�x4faM�9�B{V������3�F�2Ƃ��,� � �`յ+|�B������n��?ʚ+��y��݁�}UO<xю�*����SH�|LĎGb�K�H��ϝ�@M�>¬^pŶ����w��8�Z��ރq Kc��V@�\�{��Gt�Ch�f�p�lĻ��*8a�vSM�St��/��Le�t>K�׺Q*�g�z��S�B8�S��W�H��>��("�,A�����E��L�..�>.�e71�]�$����eBcM�� q=�!Lix��{� p��W��&G�Q�@����.���Vz�����1i�����X�6��/|����[#�����>Υb�	���ޟ�/��$��g X��,*
��ຬ�[*�>���g�ఝ�oĥoUɞ2��@?��aCZ�@RM�t�1�ٍEz`�@��*��@��<��txU�UL�	���[�*�����R��ssU��{�&��"���FV[ sU�m�C/Nnd⤩�8b�[k��p�fi��@�H�{^/�y��Г��z�`b�` ��T������i�fv(w�x�I�j�)��$�XC�:}x&� x�����!�:.�Y�`L9�/�))V�jQY����׋2���6�٘��S��c��,�t����a#	�~���m��L��^�OϹ����Px����B=��&^���Д�H:��<G�jf?�����v�^w����pk� ��ݥS���e��9�Lٟ?ih3 C�����#/0Z��gJ3�,�Y��f~ݞ)
�	� @q�8�2=�������-7��V��3�)��T+���ּV�8�`aYw�ܭz���$����n��U;��\*��(L����(|�kzi\��(�Aw-�i^�0���%N��r�
���\Ǆ��f1����q_]U�'2�U���.�a�;���������n��*7��FK�	Ip)�5q��ԁY�����	�HU��C�Z�F�p�c���?i��1CF!��ɸ}ɑ�_b�8���K�z��P֯��G��|�ͩX��ݏ�
ǲ�[4ST������B�3���<I���*�|�I �d�	�T�b_
!/�L��']�tDUc��u�%�"<"��¸قX��.��u��S'i�� H��y��M&tEy0z|������-��iS���jI�Qg��4N�,�qE�!2s� CBӏb�Pk,ٹ��Bإ�I�Zru o��2��M��cĶ�l����J>�o��/(x +�7�}r��0�#��h"��t@�ט;
����A�<,������^D%�5�����ճ�>(�qU�XU�	�c����IC�xa�f�IW�,��B(/�H��-�Py�	!v���yD�����E{�N�i<a���Y8��kc�W���Cddșe9� 6(M_t��e��F]�ɒ�}��Mb����ɳc�e��!`��3�+��@#a���˭7����
�c6����E�dc�03OH^�pf��7-|Y���u#a(���&��	�{��"���'�<Յ�H�]Nu�I4���q�(YTni�_��P�z�t&8l�M��戌���kX�Y��@�͇� n�[_!��m�&4�ԜF����2��yZ��֥��]���QU#���:M�m�j��&K�+��������f_�8E�,�O/���Z��fy�	q�I��v���UUh�w/��o��i�I�,�1�C�7�k�ܛ%�Nv8��wywb�,�j�&�Ȫx��U��&��R+ *��L�����9&����S��V��8,�����!�S��S��T��NW��˥�G$�Fe2�MThPB.}Wȯ�G-7�d./�hY�jH���+8%z
���R�%FL+ƨ{*�� �,I���؀>8`L�|�%*)ibY�����'�3%�;��?�V�DX���^�t>+&;��P�p�����c��
���U��c�)��[�&]���"�|��^IP9�w�7R���B��(|���y�oQ�z�z$��ș�-0��V�@�+$�0 ��	����3�c^<�R��[�k�A��5���t�iY�&������z������2�l)�/�K}#s�\�:��I�O���Ks>m�Հ� �s��~~\����ne��X�K	@v[͛�/6Вn<#���~N<�u�Ot�XOk]`���(&�������L�?2��/�^~M�P�~����Y���I��i`#Qc� �g�H � ��1d {��H:���,P-$��qV$x�<��
]��[p��[��]�Hr�#0����ީ�g$��H��=�!ְ���3T2az�Njko�#�0��
�̋6� ��:���:�n�1�<�j�^��_��ZЕ�P�L�\�(^�t׭Vj�Imf0BWS��ی�O��%�
��L��|ܫ�j�h�����-�;�`��.ض��&R���NqUN�9t�e�k��uv���0M&Qgf��j��
�~�óԠ�pb���G	�\O�m��`��(Oo{�z�?�&�|�%΂��KRS�PkB���?�C�U	�
�+ՕFcBZC�8H|��C/�hAG'��r���d�t�i�N���@�����/ўd����G��,�鲆�d�����,N���VɁϰ�eK�X��s�����>�"yl�����/pU�pLa@�%�j�����ނ�n%�-߁�2�OQ3����9`�:A��fUZU�`y��1�(���D�-���,��LH6�|۩�6O����H��4R֒�Z����N�9�0��fb�ܔш`(�Oam����W�A���2�e�)	Xm�����
�\�[f	r�	��:�:`��o0��[ٺV�`j�c�.T��`'v���	z�����,w2�G��=�厫�'g
'�I_�Wr@���ߚ;ָ�`
^w��jp��V���*�0��*Ex���� �{Րx��'3!"[����1���خZj4"���rb[ŔU�Q&z�>�G ��K�Y����D��ȭp�.d�
I��Z�!�(��=|�/hս����jx&L}���~�����C�?���n!ܵ&���������J����ZJNLk��v@hc\�pܲ�IY�K}׎������Th�D�E�sE��Mw2��`� �  G��R�vўk齶����K�'��w�!���V��Vz,M=}Li�o��� Q��^7,��LC�S����;�}���'4]$,J}��Z"TĽ1"I�/jt�jacx�V�kwG���cl��,d߻O��Ҵ&d�ߣ�*
�Jϋ�9�1B�B�f���aCsF�t�}�x���F����.V�[q�
��?��'#���I^N��6��?���~}�o�@���B`&� y0OP&泡UF*9����^�z�ͩ�f��N3�nF���������������A1>�d�h��[p�#�c�Dc~z��	����ݚ�J��b�HM�����>�9AP���BW��1쵨�6�m4�5;��2�ћi���͢b��C���"鵄�{ǭr��M������1�}"���T�����K�ў�V{�̝1F���g��#B�T��T��<4�]�g�ay6�P?K��g0�b�Vv�4�����4���f�u���ݚб��0>��%n�c�r7{�epX�'"��uw�^�b����u%A�:�t�V�醛T��T�:ˡ�gRL�>(����#^v}>�;��w�~�]g��xa++�%��հ���:{t��dyky�z(�
N��*m�y �9Y��x}�R�V�̈�P�۶�u�5�_�}��A}�T>�V���⓸Z�>�7��`���B�h~.�!(h������;������(��6����@Uc��#�F�PO]�p���œ��.<�aT��Fi�n��l.��b�o<�]������f1tR�Z	 �ê<��@���v�u/�	��+nI� `�"A&9�%u@0A�H81£B���z�W�s�|Mk*��ɼ�
`ĪiG���O��5�;�d�
j k�8�7U�`q�.EX6�.���9[7/�5J[�I9��Y�T�O���'>���@����%K2b�pV���i6jr|��E�{��h�."j#$G�j���߈Z䉴B��մR��F�^&��^���h'���H�U��Y8#�&NٯT�����Ї��๹�)06J��Y%k�����sc�}����t����z�H�&��
*!���=���C*�C���<�o�JF�<��m9�p�/��}�Ep-��,j���[[��z���e%C���%C1�,8X�u���v�V漁��l$&�9��"�2�L#_e�}�:B^��,|;g�oG�d��/���KS'�;^��1������}���w,B��m�7w\���N1"!�D'��6�9�E|8�LկĐ1gb6і7�O�"'�]�߼#�� �m���7w5��A�<y�����=�wOH ���i�'$l+��������$tUwUWwu�6 .��Ǟ��ߪ�����0c�/G�0q��ThiO��"��m�@&�������ۗ0ELӌ`�:� e�1�������Y���#��������_��1m�B#�X֎��ſ9���<��q���UCo���FD����R|���zRQ�	^qŉh/��W����#H}���v��]�̞��#�h��?�x&��9E����H�!G�}(X����]�[|	�j��'�\����
�ϭK���ػ�S���3�6��O�owV��r����/�����Bv��1�^��ð?�����nk|�m?\l��������;��]�5�,`]+�1	� 1��l������'�:r�¹Y�3eX��d�0���ѩ��H/�G���y������a� �j����Nh��U㨑`�@G�! F��#<����>�U�`�#��l�`�LQz�J�_*s��T���x�����B#=$pt�8�'ɂ��)d0�!M�z]���S`��k��ܐ6z.��Q���b=�y�.?/���~k�`���g5+`�jk��z>��! ��3�p
���\ٜBqH	����v�'�Ϙ�cK�9�tʀ������72뤏��I����#��̿�u_W�'Eb�A���EHꪚT4ip��?�ρ�c�Y�i�9�ZM%Ha�;�[��I��#��6�q>eZ}�8���>��=_��[3 U�������C`:�B���;_���Ҁ�ƊdцL���oN:��B�^���'�,|5bӛg�Wّ0K�����Hu�FZ74�>X��]h�Wv�>9h�Jk��9T0�T�� d�hDZ=Q��&W(� ���v��d��l��qG%ռ�:�>D.c.c�Xt�5x}�	�w6��n$�kP��[���Ѩ������ǂ�|�{(JV
�i���6�j9�]�	r.h�����5LI�Ɲ��e�I����~V~3S<QӍLN�UZg��Z1c���nc��6���b��czV0��?+�t�:Nt9 �D�CdnѼ;�!�|qc^�%f󽪘�+���J����!�d[�h�!�va?����ssa�6N �+�]&,��N��m�R5mW��&��l(�������1&��R��Rp�E��l?�
CT��S?�����}]�ц�{Z�h6b$"j]&1U�t��dw���8�-�؆��W�G݀���Qk��b�V�`� c���h�B̓2=���3x��̲���� E��,g32JBD��3��DŮ��0�3�P�s��ZP�H��g��/��t����k���"ђ�	1�q���dqbX͋�Z���s����*%�~�J���i��k��Rm�=��(�P\����cr����ޯ6ݬOa+�����Q��q��"��OB���%��z���^��� ��̀e� ���	ҙ���F��UI�w޵%�$QE�&�L���M}��	�i��uݘ�����Zv�����U:���q��K|) �W/��T3���ļK�/o�WKH�PG$�x�9�ӓ]^�N�5)/c�����S ����K����!,�f1�T̉z��[��£�{52�e!�i�7��������������      �   �	  x�u�ͺ�����U8۽9OD��^΄(�,<�Ig]��0Ƥ��IU�P�oά�N0�Ϗ�<��#�
�
����-.�(T'M�� ۠��o��9�뉸bAa�H͔�pK���N�Z�o7����B���l��5T��Q:�s��0�����3��l��˩��)?0$]�b��$5}�f�R[r�����8E��78,�=��t�<gg�B*�L��N��:����M���ؠ�23�6�w�pt��O������YO#�س��R8s�1Upv�i�␳����-tŁ�"���lTq~Q1#GA\\Ԭ�>z���S�@4����$��r�.��*(��2g�=rv�}�ګQHj��dg�����Bo]�b�9R��S�l��/4=ˆi��.{���!ǲWE��]U�Y�|����TG�%�f����5F"��w���k�eG�vdF9��b�2	�j�� ��r���Β,Sq��'Ě���͝�qL���l��[�6�}�CF@{`����U^�?���:���|��V���S�p2�>��Q)5jh�U�Z'E��\_�;TJ��=B��^��
���L$�j��oq�4��q��lԀu<������>0T��Qd�u�|<��ե�e�z�;1��i{��W�Q5�dW.�B�Dk��O��s681N�P9j��
�yg1ޱ@��)D�`gZv�%���͆l�X�Vۢ����K�$B8Y�HE"n vJf.i�����4w�'M:HÙ�#Ed�2��ñ)���n^2�{RG�b1$�Vk����HS3G��!bT(��t���U��|�g7�nV��"�����oG�)%����SJ#��MH���@O�X^i��Kv��n�F{�_7{��dIdR�N�b_3�Sk�!�ݣ���I���n�a�0p8���%xO�f�,Iv��ѥ����",��H����e������ّ���r�c`,#M��%N���c�1[Gs6fu��{���&G�󁶗�5�r�$nyX� uDy�;��5�R��Cr�V��)��:r�}�*�l~�]Ō?w�)�Xғ3 2�J� �2������@�1�d�Z��[9~K������$6�ܒ�%���Kd��>ԆT�4�Ad-J!�R9p̺��~c}A� ��'$e�� �놊]^.b�@v3��P&�Ȕ/L&�ɀ .��%CF�2�:)���O2�*��fg�>�s��u@��2�=����S��L�U�M��s��-��1e����n�TZ���5���]sf���B%A�Qq�.Ҩ9���}�xyi�����)�.��n�Z���w9gu�I\�f�퓖?�YwT|`���B-[EdU"������9"����<z�M��O��h�Cg��@s��Y*�K��H����c�Џ�z�{���b���,	� R���e1��'�8/Ҝ��3 �|�+�GC �0�"��P�'�2뜸���6a�.�U0���%��y�hP@K��z��`O����]� IP&���%Z �u֭0ɆA}'=�࠿16eO" ���V�D^��+�+�7����[�����GO[7K���K��'�6H�!>W��W��{h�Ra���_��d��b�#_��Q���P��`�4?���NN�TZ����J��贌s��ط?���O��@t9}�w�X�Ha��$�='PpB��&���T��~�Z������KA- <�okj�x�{`rx� Lb�֐��A��>N��|)
A�?XXjE����+�0�)���ʨ��c�����@ē���T��4 ��i �B��9���nT�����7��ji'D;�*,"k� }%^.vsq����� ��k��\�(GCў�mr߄�uB�7�)hPF
��|E$*�i�x傎���*��U��7�%-h���v�g�x 8�O˭g;8+�1����r�HSy�`���t��[c�Ɂ��R1��^k*/�0�_Q���Ct��?L�����D��
��+`T�o]����*=`�e��?�dک_���+�sP�s'M�^H�|��s��*�mM�!�����U��]��T0����^�i��ݤW�\����ij��z\�n�  C�Z�%	;p!��z}��j���u � �?晅P-k�Op�������cK�AL��Dn�u���4�|��x�'��c~�8���kT}_0�"�>\cp "�ˋL&e^ǁ8 !^�h�gh0�"<��׳�R��	�b�����Ձ�Z�q��|���E�N�ct[�x|���5�K��@�y� ���g�෺�M��눩E�mW/E�nx��51j�+<�x�L�y�GA1ck��+����a6:���E2e���w5v�;�:`�z1����p�� �'1<�����0��h����D%X����A��ϯ_��3�}     