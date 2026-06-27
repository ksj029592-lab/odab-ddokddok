/**
 * Azure App Service에 배포할 Node.js 백엔드 예시
 * 경로: backend/server.js (별도 프로젝트)
 * 
 * 실제 구현:
 * 1. Azure App Service 생성
 * 2. Azure Cosmos DB 또는 SQL Database 연결
 * 3. 인증 로직 구현
 * 4. 환경 변수 설정
 */

// 필수 패키지:
// npm install express cors dotenv bcrypt jsonwebtoken mongodb

const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

dotenv.config();

const app = express();
app.use(express.json());
app.use(cors());

// ============ 샘플 라우트 ============

/**
 * POST /api/auth/signup
 * 요청: { fullName, userId, password, phone, school, grade }
 * 응답: { token, user: { userId, fullName, ... } }
 */
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { fullName, userId, password, phone, school, grade } = req.body;

    // 1. userId 중복 체크 (데이터베이스에서)
    // const existing = await db.users.findOne({ userId });
    // if (existing) return res.status(409).json({ message: '이미 존재하는 아이디' });

    // 2. 비밀번호 해싱
    const hashedPassword = await bcrypt.hash(password, 10);

    // 3. 사용자 생성 (데이터베이스에)
    const user = {
      userId,
      fullName,
      password: hashedPassword,
      phone,
      school,
      grade,
      createdAt: new Date(),
    };
    // await db.users.insertOne(user);

    // 4. JWT 토큰 생성
    const token = jwt.sign(
      { userId, uid: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.status(201).json({
      token,
      user: {
        userId,
        fullName,
        phone,
        school,
        grade,
      },
    });
  } catch (error) {
    res.status(500).json({ message: '회원 가입 실패' });
  }
});

/**
 * POST /api/auth/signin
 * 요청: { userId, password }
 * 응답: { token, user: { userId, fullName, ... } }
 */
app.post('/api/auth/signin', async (req, res) => {
  try {
    const { userId, password } = req.body;

    // 1. 사용자 조회 (데이터베이스에서)
    // const user = await db.users.findOne({ userId });
    // if (!user) return res.status(401).json({ message: '인증 실패' });

    // 2. 비밀번호 확인
    // const isValid = await bcrypt.compare(password, user.password);
    // if (!isValid) return res.status(401).json({ message: '인증 실패' });

    // 3. JWT 토큰 생성
    const token = jwt.sign(
      { userId, uid: 'user_id' },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.status(200).json({
      token,
      user: {
        userId,
        fullName: 'Sample User',
        phone: '010-0000-0000',
        school: 'School Name',
        grade: '1',
      },
    });
  } catch (error) {
    res.status(500).json({ message: '로그인 실패' });
  }
});

/**
 * PUT /api/users/profile (Bearer 토큰 필요)
 * 요청: { fullName, phone, school, grade }
 * 응답: { user: { ... } }
 */
app.put('/api/users/profile', authMiddleware, async (req, res) => {
  try {
    const { fullName, phone, school, grade } = req.body;
    const userId = req.user.userId;

    // 사용자 정보 업데이트 (데이터베이스에)
    // await db.users.updateOne(
    //   { userId },
    //   { $set: { fullName, phone, school, grade, updatedAt: new Date() } }
    // );

    res.status(200).json({
      user: {
        userId,
        fullName,
        phone,
        school,
        grade,
      },
    });
  } catch (error) {
    res.status(500).json({ message: '프로필 업데이트 실패' });
  }
});

/**
 * POST /api/auth/signout (Bearer 토큰 필요)
 */
app.post('/api/auth/signout', authMiddleware, (req, res) => {
  res.status(200).json({ message: '로그아웃 성공' });
});

// ============ 미들웨어 ============

function authMiddleware(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: '토큰이 필요합니다' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({ message: '유효하지 않은 토큰' });
  }
}

// ============ 서버 시작 ============

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
