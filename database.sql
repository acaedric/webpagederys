DROP TABLE IF EXISTS PERSONA CASCADE;
DROP TABLE IF EXISTS POSTULANTE CASCADE;
DROP TABLE IF EXISTS IDIOMA CASCADE;
DROP TABLE IF EXISTS TECNICO_SELECCION CASCADE;
DROP TABLE IF EXISTS CONVOCATORIA CASCADE;
DROP TABLE IF EXISTS PUESTO_LABORAL CASCADE;
DROP TABLE IF EXISTS VACANTE CASCADE;
DROP TABLE IF EXISTS ADMINISTRADOR CASCADE;
DROP TABLE IF EXISTS EVALUACION CASCADE;
DROP TABLE IF EXISTS CONTRATA CASCADE;
DROP TABLE IF EXISTS RESPUESTA CASCADE;
DROP TABLE IF EXISTS VISUALIZA_CONVOC_POSTUL CASCADE;
DROP TABLE IF EXISTS TIPO_EVALUACION CASCADE;
DROP TABLE IF EXISTS INSCRIPCION_CONVOC_POSTUL CASCADE;
DROP TABLE IF EXISTS ESTUDIO CASCADE;
DROP TABLE IF EXISTS EXPERIENCIA_SECTOR CASCADE;
DROP TABLE IF EXISTS POSICION_DIGITAL_EJERCIDO CASCADE;
DROP TABLE IF EXISTS EMPRESA CASCADE;
DROP TABLE IF EXISTS CONTACTO CASCADE;
DROP TABLE IF EXISTS POSTULANTE_IDIOMA CASCADE;
DROP TABLE IF EXISTS POSTULANTE_ESTUDIO_FINALIZADO CASCADE;
DROP TABLE IF EXISTS PERSONA_NUMERO_TELEF CASCADE;

CREATE DATABASE prueba;
CREATE TABLE PERSONA
(
  Doc_ID NUMERIC(10,0) NOT NULL,
  apellidos VARCHAR(50) NOT NULL,
  nombre_pila VARCHAR(50) NOT NULL,
  Foto VARCHAR(150),
  Fec_Nac DATE,
  Sexo VARCHAR(16),
  direcc_email VARCHAR(64) NOT NULL,
  nombre_usuario VARCHAR(50) NOT NULL,
  password VARCHAR(50) NOT NULL,
  rol VARCHAR(15) NOT NULL,
  pais VARCHAR(30),
  ciudad VARCHAR(30),
  PRIMARY KEY (Doc_ID),
  UNIQUE (nombre_usuario)
);

CREATE TABLE EMPRESA
(
  nombre VARCHAR(20) NOT NULL,
  pais VARCHAR(15) NOT NULL,
  ruc INT NOT NULL,
  PRIMARY KEY (ruc)
);

CREATE TABLE PUESTO_LABORAL
(
  horas_dia NUMERIC(2,0) NOT NULL,
  nombre INT NOT NULL,
  departamento VARCHAR(20) NOT NULL,
  requisitos VARCHAR(800) NOT NULL,
  descripcion VARCHAR(800) NOT NULL,
  PRIMARY KEY (nombre)
);

CREATE TABLE ADMINISTRADOR
(
  turno VARCHAR(10) NOT NULL,
  Doc_ID NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (Doc_ID),
  FOREIGN KEY (Doc_ID) REFERENCES PERSONA(Doc_ID)
);

CREATE TABLE CONTACTO
(
  tema VARCHAR(64) NOT NULL,
  mensaje VARCHAR(500) NOT NULL,
  archivo_info VARCHAR(100),
  codigo SERIAL NOT NULL,
  nombre VARCHAR(40) NOT NULL,
  email VARCHAR(50) NOT NULL,
  numero VARCHAR(16) NOT NULL,
  company VARCHAR(64) NOT NULL,
  Doc_ID NUMERIC(10,0),
  PRIMARY KEY (codigo),
  FOREIGN KEY (Doc_ID) REFERENCES PERSONA(Doc_ID)
);

