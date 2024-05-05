CONNECT Pe21_duoc/duoc@localhost:1521/XE;
DROP TABLE resumen_b;
DROP TABLE resumen_a;
DROP TABLE PersonajePelicula;
DROP TABLE Pelicula;
DROP TABLE Personaje;

DROP TABLE Actor;

CREATE TABLE Actor (
    ActorID INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
	FechaNacimiento DATE NOT NULL
);

CREATE TABLE Personaje (
    PersonajeID INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    ActorID INT NOT NULL,
    FOREIGN KEY (ActorID) REFERENCES Actor(ActorID)
);

CREATE TABLE Pelicula (
    PeliculaID INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
	fechaEstreno DATE NOT NULL
);

CREATE TABLE PersonajePelicula (
    PersonajeID INT,
    PeliculaID INT,
    FOREIGN KEY (PersonajeID) REFERENCES Personaje(PersonajeID),
    FOREIGN KEY (PeliculaID) REFERENCES Pelicula(PeliculaID),
    PRIMARY KEY (PersonajeID, PeliculaID)
);

-- Datos de la tabla Actor
INSERT INTO Actor (ActorID, Nombre, FechaNacimiento) VALUES(1, 'Robert Downey Jr.', TO_DATE('04/04/1965','DD/MM/YYYY'));
INSERT INTO Actor (ActorID, Nombre, FechaNacimiento) VALUES(2, 'Chris Evans', TO_DATE('13/06/1981','DD/MM/YYYY'));
INSERT INTO Actor (ActorID, Nombre, FechaNacimiento) VALUES(3, 'Scarlett Johansson', TO_DATE('22/11/1984','DD/MM/YYYY'));
INSERT INTO Actor (ActorID, Nombre, FechaNacimiento) VALUES(4, 'Chris Hemsworth', TO_DATE('11/08/1983','DD/MM/YYYY'));
INSERT INTO Actor (ActorID, Nombre, FechaNacimiento) VALUES(5, 'Mark Ruffalo', TO_DATE('22/11/1967','DD/MM/YYYY'));



-- Datos de la tabla Personaje
INSERT INTO Personaje (PersonajeID, Nombre, ActorID) VALUES(1, 'Iron Man', 1);
INSERT INTO Personaje (PersonajeID, Nombre, ActorID) VALUES(2, 'Capitán América', 2);
INSERT INTO Personaje (PersonajeID, Nombre, ActorID) VALUES(3, 'Viuda Negra', 3);
INSERT INTO Personaje (PersonajeID, Nombre, ActorID) VALUES(4, 'Thor', 4);
INSERT INTO Personaje (PersonajeID, Nombre, ActorID) VALUES(5, 'Hulk', 5);

-- Datos de la tabla Pelicula
INSERT INTO Pelicula (PeliculaID, Nombre, fechaEstreno) VALUES(1, 'Iron Man', TO_DATE('02/05/2008','DD/MM/YYYY'));
INSERT INTO Pelicula (PeliculaID, Nombre, fechaEstreno) VALUES(2, 'The Avengers', TO_DATE('11/04/2012','DD/MM/YYYY'));
INSERT INTO Pelicula (PeliculaID, Nombre, fechaEstreno) VALUES(3, 'Avengers: Age of Ultron',TO_DATE('01/05/2015','DD/MM/YYYY'));
INSERT INTO Pelicula (PeliculaID, Nombre, fechaEstreno) VALUES(4, 'Avengers: Infinity War',TO_DATE('27/04/2018','DD/MM/YYYY'));
INSERT INTO Pelicula (PeliculaID, Nombre, fechaEstreno) VALUES(5, 'Avengers: Endgame',TO_DATE('26/04/2016','DD/MM/YYYY'));

-- Datos de la tabla PersonajePelicula
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(1, 1); -- Iron Man en Iron Man
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(1, 2); -- Iron Man en The Avengers
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(1, 3); -- Iron Man en Avengers: Age of Ultron
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(1, 4); -- Iron Man en Avengers: Infinity War
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(1, 5); -- Iron Man en Avengers: Endgame
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(2, 2); -- Capitán América en The Avengers
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(2, 3); -- Capitán América en Avengers: Age of Ultron
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(2, 4); -- Capitán América en Avengers: Infinity War
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(2, 5); -- Capitán América en Avengers: Endgame
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(3, 2); -- Viuda Negra en The Avengers
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(3, 3); -- Viuda Negra en Avengers: Age of Ultron
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(3, 4); -- Viuda Negra en Avengers: Infinity War
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(3, 5); -- Viuda Negra en Avengers: Endgame
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(4, 2); -- Thor en The Avengers
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(4, 3); -- Thor en Avengers: Age of Ultron
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(4, 4); -- Thor en Avengers: Infinity War
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(4, 5); -- Thor en Avengers: Endgame
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(5, 2); -- Hulk en The Avengers
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(5, 3); -- Hulk en Avengers: Age of Ultron
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(5, 4); -- Hulk en Avengers: Infinity War
INSERT INTO PersonajePelicula (PersonajeID, PeliculaID) VALUES(5, 5); -- Hulk en Avengers: Endgame


CREATE TABLE resumen_a
(
    id_pelicula NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    estreno NUMBER NOT NULL,
    antiguedad NUMBER NOT NULL,
    observacion VARCHAR2(100) NOT NULL
);


CREATE TABLE resumen_b
(
    id_pelicula NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    estreno DATE NOT NULL,
    cantidad_actores NUMBER NOT NULL,
    promedio_edad NUMBER NOT NULL,
    observacion VARCHAR2(100) NOT NULL
);

ALTER TABLE resumen_a ADD CONSTRAINT resumen_a_peli_FK FOREIGN KEY(id_pelicula) REFERENCES pelicula(peliculaid);
ALTER TABLE resumen_b ADD CONSTRAINT resumen_b_peli_FK FOREIGN KEY(id_pelicula) REFERENCES pelicula(peliculaid);