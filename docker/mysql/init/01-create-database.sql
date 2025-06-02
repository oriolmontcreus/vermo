-- Create database with proper charset
CREATE DATABASE IF NOT EXISTS vermo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant all privileges to the user
GRANT ALL PRIVILEGES ON vermo.* TO 'vermo_user'@'%';
FLUSH PRIVILEGES; 