CREATE TABLE IDIOMA
(
  lengua INT NOT NULL,
  PRIMARY KEY (lengua)
);

CREATE TABLE RESPUESTA
(
  fecha_resp DATE NOT NULL,
  mensaje VARCHAR(500) NOT NULL,
  Doc_ID_Admin NUMERIC(10,0) NOT NULL,
  codigo SERIAL NOT NULL,
  PRIMARY KEY (Doc_ID_Admin, codigo),
  FOREIGN KEY (Doc_ID_Admin) REFERENCES ADMINISTRADOR(Doc_ID),
  FOREIGN KEY (codigo) REFERENCES CONTACTO(codigo)
);

CREATE TABLE PERSONA_numero_telef
(
  numero_telef VARCHAR(16) NOT NULL,
  Doc_ID NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (numero_telef, Doc_ID),
  FOREIGN KEY (Doc_ID) REFERENCES PERSONA(Doc_ID)
);

CREATE TABLE ESTUDIO
(
  estudio_finalizado VARCHAR(64) NOT NULL,
  formacion_especifica VARCHAR(64) NOT NULL,
  PRIMARY KEY (estudio_finalizado, formacion_especifica)
);

CREATE TABLE TECNICO_SELECCION
(
  rol_empresa VARCHAR(20) NOT NULL,
  tipo_contrato INT NOT NULL,
  Doc_ID NUMERIC(10,0) NOT NULL,
  ruc INT NOT NULL,
  Doc_ID_Admin NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (Doc_ID),
  FOREIGN KEY (Doc_ID) REFERENCES PERSONA(Doc_ID),
  FOREIGN KEY (ruc) REFERENCES EMPRESA(ruc),
  FOREIGN KEY (Doc_ID_Admin) REFERENCES ADMINISTRADOR(Doc_ID)
);

CREATE TABLE POSTULANTE
(
  link_linkedin VARCHAR(150) NOT NULL,
  lugar_residencia VARCHAR(50) NOT NULL,
  ANTECEDENTES_PENALES VARCHAR(150),
  CURRICULUM_VITAE VARCHAR(150) NOT NULL,
  situacion_laboral_actual VARCHAR(30) NOT NULL,
  tipo_contrato_deseado VARCHAR(15) NOT NULL,
  movilidad VARCHAR(30) NOT NULL,
  Doc_ID NUMERIC(10,0) NOT NULL,
  Doc_ID_ts NUMERIC(10,0),
  PRIMARY KEY (Doc_ID),
  FOREIGN KEY (Doc_ID) REFERENCES PERSONA(Doc_ID),
  FOREIGN KEY (Doc_ID_ts) REFERENCES TECNICO_SELECCION(Doc_ID)
);

CREATE TABLE CONVOCATORIA
(
  tipo_jornada VARCHAR(30) NOT NULL,
  direccion_empresa VARCHAR(100) NOT NULL,
  fecha_publicac DATE NOT NULL,
  sueldo NUMERIC(12,2) NOT NULL,
  fecha_limite DATE NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  tipo_contrato VARCHAR(32) NOT NULL,
  estado CHAR(1) NOT NULL,
  id_convocatoria SERIAL NOT NULL,
  nombre INT NOT NULL,
  Doc_ID_ts NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (id_convocatoria),
  FOREIGN KEY (nombre) REFERENCES PUESTO_LABORAL(nombre),
  FOREIGN KEY (Doc_ID_ts) REFERENCES TECNICO_SELECCION(Doc_ID)
);

CREATE TABLE VACANTE
(
  estado CHAR(1) NOT NULL,
  fecha_asignacion DATE,
  número INT NOT NULL,
  nombre INT NOT NULL,
  Doc_ID NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (número, nombre),
  FOREIGN KEY (nombre) REFERENCES PUESTO_LABORAL(nombre),
  FOREIGN KEY (Doc_ID) REFERENCES POSTULANTE(Doc_ID)
);

