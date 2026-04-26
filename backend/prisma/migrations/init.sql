-- Database Schema for Chatbot AI Saung Vibe
-- Technology: MySQL with Prisma ORM

-- Create Database
CREATE DATABASE IF NOT EXISTS chatbot_saung_vibe;
USE chatbot_saung_vibe;

-- ============================================
-- 1. Users Table
-- ============================================
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL COMMENT 'Hashed password',
  role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
  daily_limit INT NOT NULL DEFAULT 50 COMMENT 'Daily message limit per user',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  INDEX idx_username (username),
  INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 2. Conversations Table
-- ============================================
CREATE TABLE conversations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL DEFAULT 'New Chat',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL COMMENT 'Soft delete timestamp',
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_deleted_at (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 3. Messages Table
-- ============================================
CREATE TABLE messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  conversation_id INT NOT NULL,
  sender_type ENUM('user', 'ai') NOT NULL,
  content LONGTEXT NOT NULL,
  is_typing BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Typing indicator status',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
  INDEX idx_conversation_id (conversation_id),
  INDEX idx_sender_type (sender_type),
  INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 4. Daily Usage Tracking Table
-- ============================================
CREATE TABLE daily_usage (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  usage_date DATE NOT NULL,
  message_count INT NOT NULL DEFAULT 0 COMMENT 'Number of messages sent today',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_date (user_id, usage_date),
  INDEX idx_user_id (user_id),
  INDEX idx_usage_date (usage_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 5. Insert Default Admin User
-- ============================================
INSERT INTO users (username, password, role, daily_limit, is_active)
VALUES ('admin', '$2b$10$K1.D8dP8/VLHNr3RKj7CleW5zVQWkVqHK0wVP.R9OQQ2p.pD/Oepm', 'admin', 999, TRUE)
ON DUPLICATE KEY UPDATE username=username;
-- Password hash is for 'admin123' using bcrypt

-- ============================================
-- Database Notes
-- ============================================
-- 1. All tables use InnoDB for ACID compliance and foreign key support
-- 2. UTF8MB4 charset for full emoji and international character support
-- 3. Passwords should be hashed using bcrypt before insertion
-- 4. The admin user is created with default credentials (username: admin, password: admin123)
-- 5. Soft delete implemented in conversations table via deleted_at column
-- 6. Daily limit tracking via daily_usage table for accurate user quota management
-- 7. Typing indicator represented by is_typing boolean in messages table
