import 'package:easy_localization/easy_localization.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/blocs/add_new_post_page_bloc.dart';
import 'package:we_chat_app/blocs/discover_tab_bloc.dart';
import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';
import 'package:we_chat_app/pages/add_new_post_page.dart';
import 'package:we_chat_app/pages/overlay_comment.dart';
import 'package:we_chat_app/pages/overlay_post_detail.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/view_items/chat_head_view.dart';
import 'package:we_chat_app/view_items/person_name_view.dart';
import 'package:we_chat_app/view_items/pserson_description_view.dart';
import 'package:we_chat_app/utils/extension.dart';


class DiscoverTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DiscoverTabBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: PRIMARY_COLOR,
          centerTitle: true,
             title:  AppBarTitleView(title: "moments".tr()),
             actions: [
               IconButton(
                 onPressed: (){
                   navigateToNextScreen(context,AddNewPostPage(idForEdit: null,));
                 },
                  icon: Icon(Icons.camera_alt_outlined,size: MARGIN_SIZE_FOR_ICON,color: Theme.of(context).bottomAppBarColor,),
                  ),
             ],
        ),
        body: ListView(
         children: [
            Consumer<DiscoverTabBloc>(
              builder: (context,DiscoverTabBloc bloc,child) =>
               MomentOwnerSection(
                loggedInUser: bloc.loggedInUser ?? UserVO.empty(),
               ),
              ),
           Selector<DiscoverTabBloc,List<NewsFeedVO>>(
              selector: (context,bloc) => bloc.newsFeedList ?? [],
              shouldRebuild: (previous,next) => previous != next,
              builder: (context,newsFeedList,child) =>
              AllPostSection(
                postList: newsFeedList,
                postDetail: (postDetail){
                 Navigator.of(context).push(OverlayPostDetail(postDetail: postDetail));       
                },
                favourite: (){
                  print("favourite tap");
                },
                comment: (){
                  Navigator.of(context).push(OverlayComment()).then((value){
                    if(value != null){
                      DiscoverTabBloc bloc = Provider.of(context,listen: false);
                      bloc.commentedChanged(value);
                    }
                  });
                },
                editPost: (postId){
                  navigateToNextScreen(context,AddNewPostPage(idForEdit: postId));
                },
                deletePost: (postId){
                  DiscoverTabBloc bloc = Provider.of(context,listen: false);
                    bloc.deletePost(postId).then((value) => snackBarDataShow(context,SUCCESS_DELETE_MSG_TEXT));
                },
              ),
             ),
         ],
        ),
      ),
    );
  }
}

class AllPostSection extends StatelessWidget {

  final List<NewsFeedVO> postList;
  final Function(NewsFeedVO) postDetail;
  final Function favourite;
  final Function comment;
  final Function(int) editPost;
  final Function(int) deletePost;

  AllPostSection({
    required this.postList,
    required this.postDetail,
    required this.favourite,
    required this.comment,
    required this.editPost,
    required this.deletePost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: postList.length,
        itemBuilder: (BuildContext context,int index){
          return PostView(
            postList: postList,
            index: index,
            postDetail: (){postDetail(postList[index]);},
            favourite: (){ favourite();},
            comment: (){comment();},
            editPost: (){editPost(postList[index].id ?? 0);},
            deletePost: (){deletePost(postList[index].id ?? 0);},
          );
        }
        ),
    );
  }
}

 class PostView extends StatelessWidget {

   var date = DateFormat().add_jm().format(DateTime.now());

   final List<NewsFeedVO> postList;
   final int index;
    final Function favourite;
  final Function comment;
  final Function editPost;
  final Function deletePost;
  final Function postDetail;

   PostView({
     required this.postList,
     required this.index,
     required this.postDetail,
     required this.favourite,
     required this.comment,
     required this.editPost,
     required this.deletePost,
   });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        postDetail();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: (postList[index].post == "") ? MediaQuery.of(context).size.height * 0.52 : MediaQuery.of(context).size.height * 0.82,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  PostTimeView(
                    isDetail: false,
                    time: "$date",
                    ),
                  Expanded(
                    flex: (postList[index].post == "") ? 1 : 2,
                    child: PostImageAndDescriptionView(
                      isDetail: false,
                      post: postList[index],
                      favourite: (){
                        favourite();
                      },
                      comment: (){
                        comment();
                      },
                      editPost: (){
                         editPost();
                      },
                      deletePost: (){
                         deletePost();
                      },
                      ),
                    ),
                    Expanded(
                    child: ShowCommentSection(
                      userList: postList,
                      index: index,
                    ),
                    ),
                ],
              ),
              ),
    
    
              Positioned(
                left: MARGIN_MEDIUM_1,
                child: ChatHeadView(
                  image: "${postList[index].profileImage}",
                   isChatPage: true,
                   ),
                )
          ],
        ),
      ),
    );
  }
}

