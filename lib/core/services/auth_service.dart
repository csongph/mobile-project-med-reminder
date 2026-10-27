import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service จัดการ Firebase Authentication
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleInitialization;

  Future<void> _initializeGoogle() {
    return _googleInitialization ??= _googleSignIn.initialize();
  }

  /// Stream ของ auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// User ปัจจุบัน
  User? get currentUser => _auth.currentUser;

  /// UID ของ user ปัจจุบัน
  String? get currentUserId => _auth.currentUser?.uid;

  /// ตรวจสอบว่า user ล็อกอินอยู่หรือไม่
  bool get isSignedIn => _auth.currentUser != null;

  /// Sign in ด้วย Email และ Password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Sign up ด้วย Email และ Password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _initializeGoogle();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    await _initializeGoogle();
    if (!_googleSignIn.supportsAuthenticate()) {
      throw Exception('อุปกรณ์นี้ไม่รองรับการเข้าสู่ระบบด้วย Google');
    }

    final account = await _googleSignIn.authenticate();
    final authentication = account.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
    );
    await _auth.signInWithCredential(credential);
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Update user display name
  Future<void> updateDisplayName({required String displayName}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
    }
  }

  /// Map FirebaseAuthException เป็น error message ที่ user-friendly
  String _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'ไม่พบบัญชีผู้ใช้นี้';
      case 'wrong-password':
        return 'รหัสผ่านไม่ถูกต้อง';
      case 'email-already-in-use':
        return 'อีเมลนี้ถูกใช้งานแล้ว';
      case 'invalid-email':
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      case 'weak-password':
        return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
      case 'user-disabled':
        return 'บัญชีผู้ใช้ถูกระงับการใช้งาน';
      case 'too-many-requests':
        return 'ขออภัย มีการพยายามเข้าสู่ระบบมากเกินไป กรุณาลองใหม่ภายหลัง';
      case 'operation-not-allowed':
        return 'การล็อกอินด้วยอีเมล/รหัสผ่านไม่ได้เปิดใช้งาน';
      default:
        return 'เกิดข้อผิดพลาด: ${e.message}';
    }
  }
}
