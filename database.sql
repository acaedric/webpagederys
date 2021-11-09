CREATE DATABASE prueba;
CREATE TABLE PERSONA
(
  Doc_ID NUMERIC(10,0) NOT NULL,
  apellidos VARCHAR(50) NOT NULL,
  nombre_pila VARCHAR(50) NOT NULL,
  Foto VARCHAR(150) NOT NULL,
  Fec_Nac DATE NOT NULL,
  Sexo VARCHAR(16) NOT NULL,
  direcc_email VARCHAR(64) NOT NULL,
  nombre_usuario VARCHAR(50) NOT NULL,
  password VARCHAR(50) NOT NULL,
  rol VARCHAR(15) NOT NULL,
  pais VARCHAR(30) NOT NULL,
  ciudad VARCHAR(30) NOT NULL,
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
  codigo INT NOT NULL,
  nombre VARCHAR(40) NOT NULL,
  email VARCHAR(50) NOT NULL,
  numero VARCHAR(16) NOT NULL,
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
  codigo INT NOT NULL,
  PRIMARY KEY (Doc_ID_Admin, codigo),
  FOREIGN KEY (Doc_ID_Admin) REFERENCES ADMINISTRADOR(Doc_ID),
  FOREIGN KEY (codigo) REFERENCES CONTACTO(codigo)
);

CREATE TABLE PERSONA_número_telef
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
  Doc_ID_Empleador NUMERIC(10,0),
  PRIMARY KEY (Doc_ID),
  FOREIGN KEY (Doc_ID) REFERENCES PERSONA(Doc_ID),
  FOREIGN KEY (Doc_ID_Empleador) REFERENCES TECNICO_SELECCION(Doc_ID)
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
  nombre INT NOT NULL,
  Doc_ID_Empleador NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (titulo, nombre),
  FOREIGN KEY (nombre) REFERENCES PUESTO_LABORAL(nombre),
  FOREIGN KEY (Doc_ID_Empleador) REFERENCES TECNICO_SELECCION(Doc_ID)
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
  Doc_ID_Empleador NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (tipo_evaluacion, Doc_ID_Empleador),
  FOREIGN KEY (Doc_ID_Empleador) REFERENCES TECNICO_SELECCION(Doc_ID)
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
  titulo VARCHAR(100) NOT NULL,
  nombre INT NOT NULL,
  tipo_evaluacion INT NOT NULL,
  Doc_ID_Empleador NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (titulo, nombre, tipo_evaluacion, Doc_ID_Empleador),
  FOREIGN KEY (titulo, nombre) REFERENCES CONVOCATORIA(titulo, nombre),
  FOREIGN KEY (tipo_evaluacion, Doc_ID_Empleador) REFERENCES TIPO_EVALUACION(tipo_evaluacion, Doc_ID_Empleador)
);

CREATE TABLE INSCRIPCION_CONVOC_POSTUL
(
  sueldo_esperado NUMERIC(12,2) NOT NULL,
  fecha_inscripcion DATE NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  nombre INT NOT NULL,
  PRIMARY KEY (Doc_ID_Postulante, titulo, nombre),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID),
  FOREIGN KEY (titulo, nombre) REFERENCES CONVOCATORIA(titulo, nombre)
);

CREATE TABLE VISUALIZA_CONVOC_POSTUL
(
  cant_visualizaciones INT NOT NULL,
  tiempo_retencion INT NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  nombre INT NOT NULL,
  PRIMARY KEY (Doc_ID_Postulante, titulo, nombre),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID),
  FOREIGN KEY (titulo, nombre) REFERENCES CONVOCATORIA(titulo, nombre)
);

CREATE TABLE CONTRATA
(
  archivo_contrato VARCHAR(100) NOT NULL,
  fecha_contratacion DATE NOT NULL,
  nombre_puesto_laboral VARCHAR(30) NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  Doc_ID_Empleador NUMERIC(10,0) NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  nombre INT NOT NULL,
  PRIMARY KEY (Doc_ID_Postulante, Doc_ID_Empleador),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID),
  FOREIGN KEY (Doc_ID_Empleador) REFERENCES TECNICO_SELECCION(Doc_ID),
  FOREIGN KEY (titulo, nombre) REFERENCES CONVOCATORIA(titulo, nombre)
);

CREATE TABLE EVALUACION_POSTULANTE
(
  puntaje_obtenido INT NOT NULL,
  estado CHAR(1) NOT NULL,
  Doc_ID_Postulante NUMERIC(10,0) NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  nombre INT NOT NULL,
  tipo_evaluacion INT NOT NULL,
  Doc_ID_Empleador NUMERIC(10,0) NOT NULL,
  PRIMARY KEY (Doc_ID_Postulante, titulo, nombre, tipo_evaluacion, Doc_ID_Empleador),
  FOREIGN KEY (Doc_ID_Postulante) REFERENCES POSTULANTE(Doc_ID),
  FOREIGN KEY (titulo, nombre, tipo_evaluacion, Doc_ID_Empleador) REFERENCES EVALUACION(titulo, nombre, tipo_evaluacion, Doc_ID_Empleador)
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

