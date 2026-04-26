# Requirements Chatbot AI using Gemini API Key

## Background

Saya ingin membuat aplikasi chatbot menggunakan Gemini API Key. Chatbot tersebut memiliki fitur sebagai berikut:
- Login and register
- Role (admin dan user). Untuk role admin, akan pertama kali dibuat oleh sistem dengan ketentuan berikut:
  - username: `admin`, password: `admin123`
- Chatbot interface
  - Chatbot detail
  - Send chat
  - Reply chat by AI
  - Rename chat conversation
  - Delete current chat
  - Ada typing indicator ketika AI sedang mengetik jawaban
- Daily limit per masing-masing user (diset oleh admin, ada initial value-nya ketika user pertama kali daftar)

## Tema dan tampilan

Project ini menggunakan Tailwind sebagai CSS Framework.

Primary color: #606c38
Secondary color: #fefae0
Accent 1: #dda15e
Accent 2: #283618

## Technology stacks

### Frontend:
1. TypeScript
2. React.js
3. Vite
4. Tailwind CSS

### Backend
1. Node.js
2. MySQL
3. Gemini API Key
4. Express.js
5. Prisma