CREATE TABLE TIPO_EVALUACION
(
  tipo_evaluacion INT NOT NULL,
  puntaje_minimo INT NOT NULL,
  Doc_ID_ts NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (tipo_evaluacion, Doc_ID_ts),
  FOREIGN KEY (Doc_ID_ts) REFERENCES TECNICO_SELECCION(Doc_ID)
);

CREATE TABLE EXPERIENCIA_SECTOR
(
  sector INT NOT NULL,
  tiempo INT NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (sector, Doc_ID_Postulante),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID)
);

CREATE TABLE POSICION_DIGITAL_EJERCIDO
(
  posicion INT NOT NULL,
  tiempo INT NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (posicion, Doc_ID_Postulante),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID)
);

CREATE TABLE EVALUACION
(
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE,
  estado CHAR(1) NOT NULL,
  observacion VARCHAR(800),
  instrucciones VARCHAR(500),
  prueba_evaluacion VARCHAR(100) NOT NULL,
  tipo_evaluacion INT NOT NULL,
  Doc_ID_ts NUMERIC(10,0) NOT NULL,
  id_convocatoria SERIAL NOT NULL,
  PRIMARY KEY (tipo_evaluacion, Doc_ID_ts, id_convocatoria),
  FOREIGN KEY (tipo_evaluacion, Doc_ID_ts) REFERENCES TIPO_EVALUACION(tipo_evaluacion, Doc_ID_ts),
  FOREIGN KEY (id_convocatoria) REFERENCES CONVOCATORIA(id_convocatoria)
);

CREATE TABLE INSCRIPCION_CONVOC_POSTUL
(
  sueldo_esperado NUMERIC(12,2) NOT NULL,
  fecha_inscripcion DATE NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  id_convocatoria SERIAL NOT NULL,
  PRIMARY KEY (Doc_ID_Postulante, id_convocatoria),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID),
  FOREIGN KEY (id_convocatoria) REFERENCES CONVOCATORIA(id_convocatoria)
);

CREATE TABLE VISUALIZA_CONVOC_POSTUL
(
  cant_visualizaciones INT NOT NULL,
  tiempo_retencion INT NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  id_convocatoria SERIAL NOT NULL,
  PRIMARY KEY (Doc_ID_Postulante, id_convocatoria),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID),
  FOREIGN KEY (id_convocatoria) REFERENCES CONVOCATORIA(id_convocatoria)
);

CREATE TABLE CONTRATA
(
  archivo_contrato VARCHAR(100) NOT NULL,
  fecha_contratacion DATE NOT NULL,
  nombre_puesto_laboral VARCHAR(30) NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  Doc_ID_ts NUMERIC(10,0) NOT NULL,
  id_convocatoria SERIAL NOT NULL,
  PRIMARY KEY (Doc_ID_Postulante, Doc_ID_ts),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID),
  FOREIGN KEY (Doc_ID_ts) REFERENCES TECNICO_SELECCION(Doc_ID),
  FOREIGN KEY (id_convocatoria) REFERENCES CONVOCATORIA(id_convocatoria)
);

CREATE TABLE EVALUACION_POSTULANTE
(
  puntaje_obtenido INT NOT NULL,
  estado CHAR(1) NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  tipo_evaluacion INT NOT NULL,
  Doc_ID_ts NUMERIC(10,0) NOT NULL,
  id_convocatoria SERIAL NOT NULL,
  PRIMARY KEY (Doc_ID_Postulante, tipo_evaluacion, Doc_ID_ts, id_convocatoria),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID),
  FOREIGN KEY (tipo_evaluacion, Doc_ID_ts, id_convocatoria) REFERENCES EVALUACION(tipo_evaluacion, Doc_ID_ts, id_convocatoria)
);

CREATE TABLE POSTULANTE_estudio_finalizado
(
  fecha_final DATE NOT NULL,
  fecha_inicial DATE NOT NULL,
  institucion VARCHAR(64) NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  estudio_finalizado VARCHAR(64) NOT NULL,
  formacion_especifica VARCHAR(64) NOT NULL,
  PRIMARY KEY (Doc_ID_Postulante, estudio_finalizado, formacion_especifica),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID),
  FOREIGN KEY (estudio_finalizado, formacion_especifica) REFERENCES ESTUDIO(estudio_finalizado, formacion_especifica)
);

