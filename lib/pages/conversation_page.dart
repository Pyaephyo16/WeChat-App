import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/blocs/conservation_page_bloc.dart';
import 'package:we_chat_app/data/vos/conservation_fun_icon_vo.dart';
import 'package:we_chat_app/data/vos/message_vo/message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/view_items/chat_head_view.dart';
import 'package:we_chat_app/utils/extension.dart';
import 'package:path/path.dart' as p;


const Duration ANIMATION_DURATION_FOR_ADD = Duration(milliseconds: 600);

 List<ConservationFunIconVO> icons = [
ConservationFunIconVO(
  icon:const Icon(Icons.folder,size: MARGIN_SIZE_FOR_APP_BAR_ICON,),
  title: FILE_ICON_TEXT,
),

ConservationFunIconVO(
  icon:const Icon(Icons.camera_alt_outlined,size: MARGIN_SIZE_FOR_APP_BAR_ICON,),
  title: CAMERA_ICON_TEXT,
),

ConservationFunIconVO(
  icon:const Icon(Icons.video_call_outlined,size: MARGIN_SIZE_FOR_APP_BAR_ICON,),
  title: VIDEO_CALL_ICON_TEXT,
),

ConservationFunIconVO(
  icon:const Icon(Icons.phone,size: MARGIN_SIZE_FOR_APP_BAR_ICON,),
  title: VOICE_CALL_ICON_TEXT,
),

ConservationFunIconVO(
  icon:const Icon(Icons.location_on_outlined,size: MARGIN_SIZE_FOR_APP_BAR_ICON,),
  title: LOCATION_ICON_TEXT,
),

ConservationFunIconVO(
  icon:const Icon(Icons.file_present_sharp,size: MARGIN_SIZE_FOR_APP_BAR_ICON,),
  title: RED_PACKET_ICON_TEXT,
),

ConservationFunIconVO(
  icon:const Icon(Icons.compare_arrows,size: MARGIN_SIZE_FOR_APP_BAR_ICON,),
  title: TRANSFER_ICON_TEXT,
),

ConservationFunIconVO(
  icon:const Icon(Icons.mic_none_rounded,size: MARGIN_SIZE_FOR_APP_BAR_ICON,),
  title: VOICE_INPUT_ICON_TEXT,
),
];



class ConservationPage extends StatelessWidget {

  final UserVO friend;
  final UserVO loggedInUser;

  ConservationPage({
    required this.friend,
    required this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConservationPageBloc(loggedInUser,friend),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: PRIMARY_COLOR,
          leading: IconButton(
            icon:const Icon(Icons.chevron_left,size: MARGIN_SIZE_FOR_ICON,color: Colors.white,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: AppBarTitleView(title: friend.userName ?? ""),
          actions: [
            IconButton(
              onPressed: (){},
               icon:const Icon(Icons.more_vert,size: MARGIN_SIZE_FOR_ICON,color: Colors.white,),
               ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Selector<ConservationPageBloc,List<MessageVO>>(
                  selector: (context,bloc) => bloc.messageList ?? [],
                  shouldRebuild: (previous,next) => previous != next,
                  builder: (context,messageList,child) =>
                (messageList == null) ? Container() : 
                ConsevationSection(
                  user: friend,
                  message: messageList.reversed.toList(),
                  ),
              ),
            ),
                  Consumer<ConservationPageBloc>(
        builder: (context,ConservationPageBloc bloc,child) {
          print("picked file widget check ============> ${bloc.pickedFile?.path}");
                   return ChosenPhotoView(
                      pickedFile: bloc.pickedFile,
                      fileType: bloc.fileType,
                      flickManager: bloc.manager,
                      removePhoto: (){
                        ConservationPageBloc bloc = Provider.of(context,listen: false);
                        bloc.deleteChosenPhoto();
                      },
                   );
                  }
            ),
              Consumer<ConservationPageBloc>(
                     builder: (context,ConservationPageBloc bloc,child){
                   return TextFieldView(
                     msgController: bloc.msgController,
                     userText: bloc.userText,
                      chooseFile: bloc.pickedFile,
                      submitted: (str){
                        ConservationPageBloc _cBloc = Provider.of(context,listen: false);
                        _cBloc.sendMessage(
                          loggedInUser,
                          friend,
                          emptyCallBack: (){
                              errorSnackBar(context,"Can\'t be send");
                          },
                          );
                      },
                    typeData: (text){
                   ConservationPageBloc _changeBloc = Provider.of(context,listen: false);
                   _changeBloc.onTextChanged(text);
                    },
                    send: (){

                    },
                    add: (){
                    ConservationPageBloc _changeBloc = Provider.of(context,listen: false);
                   _changeBloc.tapAdd();
                    },
                   );
                  }
               ,
            ),
            Selector<ConservationPageBloc,bool>(
              selector: (context,bloc) => bloc.isAddTap,
              shouldRebuild: (previous,next) => previous != next,
              builder: (context,isAddTap,child) =>
                 AddMoreIconView(
                  isAddTap: isAddTap,
                  tapped: (index)async{
                if(index == 0){
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                   if (result != null) {
                      ConservationPageBloc bloc = Provider.of(context,listen: false);
                      bloc.fileChosen(File(result.files.single.path!),result.files.single.extension!);
                     }
                }else if(index == 1){
                  final imagePicker = ImagePicker();
                  final XFile? cameraImage =await imagePicker.pickImage(source: ImageSource.camera,imageQuality: 80);
                   if(cameraImage !=null){
                      ConservationPageBloc bloc = Provider.of(context,listen: false);
                      final cameraFileType = p.extension(cameraImage.path);
                      bloc.fileChosen(File(cameraImage.path),cameraFileType);
                   }
                }
                  },
                ),
            )
          ],
        ),
      ),
    );
  }
}

