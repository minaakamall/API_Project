import 'package:firebase_auth/firebase_auth.dart';

class LoginDataSource {
  static String errormessage = '';
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        return true;
      } else {
        throw Exception('user not found');
      }
    } on FirebaseAuthException catch (e) {
      errormessage = e.message!;
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        errormessage = e.message!;
        print('Wrong password provided for that user.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
