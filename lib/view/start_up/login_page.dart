import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';
import '../../utils/authentication.dart';
import '../../utils/firestore/users.dart';
import '../menu/menu_list_page.dart';
import 'create_account_page.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:SizedBox(
          height: double.infinity,
          width: double.infinity,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Text(AppLocalizations.of(context).title,
                style:const TextStyle(
                  fontSize:36,
                  fontWeight:FontWeight.bold,
                  color: kColorMainText
                )
              ),
              const SizedBox(height:20),
              SizedBox(
                  width:300,
                  child: TextField(
                    controller: emailController,
                    cursorColor: kColorPrimary,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).mail_address,
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kColorPrimary, width:2)
                        ),
                    ),
                  )
              ),
              SizedBox(
                  width:300,
                  child: TextField(
                    obscureText: _isObscure,
                    controller: passController,
                    cursorColor: kColorPrimary,
                    decoration: InputDecoration(
                      // hintText: AppLocalizations.of(context).password,
                      labelText: AppLocalizations.of(context).password,
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
                  )
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed:() async{
                    var result = await Authentication.emailSignIn(email: emailController.text, pass: passController.text);
                    if(result is UserCredential) {
                      var _result = await UserFirestore.getUser(result.user!.uid);
                      if (_result == true) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuListPage(),
                              fullscreenDialog: true,
                            )
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: kColorPrimary, // background
                    onPrimary: Colors.white,
                    elevation: 2,// foreground
                  ),
                  child: Text(AppLocalizations.of(context).login_w_email),
              ),
              const SizedBox(height:20),
              RichText(
                text: TextSpan(
                    style: const TextStyle(color: kColorPrimary),
                    children:[
                      TextSpan(
                          text: AppLocalizations.of(context).new_registration,
                          recognizer: TapGestureRecognizer()..onTap=(){
                            //アカウント作成実行
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreatAccounPage(),
                                  fullscreenDialog: true,
                                )
                            );
                          }
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
