import 'package:flutter/material.dart';

class DivideLineView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Colors.black.withOpacity(0.2),
    );
  }
}