import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      child: Selector<AddNewPostPageBloc,bool>(
        selector: (context,bloc) => bloc.isLoading,
        shouldRebuild: (previous,next) => previous != next,
        builder: (context,isLoading,child) =>
         Stack(
           children: [
             Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 1,
                backgroundColor: PRIMARY_COLOR,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.chevron_left,
                    size: MARGIN_SIZE_FOR_ICON,
                    color: Colors.white,
                  ),
                ),
                title: AppBarTitleView(title: CREATE_POST_TEXT),
                actions: [
                  Builder(
                    builder: (context) => TextButton(
                        onPressed: () {
                          AddNewPostPageBloc bloc =
                              Provider.of(context, listen: false);
                          bloc
                              .tapPostButton()
                              .then((value) => Navigator.pop(context));
                        },
                        child: const Text(
                          POST_TEXT,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: TEXT_LARGE,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MARGIN_MEDIUM_1, vertical: MARGIN_SMALL_1X),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<AddNewPostPageBloc>(
                      builder: (context, AddNewPostPageBloc bloc, child) =>
                          NameAndImageView(
                        name: bloc.userName,
                        image: bloc.profileImage,
                      ),
                    ),
                    const SizedBox(
                      height: MARGIN_MEDIUM,
                    ),
                    Selector<AddNewPostPageBloc, TextEditingController>(
                      selector: (context, bloc) => bloc.despController,
                      shouldRebuild: (previous, next) => previous != next,
                      builder: (context, despController, child) =>
                       PostTextFieldView(
                        despController: despController,
                        onChanged: (text){
                          AddNewPostPageBloc bloc = Provider.of(context,listen: false);
                          bloc.descriptionType(text);
                        },
                      ),
                    ),
                    Selector<AddNewPostPageBloc, bool>(
                      selector: (context, bloc) => bloc.isError,
                      shouldRebuild: (previous, next) => previous != next,
                      builder: (context, isError, child) => ErrorShowView(
                        isError: isError,
                      ),
                    ),
                    Consumer<AddNewPostPageBloc>(
                      builder: (context, bloc, child) => PhotoOrVideoView(
                        pickedFile: bloc.pickedFile,
                        fileType: bloc.fileType,
                        flickManager: bloc.manager,
                        editImageOrVideo: bloc.editImageOrVideo,
                        deletePhoto: () {
                          AddNewPostPageBloc bloc =
                              Provider.of(context, listen: false);
                          bloc.deleteChosenPhoto();
                        },
                      ),
                    ),
                    Spacer(),
                    Builder(
                      builder: (context) => Center(
                        child: IconButton(
                          onPressed: () {
                            showBottomSheet(
                              context,
                              photoVideo: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  AddNewPostPageBloc bloc = Provider.of(context, listen: false);
                                  bloc.fileChosen(File(result.files.single.path!),
                                      result.files.single.extension!);
                                }
                                Navigator.pop(context);
                              },
                              camera: () async {
                                final imagePicker = ImagePicker();
                                final XFile? cameraImage = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 80);
                                if (cameraImage != null) {
                                  AddNewPostPageBloc bloc = Provider.of(context, listen: false);
                                  final cameraFileType = p.extension(cameraImage.path);
                                  bloc.fileChosen(File(cameraImage.path), cameraFileType);
                                }
                                Navigator.pop(context);
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_circle_up_sharp,
                            size: NEW_POST_BTM_SHEET_UP_ICON_SIZE,
                            color: COMMENT_TEXT_COLOR,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
        ),

            Visibility(
              visible: isLoading,
              child:const LoadingShowView(),
              ),

           ],
         ),
      ),
    );
  }

  void showBottomSheet(
    BuildContext context, {
    required Function photoVideo,
    required Function camera,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostFunctionIconAndTextView(
                icon: const FaIcon(
                  FontAwesomeIcons.images,
                  color: PHOTO_VIDEO_COLOR,
                  size: MARGIN_MEDIUM_2X,
                ),
                title: PHOTO_VIDEO_TEXT,
                tapped: () {
                  photoVideo();
                },
              ),
              DivideLineView(),
              PostFunctionIconAndTextView(
                icon: const FaIcon(
                  FontAwesomeIcons.userPlus,
                  color: TAG_PEOPLE_COLOR,
                  size: MARGIN_MEDIUM_2X,
                ),
                title: TAG_PEOPLE_TEXT,
                tapped: () {
                  print("tag people tap");
                },
              ),
              DivideLineView(),
              PostFunctionIconAndTextView(
                icon: const FaIcon(
                  FontAwesomeIcons.faceGrin,
                  color: FEELING_ACTIVITY_COLOR,
                  size: MARGIN_MEDIUM_2X,
                ),
                title: FEELING_ACTIVITY_TEXT,
                tapped: () {
                  print("feeling tap");
                },
              ),
              DivideLineView(),
              PostFunctionIconAndTextView(
                icon: const FaIcon(
                  FontAwesomeIcons.locationDot,
                  color: CHECK_IN_COLOR,
                  size: MARGIN_MEDIUM_2X,
                ),
                title: CHECK_IN_TEXT,
                tapped: () {
                  print("location tap");
                },
              ),
              DivideLineView(),
              PostFunctionIconAndTextView(
                icon: const FaIcon(
                  FontAwesomeIcons.video,
                  color: LIVE_VIDEO_COLOR,
                  size: MARGIN_MEDIUM_2X,
                ),
                title: LIVE_VIDEO_TEXT,
                tapped: () {
                  print("video tap");
                },
              ),
              DivideLineView(),
              PostFunctionIconAndTextView(
                icon: const FaIcon(
                  FontAwesomeIcons.a,
                  color: BACKGROUND_AA_COLOR,
                  size: MARGIN_MEDIUM_2X,
                ),
                title: BACKGROUND_COLOR_TEXT,
                tapped: () {
                  print("aa tap");
                },
              ),
              DivideLineView(),
              PostFunctionIconAndTextView(
                icon: const FaIcon(
                  FontAwesomeIcons.camera,
                  color: CAMERA_COLOR,
                  size: MARGIN_MEDIUM_2X,
                ),
                title: CAMERA_TEXT,
                tapped: () {
                  camera();
                },
              ),
            ],
          );
        });
  }
}

