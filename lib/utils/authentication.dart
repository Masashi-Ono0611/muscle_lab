import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/account.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  static Future<dynamic> signUp({required String email, required String pass})async{
    try{
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      print('登録完了');
      return newAccount;
    } on FirebaseAuthException catch(e){
      print('登録エラー');
      return false;
    }
  }

  // emailサインイン用
  static Future<dynamic> emailSignIn({required String email, required String pass}) async{
    try{
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: pass
      );
      currentFirebaseUser = _result.user;
      print('サインイン完了');
      return _result ;
    } on FirebaseAuthException catch(e){
      print('サインインエラー');
      return false;
    }
  }

  // Googleサインイン用
  static Future<dynamic> signInWithGoogle() async {
    // 認証フローを起動する
    final GoogleSignInAccount? signinAccount = await GoogleSignIn().signIn();

    if (signinAccount == null)
    {
      print ("ALERT: signinAccount is null");
      return null;
    }

    else{
      GoogleSignInAuthentication auth= await signinAccount.authentication;
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await signinAccount.authentication;
      // 新しいクレデンシャルを作成する
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // 作成されたクレデンシャルをUserCredential型に変換
      final UserCredential _result = await FirebaseAuth.instance.signInWithCredential(credential);
      currentFirebaseUser = _result.user;
      print('サインイン完了');
      print(_result);
      return _result ;
    }
  }

  static Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }
  static Future<void> deleteAuth() async{
    await _firebaseAuth.currentUser?.delete();
  }
}