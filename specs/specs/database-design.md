# Database Design - Chatbot AI Saung Vibe

## Overview
Database didesain menggunakan MySQL dengan struktur yang mendukung fitur-fitur chatbot yang diminta.

## Entity Relationship Diagram

```
┌─────────────┐
│   users     │
├─────────────┤
│ id (PK)     │
│ username    │
│ password    │
│ role        │
│ daily_limit │
│ is_active   │
└─────────────┘
      │
      ├─────────────────────────┬─────────────────────┐
      │                         │                     │
      v                         v                     v
┌──────────────────┐    ┌──────────────────┐   ┌──────────────────┐
│  conversations   │    │   daily_usage    │   │     messages     │
├──────────────────┤    ├──────────────────┤   ├──────────────────┤
│ id (PK)          │    │ id (PK)          │   │ id (PK)          │
│ user_id (FK)     │    │ user_id (FK)     │   │ conversation_id  │
│ title            │    │ usage_date       │   │ sender_type      │
│ created_at       │    │ message_count    │   │ content          │
│ updated_at       │    │ created_at       │   │ is_typing        │
│ deleted_at       │    │ updated_at       │   │ created_at       │
└──────────────────┘    └──────────────────┘   │ updated_at       │
      │                                        └──────────────────┘
      └────────────────────────┬─────────────────────┘
                               │
                     1:N relationship
```

## Table Descriptions

### 1. **users**
Tabel untuk menyimpan data user dan admin.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| id | INT | PK, AUTO_INCREMENT | User ID unik |
| username | VARCHAR(50) | UNIQUE, NOT NULL | Username untuk login |
| password | VARCHAR(255) | NOT NULL | Password yang sudah di-hash (bcrypt) |
| role | ENUM | DEFAULT 'user' | Role user: 'admin' atau 'user' |
| daily_limit | INT | DEFAULT 50 | Jumlah pesan maksimal per hari |
| is_active | BOOLEAN | DEFAULT TRUE | Status aktivitas user |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Waktu pembuatan akun |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Waktu update terakhir |

**Default Admin User:**
- Username: `admin`
- Password: `admin123` (hashed dengan bcrypt)
- Daily Limit: 999 (unlimited untuk admin)

### 2. **conversations**
Tabel untuk menyimpan percakapan/chat history.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| id | INT | PK, AUTO_INCREMENT | Conversation ID unik |
| user_id | INT | FK to users(id) | User yang memiliki percakapan ini |
| title | VARCHAR(255) | DEFAULT 'New Chat' | Judul percakapan (bisa di-rename) |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Waktu percakapan dibuat |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Waktu update terakhir |
| deleted_at | TIMESTAMP | NULL | Soft delete (jika ada) |

**Fitur:**
- Rename title conversation
- Soft delete support via `deleted_at` column

### 3. **messages**
Tabel untuk menyimpan pesan dalam sebuah percakapan.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| id | INT | PK, AUTO_INCREMENT | Message ID unik |
| conversation_id | INT | FK to conversations(id) | Percakapan mana pesan ini belongs |
| sender_type | ENUM | 'user' or 'ai' | Siapa yang mengirim: user atau AI |
| content | LONGTEXT | NOT NULL | Isi pesan |
| is_typing | BOOLEAN | DEFAULT FALSE | Typing indicator status |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Waktu pesan dikirim |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Waktu update terakhir |

**Fitur:**
- `sender_type` untuk membedakan pesan dari user atau AI
- `is_typing` untuk menampilkan typing indicator saat AI sedang menjawab
- LONGTEXT untuk mendukung pesan yang panjang

### 4. **daily_usage**
Tabel untuk tracking penggunaan harian dan enforce daily limit.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| id | INT | PK, AUTO_INCREMENT | Usage record ID |
| user_id | INT | FK to users(id) | User yang di-track |
| usage_date | DATE | NOT NULL | Tanggal pemakaian |
| message_count | INT | DEFAULT 0 | Jumlah pesan yang dikirim hari itu |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Waktu record dibuat |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Waktu update terakhir |

**Constraint:** `UNIQUE KEY (user_id, usage_date)` - memastikan hanya ada 1 record per user per hari

## Key Features Implementation

### ✅ Login & Register
- User credentials disimpan di table `users`
- Password harus di-hash sebelum disimpan

### ✅ Role Management
- Column `role` dengan ENUM ('admin', 'user')
- Admin diinisialisasi otomatis dengan username `admin` dan password `admin123`

### ✅ Chatbot Interface
- **Chatbot Detail**: Lihat conversation dari table `conversations`
- **Send Chat**: Insert message ke table `messages` dengan `sender_type = 'user'`
- **Reply by AI**: Insert message ke table `messages` dengan `sender_type = 'ai'`
- **Rename Chat**: Update `title` di table `conversations`
- **Delete Chat**: Soft delete via `deleted_at` timestamp di table `conversations`
- **Typing Indicator**: Boolean `is_typing` di table `messages`

### ✅ Daily Limit Per User
- Column `daily_limit` di table `users` menyimpan quota per user
- Table `daily_usage` tracking jumlah pesan per hari
- Admin dapat mengatur `daily_limit` value untuk setiap user
- Saat user registrasi, ada initial value untuk `daily_limit`

## Indexes untuk Performance

- `users(username)` - cepat lookup saat login
- `conversations(user_id)` - cepat query conversations per user
- `conversations(deleted_at)` - filter soft-deleted records
- `messages(conversation_id)` - cepat query messages per conversation
- `messages(sender_type)` - filter by sender type
- `messages(created_at)` - sorting by timestamp
- `daily_usage(user_id, usage_date)` - UNIQUE constraint untuk data integrity
- `daily_usage(usage_date)` - query usage data per tanggal

## Notes

1. **Character Set**: UTF8MB4 untuk support emoji dan karakter internasional
2. **Storage Engine**: InnoDB untuk ACID compliance dan foreign key support
3. **Password Hashing**: Gunakan bcrypt atau library sejenis untuk hash password
4. **Soft Delete**: Conversation bisa di-mark sebagai deleted tanpa benar-benar didelete
5. **Timezone**: Pastikan server timezone sudah konfigurasi dengan benar untuk timestamp yang akurat
