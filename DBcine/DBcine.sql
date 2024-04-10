-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS pos_cinema;

-- Usar la base de datos
USE pos_cinema;

-- Crear tabla para películas
CREATE TABLE IF NOT EXISTS Movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    release_date DATE NOT NULL
);

-- Crear tabla para asientos
CREATE TABLE IF NOT EXISTS Seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    row_letter VARCHAR(1) NOT NULL,
    seat_number INT NOT NULL,
    type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    cost INT NOT NULL
);

-- Crear tabla para horarios de películas
CREATE TABLE IF NOT EXISTS Schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(id)
);

-- Crear tabla para reservas
CREATE TABLE IF NOT EXISTS Reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    schedule_id INT,
    payment_method VARCHAR(20) NOT NULL, -- Método de pago
    total_amount INT NOT NULL, -- Monto total pagado
    FOREIGN KEY (schedule_id) REFERENCES Schedules(id)
);

CREATE TABLE IF NOT EXISTS Cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    card_number VARCHAR(16) UNIQUE NOT NULL, -- Número de la tarjeta
    cvv VARCHAR(3) NOT NULL, -- Código de seguridad (CVV)
    owner_id VARCHAR(20) UNIQUE NOT NULL,
    balance INT NOT NULL
);

-- Crear tabla para roles
CREATE TABLE IF NOT EXISTS Roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Insertar roles
INSERT INTO Roles (name) VALUES ('Regular User'), ('Admin User');

-- Crear tabla para usuarios
CREATE TABLE IF NOT EXISTS Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(30) NOT NULL,
    role_id INT,
    FOREIGN KEY (role_id) REFERENCES Roles(id)
);

-- Crear tabla de relación entre reservas y sillas
CREATE TABLE IF NOT EXISTS ReservationSeats (
    reservation_id INT,
    seat_id INT,
    PRIMARY KEY (reservation_id, seat_id),
    FOREIGN KEY (reservation_id) REFERENCES Reservations(id),
    FOREIGN KEY (seat_id) REFERENCES Seats(id)
);
