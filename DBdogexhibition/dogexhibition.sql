-- Crear la Base de Datos
CREATE DATABASE DogExhibitionDB;

-- Usar la Base de Datos recién creada
USE DogExhibitionDB;

-- Crear la Tabla "Breeds" (Razas)
CREATE TABLE Breeds (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    BreedName VARCHAR(255) NOT NULL
);

-- Crear la Tabla "Roles"
CREATE TABLE Roles (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    RoleName VARCHAR(45) NOT NULL
);

-- Insertar Roles Predeterminados
INSERT INTO Roles (RoleName) VALUES ('Admin');
INSERT INTO Roles (RoleName) VALUES ('Owner');
INSERT INTO Roles (RoleName) VALUES ('Judge');

-- Crear la Tabla "Users" (Usuarios)
CREATE TABLE Users (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(45) NOT NULL,
    LastName VARCHAR(45) NOT NULL,
    Email VARCHAR(45) NOT NULL,
    Document VARCHAR(45) NOT NULL,
    PhoneNumber VARCHAR(45) NOT NULL,
    Username VARCHAR(45) NOT NULL,
    PasswordHash VARCHAR(45) NOT NULL,
    RoleId INT,
    FOREIGN KEY (RoleId) REFERENCES Roles(Id)
);


-- Crear la Tabla "Dogs" (Perros) con Relación a "Breeds" y "Users"
CREATE TABLE Dogs (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(45) NOT NULL,
    BreedId INT,
    Age INT CHECK (Age >= 0),
    OwnerId INT,
    FOREIGN KEY (BreedId) REFERENCES Breeds(Id),
    FOREIGN KEY (OwnerId) REFERENCES Users(Id)
);

-- Crear la Tabla "DogScores" para rastrear puntajes de perros en el tiempo
CREATE TABLE DogScores (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    DogId INT NOT NULL,
    Score INT NOT NULL,
    ScoreDate DATE NOT NULL,
    FOREIGN KEY (DogId) REFERENCES Dogs(Id)
);

-- Crear una tabla para almacenar imágenes de perros
CREATE TABLE DogImages (
ImageId INT PRIMARY KEY AUTO_INCREMENT,
DogId INT NOT NULL,
ImageUrl VARCHAR(255) NOT NULL,
Description VARCHAR(100),
FOREIGN KEY (DogId) REFERENCES Dogs(Id)
);

-- Crear un índice en BreedId, OwnerId y RoleId para mejorar rendimiento en búsquedas
CREATE INDEX idx_BreedId ON Dogs (BreedId);
CREATE INDEX idx_OwnerId ON Dogs (OwnerId);
CREATE INDEX idx_RoleId ON Users (RoleId);

-- Crear usuario con admin con todos los permisos
CREATE USER 'admin_dogexhibition'@'localhost' IDENTIFIED BY 'gsgfve568*GD';
GRANT ALL PRIVILEGES ON DogExhibitionDB.* TO 'admin_dogexhibition'@'localhost';
FLUSH PRIVILEGES;

-- Insertar las razas en la tabla Breeds
INSERT INTO Breeds (BreedName)
VALUES
-- Grupo 1 
    ("PASTOR ALEMÁN PELO CORTO"), ("PASTOR ALEMÁN PELO LARGO"), ("AUSTRALIAN KELPIE"), ("PERRO DE PASTOR BELGA Groenendael"),
    ("PERRO DE PASTOR BELGA Laekenois"), ("PERRO DE PASTOR BELGA Malinois"), ("PERRO DE PASTOR BELGA Tervueren"), ("SCHIPPERKE"),
    ("PERRO PASTOR CROATA"), ("PERRO LOBO CHECOSLOVACO"), ("TCHUVATCH ESLOVACO"), ("PERRO DE PASTOR CATALÁN"), ("PERRO DE PASTOR MALLORQUĺN PELO CORTO"),
    ("PERRO DE PASTOR MALLORQUĺN PELO LARGO"), ("PERRO PASTOR AUSTRALIANO"), ("PASTOR DE BEAUCE"), ("PASTOR DE BRIE"), ("PASTOR DE LOS PIRINEOS DE CARA RASA"),
    ("PASTOR DE PICARDÍA"), ("PERRO PASTOR DE LOS PIRINEOS DE PELO LARGO"), ("KOMONDOR"), ("KUVASZ"), ("MUDI BAYO"), ("MUDI NEGRO"), ("MUDI MARRÓN"), ("MUDI BLUE MERLE"),
    ("MUDI COLORES CENICIENTOS"), ("MUDI BLANCO"), ("PULI BLANCO PERLA"), ("PULI NEGRO"), ("PULI NEGRO CON ALGUN SOMBREADO ROJO-ÓXIDO O GRIS"), ("PULI LEONADO"),
    ("PULI GRIS (TD. TONALIDADES)"), ("PUMI GRIS EN DIFERENTES TONALIDADES"), ("PUMI NEGRO"), ("PUMI LEONADO. COLORES BÁSICOS: ROJO, AMARILLO, CREMA"), ("PUMI BLANCO"),
    ("PERRO DE PASTOR BERGAMASCO"), ("PERRO DE PASTOR DE LA MAREMMA Y DE LOS ABRUZOS"), ("PASTOR HOLANDÉS PELO CORTO"), ("PASTOR HOLANDÉS PELO LARGO"),
    ("PASTOR HOLANDÉS PELO DURO"), ("PERRO LOBO DE SAARLOOS"), ("SCHAPENDOES NEERLANDÉS"), ("PERRO DE PASTOR POLACO DE LAS LLANURAS"), ("PERRO DE PASTOR POLACO DE PODHALE"),
    ("PERRO DE PASTOR PORTUGUÉS"), ("ANTIGUO PERRO DE PASTOR INGLÉS"), ("BORDER COLLIE"), ("COLLIE BARBUDO"), ("COLLIE DE PELO CORTO"), ("COLLIE DE PELO LARGO"),
    ("PERRO PASTOR DE SHETLAND"), ("PERRO DE PASTOR RUMANO DE LOS CÁRPATOS (CARPATIN)"), ("PERRO PASTOR RUMANO DE MIORITZA"), ("PERRO DE PASTOR DE RUSIA MERIDIONAL"),
    ("PASTOR BLANCO SUIZO"), ("BOYERO AUSTRALIANO"), ("BOYERO DE LAS ARDENAS"), ("BOYERO DE FLANDES"), ("WELSH CORGI (CARDIGAN)"), ("WELSH CORGI (PEMBROKE)")
    ;
