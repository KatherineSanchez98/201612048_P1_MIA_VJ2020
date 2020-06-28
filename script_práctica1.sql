-----------------------------
----  KATHERINE SÁNCHEZ  ----
----  201612408          ----
-----------------------------


----PLANTEAMIENTOS
--------------------------INCIO 1--------------------------

--CREACION DE TABLAS

---1. Crea tabla PROFESION
CREATE TABLE PROFESION(
	cod_prof SERIAL not null PRIMARY KEY,
	nombre varchar(50) not null UNIQUE
);

---2. Crea tabla PAIS
CREATE TABLE PAIS(
	cod_pais SERIAL not null PRIMARY KEY,
	nombre varchar(50) not null UNIQUE
);

---3. Crea tabla PUESTO
CREATE TABLE PUESTO(
	cod_puesto SERIAL not null PRIMARY KEY,
	nombre varchar(50) not null UNIQUE
);

---4. Crea tabla DEPARTAMENTO
CREATE TABLE DEPARTAMENTO(
	cod_depto SERIAL not null PRIMARY KEY,
	nombre varchar(50) not null UNIQUE
);

---5. Crea tabla MIEMBRO
CREATE TABLE MIEMBRO(
	cod_miembro SERIAL not null PRIMARY KEY,
	nombre varchar(100) not null,
	apellido varchar(100) not null,
	edad integer not null,
	telefono integer,
	residencia varchar(100),
	PAIS_cod_pais SERIAL not null,
	PROFESION_cod_prof SERIAL not null,
	FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS (cod_pais),
	FOREIGN KEY (PROFESION_cod_prof) REFERENCES PROFESION (cod_prof)
);

--6. Crear tabla PUESTO_MIEMBRO
CREATE TABLE PUESTO_MIEMBRO(
	MIEMBRO_cod_miembro SERIAL not null,
	PUESTO_cod_puesto SERIAL not null,
	DEPARTAMENTO_cod_depto SERIAL not null,
	fecha_inicio date not null,
	fecha_fin date,
	FOREIGN KEY (MIEMBRO_cod_miembro) REFERENCES MIEMBRO (cod_miembro),
	FOREIGN KEY (PUESTO_cod_puesto) REFERENCES PUESTO (cod_puesto),
	FOREIGN KEY (DEPARTAMENTO_cod_depto) REFERENCES DEPARTAMENTO (cod_depto),
	PRIMARY KEY (MIEMBRO_cod_miembro, PUESTO_cod_puesto, DEPARTAMENTO_cod_depto)
);

--7. Crear tabla TIPO_MEDALLA
CREATE TABLE TIPO_MEDALLA(
	cod_tipo SERIAL not null PRIMARY KEY,
	medalla varchar(20) not null UNIQUE
);

--8. Crear tabla MEDALLERO
CREATE TABLE MEDALLERO(
	PAIS_cod_pais SERIAL not null,
	cantidad_medallas integer not null,
	TIPO_MEDALLA_cod_tipo SERIAL not null,
	FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS (cod_pais),
	FOREIGN KEY (TIPO_MEDALLA_cod_tipo) REFERENCES TIPO_MEDALLA (cod_tipo),
	PRIMARY KEY (PAIS_cod_pais, TIPO_MEDALLA_cod_tipo)
);

--9. Crear tabla DISCIPLINA
CREATE TABLE DISCIPLINA(
	cod_disciplina SERIAL not null PRIMARY KEY,
	nombre varchar(50) not null,
	descripcion varchar(150)
);

--10. Crear tabla ATLETA
CREATE TABLE ATLETA(
	cod_atleta SERIAL not null PRIMARY KEY,
	nombre varchar(50) not null,
	apellido varchar(50) not null,
	edad integer not null,
	participaciones varchar(100) not null,
	DISCIPLINA_cod_disciplina SERIAL not null,
	PAIS_cod_pais SERIAL not null,
	FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA (cod_disciplina),
	FOREIGN KEY (PAIS_cod_pais) REFERENCES PAIS (cod_pais)
);

--11. Crear tabla CATEGORIA
CREATE TABLE CATEGORIA(
	cod_categoria SERIAL not null PRIMARY KEY,
	nombre varchar(50) not null
);

--12. Crear tabla TIPO_PARTICIPACION
CREATE TABLE TIPO_PARTICIPACION(
	cod_participacion SERIAL PRIMARY KEY,
	tipo_participacion varchar(100) not null
);

--13. Crear tabla EVENTO
CREATE TABLE EVENTO(
	cod_evento SERIAL PRIMARY KEY,
	fecha date not null,
	ubicacion varchar(50) not null,
	hora date not null,
	DISCIPLINA_cod_disciplina SERIAL not null,
	TIPO_PARTICIPACION_cod_participacion SERIAL not null,
	CATEGORIA_cod_categoria SERIAL not null,
	FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA (cod_disciplina),
	FOREIGN KEY (TIPO_PARTICIPACION_cod_participacion) REFERENCES TIPO_PARTICIPACION (cod_participacion),
	FOREIGN KEY (CATEGORIA_cod_categoria) REFERENCES CATEGORIA (cod_categoria)
);

