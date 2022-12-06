import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../main.dart';
import '../../model/account.dart';
import '../../model/menu.dart';
import '../../utils/authentication.dart';
import '../../utils/firestore/menus.dart';
import '../../utils/firestore/users.dart';
import '../../utils/function_utils.dart';
import '../menu/menu_list_page.dart';

class CreatAccounPage extends StatefulWidget {
  @override
  State<CreatAccounPage> createState() => _CreatAccounPageState();
}

class _CreatAccounPageState extends State<CreatAccounPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  File? image;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kColorPrimary,
          elevation: 2,
          title:
          Text(AppLocalizations.of(context).add_account_title,
              style:  const TextStyle(
                color: kColorAppbarText,
              )
          ),
        ),
        body:SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height:40),
                GestureDetector(
                  onTap: () async{
                     var result = await FunctionUtils.getImageFromGallery();
                     if (result != null){
                       setState((){
                         image = File(result.path);
                       });
                     }
                  },
                  child: CircleAvatar(
                    foregroundImage: image == null
                        ? null
                        : FileImage(image!),
                    radius: 40,
                    child: const Icon(Icons.add),
                  ),
                ),
                const SizedBox(height:20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: nameController,
                    cursorColor: kColorPrimary,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).add_account_name,
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kColorPrimary, width:2)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: userIdController,
                      cursorColor: kColorPrimary,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).add_account_uid,
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: kColorPrimary, width:2)
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: selfIntroductionController,
                    cursorColor: kColorPrimary,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).add_account_intro,
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kColorPrimary, width:2)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: emailController,
                      cursorColor: kColorPrimary,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).add_account_mail_address,
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: kColorPrimary, width:2)
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: _isObscure,
                    controller: passController,
                    cursorColor: kColorPrimary,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).add_account_password,
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kColorPrimary, width:2)
                      ),
                      suffixIcon: IconButton(
                        icon:
                        Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                          color: _isObscure
                              ? Colors.grey
                              : kColorPrimary,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  height: 30,
                  child: ElevatedButton(
                      onPressed:()async {
                        if (nameController.text.isNotEmpty
                            && userIdController.text.isNotEmpty
                            && selfIntroductionController.text.isNotEmpty
                            && emailController.text.isNotEmpty
                            && passController.text.isNotEmpty
                            && image != null) {
                          var result = await Authentication.signUp(
                              email: emailController.text,
                              pass: passController.text);
                          if (result is UserCredential) {
                            String imagePath = await FunctionUtils.uploadImage(result.user!.uid, image!);
                            Account newAccount = Account(
                              id: result.user!.uid,
                              name: nameController.text,
                              userId: userIdController.text,
                              selfIntroduction: selfIntroductionController.text,
                              imagePath: imagePath,
                            );
                            await UserFirestore.setUser(newAccount);

                            // 新規アカウント作成時にデフォルトのメニューを登録する
                            Menu _initialMenu = Menu(
                              name: "Bench Press",
                              contents: "50kg 10times 3sets",
                              videoURL: "https://www.youtube.com/watch?v=hXWPuHddS5E",
                              menuAccountId:result.user!.uid,
                            );
                            var _result = await MenuFirestore.addMenu(_initialMenu);
                            if (_result == true) {
                              Navigator.pop(context);
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: kColorPrimary, // background
                        onPrimary: Colors.white,
                        elevation: 2,// foreground
                      ),
                      child: Text(AppLocalizations.of(context).add_account_button_update)
                  ),
                ),
                const SizedBox(height:30),
                SizedBox(
                  width: 200,
                  height: 30,
                  child: SignInButton(
                      Buttons.google,
                      text: AppLocalizations.of(context).add_account_button_google,
                      elevation: 2,

                      onPressed: () async {
                        // 認証フローを起動する
                        GoogleSignInAccount? signinAccount = await GoogleSignIn().signIn();
                        if (signinAccount == null) return;
                        GoogleSignInAuthentication? auth= await signinAccount.authentication;

                        // 新しいクレデンシャルを作成する
                        final OAuthCredential credential = GoogleAuthProvider.credential(
                          accessToken: auth.accessToken,
                          idToken: auth.idToken,
                        );
                        print(credential);

                        // 認証情報をFirebaseに登録
                        User? user =
                            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
                        if (user != null) {
                          Account newAccount = Account(
                            id:user.uid,
                            name: "Google Account",
                            userId: "Google Account",
                            selfIntroduction: "Google Account",
                            imagePath: "https://play-lh.googleusercontent.com/aFWiT2lTa9CYBpyPjfgfNHd0r5puwKRGj2rHpdPTNrz2N9LXgN_MbLjePd1OTc0E8Rl1=w240-h480-rw",
                          );
                          await UserFirestore.setUser(newAccount);

                          // 新規アカウント作成時にデフォルトのメニューを登録する
                          Menu _initialMenu = Menu(
                            name: "Bench Press",
                            contents: "50kg 10times 3sets",
                            videoURL: "https://www.youtube.com/watch?v=hXWPuHddS5E",
                            menuAccountId:user.uid,
                          );
                          var _result = await MenuFirestore.addMenu(_initialMenu);
                          if (_result == true) {
                            Navigator.pop(context);
                          }
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
