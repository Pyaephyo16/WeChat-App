
import 'package:flutter/material.dart';

extension NavigateUtility on Widget{

  void navigateToNextScreen(BuildContext context,Widget page){
      Navigator.push(context,
       MaterialPageRoute(builder: (context) => page));
  }

  void snackBarDataShow(BuildContext context,String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green.withOpacity(0.2),
        ),
    );
  }

}


