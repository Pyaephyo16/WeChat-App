import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/blocs/add_new_post_page_bloc.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/view_items/chat_head_view.dart';
import 'package:we_chat_app/view_items/divide_line_view.dart';
import 'package:we_chat_app/view_items/person_name_view.dart';
import 'package:path/path.dart' as p;

class AddNewPostPage extends StatelessWidget {

    final int? idForEdit;

    AddNewPostPage({
      required this.idForEdit,
    });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewPostPageBloc(idForEdit),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: PRIMARY_COLOR,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
           icon:const Icon(Icons.chevron_left,size: MARGIN_SIZE_FOR_ICON,color: Colors.white,),
             ),
            title: AppBarTitleView(title: CREATE_POST_TEXT),
            actions: [
                 Builder(
                   builder: (context) =>
                    TextButton(
                    onPressed: (){
                      AddNewPostPageBloc bloc = Provider.of(context,listen: false);
                        //bloc.addPost().then((value) => Navigator.pop(context));
                        bloc.tapPostButton().then((value) => Navigator.pop(context));
                    },
                     child: Text("Post",
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: TEXT_LARGE,
                       fontWeight: FontWeight.bold,
                     ),
                     )
                               ),
                 ),
            ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1,vertical: 10),
          child: Column(
            children: [
              Consumer<AddNewPostPageBloc>(
                builder: (context,AddNewPostPageBloc bloc,child) =>
                 NameAndImageView(
                   name: bloc.userName,
                   image: bloc.profileImage,
                 ),
                ),
             const SizedBox(height: 12,),
              Selector<AddNewPostPageBloc,TextEditingController>(
                selector: (context,bloc) => bloc.despController,
                shouldRebuild: (previous,next) => previous != next,
                builder: (context,despController,child) =>
                 PostTextFieldView(
                   despController: despController,
                   //postDescription: postDescription,
                  // postDesp: (text){
                  //   AddNewPostPageBloc bloc = Provider.of(context,listen: false);
                  //   bloc.descriptionType(text);
                  // },
                ),
              ),
              Selector<AddNewPostPageBloc,bool>(
                selector: (context,bloc) => bloc.isError,
                shouldRebuild: (previous,next) => previous != next,
                builder: (context,isError,child) =>
                ErrorShowView(
                  isError: isError,
                ),
                ),
              Consumer<AddNewPostPageBloc>(
                builder: (context,bloc,child) =>
                PhotoOrVideoView(
                  pickedFile: bloc.pickedFile,
                  fileType: bloc.fileType,
                  flickManager: bloc.manager,
                  editImageOrVideo: bloc.editImageOrVideo,
                  deletePhoto: (){
                    AddNewPostPageBloc bloc = Provider.of(context,listen: false);
                    bloc.deleteChosenPhoto();
                  },
                ),
                ),
              Spacer(),
              Builder(
                builder: (context) =>
                 IconButton(
                   onPressed: (){
                showBottomSheet(
                  context,
                  photoVideo: ()async{
                       FilePickerResult? result = await FilePicker.platform.pickFiles();
                       if (result != null) {
                          AddNewPostPageBloc bloc = Provider.of(context,listen: false);
                          bloc.fileChosen(File(result.files.single.path!),result.files.single.extension!);
                         }
                         Navigator.pop(context);
                  },
                  camera: ()async{
                    final imagePicker = ImagePicker();
                    final XFile? cameraImage =await imagePicker.pickImage(source: ImageSource.camera,imageQuality: 80);
                     if(cameraImage !=null){
                        AddNewPostPageBloc bloc = Provider.of(context,listen: false);
                        final cameraFileType = p.extension(cameraImage.path);
                         bloc.fileChosen(File(cameraImage.path),cameraFileType);
                     }
                      Navigator.pop(context);
                  },
                  );
                          },
                         icon:const Icon(Icons.arrow_circle_up_sharp,size: 36,color: COMMENT_TEXT_COLOR,),
                           ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showBottomSheet(
    BuildContext context,
    {
      required Function photoVideo,
      required Function camera,
    }){
    showModalBottomSheet(
      context: context,
       builder: (_){
         return 
            Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                  PostFunctionIconAndTextView(
                   icon:const FaIcon(FontAwesomeIcons.images,color: PHOTO_VIDEO_COLOR,size: MARGIN_MEDIUM_2X,),
                   title:PHOTO_VIDEO_TEXT,
                   tapped: (){
                     photoVideo();
                   },
                 ),
               DivideLineView(),
                PostFunctionIconAndTextView(
                 icon:const FaIcon(FontAwesomeIcons.userPlus,color: TAG_PEOPLE_COLOR,size: MARGIN_MEDIUM_2X,),
                 title:TAG_PEOPLE_TEXT,
                 tapped: (){
                   print("tag people tap");
                 },
               ),
               DivideLineView(),
                PostFunctionIconAndTextView(
                 icon:const FaIcon(FontAwesomeIcons.faceGrin,color: FEELING_ACTIVITY_COLOR,size: MARGIN_MEDIUM_2X,),
                 title:FEELING_ACTIVITY_TEXT,
                 tapped: (){
                  print("feeling tap");
                 },
               ),
               DivideLineView(),
                PostFunctionIconAndTextView(
                 icon:const FaIcon(FontAwesomeIcons.locationDot,color: CHECK_IN_COLOR,size: MARGIN_MEDIUM_2X,),
                 title:CHECK_IN_TEXT,
                 tapped: (){
                    print("location tap");
                 },
               ),
               DivideLineView(),
                PostFunctionIconAndTextView(
                 icon:const FaIcon(FontAwesomeIcons.video,color: LIVE_VIDEO_COLOR,size: MARGIN_MEDIUM_2X,),
                 title:LIVE_VIDEO_TEXT,
                 tapped: (){
                     print("video tap");
                 },
               ),
               DivideLineView(),
                PostFunctionIconAndTextView(
                 icon:const FaIcon(FontAwesomeIcons.a,color: BACKGROUND_AA_COLOR,size: MARGIN_MEDIUM_2X,),
                 title:BACKGROUND_COLOR_TEXT,
                 tapped: (){
                     print("aa tap");
                 },
               ),
               DivideLineView(),
                PostFunctionIconAndTextView(
                 icon:const FaIcon(FontAwesomeIcons.camera,color: CAMERA_COLOR,size: MARGIN_MEDIUM_2X,),
                 title:CAMERA_TEXT,
                 tapped: (){
                   camera();
                 },
               ),
             ],
           );
       }  
       );
  }

}

class ErrorShowView extends StatelessWidget {

  final bool isError;

  ErrorShowView({
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isError,
      child:const Text(
          REQUIRED_TEXT,
        style: TextStyle(
          fontSize: 14,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
        ),
      );
  }
}

class PhotoOrVideoView extends StatelessWidget {

  final File? pickedFile;
  final Function deletePhoto;
  final String? fileType;
  final FlickManager? flickManager;
  final String? editImageOrVideo;

  PhotoOrVideoView({
    required this.pickedFile,
    required this.deletePhoto,
    required this.fileType,
    required this.flickManager,
    required this.editImageOrVideo,
  });

  @override
  Widget build(BuildContext context) {
    print("picked file wiget ============> $pickedFile");
    return Visibility(
      visible:  ( pickedFile != null || flickManager != null || editImageOrVideo != null || editImageOrVideo != "") ? true : false,
      child: Stack(
        children: [
            Container(
              width: MediaQuery.of(context).size.width,
           height: MediaQuery.of(context).size.height * 0.3,
           clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
            ),
            child: (editImageOrVideo != null) ?
             (fileType == "jpg" || fileType == "png" || fileType == "jpeg" || fileType == ".jpg") ? Image.network(editImageOrVideo ?? "",
              fit: BoxFit.cover,
            ) : (fileType == "mpr") ? 
            FlickVideoPlayer(flickManager: FlickManager(videoPlayerController: VideoPlayerController.network(editImageOrVideo!),autoPlay: false)) 
            : Container()
            


             : (fileType == "jpg" || fileType == "png" || fileType == "jpeg" || fileType == ".jpg") ? Image.file( pickedFile ?? File(''),
              fit: BoxFit.cover,
            )
            : (fileType == "mp4") ? FlickVideoPlayer(flickManager: flickManager!) : Container(),
            ),

          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: (){
                deletePhoto();
              },
               icon: Icon(Icons.cancel_outlined,size: 32,color: Colors.red,),
              ),
          )
        ],
      ),
    );
  }
}

