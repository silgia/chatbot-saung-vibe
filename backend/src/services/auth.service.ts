import prisma from '../utils/prisma';
import { hashPassword, comparePassword } from '../utils/password';
import { generateToken } from '../utils/jwt';

export interface RegisterInput {
  username: string;
  password: string;
}

export interface LoginInput {
  username: string;
  password: string;
}

export class AuthService {
  async register(data: RegisterInput) {
    const existingUser = await prisma.user.findUnique({
      where: { username: data.username },
    });

    if (existingUser) {
      throw new Error('Username already exists');
    }

    const hashedPassword = await hashPassword(data.password);

    const user = await prisma.user.create({
      data: {
        username: data.username,
        password: hashedPassword,
        role: 'USER',
        dailyLimit: 50,
        isActive: true,
      },
    });

    const token = generateToken({
      id: user.id,
      username: user.username,
      role: user.role === 'ADMIN' ? 'admin' : 'user',
    });

    return {
      id: user.id,
      username: user.username,
      role: user.role,
      token,
    };
  }

  async login(data: LoginInput) {
    const user = await prisma.user.findUnique({
      where: { username: data.username },
    });

    if (!user) {
      throw new Error('Username or password is incorrect');
    }

    const isPasswordCorrect = await comparePassword(data.password, user.password);

    if (!isPasswordCorrect) {
      throw new Error('Username or password is incorrect');
    }

    if (!user.isActive) {
      throw new Error('Account is inactive');
    }

    const token = generateToken({
      id: user.id,
      username: user.username,
      role: user.role === 'ADMIN' ? 'admin' : 'user',
    });

    return {
      id: user.id,
      username: user.username,
      role: user.role,
      token,
    };
  }

  async getCurrentUser(userId: number) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        username: true,
        role: true,
        dailyLimit: true,
        isActive: true,
        createdAt: true,
      },
    });

    if (!user) {
      throw new Error('User not found');
    }

    return user;
  }
}

export default new AuthService();
