import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import '../../model/menu.dart';

class MenuFirestore{
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference menus = _firestoreInstance.collection('menus');

  static Future<dynamic> addMenu(Menu newMenu) async{

    try{
      final CollectionReference _userMenus = _firestoreInstance.collection('users')
          .doc(newMenu.menuAccountId).collection('my_menus');
      var result = await menus.add({
        'name': newMenu.name,
        'contents': newMenu.contents,
        'videoURL': newMenu.videoURL,
        'videoOGP': (await MetadataFetch.extract(newMenu.videoURL))?.image,
        'menu_account_id':newMenu.menuAccountId,// ユーザーIDと紐付け
        'menu_created_time': Timestamp.now()
      });

      _userMenus.doc(result.id).set({
        'menu_id': result.id,
        'menu_created_time': Timestamp.now()
      });
      print('Menu登録完了');
      return true;
    } on FirebaseException catch(e){
      print('Menu登録エラー');
      return false;
    }
  }


  static Future<List<Menu>?> getMenusFromIds(List<String> ids) async{
    List<Menu> menuList = [];
    try{
      await Future.forEach(ids, (String id) async{
        var doc = await menus.doc(id).get();
        print(menus.doc(id));
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Menu menu = Menu(
            id: doc.id,
            name: data['name'],
            contents: data['contents'],
            videoURL: data['videoURL'],
            videoOGP: data['videoOGP'],
            menuAccountId: data['menu_account_id'],
            menuCreatedTime: data['menu_created_time']
        );
        menuList.add(menu);
        print(doc.id);
        print(data['name']);
        print(data['contents']);
      });
      print('自分のメニュー取得完了');
      return menuList;
    } on FirebaseException catch(e){
      print('自分のメニュー取得エラー：$e');
      return null;
    }
  }

  static Future<dynamic> deleteMenu(String menuId, accountId)
  async{
    await FirebaseFirestore.instance.collection('menus').doc(menuId).delete();
    // "menus"の中に保存された削除対象のmenuデータを削除する
    await FirebaseFirestore.instance.collection('users').doc(accountId)
        .collection('my_menus').doc(menuId).delete();
    // "users>my_menus"の中に保存された削除対象のmy_menuデータを削除する
  }
  static Future<dynamic> deleteMenuAll(String accountId)
    async{
      final CollectionReference _userMenus
      = FirebaseFirestore.instance.collection('users').doc(accountId).collection('my_menus');
      var snapshot = await _userMenus.get();
      snapshot.docs.forEach((doc) async{
        await menus.doc(doc.id).delete();
        _userMenus.doc(doc.id).delete();
      });
    }
}