CREATE TABLE POSTULANTE_IDIOMA
(
  nivel VARCHAR(20) NOT NULL,
  Doc_ID NUMERIC(10,0) NOT NULL,
  lengua INT NOT NULL,
  PRIMARY KEY (Doc_ID, lengua),
  FOREIGN KEY (Doc_ID) REFERENCES POSTULANTE(Doc_ID),
  FOREIGN KEY (lengua) REFERENCES IDIOMA(lengua)
);

SELECT * FROM PERSONA WHERE doc_id = '74836198';
INSERT INTO postulante (link_linkedin, lugar_residencia, antecedentes_penales, curriculum_vitae, situacion_laboral_actual, tipo_contrato_deseado, movilidad, doc_id) VALUES ('https://linkedin.com/in/marcialvasquezrubio', 'Lima, Perú', '', '', 'Desempleado, de 1 a 6 meses', 'Freelance', 'Misma provincia igual a residencia', '74836198');

INSERT INTO persona (doc_id, apellidos, nombre_pila, foto, fec_nac, sexo, direcc_email, nombre_usuario, password, rol, pais, ciudad) VALUES ('74836198', 'Vásquez Rubio', 'Marcial', '', '28-05-1999', 'Hombre', 'marcial@yahoo.es', 'marcial', '20170145d', 'postulante', 'Lima, Perú', 'Lima, Perú');
INSERT INTO postulante (link_linkedin, lugar_residencia, antecedentes_penales, curriculum_vitae, situacion_laboral_actual, tipo_contrato_deseado, movilidad, doc_id) VALUES ('https://linkedin.com/in/fernandovasquezmontes', 'Lima, Perú', '', '', 'Desempleado, de 1 a 6 meses', 'Freelance', 'Misma provincia igual a residencia', '74836198');

INSERT INTO persona (doc_id, apellidos, nombre_pila, foto, fec_nac, sexo, direcc_email, nombre_usuario, password, rol, pais, ciudad) VALUES ('74836192', 'Riquelme Monge', 'Joseph', '', '12-05-1995', 'Hombre', 'joseph@yahoo.es', 'joseph', '20170145d', 'admin', 'Lima, Perú', 'Lima, Perú');
INSERT INTO administrador (turno, doc_id) VALUES ('noche', '74836192');


INSERT INTO persona (doc_id, apellidos, nombre_pila, foto, fec_nac, sexo, direcc_email, nombre_usuario, password, rol, pais, ciudad) VALUES ('74836191', 'Vásquez Montes', 'Fernando', '', '12-02-1964', 'Hombre', 'lotarvasquez@yahoo.es', 'vasquezconstructions', '20170145d', 'tecnico', 'Lima, Perú', 'Lima, Perú');

INSERT INTO empresa (nombre, pais, ruc) VALUES ('Melositos', 'Perú', 486456781);
INSERT INTO tecnico_seleccion (rol_empresa, tipo_contrato, doc_id, ruc, doc_id_admin) VALUES ('Director de RRHH', 2, '74836191', 486456781, '74836191');
INSERT INTO puesto_laboral
(horas_dia ,nombre ,departamento ,requisitos ,descripcion )
VALUES
(08, 1234,'Lima',' educación, títulos, experiencia laboral.conocimientos especiales, tales como idiomas en inglés o informática','El especialista será el encargado de crear aplicaciones para la empresa las aplicaciones de la empresa con la finalidad  de brindar rapidez para el usuario para realizar las operaciones');

INSERT INTO CONVOCATORIA 
(tipo_jornada ,direccion_empresa ,fecha_publicac ,sueldo ,fecha_limite ,titulo ,tipo_contrato,estado,nombre, doc_id_ts )
VALUES
('A tiempo parcial','Ancon.Lima.475','25/10/2021',4000,'10/12/2021','Se busca Ing.Software','Indefinido','A',1234,74836191);

SELECT * FROM convocatoria;