class ChosenPhotoView extends StatelessWidget {

  final File? pickedFile;
  final Function removePhoto;
  final String? fileType;
  final FlickManager? flickManager;

   ChosenPhotoView({
     required this.pickedFile,
     required this.removePhoto,
     required this.flickManager,
     required this.fileType,
   });

  @override
  Widget build(BuildContext context) {
    return Visibility(
                visible: ( pickedFile != null) ? true : false,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: CHOOSEN_PHOTO_CONTAINER_HEIGHT,
                  color: Colors.white,
                  child: Row(
     children: [
       Container(
        margin:const EdgeInsets.only(left: MARGIN_FOR_CONTACT_NAME_TITLE),
         width: (fileType == "mp4") ? CONSERVATION_SEND_VIDEO_WIDTH : CHOOSEN_PHOTO_WIDTH,
         height: CHOOSEN_PHOTO_HEIGHT,
         clipBehavior: Clip.antiAlias,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
         ),
        //  child: (fileType == "jpg" || fileType == "png" || fileType == "jpeg" || fileType == ".jpg" || fileType == "gif") ? Image.file(pickedFile ?? File(''),
        //  fit: BoxFit.cover,
        //  )
        //  : (fileType == "mp4") ? FlickVideoPlayer(flickManager: flickManager!): Container(),
        child: chooseFileShow(fileType ?? "", pickedFile, flickManager),
       ),
      const SizedBox(width: MARGIN_MEDIUM,),
       IconButton(
         onPressed: (){
           removePhoto();
         },
          icon:const Icon(Icons.cancel_outlined,size: MARGIN_SIZE_FOR_ICON,color: Colors.red,)
          ),
     ],
     ),
    )
    );
  }


  Widget chooseFileShow(String fileType,File? pickedFile,FlickManager? flickManager){
    return (fileType == "jpg" || fileType == "png" || fileType == "jpeg" || fileType == ".jpg" || fileType == "gif") ? Image.file(pickedFile ?? File(''),
         fit: BoxFit.cover,
         )
         : (fileType == "mp4") ? FlickVideoPlayer(flickManager: flickManager!): Container();
  }

}

class AddMoreIconView extends StatelessWidget {

  final bool isAddTap;
  final Function(int) tapped;

  AddMoreIconView({
    required this.isAddTap,
    required this.tapped,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: ANIMATION_DURATION_FOR_ADD,
      width: MediaQuery.of(context).size.width,
      height: (isAddTap) ? MediaQuery.of(context).size.height * 0.3 : 0.0,
      color: CONSERVATION_TEXTFIELD_CONTAINER_COLOR,
      child: GridView.builder(
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.8,
        ),
        shrinkWrap: true,
        physics:const NeverScrollableScrollPhysics(),
        itemCount: icons.length,
        itemBuilder: (BuildContext context,int index){
          return FunctionIconView(
            tapped: (){
              tapped(index);
            },
             icon: icons[index].icon ?? Container(),
             title: icons[index].title ?? "",
             );
        },
      ),
    );
  }
}

class FunctionIconView extends StatelessWidget {
 
  final Function tapped;
  final Widget icon;
  final String title;

  FunctionIconView({
    required this.tapped,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        tapped();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin:const EdgeInsets.all(MARGIN_MEDIUM_1),
            alignment: Alignment.center,
            width: FUNCTIION_ICON_CONTAINER_WIDTH,
            height: FUNCTIION_ICON_CONTAINER_HEIGHT,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2X),
            ),
            child: icon,
          ),
          Text(title,
          style:const TextStyle(
            color: Colors.black,
            fontSize: TEXT_MEDIUM,
          ),
          )
        ],
      ),
    );
  }
}

class ConsevationSection extends StatelessWidget {
  const ConsevationSection({
    Key? key,
    required this.user,
    required this.message,
  }) : super(key: key);

  final UserVO user;
  final List<MessageVO> message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1,vertical: MARGIN_SMALL),
      child:
      ListView.builder(
        reverse: true,
          itemCount: message.length,
          itemBuilder: (BuildContext context,int index){
            final bool isFriend = user.id == message[index].id;
            return TextMsgShowView(
                isFriend: isFriend,
                index: index,
                message: message,
            );
          }
          ),
      );
  }
}


