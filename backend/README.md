# Backend Setup - Chatbot Saung Vibe

## Struktur Direktori

```
backend/
├── src/
│   ├── controllers/       # Request handlers
│   ├── middleware/        # Express middleware (auth, etc)
│   ├── routes/           # API endpoints
│   ├── services/         # Business logic
│   ├── utils/            # Helper functions
│   └── index.ts          # Main server file
├── prisma/
│   ├── schema.prisma     # Database schema
│   └── migrations/       # Database migrations
├── package.json
├── tsconfig.json
├── .env.example          # Example environment variables
├── .gitignore
└── README.md
```

## Langkah Setup

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Konfigurasi Environment Variables

```bash
cp .env.example .env
```

Edit `.env` dan sesuaikan:
```env
DATABASE_URL=mysql://user:password@localhost:3306/chatbot_saung_vibe
JWT_SECRET=your_secure_jwt_secret_key
GEMINI_API_KEY=your_gemini_api_key
PORT=3000
NODE_ENV=development
```

### 3. Buat Database di MySQL

Jalankan script di `prisma/migrations/init.sql` ke MySQL:

```bash
mysql -u user -p < prisma/migrations/init.sql
```

Atau gunakan Prisma:

```bash
npx prisma migrate deploy
```

### 4. Generate Prisma Client

```bash
npm run prisma:generate
```

### 5. Jalankan Development Server

```bash
npm run dev
```

Server akan berjalan di `http://localhost:3000`

## Available Scripts

- `npm run dev` - Jalankan server dalam mode development
- `npm run build` - Compile TypeScript ke JavaScript
- `npm start` - Jalankan server production
- `npm run prisma:generate` - Generate Prisma Client
- `npm run prisma:migrate` - Jalankan database migrations
- `npm run prisma:studio` - Buka Prisma Studio untuk melihat/manage data

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: MySQL
- **ORM**: Prisma
- **Authentication**: JWT
- **AI API**: Google Gemini API
- **Password Hashing**: bcryptjs
- **CORS**: Express CORS

## Notes

- Default admin: username `admin`, password `admin123`
- Daily limit default: 50 messages per user
- Soft delete implementation untuk conversations
- Typing indicator support untuk real-time feel

## API Endpoints (To be implemented)

- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login
- `GET /api/auth/me` - Current user info
- `GET /api/conversations` - List conversations
- `POST /api/conversations` - Create new conversation
- `PATCH /api/conversations/:id` - Rename conversation
- `DELETE /api/conversations/:id` - Delete conversation
- `POST /api/conversations/:id/messages` - Send message
- `GET /api/conversations/:id/messages` - Get messages

## Troubleshooting

**Error: "Can't connect to database"**
- Pastikan MySQL running
- Check `DATABASE_URL` di `.env`

**Error: "Prisma client not found"**
```bash
npm run prisma:generate
```

**Error: "Migrations not synced"**
```bash
npx prisma migrate deploy
```
