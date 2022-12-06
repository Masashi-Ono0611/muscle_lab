import 'package:cloud_firestore/cloud_firestore.dart';

class Menu{
  String id;
  String name;
  String contents;
  String videoURL;
  String videoOGP;
  String menuAccountId;
  Timestamp? menuCreatedTime;

  Menu({this.id='', this.name='', this.contents='', this.videoURL=''
    , this.videoOGP='',this.menuAccountId='',this.menuCreatedTime});
}