class TextMsgShowView extends StatelessWidget {

  final bool isFriend;
  final List<MessageVO> message;
  final int index;

  TextMsgShowView({
    required this.isFriend,
    required this.message,
      required this.index,
  });

  @override
  Widget build(BuildContext context) {
    int textLength = message[index].message?.length ?? -1;
      return Padding(
        padding: (isFriend) ?
        const EdgeInsets.only(right: 54) :
        const EdgeInsets.only(left: 54),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: (isFriend) ? true : false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ChatHeadView(image: message[index].profileImge ?? "", isChatPage: false),
              )),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: (isFriend) ? CrossAxisAlignment.start : CrossAxisAlignment.end, 
                children: [
                  Center(
                    child: Text(
                        DateFormat().add_jm().format(DateTime.fromMicrosecondsSinceEpoch(int.parse(message[index].timeStamp ?? ""))), 
                        style:const TextStyle(
                    color: Colors.grey,
                    fontSize: TEXT_MEDIUM,
                ),
                      ),
                  ),
                  Visibility(
                    visible: (message[index].fileType == "") ? false : true,
                    child: Container(
                      width: (message[index].fileType == "jpg" || message[index].fileType == "png" || message[index].fileType == "jpeg" || message[index].fileType == ".jpg" || message[index].fileType == "gif") ?
                      MediaQuery.of(context).size.width * 0.6
                      : (message[index].fileType == "mp4") ? MediaQuery.of(context).size.width * 0.6
                     : (textLength < 6) ? MediaQuery.of(context).size.width * 0.2 : (textLength < 15) ? MediaQuery.of(context).size.width * 0.36 : MediaQuery.of(context).size.width * 0.6,
                      padding:const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM,vertical: MARGIN_MEDIUM_1),
                      decoration: BoxDecoration(
                        color: CONSERVATION_TEXTFIELD_CONTAINER_COLOR,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: (isFriend) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          showText(message[index]),
                      Visibility(
                        visible: (message[index].message == "") ? false : true,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8,bottom: 6),
                          child: Text(
                            "${message[index].message}",
                          style:const TextStyle(
                            fontSize: TEXT_MEDIUM_1,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
                        ),
                      ),
                        ],
                      )
                    ),
                  ),
                  Visibility(
                    visible: (message[index].fileType == "") ? true : false,
                    child: Container(
                       padding:const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM,vertical: MARGIN_MEDIUM_1),
                      decoration: BoxDecoration(
                         color: CONSERVATION_TEXTFIELD_CONTAINER_COLOR,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text("${message[index].message}",
                      style:const TextStyle(
                        fontSize: TEXT_MEDIUM_1,
                        fontWeight: FontWeight.w500,
                      ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }

   Widget showText(MessageVO message){
    return (message.fileType == "jpg" || message.fileType == "png" || message.fileType == "jpeg" || message.fileType == ".jpg" || message.fileType == "gif") ? Image.network(message.post ?? "",
         fit: BoxFit.cover,
         )
         : (message.fileType == "mp4") ? FlickVideoPlayer(flickManager: FlickManager(
                                videoPlayerController:
                                    VideoPlayerController.network(
                                        message.post!),
                                autoPlay: false))
         : Container();
  } 
}



class TextFieldView extends StatelessWidget {
  
  final TextEditingController msgController;
  final String userText;
  final File? chooseFile;
  final Function(String) typeData;
  final Function send;
  final Function add;
  final Function submitted;

  TextFieldView({
    required this.msgController,
    required this.userText,
    required this.chooseFile,
    required this.typeData,
    required this.send,
    required this.add,
    required this.submitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CONSERVATION_TEXTFIELD_CONTAINER_COLOR,
                width: MediaQuery.of(context).size.width,
                height: FUNCTIION_ICON_CONTAINER_HEIGHT,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM,vertical: MARGIN_SMALL_1),
                  child: Row(
     children: [
         IconButton(
           onPressed: (){},
            icon:const Icon(Icons.mic,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
            ),
          Expanded(
               child: TextField(
                 controller: msgController,
                 decoration: InputDecoration(
                   contentPadding:const EdgeInsets.symmetric(horizontal: MARGIN_SMALL_1),
                   hintText: HINT_TEXT,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(12),
                     borderSide:const BorderSide(color: TEXTFIELD_BORDER_COLOR,width: 0.4),
                   ),
                   filled: true,
                   fillColor: TEXTFIELD_BG_COLOR,
                 ),
                 style:const TextStyle(
                   fontSize: TEXT_MEDIUM_1X,
                   fontWeight: FontWeight.w500,
                 ),
                 onSubmitted: (str){
                  submitted(str);
                 },
                 onChanged: (text){
                   typeData(text);
                 },
              ),
          ),
        IconButton(
           onPressed: (){
              add();
           },
            icon:const Icon(Icons.add,size: MARGIN_SIZE_FOR_ICON,color: TEXTFIELD_ICON_COLOR,),
            )
     ],
                  ),
                ),
              );
  }
}
