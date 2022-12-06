import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';
import '../../model/menu.dart';
import '../../utils/authentication.dart';
import '../../utils/firestore/menus.dart';

class AddMenuPage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  TextEditingController videoURLController = TextEditingController();
  // 入力文字を読み取るコントローラ↑

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kColorPrimary,
          elevation: 2,
          title:
          Text(AppLocalizations.of(context).add_menu_title,
              style:  const TextStyle(
                color: kColorAppbarText,
              )
          ),
        ),
        body:  Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                cursorColor: kColorPrimary,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).add_menu_name,
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kColorPrimary, width:2)
                        ),
                    ),
                ),
              const SizedBox(height:20),
              TextField(
                controller: contentsController,
                cursorColor: kColorPrimary,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).add_menu_contents,
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kColorPrimary, width:2)
                  ),
                ),
              ),
              const SizedBox(height:20),
              TextField(
                controller: videoURLController,
                cursorColor: kColorPrimary,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).add_menu_videoURL,
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: kColorPrimary, width:2)
                  ),
                ),
              ),
              const SizedBox(height:40),
              ElevatedButton(
                onPressed:() async {
                  // 投稿実装
                  if(nameController.text.isNotEmpty){
                    Menu newMenu = Menu(
                      name: nameController.text,
                      contents: contentsController.text,
                      videoURL: videoURLController.text,
                      menuAccountId:Authentication.myAccount!.id,
                    );
                    var result = await MenuFirestore.addMenu(newMenu);
                    if (result == true){
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: kColorPrimary, // background
                  onPrimary: Colors.white,
                  elevation: 2,// foreground
                ),
                child:Text(AppLocalizations.of(context).add_menu_button,),
              )
            ],
          ),
        )
      );
  }
}
