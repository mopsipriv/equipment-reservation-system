CREATE DATABASE IF NOT EXISTS reservation_system;
USE reservation_system;

DROP TABLE IF EXISTS logs;
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

CREATE TABLE roles(
id INT NOT NULL AUTO_INCREMENT,
role_name ENUM('student', 'admin', 'staff'),

PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE users (
id INT NOT NULL AUTO_INCREMENT,
full_name VARCHAR(100) NOT NULL,
student_number VARCHAR(50) UNIQUE,
email VARCHAR(255) UNIQUE NOT NULL,
id_role INT NOT NULL,
phone_number VARCHAR(20),
is_active BOOLEAN NOT NULL DEFAULT TRUE,
password_hash VARCHAR(255) NOT NULL,

PRIMARY KEY (id),

FOREIGN KEY(id_role) REFERENCES roles(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE equipment(
id INT NOT NULL AUTO_INCREMENT,
equipment_name VARCHAR(100) NOT NULL,
equipment_description TEXT,
equipment_status ENUM('available', 'in_use', 'maintenance', 'retired') NOT NULL DEFAULT 'available',
image_url VARCHAR(500),
serial_number VARCHAR(100) UNIQUE NOT NULL,
id_category INT UNSIGNED,
scan_code VARCHAR(100) UNIQUE NOT NULL,
current_holder_id INT,
location VARCHAR(100),

PRIMARY KEY(id),

FOREIGN KEY(current_holder_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE booking(
id INT NOT NULL AUTO_INCREMENT,
id_user INT NOT NULL,
id_equipment INT NOT NULL,
start_time DATETIME NOT NULL,
end_time  DATETIME NOT NULL,
status ENUM('pending', 'confirmed', 'active', 'completed', 'cancelled', 'no_show') NOT NULL DEFAULT 'pending',
checked_out_at DATETIME NULL,
checked_in_at DATETIME NULL,

PRIMARY KEY(id),

FOREIGN KEY(id_user) REFERENCES users(id) ON DELETE RESTRICT,
FOREIGN KEY(id_equipment) REFERENCES equipment(id) ON DELETE RESTRICT,

CONSTRAINT check_time CHECK(end_time>start_time)
) ENGINE=InnoDB;

CREATE TABLE logs (
  id BIGINT UNSIGNED AUTO_INCREMENT,
  user_id INT,
  action VARCHAR(50) NOT NULL, 
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  entity_type VARCHAR(50),
  entity_id INT,
  description TEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX index_scan_code ON equipment(scan_code);
CREATE INDEX index_user_email ON users(email);
CREATE INDEX index_logs_timestamp ON logs(timestamp);