class PostFunctionIconAndTextView extends StatelessWidget {

  final String title;
  final FaIcon icon;
  final Function tapped;

  PostFunctionIconAndTextView({
    required this.icon,
    required this.title,
    required this.tapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      child: GestureDetector(
        onTap: (){
          tapped();
        },
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.08,
              child: icon),
            SizedBox(width: 14,),
            Expanded(
              child: Text(title,
              style:const TextStyle(
                color: COMMENT_TEXT_COLOR,
                fontSize: 18,
              ),
              ),
            ), 
          ],
        ),
      ),
      // child: ListTile(
      //   onTap: (){
      //     tapped();
      //   },
      //   leading: icon,
      //   title: Text(title,
      //     style:const TextStyle(
      //       color: COMMENT_TEXT_COLOR,
      //       fontSize: 18,
      //     ),
      //     ), 
      // ),
    );
  }
}

class PostTextFieldView extends StatelessWidget {

  //final Function(String) postDesp;
  //final String postDescription;
  final TextEditingController despController;

  PostTextFieldView({
    //required this.postDesp,
    //required this.postDescription,
    required this.despController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: TextField(
        controller: despController,
        maxLines: 20,
        // onChanged: (text){
        //   postDesp(text);
        // },
        style:const TextStyle(
          fontSize: 22,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        decoration:const InputDecoration.collapsed(
          hintText: WHAT_S_ON_YOUR_MIND_TEXT,
          hintStyle: TextStyle(
          fontSize: 22,
          color: CONTACT_SEARCH_TEXT_COLOR,
          fontWeight: FontWeight.w400,
        ),
        ),
      ),
    );
  }
}

class NameAndImageView extends StatelessWidget {

  final String name;
  final String image;

  NameAndImageView({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatHeadView(
            image: image,
             isChatPage: true,
             ),
            const SizedBox(width: 16,),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: PersonNameView(name: name),
            ),
        ],
      ),
    );
  }
}