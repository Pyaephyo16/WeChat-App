import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/chat_tab_bloc.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';
import 'package:we_chat_app/pages/conversation_page.dart';
import 'package:we_chat_app/pages/tabs/contact_tab.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/view_items/chat_head_view.dart';
import 'package:we_chat_app/view_items/divide_line_view.dart';
import 'package:we_chat_app/utils/extension.dart';
import 'package:we_chat_app/view_items/person_name_view.dart';
import 'package:we_chat_app/view_items/pserson_description_view.dart';

class ChatTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatTabBloc(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
            backgroundColor: PRIMARY_COLOR,
            centerTitle: true,
            title: AppBarTitleView(title: WE_CHAT_TITLE_TEXT),
            actions: [
              IconButton(
                onPressed: (){},
                 icon:const Icon(Icons.search,size: MARGIN_SIZE_FOR_APP_BAR_ICON,color: Colors.white),
                 ),
                 IconButton(
                onPressed: (){},
                 icon:const Icon(Icons.add_circle_outline,size: MARGIN_SIZE_FOR_APP_BAR_ICON,color: Colors.white),
                 ),
            ],
          ),
           body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1,vertical: MARGIN_SMALL),
          child: Selector<ChatTabBloc,UserVO>(
              selector: (context,bloc) => bloc.loggedInUser ?? UserVO.empty(),
              shouldRebuild: (pervious,next) => pervious != next,
              builder: (context,loggedInUser,child) =>
               Selector<ChatTabBloc,List<ChatHistoryVO>>(
              selector: (context,bloc) => bloc.chatHistory,
              shouldRebuild: (pervious,next) => pervious != next,
              builder: (context,chatHistory,child){
               print("widget layer ====> ${chatHistory.length}"); 
                  return (chatHistory == null || chatHistory.length == 0) ?
                 const NoFriendView()
                  : ListView.separated(
                separatorBuilder: (context,index) => DivideLineView(),
                itemCount: chatHistory.length,
                itemBuilder: (BuildContext context,int index){
                  return DismissiblePersonView(
                    index: index,
                    users: chatHistory,
                    onClick: (){
                      navigateToNextScreen(
                        context,
                        ConservationPage(
                          friend: chatHistory[index].friend ?? UserVO.empty(),
                          loggedInUser: loggedInUser,
                          ));
                    },
                    remove: (context){
                //    ChatTabBloc bloc = Provider.of(context,listen: false);
                // bloc.remoteUser(index);
                    },
                  );
                }
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DismissiblePersonView extends StatelessWidget {

  final int index;
  final List<ChatHistoryVO> users;
  final Function(BuildContext) remove;
  final Function onClick;

  DismissiblePersonView({
    required this.index,
    required this.users,
    required this.remove,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
         children: [
            SlidableAction(
             flex: 2,
              onPressed: (BuildContext context){
                remove(context);
              },
            backgroundColor: APP_BAR_BACKGROUND_COLOR,
            foregroundColor: Colors.red,
            icon: Icons.cancel,
      ),
         ],
         ),
      child: ChatPersonView(
        user: users[index],
        onClick: (){
          onClick();
        },
        ),
    );
  }
}

// class DismissiblePersonView extends StatelessWidget {
//   final int index;
//   DismissiblePersonView({
//     required this.index,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//       key: Key("ChatPerson$index"),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         child: IconButton(
//           onPressed: (){
//           },
//           icon: Icon(Icons.cancel,size: 32,color: Colors.red,),
//         ),
//       ),
//       child: ChatPersonView(
//         user: userDummyList[index],
//       ),
//     );
//   }
// }

class ChatPersonView extends StatelessWidget {

  ChatHistoryVO user;
  final Function onClick;

  ChatPersonView({
    required this.user,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onClick();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: MARGIN_SMALL,vertical: MARGIN_SMALL_1X),
        child: Row(
          children: [
            ChatHeadView(
              isChatPage: true,
              image: user.friend?.profileImage ?? CONSTANT_IMAGE,
            ),
           const SizedBox(width: MARGIN_MEDIUM,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                PersonNameView(
                  name: user.friend?.userName ?? "",
                ),
                SizedBox(height: MARGIN_PRE_SMALL,),
                // PersonDescriptionView(
                //   isChatPage: true,
                //   description: user.messages.last.message ?? "",
                // ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    user.messages.last.message ?? "",
                    overflow: TextOverflow.ellipsis,
                    style:const TextStyle(
                        color: CHAT_HEAD_SUBTITLE_COLOR,
                      fontWeight: FontWeight.w500,
                      fontSize: TEXT_MEDIUM_1,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}





