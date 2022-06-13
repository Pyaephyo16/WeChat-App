
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
import 'package:we_chat_app/pages/tabs/discover_tab.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/chat_head_view.dart';

class OverlayPostDetail extends ModalRoute{

  final NewsFeedVO postDetail;

  OverlayPostDetail({
    required this.postDetail,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  var date = DateFormat().add_jm().format(DateTime.now());

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
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: (postDetail.post == "") ? MediaQuery.of(context).size.height * 0.3 : MediaQuery.of(context).size.height * 0.5,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PostTimeView(
                    isDetail: true,
                    time: "$date",
                    ),
                  Expanded(
                    flex: (postDetail.post == "") ? 1 : 2,
                    child: PostImageAndDescriptionView(
                      isDetail: true,
                      post: postDetail,
                      favourite: (){
                      },
                      comment: (){
                      },
                      editPost: (){
                      },
                      deletePost: (){
                      },
                      ),
                    ),
                ],
              ),
              ),
    
    
              Positioned(
                left: MARGIN_MEDIUM_1,
                child: ChatHeadView(
                  image: "${postDetail.profileImage}",
                   isChatPage: true,
                   ),
                )
          ],
        ),
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