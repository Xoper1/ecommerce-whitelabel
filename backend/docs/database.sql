-- E-commerce Whitelabel Database Schema
-- MySQL Database Setup

-- Create Database
CREATE DATABASE IF NOT EXISTS ecommerce_whitelabel;
USE ecommerce_whitelabel;

-- Table: clients
-- Armazena informações dos clientes whitelabel
CREATE TABLE IF NOT EXISTS clients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  domain VARCHAR(255) NOT NULL UNIQUE,
  logo_url VARCHAR(500) NULL,
  primary_color VARCHAR(7) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_domain (domain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: users
-- Armazena usuários de cada cliente
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  INDEX idx_email (email),
  INDEX idx_client_id (client_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: provider_configs
-- Configura quais fornecedores cada cliente usa
CREATE TABLE IF NOT EXISTS provider_configs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT NOT NULL,
  provider_name VARCHAR(50) NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  priority INT DEFAULT 1,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  INDEX idx_client_provider (client_id, is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- SEED DATA - Dados iniciais para teste
-- ============================================

-- Cliente 1: Loja Brasileira
INSERT INTO clients (name, domain, logo_url, primary_color) VALUES
('Loja BR', 'cliente1.local', 'https://via.placeholder.com/150/FF5722/FFFFFF?text=Loja+BR', '#FF5722');

-- Cliente 2: Euro Store
INSERT INTO clients (name, domain, logo_url, primary_color) VALUES
('Euro Store', 'cliente2.local', 'https://via.placeholder.com/150/2196F3/FFFFFF?text=Euro+Store', '#2196F3');

-- Configuração de fornecedores para Cliente 1 (usa fornecedor brasileiro)
INSERT INTO provider_configs (client_id, provider_name, is_active, priority) VALUES
(1, 'brazilian', TRUE, 1);

-- Configuração de fornecedores para Cliente 2 (usa fornecedor europeu)
INSERT INTO provider_configs (client_id, provider_name, is_active, priority) VALUES
(2, 'european', TRUE, 1);

-- Usuários de teste (senha: password123)
-- Hash bcrypt de 'password123': $2b$10$rX8yZJZqGZJ7Z9X8yZJZqOeX8yZJZqGZJ7Z9X8yZJZqGZJ7Z9X8yZ
INSERT INTO users (client_id, email, password, name) VALUES
(1, 'user@cliente1.local', '$2b$10$K7L/8Y3KxfxJ0LqGOzPqh.FvZnPZ0sFZKqYqH8fF3Z9X8yZJZqGZJ', 'Usuário Loja BR'),
(2, 'user@cliente2.local', '$2b$10$K7L/8Y3KxfxJ0LqGOzPqh.FvZnPZ0sFZKqYqH8fF3Z9X8yZJZqGZJ', 'Usuário Euro Store');

-- ============================================
-- EXEMPLO: Cliente 3 que usa AMBOS fornecedores
-- ============================================

INSERT INTO clients (name, domain, logo_url, primary_color) VALUES
('Multi Store', 'cliente3.local', 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=Multi+Store', '#4CAF50');

INSERT INTO provider_configs (client_id, provider_name, is_active, priority) VALUES
(3, 'brazilian', TRUE, 1),
(3, 'european', TRUE, 2);

INSERT INTO users (client_id, email, password, name) VALUES
(3, 'user@cliente3.local', '$2b$10$K7L/8Y3KxfxJ0LqGOzPqh.FvZnPZ0sFZKqYqH8fF3Z9X8yZJZqGZJ', 'Usuário Multi Store');
