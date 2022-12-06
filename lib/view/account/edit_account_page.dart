import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muscle_lab_3/utils/firestore/menus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';
import '../../model/account.dart';
import '../../utils/authentication.dart';
import '../../utils/firestore/users.dart';
import '../../utils/function_utils.dart';
import '../start_up/login_page.dart';


class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  Account myAccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();

  File? image;

  ImageProvider getImage(){
    if(image == null) {
      return NetworkImage(myAccount.imagePath);
    }else{
      return FileImage(image!);
    }
  }

  void initState(){
    super.initState();
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfIntroductionController = TextEditingController(text: myAccount.selfIntroduction);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kColorPrimary,
          elevation: 2,
          title:
          Text(AppLocalizations.of(context).edit_account_title,
              style:  const TextStyle(
                color: kColorAppbarText,
              )
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
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
                    foregroundImage: getImage(),
                    radius: 40,
                    child: Icon(Icons.add),
                  ),
                ),
                const SizedBox(height:20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: nameController,
                    cursorColor: kColorPrimary,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).edit_account_name,
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
                        labelText: AppLocalizations.of(context).edit_account_uid,
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
                      labelText: AppLocalizations.of(context).edit_account_intro,
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kColorPrimary, width:2)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                    onPressed:() async {
                      if (nameController.text.isNotEmpty
                          && userIdController.text.isNotEmpty
                          && selfIntroductionController.text.isNotEmpty) {
                        //&& image != null) {
                        String imagePath ='';
                        if (image == null){
                          imagePath = myAccount.imagePath;
                        } else{
                          var result  = await FunctionUtils.uploadImage(myAccount.id,image!);
                          imagePath = result;
                        }
                        Account updateAccount =Account(
                            id: myAccount.id,
                            name: nameController.text,
                            userId: userIdController.text,
                            selfIntroduction: selfIntroductionController.text,
                            imagePath: imagePath
                        );
                        Authentication.myAccount = updateAccount;
                        var result = await UserFirestore.updateUser(updateAccount);
                        if (result == true){
                          Navigator.pop(context,true);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: kColorPrimary, // background
                      onPrimary: Colors.white,
                      elevation: 2,// foreground
                    ),
                    child: Text(AppLocalizations.of(context).edit_account_button_update)
                ),
                const SizedBox(height: 20),
                TextButton(
                    style: TextButton.styleFrom(
                      primary: kColorPrimary,
                    ),
                    onPressed:(){
                      Authentication.signOut();
                      while(Navigator.canPop(context)){
                        Navigator.pop(context);
                      }
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => LoginPage()
                      ));
                    },
                    child: Text(AppLocalizations.of(context).edit_account_button_logout)
                ),
                const SizedBox(height: 20),
                TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed:()
                    {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Alert'),
                            content: Text('You Really delete?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text("No"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                  child: Text("Yes"),
                                  onPressed: ()
                                  {
                                    UserFirestore.deleteUser(myAccount.id);
                                    Authentication.deleteAuth();
                                    while(Navigator.canPop(context)){
                                      Navigator.pop(context);
                                    }
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(
                                        builder: (context) => LoginPage()
                                    )
                                    );
                                  }
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(AppLocalizations.of(context).edit_account_button_delete)
                ),
              ]
            ),
          ),
        )
    );
  }
}
