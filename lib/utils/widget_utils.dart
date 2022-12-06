import 'package:flutter/material.dart';

class WidgetUtils{
  static AppBar createAppBar(String title){
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(title, style: TextStyle(color: Colors.black),),
      centerTitle: true,
    );
  }
}

class OverlayLoadingMolecules extends StatelessWidget {
  OverlayLoadingMolecules();

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width:double.infinity,
        height:double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
          ],
        ),
      );
  }
}