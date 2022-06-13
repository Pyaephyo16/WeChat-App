import 'package:flutter/material.dart';

class DivideLineView extends StatelessWidget {

final bool isContactPage;

DivideLineView({
  this.isContactPage = false,
});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: (isContactPage == true) ? MediaQuery.of(context).size.width * 0.7  : MediaQuery.of(context).size.width,
      height: 1,
      color: Colors.black.withOpacity(0.2),
    );
  }
}