-- Usar la base de datos
USE DogExhibitionDB;
-- Verificar las inserciones
SELECT * FROM Users;
SELECT * FROM Breeds;

DELIMITER //
CREATE PROCEDURE ShowDogs(IN order_criteria VARCHAR(50))
BEGIN
    IF order_criteria = 'breed' THEN
        SELECT * FROM Dogs ORDER BY BreedId;
    ELSEIF order_criteria = 'points' THEN
        SELECT * FROM Dogs ORDER BY (SELECT SUM(Score) FROM DogScores WHERE DogScores.DogId = Dogs.Id) DESC;
    ELSEIF order_criteria = 'age' THEN
        SELECT * FROM Dogs ORDER BY Age DESC;
    ELSE
        SELECT * FROM Dogs; -- Si no se proporciona un criterio válido, mostrar todos los perros
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ShowDogByName(IN dog_name VARCHAR(50))
BEGIN
    SELECT * FROM Dogs WHERE Name = dog_name;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AddNewDog(IN dog_name VARCHAR(50), IN breed_id INT, IN age INT, IN owner_id INT)
BEGIN
    INSERT INTO Dogs (Name, BreedId, Age, OwnerId) VALUES (dog_name, breed_id, age, owner_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE FindDogByName(IN dog_name VARCHAR(50))
BEGIN
    SELECT * FROM Dogs WHERE Name = dog_name;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE FindTopDog()
BEGIN
    SELECT Dogs.*, SUM(DogScores.Score) AS TotalScore
    FROM Dogs
    JOIN DogScores ON Dogs.Id = DogScores.DogId
    GROUP BY Dogs.Id
    ORDER BY TotalScore DESC
    LIMIT 1;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE FindBottomDog()
BEGIN
    SELECT Dogs.*, SUM(DogScores.Score) AS TotalScore
    FROM Dogs
    LEFT JOIN DogScores ON Dogs.Id = DogScores.DogId
    GROUP BY Dogs.Id
    ORDER BY TotalScore ASC
    LIMIT 1;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE FindOldestDog()
BEGIN
    SELECT * FROM Dogs ORDER BY Age DESC LIMIT 1;
END //
DELIMITER ;

-- Ejemplo de uso de los procedimientos
CALL ShowDogs('BreedId');
CALL ShowDogByName('nombre_del_perro');
CALL AddNewDog('NombreNuevoPerro', 'IdRaza', 'Edad', 'IdPropietario');
CALL FindDogByName('nombre_del_perro');
CALL FindTopDog();
CALL FindBottomDog();
CALL FindOldestDog();





DELIMITER //

CREATE PROCEDURE InsertarIntegrante(
    IN p_nombre VARCHAR(255),
    IN p_instrumento VARCHAR(50),
    IN p_foto_path VARCHAR(255)
)
BEGIN
    INSERT INTO integrantes (nombre, instrumento, foto_path, seguidores, conciertos, ganancias)
    VALUES (p_nombre, p_instrumento, p_foto_path, 0, 0, 0.00);
END //

DELIMITER ;