class ShowCommentSection extends StatelessWidget {

  final List<NewsFeedVO> userList;
  final int index;

  ShowCommentSection({
    required this.userList,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: DISCOVER_POST_COMMENT_SECTION_PADDING,vertical: MARGIN_MEDIUM),
      color: Theme.of(context).primaryColorDark,
      child: ListView(
        children: [
          ReactCommentView(userList: userList),
         const SizedBox(height: MARGIN_MEDIUM,),
          TextComment(
            userList: userList,
          ),
        ],
      ),
      );
  }
}

class TextComment extends StatelessWidget {
   final List<NewsFeedVO> userList;

   TextComment({
     required this.userList,
   });

  @override
  Widget build(BuildContext context) {
     return Row(
       crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: COMMENT_SECTION_ICON_WIDTH,
          child: Icon(Icons.mode_comment_rounded,color: Theme.of(context).primaryColor,size: MARGIN_MEDIUM_2,),
        ),
       const SizedBox(width: MARGIN_SMALL_1X,),
        Expanded(
          child: Wrap(
            children: userList.map((user){
              return RichText(
                maxLines: 3,
                text: TextSpan(
                  text: "${user.userName}, ",
              style: TextStyle(
                fontSize: TEXT_MEDIUM,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ), 
             children: [
               TextSpan(
                 text: "${user.description}, ",
              style:const TextStyle(
                fontSize: TEXT_MEDIUM,
                color: CHAT_HEAD_SUBTITLE_COLOR,
              ), 
               )
             ],
                ),
                );
            }).toList(),
          )
          )
    ],
    );
  }
}

class ReactCommentView extends StatelessWidget {
  const ReactCommentView({
    Key? key,
    required this.userList,
  }) : super(key: key);

  final List<NewsFeedVO> userList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: COMMENT_SECTION_ICON_WIDTH,
          child: Icon(Icons.favorite,color: Theme.of(context).primaryColor,size: MARGIN_MEDIUM_2,),
        ),
       const SizedBox(width: MARGIN_SMALL_1X,),
        Expanded(
          child: Wrap(
            children: userList.map((user){
              return Text("${user.userName}, ",
              style: TextStyle(
                fontSize: TEXT_MEDIUM,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
              );
            }).toList(),
          )
          )
    ],
    );
  }
}

class PostImageAndDescriptionView extends StatelessWidget {
  const PostImageAndDescriptionView({
    Key? key,
    required this.post,
    required this.favourite,
    required this.comment,
    required this.editPost,
    required this.deletePost,
    required this.isDetail,
  }) : super(key: key);

  final NewsFeedVO post;
  final Function favourite;
  final Function comment;
  final Function editPost;
  final Function deletePost;
  final bool isDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1,vertical: MARGIN_SMALL_1),
      color: (isDetail) ? Colors.transparent : Theme.of(context).primaryColorLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: DISCOVER_POST_USER_NAME_PADDING),
            child: PersonNameView(name: post.userName ?? ""),
          ),
         const SizedBox(height: MARGIN_SMALL_1),
          Expanded(
            child: PersonDescriptionView(
              description: post.description ?? "",
              isChatPage: false,
              isMomentDescription: true,
              ),
          ),
            SizedBox(height: 12,),
           PostImageView(post: post),
           FavouriteAndCommectSection(
            isDetail: isDetail,
             favourite: () => favourite(),
             comment: ()=> comment(),
             editPost: ()=> editPost(),
             deletePost: ()=> deletePost(),
           ),
        ],
      ),
      );
  }
}

class FavouriteAndCommectSection extends StatelessWidget {

  final Function favourite;
  final Function comment;
  final Function editPost;
  final Function deletePost;
  final bool isDetail;

