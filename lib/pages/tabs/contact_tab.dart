import 'package:azlistview/azlistview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/contact_tab_bloc.dart';
import 'package:we_chat_app/data/vos/az_vo/az_user_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/dummy/az_item_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';
import 'package:we_chat_app/pages/conversation_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/view_items/chat_head_view.dart';
import 'package:we_chat_app/view_items/divide_line_view.dart';
import 'package:we_chat_app/utils/extension.dart';

class ContactTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactTabBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: PRIMARY_COLOR,
          centerTitle: true,
          title: AppBarTitleView(title: "contact".tr()),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
              child: IconButton(
                onPressed: (){
                }, 
                icon: Icon(Icons.person_add_alt,size: MARGIN_SIZE_FOR_ICON,color: Theme.of(context).bottomAppBarColor,),
                ),
            ),
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) =>
                SearchButtonView(
                  search: (text){
                    ContactTabBloc bloc = Provider.of(context,listen: false);
                    bloc.searchByName(text);
                  },
                ),
              ),
             const SizedBox(height: MARGIN_SMALL_1,),
             const ContactRowView(),
              Expanded(
                child: Selector<ContactTabBloc,UserVO>(
                    selector: (context,bloc) => bloc.loggedInUser ??  UserVO.empty(),
                    shouldRebuild: (previous,next) => previous != next,
                    builder: (context,loggedInUser,child) =>
                   Selector<ContactTabBloc,List<AZUserVO>>(
                    selector: (context,bloc) => bloc.azContactList ??  [],
                    shouldRebuild: (previous,next) => previous != next,
                    builder: (context,azContactList,child){
                     return (azContactList.length == 0 || azContactList == null) ?
                     NoFriendView(
                      text: "no_contact".tr(),
                     ) 
                    :  ContactSection(
                      user: azContactList,
                      onClick: (user){
                    navigateToNextScreen(
                      context,
                      ConservationPage(friend: user,loggedInUser: loggedInUser,));
                      },
                    );
                    }
                    
                  ),
                ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class NoFriendView extends StatelessWidget {
 
  final String text;

  NoFriendView({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        
              width: 460,
              height: 400,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset("./asset/image/no_chat_message.png",
              fit: BoxFit.cover,
              ),
            ),

           Text(text,
          style:const TextStyle(
           fontSize: MARGIN_MEDIUM_1,
           color: Colors.black,
           fontWeight: FontWeight.w600,
          ),
          ),
          ],
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {


  final List<AZUserVO> user;
  final Function(UserVO) onClick;

  ContactSection({
    required this.user,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return AzListView(
      data: user,
       itemCount: user.length,
      //  indexHintBuilder: (context,hint) => Container(
      //    alignment: Alignment.center,
      //    child: Text("$hint",
      //    style: TextStyle(
      //      fontSize: 18,
      //      color: Colors.white,
      //    ),
      //    )
      //  ),
      //  indexBarOptions: IndexBarOptions(
      //    needRebuild: true,
      //    indexHintAlignment: Alignment.centerRight,
      //    selectTextStyle: TextStyle(
      //      color: PRIMARY_COLOR,
      //      fontWeight: FontWeight.w500,
      //    )
      //  ),
      indexBarMargin:const EdgeInsets.only(right: MARGIN_MEDIUM_1),
        itemBuilder: (BuildContext context,int index){
          final tag = user[index].getSuspensionTag();    
       final offStage = !user[index].isShowSuspension;
           return ContactPeopleShowView(
             user: user,
             index: index,
             tag: tag,
             offStage: offStage,
             onClick: (){
               onClick(user[index].person);
             },
             );
        });
  }
}

class ContactPeopleShowView extends StatelessWidget {
   ContactPeopleShowView({
    Key? key,
    required this.user,
    required this.index,
    required this.tag,
    required this.offStage,
    required this.onClick,
  }) : super(key: key);

  final List<AZUserVO> user;
  final int index;
  final String tag;
  final bool offStage;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onClick();
      },
      child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1,vertical: MARGIN_MEDIUM_1X),
            child: Column(
       mainAxisSize: MainAxisSize.min,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          Offstage(
            offstage: offStage,
            child: Container(
              alignment: Alignment.centerLeft,
               width: MediaQuery.of(context).size.width,
               height: CONTACT_NAME_LIST_TITLE_CONTAINGER_HEIGHT,
               margin:const EdgeInsets.symmetric(vertical: 4),
               color: Theme.of(context).primaryColorDark,
               child: Padding(
                 padding: const EdgeInsets.only(left: MARGIN_FOR_CONTACT_NAME_TITLE),
                 child: Text("${tag}",
                 style:const TextStyle(
                   color: UNSELECTED_ICON_COLOR,
                   fontSize: MARGIN_MEDIUM_2X,
                   fontWeight: FontWeight.bold,
                 ),
                 ),
               ),
             ),
          ),
         Row(
           children: [
             ChatHeadView(
               image: user[index].person.profileImage ?? CONSTANT_IMAGE,
                isChatPage: true,
               ),
              const SizedBox(width: MARGIN_MEDIUM,),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text(user[index].person.userName ?? "",
                      style: TextStyle(
                         color: Theme.of(context).primaryColor,
                         fontWeight: FontWeight.w500,
                         fontSize: TEXT_LARGE,
                       ),
                     ),
                    const SizedBox(height: MARGIN_MEDIUM_1,),
                     DivideLineView(
                      isContactPage: true,
                     ),
                   ],
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

class ContactRowView extends StatelessWidget {
  const ContactRowView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: CONTACT_ICON_ROW_CONTAINER_HEIGHT,
      decoration:const BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: CONTACT_ROW_ICON_COLOR)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ContactMenuIconView(
              icon:const Icon(Icons.person_add_alt,size: MARGIN_SIZE_FOR_ICON,color: CHAT_HEAD_SUBTITLE_COLOR,),
              title: "new_friend".tr(),
            ),
          ),
          VerticalLineView(),
          Expanded(
            child: ContactMenuIconView(
              icon:const Icon(Icons.people_alt_outlined,size: MARGIN_SIZE_FOR_ICON,color: CHAT_HEAD_SUBTITLE_COLOR,),
              title: "group_chat".tr(),
            ),
          ),
          VerticalLineView(),
          Expanded(
            child: ContactMenuIconView(
              icon:const Icon(Icons.bookmarks_outlined,size: MARGIN_SIZE_FOR_ICON,color: CHAT_HEAD_SUBTITLE_COLOR,),
              title: "tags".tr(),
            ),
          ),
          VerticalLineView(),
          Expanded(
            child: ContactMenuIconView(
              icon:const Icon(Icons.book_outlined,size: MARGIN_SIZE_FOR_ICON,color: CHAT_HEAD_SUBTITLE_COLOR,),
              title: "offical_accounts".tr(),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalLineView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1,height: DIVIDE_VERTICAL_LINE,color: CONTACT_ROW_ICON_COLOR,);
  }
}

class ContactMenuIconView extends StatelessWidget {

  final Icon icon;
  final String title;

  ContactMenuIconView({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        Expanded(
          child: Text(title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:const TextStyle(
            color: CHAT_HEAD_SUBTITLE_COLOR,
            fontSize: TEXT_MEDIUM_1,
            fontWeight: FontWeight.w500,
          ),
          ),
        )
      ],
    );
  }
}


class SearchButtonView extends StatelessWidget {

  final Function(String) search;

  SearchButtonView({
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     padding:const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
     margin:const EdgeInsets.only(top: MARGIN_SMALL,left: MARGIN_MEDIUM_1,right: MARGIN_MEDIUM_1),
     width: MediaQuery.of(context).size.width,
     height:  CONTACT_NAME_LIST_TITLE_CONTAINGER_HEIGHT,
     clipBehavior: Clip.antiAlias,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(MARGIN_SMALL),
       color: CHAT_HEAD_SUBTITLE_COLOR,
     ),
      child: Center(
        child: IntrinsicWidth(
          child: TextField(
           textAlignVertical: TextAlignVertical.center,
            style:const TextStyle(
              color: UNSELECTED_ICON_COLOR,
              fontSize: TEXT_MEDIUM_1X,
            ),
            onChanged: (text){
              search(text);
            },
            decoration:const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: SEARCH_TEXT,
              hintStyle: TextStyle(
                    fontSize: TEXT_MEDIUM_1X,
                    fontWeight: FontWeight.w400,
                    color: UNSELECTED_ICON_COLOR,
              )
            ),
          ),
        ),
      ),
    );
  }
}