import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/conservation_page_bloc.dart';
import 'package:we_chat_app/data/vos/conservation_fun_icon_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/view_items/chat_head_view.dart';
import 'package:path/path.dart' as p;


const Duration ANIMATION_DURATION_FOR_ADD = const Duration(milliseconds: 600);

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

  final UserDummyVO user;

  ConservationPage({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConservationPageBloc(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: PRIMARY_COLOR,
          leading: IconButton(
            icon: Icon(Icons.chevron_left,size: MARGIN_SIZE_FOR_ICON,color: Colors.white,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: AppBarTitleView(title: user.name ?? ""),
          actions: [
            IconButton(
              onPressed: (){},
               icon: Icon(Icons.more_vert,size: MARGIN_SIZE_FOR_ICON,color: Colors.white,),
               ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Selector<ConservationPageBloc,List<MessageDummyVO>>(
                  selector: (context,bloc) => bloc.messagesDummy,
                  shouldRebuild: (previous,next) => previous != next,
                  builder: (context,messageDummy,child) =>
                ConsevationSection(
                  user: user,
                  message: messageDummy.reversed.toList(),
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
                visible: ( pickedFile != null || flickManager != null) ? true : false,
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
          style: TextStyle(
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

  final UserDummyVO user;
  final List<MessageDummyVO> message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1,vertical: MARGIN_SMALL),
      child:
      ListView.builder(
        reverse: true,
          itemCount: message.length,
          itemBuilder: (BuildContext context,int index){
            final bool isFriend = user.id == message[index].sender?.id;
            return TextMsgShowView(
                isFriend: isFriend,
                index: index,
                message: message[index],
            );
          }
          ),
      );
  }
}


class TextMsgShowView extends StatelessWidget {

  final bool isFriend;
  final MessageDummyVO message;
  final int index;

  TextMsgShowView({
    required this.isFriend,
    required this.message,
      required this.index,
  });

  @override
  Widget build(BuildContext context) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Visibility(
              visible: (isFriend) ? true : false,
              child: ChatHeadView(image: message.sender?.image ?? "", isChatPage: false))),
          Expanded(
            flex: 10,
            child: Container(
              margin: (isFriend) ? 
             const EdgeInsets.only(right: MARGIN_SIZE_FOR_CHAT,top: MARGIN_SMALL_1,bottom: MARGIN_SMALL_1) :
              const EdgeInsets.only(left: MARGIN_SIZE_FOR_CHAT,top: MARGIN_SMALL_1,bottom: MARGIN_SMALL_1),
              padding:const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM,vertical: MARGIN_MEDIUM_1),
              decoration: BoxDecoration(
                color: CONSERVATION_TEXTFIELD_CONTAINER_COLOR,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("${message.msg}",
              style:const TextStyle(
                fontSize: TEXT_MEDIUM_1,
                fontWeight: FontWeight.w500,
              ),
              ),
            ),
          ),
        ],
      );
  }
}



class TextFieldView extends StatelessWidget {
  
  final TextEditingController msgController;
  final String userText;
  final File? chooseFile;
  final Function(String) typeData;
  final Function send;
  final Function add;

  TextFieldView({
    required this.msgController,
    required this.userText,
    required this.chooseFile,
    required this.typeData,
    required this.send,
    required this.add,
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
                 onChanged: (text){
                   typeData(text);
                 },
              ),
          ),
        (userText ==  ""  && chooseFile == null) ? IconButton(
           onPressed: (){
              add();
           },
            icon:const Icon(Icons.add,size: MARGIN_SIZE_FOR_ICON,color: TEXTFIELD_ICON_COLOR,),
            ) :
             IconButton(
           onPressed: (){
              send();
           },
            icon:const Icon(Icons.send,size: MARGIN_SIZE_FOR_ICON,color: TEXTFIELD_ICON_COLOR,),
            ),  
     ],
                  ),
                ),
              );
  }
}
