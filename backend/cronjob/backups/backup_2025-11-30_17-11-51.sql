--
-- PostgreSQL database dump
--

\restrict rn1degQ2gD36RD4PoHHGnhrD7Knm3NliyeikaiF83S4wIzVtdCIC7CR8a0bvnBM

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bienvenida_notificacion_func(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bienvenida_notificacion_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Notificaciones (
        IdCuenta,
        Asunto,
        Descripcion,
        FechaHoraEnvio
    )
    VALUES (
        NEW.IdCuenta, 
        '¡Bienvenido/a a nuestra Cafetería!',
        'Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.',
        NOW()
    );

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.bienvenida_notificacion_func() OWNER TO postgres;

--
-- Name: obtener_datos_usuario_por_email(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.obtener_datos_usuario_por_email(p_email character varying) RETURNS TABLE(nombre_usuario character varying, email_cuenta character varying, contrasena character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        (CASE
            WHEN E.Nombre IS NOT NULL THEN E.Nombre || ' ' || E.Apellido 
            WHEN CE.RazonSocial IS NOT NULL THEN CE.RazonSocial 
            ELSE 'No Asociado'
        END)::VARCHAR AS nombre_usuario,
        C.Email AS email_cuenta,
        C.Password AS contrasena
    FROM 
        Cuenta C
    LEFT JOIN Empleado E ON C.IdCuenta = E.IdCuenta
    LEFT JOIN ClientePersona CP ON C.IdCuenta = CP.IdCuenta
    LEFT JOIN ClienteEmpresa CE ON C.IdCuenta = CE.IdCuenta
    WHERE C.Email = p_email
    LIMIT 1;
END;
$$;


ALTER FUNCTION public.obtener_datos_usuario_por_email(p_email character varying) OWNER TO postgres;

--
-- Name: sp_crear_nueva_cuenta(character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_crear_nueva_cuenta(IN p_email character varying, IN p_password character varying, IN p_rol character varying, IN p_estado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Cuenta (
        Email,
        Password,
        Rol,
        Estado,
        FechaRegistro
    )
    VALUES (
        p_email,
        p_password,
        p_rol,
        p_estado,
        NOW()
    );

END;
$$;


ALTER PROCEDURE public.sp_crear_nueva_cuenta(IN p_email character varying, IN p_password character varying, IN p_rol character varying, IN p_estado character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: caja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja (
    idcaja integer NOT NULL,
    idsucursal integer,
    fechaapertura timestamp without time zone,
    fechacierre timestamp without time zone,
    estado character varying(20)
);


ALTER TABLE public.caja OWNER TO postgres;

--
-- Name: caja_idcaja_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caja_idcaja_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caja_idcaja_seq OWNER TO postgres;

--
-- Name: caja_idcaja_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_idcaja_seq OWNED BY public.caja.idcaja;


--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    idcliente integer NOT NULL,
    tipocliente character varying(20) NOT NULL,
    idclientepersona integer,
    idclienteempresa integer
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: cliente_idcliente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cliente_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_idcliente_seq OWNER TO postgres;

--
-- Name: cliente_idcliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_idcliente_seq OWNED BY public.cliente.idcliente;


--
-- Name: clienteempresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clienteempresa (
    idclienteempresa integer NOT NULL,
    idcuenta integer,
    ruc character varying(20),
    razonsocial character varying(150),
    direccion character varying(200),
    telefono character varying(30)
);


ALTER TABLE public.clienteempresa OWNER TO postgres;

--
-- Name: clienteempresa_idclienteempresa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clienteempresa_idclienteempresa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clienteempresa_idclienteempresa_seq OWNER TO postgres;

--
-- Name: clienteempresa_idclienteempresa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clienteempresa_idclienteempresa_seq OWNED BY public.clienteempresa.idclienteempresa;


--
-- Name: clientepersona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientepersona (
    idclientepersona integer NOT NULL,
    idcuenta integer,
    dni character varying(8),
    nombre character varying(80),
    apellido character varying(80),
    direccion character varying(200),
    telefono character varying(30)
);


ALTER TABLE public.clientepersona OWNER TO postgres;

--
-- Name: clientepersona_idclientepersona_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientepersona_idclientepersona_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientepersona_idclientepersona_seq OWNER TO postgres;

--
-- Name: clientepersona_idclientepersona_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientepersona_idclientepersona_seq OWNED BY public.clientepersona.idclientepersona;


--
-- Name: cuenta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuenta (
    idcuenta integer NOT NULL,
    email character varying(150) NOT NULL,
    password character varying(180) NOT NULL,
    rol character varying(50),
    estado character varying(20),
    fecharegistro timestamp without time zone,
    alias character varying(255),
    direccion character varying(200),
    fechanacimiento date,
    pais character varying(100),
    telefono character varying(12)
);


ALTER TABLE public.cuenta OWNER TO postgres;

--
-- Name: cuenta_idcuenta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuenta_idcuenta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cuenta_idcuenta_seq OWNER TO postgres;

--
-- Name: cuenta_idcuenta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cuenta_idcuenta_seq OWNED BY public.cuenta.idcuenta;


--
-- Name: detalleventa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalleventa (
    iddetalle integer NOT NULL,
    idventa integer,
    idproducto integer,
    cantidad integer NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    CONSTRAINT detalleventa_cantidad_check CHECK ((cantidad > 0))
);


ALTER TABLE public.detalleventa OWNER TO postgres;

--
-- Name: detalleventa_iddetalle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalleventa_iddetalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalleventa_iddetalle_seq OWNER TO postgres;

--
-- Name: detalleventa_iddetalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalleventa_iddetalle_seq OWNED BY public.detalleventa.iddetalle;


--
-- Name: empleado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleado (
    idempleado integer NOT NULL,
    idcuenta integer,
    nombre character varying(80) NOT NULL,
    apellido character varying(80) NOT NULL,
    cargo character varying(60),
    fechacontratacion timestamp without time zone
);


ALTER TABLE public.empleado OWNER TO postgres;

--
-- Name: empleado_idempleado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.empleado_idempleado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.empleado_idempleado_seq OWNER TO postgres;

--
-- Name: empleado_idempleado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.empleado_idempleado_seq OWNED BY public.empleado.idempleado;


--
-- Name: notificaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notificaciones (
    idnotificaciones bigint NOT NULL,
    idcuenta integer,
    asunto character varying(50),
    descripcion character varying(300),
    fechahoraenvio timestamp without time zone DEFAULT now()
);


ALTER TABLE public.notificaciones OWNER TO postgres;

--
-- Name: notificaciones_idnotificaciones_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notificaciones_idnotificaciones_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notificaciones_idnotificaciones_seq OWNER TO postgres;

--
-- Name: notificaciones_idnotificaciones_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notificaciones_idnotificaciones_seq OWNED BY public.notificaciones.idnotificaciones;


--
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    idproducto integer NOT NULL,
    codproducto character varying(255) NOT NULL,
    nombre character varying(255) NOT NULL,
    categoria character varying(255),
    stock integer DEFAULT 0,
    preciocompra numeric(38,2),
    precioventa numeric(38,2),
    fechavencimiento timestamp(6) without time zone,
    CONSTRAINT producto_stock_check CHECK ((stock >= 0))
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- Name: producto_idproducto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_idproducto_seq OWNER TO postgres;

--
-- Name: producto_idproducto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_idproducto_seq OWNED BY public.producto.idproducto;


--
-- Name: purchase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase (
    idpurchase bigint NOT NULL,
    address_delivery character varying(255),
    city_delivery character varying(255),
    total_amount numeric(38,2),
    idcuenta integer NOT NULL
);


ALTER TABLE public.purchase OWNER TO postgres;

--
-- Name: purchase_idpurchase_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.purchase ALTER COLUMN idpurchase ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.purchase_idpurchase_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: purchasedetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchasedetails (
    id bigint NOT NULL,
    quantity integer NOT NULL,
    idproducto integer,
    idpurchase bigint,
    instructions character varying(255)
);


ALTER TABLE public.purchasedetails OWNER TO postgres;

--
-- Name: purchasedetails_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.purchasedetails ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.purchasedetails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    idreview bigint NOT NULL,
    cuerpo text NOT NULL,
    email character varying(150) NOT NULL,
    nombre character varying(100) NOT NULL,
    puntuacion integer NOT NULL,
    verified boolean NOT NULL,
    idcuenta integer
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- Name: reviews_idreview_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.reviews ALTER COLUMN idreview ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.reviews_idreview_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sucursal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sucursal (
    idsucursal integer NOT NULL,
    nombre character varying(100) NOT NULL,
    direccion character varying(200)
);


ALTER TABLE public.sucursal OWNER TO postgres;

--
-- Name: sucursal_idsucursal_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sucursal_idsucursal_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sucursal_idsucursal_seq OWNER TO postgres;

--
-- Name: sucursal_idsucursal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sucursal_idsucursal_seq OWNED BY public.sucursal.idsucursal;


--
-- Name: venta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta (
    idventa integer NOT NULL,
    codventa character varying(40),
    tipocomprobante character varying(40),
    fechaemision timestamp without time zone DEFAULT now(),
    cantidadproductos integer,
    total numeric(12,2),
    formapago character varying(40),
    idcaja integer,
    idempleado integer,
    idcliente integer
);


ALTER TABLE public.venta OWNER TO postgres;

--
-- Name: venta_idventa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.venta_idventa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.venta_idventa_seq OWNER TO postgres;

--
-- Name: venta_idventa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.venta_idventa_seq OWNED BY public.venta.idventa;


--
-- Name: caja idcaja; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja ALTER COLUMN idcaja SET DEFAULT nextval('public.caja_idcaja_seq'::regclass);


--
-- Name: cliente idcliente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente ALTER COLUMN idcliente SET DEFAULT nextval('public.cliente_idcliente_seq'::regclass);


--
-- Name: clienteempresa idclienteempresa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clienteempresa ALTER COLUMN idclienteempresa SET DEFAULT nextval('public.clienteempresa_idclienteempresa_seq'::regclass);


--
-- Name: clientepersona idclientepersona; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientepersona ALTER COLUMN idclientepersona SET DEFAULT nextval('public.clientepersona_idclientepersona_seq'::regclass);


--
-- Name: cuenta idcuenta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuenta ALTER COLUMN idcuenta SET DEFAULT nextval('public.cuenta_idcuenta_seq'::regclass);


--
-- Name: detalleventa iddetalle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalleventa ALTER COLUMN iddetalle SET DEFAULT nextval('public.detalleventa_iddetalle_seq'::regclass);


--
-- Name: empleado idempleado; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado ALTER COLUMN idempleado SET DEFAULT nextval('public.empleado_idempleado_seq'::regclass);


--
-- Name: notificaciones idnotificaciones; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones ALTER COLUMN idnotificaciones SET DEFAULT nextval('public.notificaciones_idnotificaciones_seq'::regclass);


--
-- Name: producto idproducto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto ALTER COLUMN idproducto SET DEFAULT nextval('public.producto_idproducto_seq'::regclass);


--
-- Name: sucursal idsucursal; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal ALTER COLUMN idsucursal SET DEFAULT nextval('public.sucursal_idsucursal_seq'::regclass);


--
-- Name: venta idventa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta ALTER COLUMN idventa SET DEFAULT nextval('public.venta_idventa_seq'::regclass);


--
-- Data for Name: caja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja (idcaja, idsucursal, fechaapertura, fechacierre, estado) FROM stdin;
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (idcliente, tipocliente, idclientepersona, idclienteempresa) FROM stdin;
\.


--
-- Data for Name: clienteempresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clienteempresa (idclienteempresa, idcuenta, ruc, razonsocial, direccion, telefono) FROM stdin;
\.


--
-- Data for Name: clientepersona; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientepersona (idclientepersona, idcuenta, dni, nombre, apellido, direccion, telefono) FROM stdin;
\.


--
-- Data for Name: cuenta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuenta (idcuenta, email, password, rol, estado, fecharegistro, alias, direccion, fechanacimiento, pais, telefono) FROM stdin;
17	gaylin773@gmail.com	$2a$10$Ai3cQ.bEyIZgfoZicvnse.B1/veXYOtulq9Y3tx0zGVSB6JU91Sdm	ADMIN	ACTIVO	2025-10-25 19:06:06.599346	Aylin	Av. Principal 123	1990-05-12	Perú	\N
1	periquito2	$2a$10$CT8dx/H.XnWn4T4rgWb2xORKdBBhOWvuxckqVP2jfjNUHr7yjjxNy	CLIENTE	ACTIVO	2025-09-29 02:32:30.801936	Nameless User	\N	\N	\N	\N
2	periquito3	$2a$10$2l1EaHGFwXoKWcOEnKNbS.NVgT5U.JCUSk3UOR6vtz6NIx5UjE3qa	CLIENTE	ACTIVO	2025-09-29 03:57:27.867375	Nameless User	\N	\N	\N	\N
3	pedrito@gmail.com	$2a$10$eMamCawLfKGQY6Es7kNhCOpcBAzmRH83Op/CD0yMm1JJcgFZdhs72	CLIENTE	ACTIVO	2025-09-29 18:33:23.575057	Nameless User	\N	\N	\N	\N
4	pedrito2@gmail.com	$2a$10$fvpuJGcXTHPqo5QZ6BoQw.uHrKKZgczhfDFmFcYP2WaBA6ZJuVRVS	CLIENTE	ACTIVO	2025-09-29 18:33:56.446011	Nameless User	\N	\N	\N	\N
8	AWA@gmail.com	$2a$10$CBPEnsiV4Fgk5xHdx6LBF..nziquC.NcyClX1hq75iv1Dk8CtkW8a	CLIENTE	ACTIVO	2025-09-29 18:37:36.652196	Nameless User	\N	\N	\N	\N
9	tallarinconpollo@gmail.com	$2a$10$.inAgryOr7tJgV5m2O4Oe.QVyiQhPlttBN6H.cefd0CRGIwNRhRMu	CLIENTE	ACTIVO	2025-09-29 18:52:00.069622	Nameless User	\N	\N	\N	\N
10	auxilio@gmail.com	$2a$10$NNOWYx7INMZj46c5v0qnOOVrXXMIaYO851GvRqcbczyKNdISCRKXy	CLIENTE	ACTIVO	2025-09-29 18:53:16.672718	Nameless User	\N	\N	\N	\N
11	hola123@gmail.com	$2a$10$WnCMWabHr3XSSplxiForiuFhxiB1TG2orfRElLjsT0Lt.hSPoNIoe	CLIENTE	ACTIVO	2025-10-02 14:12:10.406346	Nameless User	\N	\N	\N	\N
12	acuna@gmail.com	$2a$10$vUfNIrU3Yqb6fbt5qwMHCOcmy8ye40FznQ2DQ828X0we4uk5m19sO	CLIENTE	ACTIVO	2025-10-02 14:21:48.862881	Nameless User	\N	\N	\N	\N
13	pruebaaa@gmail.com	$2a$10$mvRQ2KsE4.FS24z4tZw8KO.4bmE7cRgzxCqrddt7.OrkxeJaqRedS	CLIENTE	ACTIVO	2025-10-02 14:22:47.065164	Nameless User	\N	\N	\N	\N
15	pepe@gmail.com	$2a$10$lRQutVGtANDhv/pM0oglG.rHzJl6oWFlVHnIfMa2.1yPqQoyaa36S	CLIENTE	ACTIVO	2025-10-24 20:51:22.924889	Nameless User	\N	\N	\N	\N
16	pepe@pepe.com	$2a$10$53HIqA.5X27S0/Kb0IQH5O6HC.cwkdHy1t1FlbnG3jYtT9WPLwOMa	CLIENTE	ACTIVO	2025-10-25 01:42:11.766796	Nameless User	\N	\N	\N	\N
18	fernandez@gmail.com	$2a$10$B0xct5WkxEAV2wHYAcAJauoZTwqGjm4pq5AP8nppm5TxUsO3..YqK	ADMIN	ACTIVO	2025-10-28 02:55:21.937634	Nameless User	\N	\N	\N	\N
19	marcelocarmen0@gmail.com	$2a$10$WAE.VMruOx.lqeS9fkB9me4cCwNJZYgVpKs.dNqpdNNca.M.WBami	CLIENTE	ACTIVO	2025-10-28 20:49:36.880346	Nameless User	\N	\N	\N	\N
20	marcelocarmen9@gmail.com	$2a$10$bs3ou2uA1xEmQY3n.ns7zuJgzWqtBXsIHvE63ciKX/XGk5bb2jYq2	CLIENTE	ACTIVO	2025-10-28 20:52:15.939344	Nameless User	\N	\N	\N	\N
21	pruebini@gmail.com	$2a$10$estdgLP164.9sjeDJTVN0.ru8Ozd3/Dxv3LQqYY3XMvQvvpYp5AbC	CLIENTE	ACTIVO	2025-11-13 19:31:27.033024	Nameless User	\N	\N	\N	\N
14	angelolma2080@gmail.com	$2a$10$wwkB/nCEvZQH39lqAPEALON5cQIbqPN5bZwpsKtu6SbggO.s1dGTC	ADMIN	ACTIVO	2025-10-15 17:59:42.778001	Nameless User	\N	\N	\N	\N
22	pruebinii@gmail.com	$2a$10$iiabbGL85Qij5qbs9.j/cuWY58cG0KiACNNublxaLpexKKMvG7JNq	CLIENTE	ACTIVO	2025-11-13 20:29:30.258493	Nameless User	\N	\N	\N	\N
\.


--
-- Data for Name: detalleventa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalleventa (iddetalle, idventa, idproducto, cantidad, subtotal) FROM stdin;
\.


--
-- Data for Name: empleado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empleado (idempleado, idcuenta, nombre, apellido, cargo, fechacontratacion) FROM stdin;
\.


--
-- Data for Name: notificaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notificaciones (idnotificaciones, idcuenta, asunto, descripcion, fechahoraenvio) FROM stdin;
5	8	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-09-29 18:37:36.652196
6	9	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-09-29 18:52:00.069622
7	10	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-09-29 18:53:16.672718
8	11	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-10-02 14:12:10.406346
9	12	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-10-02 14:21:48.862881
10	13	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-10-02 14:22:47.065164
11	14	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-10-15 17:59:42.778001
12	15	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-10-24 20:51:22.945357
13	16	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-10-25 01:42:11.786795
14	17	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-10-25 19:06:06.637242
15	18	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-10-28 02:55:21.942751
16	19	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-10-28 20:49:36.920143
17	20	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-10-28 20:52:15.941805
18	21	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-11-13 19:31:27.072091
19	22	¡Bienvenido/a a nuestra Cafetería!	Gracias por registrarte. Tu cuenta está activa y lista para ser usada ♡.	2025-11-13 20:29:30.264424
\.


--
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (idproducto, codproducto, nombre, categoria, stock, preciocompra, precioventa, fechavencimiento) FROM stdin;
1	CAF001	Café Americano	Bebidas Calientes	50	4.50	7.00	2026-12-31 00:00:00
2	CAF002	Café Latte	Bebidas Calientes	40	5.00	8.50	2026-11-30 00:00:00
3	CAF003	Capuccino	Bebidas Calientes	35	5.50	9.00	2026-10-15 00:00:00
4	CAF004	Mocaccino	Bebidas Calientes	25	6.00	9.50	2026-09-01 00:00:00
5	CAF005	Café Frappé	Bebidas Frías	30	6.50	10.00	2026-08-20 00:00:00
6	CAF006	Té Verde	Infusiones	60	3.00	6.00	2026-12-01 00:00:00
7	CAF007	Té Chai Latte	Infusiones	45	4.00	7.50	2026-10-05 00:00:00
8	CAF008	Chocolate Caliente	Bebidas Calientes	50	5.00	8.00	2026-12-31 00:00:00
9	CAF009	Limonada Frozen	Bebidas Frías	20	3.50	6.50	2026-06-01 00:00:00
10	CAF010	Smoothie de Fresa	Bebidas Frías	25	4.00	7.00	2026-07-15 00:00:00
12	CAF011	PRUEBACCHINO XD	Bebidas Calientes	60	6.00	11.50	2026-09-20 00:00:00
19	CAF080	Café prueba 3	Bebidas Calientes	45	6.50	10.00	2026-09-15 00:00:00
37	CAF501	Croissant	panes	30	2.50	4.50	2026-10-12 00:00:00
38	CAF502	Pan de centeno	panes	20	1.80	3.00	2026-10-18 00:00:00
39	CAF503	Sándwich Panino	panes	15	4.50	7.50	2026-10-20 00:00:00
40	CAF504	Pan Suizo	panes	10	2.20	4.00	2026-10-14 00:00:00
41	CAF505	Sandwich Triple	panes	18	2.00	3.50	2026-10-16 00:00:00
42	CAF506	Pan Concha	panes	22	2.30	4.20	2026-10-19 00:00:00
43	CAF507	Pan Baguette	panes	12	1.50	2.80	2026-10-13 00:00:00
44	CAF508	Pan dulce oreja	panes	28	2.10	3.80	2026-10-17 00:00:00
45	CAF509	Pan con pavo	panes	14	2.80	4.75	2026-10-11 00:00:00
46	CAF510	Sándwich Eggmont	panes	16	2.10	3.60	2026-10-21 00:00:00
47	CAF101	Muffin de Vainilla	muffins	20	2.50	4.50	2025-12-05 00:00:00
48	CAF102	Muffin de Chocolate	muffins	18	3.00	5.00	2025-12-03 00:00:00
49	CAF103	Muffin de Fresa	muffins	15	2.70	4.80	2025-11-28 00:00:00
50	CAF104	Muffin de Blueberry	muffins	12	3.20	5.20	2025-11-30 00:00:00
51	CAF105	Muffin de Manzana	muffins	14	2.80	4.90	2025-12-02 00:00:00
52	CAF106	Muffin de Canela	muffins	16	2.60	4.70	2025-12-04 00:00:00
53	CAF107	Muffin de Limón	muffins	13	2.70	4.80	2025-11-29 00:00:00
54	CAF108	Muffin de Nuez	muffins	11	3.40	5.30	2025-12-06 00:00:00
55	CAF109	Muffin de Arándano	muffins	17	3.20	5.10	2025-12-01 00:00:00
56	CAF110	Muffin de Coco	muffins	15	2.80	4.90	2025-12-03 00:00:00
57	CAF111	Torta de Chocolate	tortas	10	4.50	7.50	2025-12-08 00:00:00
58	CAF112	Torta de Fresa	tortas	8	4.50	7.50	2025-12-07 00:00:00
59	CAF113	Torta de Vainilla	tortas	12	5.50	9.00	2025-12-10 00:00:00
60	CAF114	Torta Red Velvet	tortas	5	8.50	15.00	2025-12-09 00:00:00
61	CAF115	Torta Selva Negra	tortas	6	6.00	10.00	2025-12-06 00:00:00
62	CAF116	Torta Tres Leches	tortas	15	5.00	8.50	2025-12-05 00:00:00
63	CAF117	Torta de Zanahoria	tortas	10	5.00	8.50	2025-12-11 00:00:00
64	CAF118	Torta de Maracuyá	tortas	12	4.50	7.50	2025-12-04 00:00:00
65	CAF119	Torta de Limón	tortas	14	4.50	7.50	2025-12-07 00:00:00
66	CAF120	Torta de Coco	tortas	11	4.50	7.50	2025-12-09 00:00:00
\.


--
-- Data for Name: purchase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase (idpurchase, address_delivery, city_delivery, total_amount, idcuenta) FROM stdin;
1	Los Olivos	Lima	80.50	17
2	Los Olivos	Lima	80.50	17
\.


--
-- Data for Name: purchasedetails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchasedetails (id, quantity, idproducto, idpurchase, instructions) FROM stdin;
1	5	3	1	\N
2	5	2	1	\N
3	3	1	1	\N
4	5	3	2	Con extra leche
5	5	2	2	\N
6	3	1	2	Sin azucar
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (idreview, cuerpo, email, nombre, puntuacion, verified, idcuenta) FROM stdin;
1	Me gustó el cafe :D	pepito@gmail.com	Pepito	5	f	\N
4	Me gustó el te :)	gaylin773@gmail.com	Pepito	5	t	17
5	FEO TODO	Arturito@gmail.com	Arturito	2	f	\N
6	Me gustó el te :)	gaylin773@gmail.com	Pepito	5	t	17
7	HORRENDO	Periquito@gmail.com	Periquito	1	f	\N
8	Bien	gaylin773@gmail.com	Aylin	4	t	17
9	HORRENDO	Pruebini@gmail.com	Pruebini	1	f	\N
10	Bien	gaylin773@gmail.com	Aylin	4	t	17
11	Buen lugar para cafe	gaylin773@gmail.com	Nameless User	5	t	17
12	NICE	Hola@gmail.com	Hola	3	f	\N
13	Nunca me canso del cafe	gaylin773@gmail.com	Nameless User	6	t	17
14	Tengo sueño	gaylin773@gmail.com	Aylin	2	t	17
\.


--
-- Data for Name: sucursal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sucursal (idsucursal, nombre, direccion) FROM stdin;
1	Le Pettite Coffee - Miraflores	Av. José Pardo 610, Miraflores, Lima
2	Le Pettite Coffee - San Isidro	Av. Javier Prado Este 3200, San Isidro, Lima
3	Le Pettite Coffee - Barranco	Av. Grau 210, Barranco, Lima
4	Le Pettite Coffee - Surco	C.C. Jockey Plaza, Av. Javier Prado Este 4200, Santiago de Surco
5	Le Pettite Coffee - La Molina	Av. La Fontana 755, La Molina, Lima
6	Le Pettite Coffee - San Miguel	C.C. Plaza San Miguel, Av. La Marina 2000, San Miguel, Lima
7	Le Pettite Coffee - Chorrillos	Av. Defensores del Morro 1800, Chorrillos, Lima
8	Le Pettite Coffee - Lince	Av. Arequipa 2390, Lince, Lima
9	Le Pettite Coffee - Callao	Av. Elmer Faucett 200, Aeropuerto Jorge Chávez, Callao
10	Le Pettite Coffee - Pueblo Libre	Av. Bolívar 950, Pueblo Libre, Lima
11	Sucursal Norte Renovada	Calle Falsa 123
13	Sucursal Pepito 2	Calle Pepeeeee 1234
14	Sucursal Pepito 2	Calle Pepeeeee 1234
15	Sucursal Pepito 2	Calle Pepeeeee 1234
\.


--
-- Data for Name: venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venta (idventa, codventa, tipocomprobante, fechaemision, cantidadproductos, total, formapago, idcaja, idempleado, idcliente) FROM stdin;
\.


--
-- Name: caja_idcaja_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_idcaja_seq', 1, false);


--
-- Name: cliente_idcliente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_idcliente_seq', 1, false);


--
-- Name: clienteempresa_idclienteempresa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clienteempresa_idclienteempresa_seq', 1, false);


--
-- Name: clientepersona_idclientepersona_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientepersona_idclientepersona_seq', 1, false);


--
-- Name: cuenta_idcuenta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuenta_idcuenta_seq', 22, true);


--
-- Name: detalleventa_iddetalle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalleventa_iddetalle_seq', 1, false);


--
-- Name: empleado_idempleado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empleado_idempleado_seq', 1, false);


--
-- Name: notificaciones_idnotificaciones_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notificaciones_idnotificaciones_seq', 19, true);


--
-- Name: producto_idproducto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_idproducto_seq', 66, true);


--
-- Name: purchase_idpurchase_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_idpurchase_seq', 2, true);


--
-- Name: purchasedetails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchasedetails_id_seq', 6, true);


--
-- Name: reviews_idreview_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_idreview_seq', 14, true);


--
-- Name: sucursal_idsucursal_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sucursal_idsucursal_seq', 15, true);


--
-- Name: venta_idventa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_idventa_seq', 1, false);


--
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (idcaja);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (idcliente);


--
-- Name: clienteempresa clienteempresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clienteempresa
    ADD CONSTRAINT clienteempresa_pkey PRIMARY KEY (idclienteempresa);


--
-- Name: clienteempresa clienteempresa_ruc_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clienteempresa
    ADD CONSTRAINT clienteempresa_ruc_key UNIQUE (ruc);


--
-- Name: clientepersona clientepersona_dni_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientepersona
    ADD CONSTRAINT clientepersona_dni_key UNIQUE (dni);


--
-- Name: clientepersona clientepersona_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientepersona
    ADD CONSTRAINT clientepersona_pkey PRIMARY KEY (idclientepersona);


--
-- Name: cuenta cuenta_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuenta
    ADD CONSTRAINT cuenta_email_key UNIQUE (email);


--
-- Name: cuenta cuenta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuenta
    ADD CONSTRAINT cuenta_pkey PRIMARY KEY (idcuenta);


--
-- Name: detalleventa detalleventa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalleventa
    ADD CONSTRAINT detalleventa_pkey PRIMARY KEY (iddetalle);


--
-- Name: empleado empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (idempleado);


--
-- Name: notificaciones notificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (idnotificaciones);


--
-- Name: producto producto_codproducto_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_codproducto_key UNIQUE (codproducto);


--
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (idproducto);


--
-- Name: purchase purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (idpurchase);


--
-- Name: purchasedetails purchasedetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchasedetails
    ADD CONSTRAINT purchasedetails_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (idreview);


--
-- Name: sucursal sucursal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal
    ADD CONSTRAINT sucursal_pkey PRIMARY KEY (idsucursal);


--
-- Name: venta venta_codventa_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_codventa_key UNIQUE (codventa);


--
-- Name: venta venta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (idventa);


--
-- Name: cuenta trg_bienvenida_notificacion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_bienvenida_notificacion AFTER INSERT ON public.cuenta FOR EACH ROW EXECUTE FUNCTION public.bienvenida_notificacion_func();


--
-- Name: caja caja_idsucursal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_idsucursal_fkey FOREIGN KEY (idsucursal) REFERENCES public.sucursal(idsucursal) ON DELETE CASCADE;


--
-- Name: cliente cliente_idclienteempresa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_idclienteempresa_fkey FOREIGN KEY (idclienteempresa) REFERENCES public.clienteempresa(idclienteempresa) ON DELETE SET NULL;


--
-- Name: cliente cliente_idclientepersona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_idclientepersona_fkey FOREIGN KEY (idclientepersona) REFERENCES public.clientepersona(idclientepersona) ON DELETE SET NULL;


--
-- Name: clienteempresa clienteempresa_idcuenta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clienteempresa
    ADD CONSTRAINT clienteempresa_idcuenta_fkey FOREIGN KEY (idcuenta) REFERENCES public.cuenta(idcuenta) ON DELETE SET NULL;


--
-- Name: clientepersona clientepersona_idcuenta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientepersona
    ADD CONSTRAINT clientepersona_idcuenta_fkey FOREIGN KEY (idcuenta) REFERENCES public.cuenta(idcuenta) ON DELETE SET NULL;


--
-- Name: detalleventa detalleventa_idproducto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalleventa
    ADD CONSTRAINT detalleventa_idproducto_fkey FOREIGN KEY (idproducto) REFERENCES public.producto(idproducto) ON DELETE RESTRICT;


--
-- Name: detalleventa detalleventa_idventa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalleventa
    ADD CONSTRAINT detalleventa_idventa_fkey FOREIGN KEY (idventa) REFERENCES public.venta(idventa) ON DELETE CASCADE;


--
-- Name: empleado empleado_idcuenta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_idcuenta_fkey FOREIGN KEY (idcuenta) REFERENCES public.cuenta(idcuenta) ON DELETE SET NULL;


--
-- Name: purchasedetails fk260hrbyws2sg7per1rmthu6yw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchasedetails
    ADD CONSTRAINT fk260hrbyws2sg7per1rmthu6yw FOREIGN KEY (idproducto) REFERENCES public.producto(idproducto);


--
-- Name: purchasedetails fk2ugay9ibmd0acylx45wbdx2xv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchasedetails
    ADD CONSTRAINT fk2ugay9ibmd0acylx45wbdx2xv FOREIGN KEY (idpurchase) REFERENCES public.purchase(idpurchase);


--
-- Name: reviews fkf282ntis7bdqnrpfeeojwdnav; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fkf282ntis7bdqnrpfeeojwdnav FOREIGN KEY (idcuenta) REFERENCES public.cuenta(idcuenta);


--
-- Name: purchase fkknd9dbyd3lna8rfif9ithynx7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT fkknd9dbyd3lna8rfif9ithynx7 FOREIGN KEY (idcuenta) REFERENCES public.cuenta(idcuenta);


--
-- Name: notificaciones notificaciones_idcuenta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_idcuenta_fkey FOREIGN KEY (idcuenta) REFERENCES public.cuenta(idcuenta) ON DELETE SET NULL;


--
-- Name: venta venta_idcaja_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_idcaja_fkey FOREIGN KEY (idcaja) REFERENCES public.caja(idcaja) ON DELETE SET NULL;


--
-- Name: venta venta_idcliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_idcliente_fkey FOREIGN KEY (idcliente) REFERENCES public.cliente(idcliente) ON DELETE SET NULL;


--
-- Name: venta venta_idempleado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_idempleado_fkey FOREIGN KEY (idempleado) REFERENCES public.empleado(idempleado) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict rn1degQ2gD36RD4PoHHGnhrD7Knm3NliyeikaiF83S4wIzVtdCIC7CR8a0bvnBM

