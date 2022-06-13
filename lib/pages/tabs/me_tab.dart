import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/me_tab_bloc.dart';
import 'package:we_chat_app/data/vos/conservation_fun_icon_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/pages/qr_code_page.dart';
import 'package:we_chat_app/pages/splash_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extension.dart';


List<ConservationFunIconVO> iconFun = [

  ConservationFunIconVO(
    icon: Icon(Icons.photo_camera_back,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: ME_PHOTO_ICON_TEXT,
  ),

  ConservationFunIconVO(
    icon: Icon(Icons.favorite_border_outlined,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: ME_FAVOURITE_ICON_TEXT,
  ),

  ConservationFunIconVO(
    icon: Icon(Icons.wallet_travel,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: ME_WALLET_ICON_TEXT,
  ),

  ConservationFunIconVO(
    icon: Icon(Icons.payment_rounded,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: ME_CARDS_ICON_TEXT,
  ),

  ConservationFunIconVO(
    icon: Icon(Icons.face_sharp,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: ME_STICKERS_ICON_TEXT,
  ),

  ConservationFunIconVO(
    icon: Icon(Icons.settings,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: ME_SETTING_ICON_TEXT,
  ),

];



class MeTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MeTabBloc(),
      child: Scaffold(
        body: Consumer<MeTabBloc>(
    builder: (context,MeTabBloc bloc,child) =>
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
                      color: PRIMARY_COLOR,
                      child:  ProfileAppBarView(
                        qrTouch: (){
                          navigateToNextScreen(context,QrCodePage(loggedInUser: bloc.loggedInUser ?? UserVO.empty(),));
                        },
                        loggedInUser: bloc.loggedInUser ?? UserVO.empty(),
                       )
                    ),
                    Expanded(
                      child: Container(
                        color: TEXT_BACKGROUND_COLOR,
                      ),
                    ),
                  ],
                )
                ),
            
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.21,
                  //left: MediaQuery.of(context).size.width * 0.34,
                  //right: MediaQuery.of(context).size.width * 0.34,
                  child:  Container(
                 width: ME_TAB_PROFILE_CONTAINER_WIDTH,
                 height: ME_TAB_PROFILE_CONTAINER_HEIGHT,
                 decoration: BoxDecoration(
                   color: ME_TAB_PROFILE_BG_COLOR,
                   image: DecorationImage(
                     image: NetworkImage(bloc.loggedInUser?.profileImage ?? CONSTANT_IMAGE),
                     fit: BoxFit.cover,
                   ),
                   borderRadius:const BorderRadius.all( Radius.circular(MARGIN_PROFILE_CIRCLE)),
                   border: Border.all(
                     color: Colors.white,
                     width: MARGIN_PRE_SMALL,
                   ),
                 ),
               ),
               ),
            
               Positioned(
                 top: MediaQuery.of(context).size.height * 0.4,
                 //left: MediaQuery.of(context).size.width * 0.1,
                 //right: MediaQuery.of(context).size.width * 0.1,
                 child: BioTextView(
                   edit: (){
                     return print("Edit tap");
                   },
                   text: BIO_TEXT,
                 ),
                 ),
            
                 Positioned(
                   top: MediaQuery.of(context).size.height * 0.42,
                   child: MeTabIconFunSection(
                      photoTap: (){return print("photo me tap");},
                      favouriteTap: (){return print("favourite me tap");},
                      walletTap: (){return print("wallet me tap");},
                      cardsTap: (){return print("cards me tap");},
                      stickersTap: (){return print("stickers me tap");},
                      settingTap: (){return print("setting me tap");},
                   ),
                   ),
            
                   Positioned(
                     top: MediaQuery.of(context).size.height * 0.86,
                     //left: MediaQuery.of(context).size.width * 0.2,
                     //right: MediaQuery.of(context).size.width * 0.2,
                     child: Builder(
                      builder: (context) =>
                       LogoutButtonView(
                         logout: (){
                          MeTabBloc meBloc = Provider.of(context,listen: false);
                          meBloc.logout().then((value) => navigteToEnd(context,SplashPage()));
                         },
                       ),
                     )
                     )
            
            
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutButtonView extends StatelessWidget {

  final Function logout;

  LogoutButtonView({
    required this.logout,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        logout();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: LOGOUT_BTN_CONTAINER_HEIGHT,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2),
          border: Border.all(color: CHAT_HEAD_SUBTITLE_COLOR),
        ),
        child: Text(LOGOUT_TEXT,
        style: TextStyle(
          color: Colors.black,
          fontSize: TEXT_LARGE,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
    );
  }
}

class MeTabIconFunSection extends StatelessWidget {

    final Function photoTap;
  final Function favouriteTap;
  final Function walletTap;
  final Function cardsTap;
  final Function stickersTap;
  final Function settingTap;

  MeTabIconFunSection({
        required this.photoTap,
    required this.favouriteTap,
    required this.walletTap,
    required this.cardsTap,
    required this.stickersTap,
    required this.settingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.45,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: iconFun.length,
         itemBuilder: (BuildContext context,int index){
           return Container(
             alignment: Alignment.center,
             decoration: BoxDecoration(
               color: Colors.white,
               border: Border.all(color: CHAT_HEAD_SUBTITLE_COLOR),
             ),
             child: MeIconFunView(
               iconFun: iconFun,
               index: index,
              photoTap: (){photoTap();},
              favouriteTap: (){favouriteTap();},
              walletTap: (){walletTap();},
              cardsTap: (){cardsTap();},
              stickersTap: (){stickersTap();},
              settingTap: (){settingTap();},
             ),
           );
         }
         ),
    );
  }
}

class MeIconFunView extends StatelessWidget {
 
  final List<ConservationFunIconVO> iconFun;
  final int index;
  final Function photoTap;
  final Function favouriteTap;
  final Function walletTap;
  final Function cardsTap;
  final Function stickersTap;
  final Function settingTap;

  MeIconFunView({
    required this.iconFun,
    required this.index,
    required this.photoTap,
    required this.favouriteTap,
    required this.walletTap,
    required this.cardsTap,
    required this.stickersTap,
    required this.settingTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(index == 0){
          photoTap();
        }else if(index == 1){
          favouriteTap();
        }else if(index == 2){
          walletTap();
        }else if(index == 3){
          cardsTap();
        }else if(index == 4){
          stickersTap();
        }else if(index == 5){
          settingTap();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           iconFun[index].icon ?? Container(),
           SizedBox(height: MARGIN_SMALL_1X,),
           Text("${iconFun[index].title}"),
        ],
      ),
    );
  }
}

class BioTextView extends StatelessWidget {
 
  final String text;
  final Function edit;

  BioTextView({
    required this.text,
    required this.edit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: DISCOVER_POST_COMMENT_SECTION_PADDING),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: RichText(
        textAlign: TextAlign.center,
        //overflow: TextOverflow.ellipsis,
        //maxLines: 3,
        text: TextSpan(
          text: text,
          style:const TextStyle(
            color: UNSELECTED_ICON_COLOR,
            fontSize: TEXT_MEDIUM_1,
            fontWeight: FontWeight.w500,
          ),
          children: <TextSpan>[
            TextSpan(
              text: EDIT_TEXT,
              // recognizer: TapGestureRecognizer()..onTap = (){
              //  print("work here");
              //  edit();
              //    },
               recognizer: TapGestureRecognizer()..onTap = ()=> debugPrint("work here"),
              style:const TextStyle(
                color: PRIMARY_COLOR,
                fontSize: MARGIN_MEDIUM_1,
                fontWeight: FontWeight.w700,
              )
            )
          ],
        ),
        ),
    );
  }
}

class ProfileAppBarView extends StatelessWidget {

  final UserVO loggedInUser;
  final Function qrTouch;

  ProfileAppBarView({
    required this.loggedInUser,
    required this.qrTouch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Container()),
        Expanded(
          flex: 3,
          child: ProfileNameView(
            title: loggedInUser.userName ?? "",
            subtitle: loggedInUser.qrCode ?? "",
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: (){
                qrTouch();
              },
               icon:const Icon(Icons.qr_code,size: MARGIN_SIZE_FOR_APP_BAR_ICON,color: Colors.white,),
               ),
          ),
        )
      ],
    );
  }
}

class ProfileNameView extends StatelessWidget {

  final String title;
  final String subtitle;

  ProfileNameView({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
        style:const TextStyle(
          color: Colors.white,
          fontSize: TEXT_LARGE_1,
          fontWeight: FontWeight.w600,
        ),
        ),
        Text(subtitle,
        textAlign: TextAlign.center,
        style:const TextStyle(
          color: Colors.white,
          fontSize: TEXT_MEDIUM,
          fontWeight: FontWeight.w400,
        ),
        ),
      ],
    );
  }
}