  FavouriteAndCommectSection({
    required this.isDetail,
    required this.favourite,
    required this.comment,
    required this.editPost,
    required this.deletePost,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconFunctionView(
          icon: Icon(Icons.favorite_outline_outlined,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
          onClick: (){
            favourite();
          },
        ),
        IconFunctionView(
          icon: Icon(Icons.message_outlined,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
          onClick: (){
            comment();
          },
        ),
        PopupMenuButton(
          onSelected: (index){
            if(index == 0){
              editPost();
            }else if(index == 1){
              deletePost();
            }
          },
          icon:Icon(Icons.more_horiz,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text(EDIT_POST_TEXT),
              value: 0,
              ),
              PopupMenuItem(
              child: Text(DELETE_POST_TEXT),
              value: 1,
              ),
          ]),
      ], 
    );
  }
}

class IconFunctionView extends StatelessWidget {
 
  final Function onClick;
  final Icon icon;

  IconFunctionView({
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        onClick();
      },
       icon: icon,
       );
  }
}

class PostImageView extends StatelessWidget {
  const PostImageView({
    Key? key,
    required this.post,
  }) : super(key: key);

  final NewsFeedVO post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (post.post == "") ? 0 : MediaQuery.of(context).size.height * 0.3,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
        color: ME_TAB_PROFILE_BG_COLOR,
      ),
      child:(post.fileType == "jpg" || post.fileType == "png" || post.fileType == "jpeg" || post.fileType == ".jpg" || post.fileType == "gif") 
      ? (post.post == "" || post.post == null) ? Container() : Image.network(post.post ?? "",
      fit: BoxFit.cover,
      )
      : 
     (post.fileType == "mp4") ? FlickVideoPlayer(flickManager: FlickManager(videoPlayerController: VideoPlayerController.network(post.post!),autoPlay: false))
     :
      Container(),
    );
  }
}

class PostTimeView extends StatelessWidget {
 
  final String time;
  final bool isDetail;

  PostTimeView({
    required this.time,
    required this.isDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: MARGIN_MEDIUM_1),
      alignment: Alignment.centerRight,
      height: 24,
     decoration: BoxDecoration(
       color: (isDetail) ? Colors.transparent : Theme.of(context).primaryColorDark,
     ),
      child: Text(time,
        style: TextStyle(
          color: UNSELECTED_ICON_COLOR,
          fontSize: 14,
        ),
        ),
    );
  }
}

class MomentOwnerSection extends StatelessWidget {

  final UserVO loggedInUser;

  MomentOwnerSection({
    required this.loggedInUser,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.38,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CoverPhotoSection(),
            ),

            Positioned(
              left: MediaQuery.of(context).size.width * 0.18,
              top: MediaQuery.of(context).size.height * 0.22,
              child: MomentOwnerProfile(
                image: loggedInUser.profileImage ?? CONSTANT_IMAGE,
              ),
              ),

              Positioned(
                right: 16,
                top: MediaQuery.of(context).size.height * 0.23,
                child: MomentOwnerInfoSection(
                  name: loggedInUser.userName ?? "",
                ),
                  ),
        ],
      ),
    );
  }
}

class CoverPhotoSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
       width: MediaQuery.of(context).size.width,
       height: MediaQuery.of(context).size.height * 0.28,
       child: Image.network("https://images.pexels.com/photos/1535907/pexels-photo-1535907.jpeg?cs=srgb&dl=pexels-karyme-fran%C3%A7a-1535907.jpg&fm=jpg",
        fit: BoxFit.cover,
       ),
        ),
        Expanded(child: Container(color: Theme.of(context).primaryColorDark,)),
      ],
    );
  }
}

class MomentOwnerProfile extends StatelessWidget {

  final String image;

  MomentOwnerProfile({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 42,
      backgroundColor: ME_TAB_PROFILE_BG_COLOR,
      backgroundImage: NetworkImage(image),
    );
  }
}

class MomentOwnerInfoSection extends StatelessWidget {

  final String name;

  MomentOwnerInfoSection({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          ),
          SizedBox(height: 20,),
          MomentShowDateView(
            date: "Sunday, Sept 14,2015",
          ),
         MomentShowDateView(
           date: "23 new moments",
           ),
        ],
      );
  }
}

class MomentShowDateView extends StatelessWidget {
  
  final String date;

  MomentShowDateView({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Text(date,
     style: TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w400,
      fontSize: TEXT_MEDIUM,
    ),
    );
  }
}