class LoadingShowView extends StatelessWidget {
  const LoadingShowView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: LOADING_VIEW_CONTAINER_WIDTH,
        height: LOADING_VIEW_CONTAINER_HEIGHT,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
          color: DISABLED_BTN_COLOR,
        ),
        child:const SpinKitFadingCircle(
          color: PRIMARY_COLOR,
        ),
      ),
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
      child: const Text(
        REQUIRED_TEXT,
        style: TextStyle(
          fontSize: TEXT_MEDIUM,
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
    print("editImageOrVideo wiget ============> $editImageOrVideo");
    return Visibility(
      visible: (pickedFile != null || editImageOrVideo != null) ? true : false,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
            ),
            child: (editImageOrVideo != null)
                ? (fileType == "jpg" ||
                        fileType == "png" ||
                        fileType == "jpeg" ||
                        fileType == ".jpg" ||
                        fileType == "gif")
                    ? Image.network(
                        editImageOrVideo ?? "",
                        fit: BoxFit.cover,
                      )
                    : (fileType == "mp4")
                        ? FlickVideoPlayer(
                            flickManager: FlickManager(
                                videoPlayerController:
                                    VideoPlayerController.network(
                                        editImageOrVideo!),
                                autoPlay: false))
                        : Container()
                : (fileType == "jpg" ||
                        fileType == "png" ||
                        fileType == "jpeg" ||
                        fileType == ".jpg" ||
                        fileType == "gif")
                    ? Image.file(
                        pickedFile ?? File(''),
                        fit: BoxFit.cover,
                      )
                    : (fileType == "mp4")
                        ? FlickVideoPlayer(flickManager: flickManager!)
                        : Container(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                deletePhoto();
              },
              icon:const Icon(
                Icons.cancel_outlined,
                size: MARGIN_SIZE_FOR_ICON,
                color: Colors.red,
              ),
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
      padding: const EdgeInsets.symmetric(vertical: MARGIN_MEDIUM_1, horizontal: MARGIN_MEDIUM_1),
      child: GestureDetector(
        onTap: () {
          tapped();
        },
        child: Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.08, child: icon),
           const SizedBox(
              width: MARGIN_MEDIUM_1,
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: COMMENT_TEXT_COLOR,
                  fontSize: TEXT_MEDIUM_1X,
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
  final TextEditingController despController;
  final Function(String) onChanged;

  PostTextFieldView({
    required this.despController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: TextField(
        controller: despController,
        onChanged: (text){
          onChanged(text);
        },
        maxLines: 20,
        style: const TextStyle(
          fontSize: TEXT_LARGE_1,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        decoration: const InputDecoration.collapsed(
          hintText: WHAT_S_ON_YOUR_MIND_TEXT,
          hintStyle: TextStyle(
            fontSize: TEXT_LARGE_1,
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
      padding: const EdgeInsets.symmetric(vertical: MARGIN_MEDIUM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatHeadView(
            image: image,
            isChatPage: true,
          ),
          const SizedBox(
            width: MARGIN_MEDIUM_1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: MARGIN_PRE_SMALL),
            child: PersonNameView(name: name),
          ),
        ],
      ),
    );
  }
}