--14. EVENTO ATLETA
CREATE TABLE EVENTO_ATLETA(
	ATLETA_cod_atleta SERIAL not null,
	EVENTO_cod_evento SERIAL not null,
	FOREIGN KEY (ATLETA_cod_atleta) REFERENCES ATLETA (cod_atleta),
	FOREIGN KEY (EVENTO_cod_evento) REFERENCES EVENTO (cod_evento),
	PRIMARY KEY (ATLETA_cod_atleta, EVENTO_cod_evento)
);

--15. TELEVISORA
CREATE TABLE TELEVISORA(
	cod_televisora SERIAL not null PRIMARY KEY,
	nombre varchar(50) not null
);

--16. Crear tabla COSTO_EVENTO
CREATE TABLE COSTO_EVENTO(
	EVENTO_cod_evento SERIAL not null,
	TELEVISORA_cod_televisora SERIAL not null,
	tarifa numeric not null,
	FOREIGN KEY (EVENTO_cod_evento) REFERENCES EVENTO (cod_evento),
	FOREIGN KEY (TELEVISORA_cod_televisora) REFERENCES TELEVISORA (cod_televisora),
	PRIMARY KEY (EVENTO_cod_evento, TELEVISORA_cod_televisora)
);

--------------------------INCISO 2--------------------------

--Eliminación de columna fecha y hora de Evento y creación de fecha_hora
--ALTER TABLE MODIFICA ESTRUCTURA DE UNA TABLA
ALTER TABLE EVENTO DROP COLUMN fecha;
ALTER TABLE EVENTO DROP COLUMN hora;
ALTER TABLE EVENTO ADD fecha_hora timestamp;


--------------------------INCISO 3--------------------------

--Eventos programados del 24 de julio de 2020 9:00:00 hasta el 9 de agosto de 2020 hasta 20:00:00
ALTER TABLE EVENTO ADD CONSTRAINT programacion_even_check CHECK (
	fecha_hora >= '2020-07-24 9:00:00-06'
	AND fecha_hora <= '2020-09-09 20:00:00-06'
);

--------------------------INCISO 4--------------------------

--a) Crear tabla Sede
CREATE TABLE SEDE(
	codigo SERIAL PRIMARY KEY,
	sede varchar(50) not null
);

--b) Cambiar tipo de dato de campo ubicacion de tabla Evento por int
ALTER TABLE EVENTO ALTER COLUMN ubicacion SET DATA TYPE int USING ubicacion::integer;
--PUEDO OMITIR EL SET DATA

--c) Relacionar columna codigo de sede con ubicacion (hacerla foránea) de evento 
ALTER TABLE EVENTO ADD CONSTRAINT foranea_ubicacion FOREIGN KEY (ubicacion) REFERENCES SEDE (codigo);


--------------------------INCISO 5--------------------------

--Agregar default a telefono de miembro, valor 0.
ALTER TABLE MIEMBRO ALTER COLUMN telefono SET DEFAULT 0;


--------------------------INCISO 6--------------------------
----Inserción  de datos a tablas
--TABLA PAIS
INSERT INTO PAIS (nombre) VALUES 
('Guatemala'),('Francia'),('Argentina'),('Alemania'),
('Italia'),('Brasil'),('Estados Unidos');



--TABLA PROFESION
INSERT INTO PROFESION (nombre) VALUES 
('Médico' ),('Arquitecto'),('Ingeniero'),('Secretaria'),
('Auditor');


--TABLA MIEMBROS
INSERT INTO MIEMBRO  (nombre, apellido, edad, telefono, residencia, PAIS_cod_pais, PROFESION_cod_prof) VALUES
('Scott','Mitchell',32,default,'1092 Highland Drive Manitowoc, WI 54220',7,3),
('Fanette','Poulin',25,25075853,'49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY',2,4),
('Laura','Cunha Silva',55,default,'Rua Onze, 86 Uberaba-MG',6,5),
('Juan José','López',38,36985247,'26 calle 4-10 zona 11',1,2),
('Arcangela','Panicucci',39,391664921,'Via Santa Teresa, 114 90010-Geraci Siculo PA',5,1),
('Jeuel','Villalpando',31,default,'Acuña de Figueroa 6106 80101 Playa Pascual',3,5);

--TABLA DISCIPLINA
INSERT INTO DISCIPLINA (nombre, descripcion) VALUES
('Atletismo','Saltos de longitud y triples, de altura y con pértiga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco.'),
('Bádminton',null),
('Ciclismo',null),
('Judo','Es un arte marcial que se originó en Japón alrededor de 1880.'),
('Lucha',null),
('Tenis de Mesa',null),
('Boxeo',null),
('Natación','Está presente como deporte en los Juegos desde la primera edición de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas.'),
('Esgrima',null),
('Vela',null);

