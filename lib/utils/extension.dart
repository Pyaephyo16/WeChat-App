
import 'package:flutter/material.dart';

extension NavigateUtility on Widget{

  Future<dynamic> navigateToNextScreen(BuildContext context,Widget page){
     return Navigator.push(context,
       MaterialPageRoute(builder: (context) => page));
  }


  Future<dynamic> navigteToEnd(BuildContext context,Widget page){
    return Navigator.pushAndRemoveUntil(context,
     MaterialPageRoute(builder: (context) => page),
      (route) => false);
  }

  void snackBarDataShow(BuildContext context,String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green.withOpacity(0.8),
        ),
    );
  }

   void errorSnackBar(BuildContext context,String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        ),
    );
  }

}


