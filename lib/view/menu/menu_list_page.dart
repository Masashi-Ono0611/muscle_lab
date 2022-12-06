import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';
import '../../model/account.dart';
import '../../model/menu.dart';
import '../../utils/authentication.dart';
import '../../utils/firestore/menus.dart';
import '../../utils/firestore/users.dart';
import '../../utils/widget_utils.dart';
import '../account/edit_account_page.dart';
import 'add_menu_page.dart';

class MenuListPage extends StatefulWidget {
  @override
  _MenuListPageState createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  Account myAccount = Authentication.myAccount!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorPrimary,
        elevation: 2,
        title:
          Text(AppLocalizations.of(context).title,
            style: const TextStyle(
              color: kColorAppbarText,
            )
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditAccountPage()));
              if (result == true) {
                setState(() {
                  myAccount = Authentication.myAccount!;
                });
              }
            }
          ),
        ]
      ),
      body: Center(
        child:StreamBuilder<QuerySnapshot>(
          stream: UserFirestore.users.doc(myAccount.id)
              .collection('my_menus').orderBy('menu_created_time', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
             if(snapshot.hasData){
               List<String> myMenuIds = List.generate(snapshot.data!.docs.length, (index) {
                 //"myMenuIds"というListをsnapshot内のデータ長さ分(データの数分)作成
                 return snapshot.data!.docs[index].id;
               });
               print(myMenuIds);
               return FutureBuilder<List<Menu>?>(
                 future: MenuFirestore.getMenusFromIds(myMenuIds),
                 builder: (context, snapshot){
                   if(snapshot.hasData){
                     return ListView.builder(
                       itemCount: snapshot.data!.length,
                       itemBuilder: (BuildContext context, int index){
                         Menu menu = snapshot.data![index];
                         return
                           Column(
                             children: [
                               Slidable(
                                 actionPane: const SlidableDrawerActionPane(),
                                 secondaryActions: <Widget>[
                                   IconSlideAction(
                                       caption: AppLocalizations.of(context).slide_delete,
                                       color: Colors.red,
                                       onTap: () {
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
                                                     onPressed: () async {
                                                       MenuFirestore.deleteMenu(menu.id, myAccount.id);
                                                       Navigator.pop(context);
                                                     }
                                                 ),
                                               ],
                                             );
                                           },
                                         );
                                       },
                                       icon: Icons.delete
                                   ),
                                 ],
                                 child: ListTile(
                                     leading: Image.network(
                                       menu.videoOGP,
                                       height: 50,
                                     ),
                                     title: Text(
                                       menu.name,
                                       style: const TextStyle(
                                         fontSize: 15,
                                         fontWeight:FontWeight.bold,
                                         color: kColorMainText
                                       ),
                                     ),
                                     subtitle: Text(
                                       menu.contents,
                                       style: const TextStyle(
                                         fontSize: 15,
                                         // fontWeight:FontWeight.bold,
                                       ),
                                     ),
                                     trailing: IconButton(
                                         onPressed: ()  {
                                           _launchInBrowser(menu.videoURL);
                                         },
                                         icon: const DecoratedIcon(
                                           Icons.ondemand_video,
                                           color: kColorPrimary
                                         )
                                     )
                                 ),
                               ),
                               const Divider(), //区切り線
                             ],
                           );
                       },
                     );
                   }else{
                     return OverlayLoadingMolecules();
                     // return Text('データあり、読み込み中');
                   }
                 }
               );
             }else{
               return const Text('No Menu');
             }
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kColorPrimary,
        elevation: 5,
        onPressed: () {
          //画面遷移
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMenuPage(),
                fullscreenDialog: true,
              )
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

_launchInBrowser(String LinkURL) async {
  if (await canLaunch(LinkURL)) {
    await launch(
      LinkURL,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    throw 'このURLにはアクセスできません';
  }
}


/*
Future showConfirmDialog(
    BuildContext context,
    Menu menu,
    MenuListModel model,
    ) {

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        title: Text("削除確認"),
        content: Text("『${menu.name}』を削除しますか？"),
        actions: [
          TextButton(
            child: Text("いいえ"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("はい"),
            onPressed: () async {
              // modelで削除
              await model.delete(menu);
              Navigator.pop(context);
              final snackBar = SnackBar(
                content: Text("${menu.name}を削除しました"),
                backgroundColor: Colors.redAccent,
              );
              model.fetchMenuList();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      );
    },
  );
}
*/