--TABLA TIPO_MEDALLA
INSERT INTO TIPO_MEDALLA (medalla) VALUES
('Oro'),
('Plata'),
('Bronce'),
('Platino');


--TABLA CATEGORIA
INSERT INTO CATEGORIA (nombre) VALUES
('Clasificatorio'),
('Eliminatorio'),
('Final');


--TABLA TIPO_PARTICIPACION
INSERT INTO TIPO_PARTICIPACION (tipo_participacion) VALUES
('Individual'),
('Parejas'),
('Equipos');


--TABLA MEDALLERO
INSERT INTO MEDALLERO (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo,cantidad_medallas) VALUES
(5,1,3),
(2,1,5),
(6,3,4),
(4,4,3),
(7,3,10),
(3,2,8),
(1,1,2),
(1,4,5),
(5,2,7);

--TABLA SEDE
INSERT INTO SEDE (sede) VALUES
('Gimnasio Metropolitano de Tokio'),
('Jardín del Palacio Imperial de Tokio'),
('Gimnasio Nacional Yoyogi'),
('Nippon Budokan'),
('Estadio Olímpico');

--TABLA EVENTO
INSERT INTO EVENTO (fecha_hora,ubicacion, DISCIPLINA_cod_disciplina,
					TIPO_PARTICIPACION_cod_participacion,CATEGORIA_cod_categoria)
VALUES
('2020-07-24 11:00:00-06',3,2,2,1),
('2020-07-26 10:30:00-06',1,6,1,3),
('2020-07-30 18:45:00-06',5,7,1,2),
('2020-08-01 12:15:00-06',2,1,1,1),
('2020-08-08 19:35:00-06',4,10,3,1);
					

--------------------------INCISO 7--------------------------
--Eliminar restricción UNIQUE de PAIS, TIPO_MEDALLA, DEPARTAMENTO
ALTER TABLE PAIS DROP CONSTRAINT PAIS_nombre_key;
ALTER TABLE TIPO_MEDALLA DROP CONSTRAINT TIPO_MEDALLA_medalla_key;
ALTER TABLE DEPARTAMENTO DROP CONSTRAINT DEPARTAMENTO_nombre_key;


--------------------------INCISO 8--------------------------
--a) Eliminar llave foránea de cod_disciplina de Atleta
ALTER TABLE ATLETA DROP CONSTRAINT ATLETA_disciplina_cod_disciplina_fkey;

--b) Crear tabla disciplina_atleta
CREATE TABLE DISCIPLINA_ATLETA(
	ATLETA_cod_atleta SERIAL not null,
	DISCIPLINA_cod_disciplina SERIAL not null,
	FOREIGN KEY (ATLETA_cod_atleta) REFERENCES ATLETA (cod_atleta),
	FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA (cod_disciplina),
	PRIMARY KEY (ATLETA_cod_atleta, DISCIPLINA_cod_disciplina)
);

--------------------------INCISO 9--------------------------

ALTER TABLE COSTO_EVENTO ALTER COLUMN tarifa SET DATA TYPE int USING tarifa::integer;

--------------------------INCISO 10--------------------------

--Eliminar registro de TIPO_MEDALLA de cod_tipo=4 //ESTA NO
--PRIMERO ELIMINAR DE MEDALLERO POR LA LLAVE FORANEA
DELETE FROM MEDALLERO WHERE TIPO_MEDALLA_cod_tipo=4;
DELETE FROM TIPO_MEDALLA WHERE cod_tipo=4;

--------------------------INCISO 11--------------------------

--Eliminar tabla TELEVISORA COSTO_EVENTO
DROP TABLE TELEVISORA, COSTO_EVENTO;

--------------------------INCISO 12--------------------------

--Eliminar todos los registros de tabla DISCIPLINA
--PRIMERO ELIMINAR DE EVENTO TODOS LOS DATOS
DELETE FROM EVENTO;
DELETE FROM DISCIPLINA;

--------------------------INCISO 13--------------------------

--Actualizar datos de telefono de tabla MIEMBRO
UPDATE MIEMBRO set telefono=55464601 WHERE nombre='Laura' AND apellido='Cunha Silva';
UPDATE MIEMBRO set telefono=91514243 WHERE nombre='Jeuel' AND apellido='Villalpando';
UPDATE MIEMBRO set telefono=920686670 WHERE nombre='Scott' AND apellido='Mitchell';

--------------------------INCISO 14--------------------------

--Agregar campo fotografia a tabla ATLETA
--En versiones anteriores el estandar era el tipo de dato varchar o para texto; en donde se almacenaba la ruta, pero actualmente
--el desempeño de las bases de datos postgres ha mejorado; por lo que es conveniente utilizar un arreglo de bytes
--ya que no es necesario utilizar el sistema dual sistema de archivos más base de datos.
ALTER TABLE ATLETA ADD fotografia bytea;

--------------------------INCISO 14--------------------------

--Atletas menores a 25 años para poder registrarse
ALTER TABLE ATLETA ADD CONSTRAINT edad_atletas_check CHECK (
	edad < 25
);


