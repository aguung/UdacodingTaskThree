import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User> getCurrentUser() async {
    User user = _firebaseAuth.currentUser;
    return user;
  }

  Future<Either<String, User>> signIn(String email, String password) async {
    try {
      User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(e.message);
    }
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<Either<String, User>> signUp(String email, String password) async {
    try {
      User user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(e.message);
    }
  }
}
