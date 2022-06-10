import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';

class TutorialOverlay extends ModalRoute{

    String? commentTyped = null;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String get barrierLabel => "";

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
             child: Row(
               children: [
                 Expanded(
                   child: TextField(
                     onChanged: (text){
                       commentTyped = text;
                     },
                      style:const TextStyle(
                        color: Colors.white,
                        fontSize: TEXT_MEDIUM_1X,
                      ),
                      decoration: const InputDecoration(
                        focusColor: PRIMARY_COLOR,
                        hintText: WRITE_MESSAGE_TEXT,
                             hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: TEXT_MEDIUM_1X,
                          fontWeight: FontWeight.w400,
                        ),
                        ),
                    ),
                 ),
                 IconButton(
                   onPressed: (){
                     Navigator.pop(context,commentTyped);
                   },
                    icon: const Icon(Icons.send,size: MARGIN_SIZE_FOR_ICON,color: PRIMARY_COLOR,),
                    )
               ],
             ),
           ),
        ],
      ),
    );
  }


  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}