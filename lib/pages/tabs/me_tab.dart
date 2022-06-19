import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/me_tab_bloc.dart';
import 'package:we_chat_app/data/vos/conservation_fun_icon_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/pages/qr_code_page.dart';
import 'package:we_chat_app/pages/setting_page.dart';
import 'package:we_chat_app/pages/splash_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extension.dart';






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
                          print("qr check me tab ===========> ${bloc.loggedInUser?.qrCode}");
                          navigateToNextScreen(context,QrCodePage(loggedInUser: bloc.loggedInUser ?? UserVO.empty(),));
                        },
                        loggedInUser: bloc.loggedInUser ?? UserVO.empty(),
                       )
                    ),
                    Expanded(
                      child: Container(
                      ),
                    ),
                  ],
                )
                ),
            
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.21,
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
                 child: BioTextView(
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
                      settingTap: (){ navigateToNextScreen(context,SettingPage());},
                   ),
                   ),
            
                   Positioned(
                     top: MediaQuery.of(context).size.height * 0.86,
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
        padding:const EdgeInsets.symmetric(horizontal: 6,),
        width: MediaQuery.of(context).size.width * 0.5,
        height: LOGOUT_BTN_CONTAINER_HEIGHT,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2),
          border: Border.all(color: UNSELECTED_ICON_COLOR),
        ),
        child: Text(
          "logout".tr(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
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

List<ConservationFunIconVO> iconFun = [

  ConservationFunIconVO(
    icon:const Icon(Icons.photo_camera_back,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: "photos".tr(),
  ),

  ConservationFunIconVO(
    icon:const Icon(Icons.favorite_border_outlined,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: "favourites".tr(),
  ),

  ConservationFunIconVO(
    icon:const Icon(Icons.wallet_travel,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: "wallet".tr(),
  ),

  ConservationFunIconVO(
    icon:const Icon(Icons.payment_rounded,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: "cards".tr(),
  ),

  ConservationFunIconVO(
    icon:const Icon(Icons.face_sharp,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: "stickers".tr(),
  ),

  ConservationFunIconVO(
    icon:const Icon(Icons.settings,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: "setting".tr(),
  ),

];

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
               color: Theme.of(context).primaryColorLight,
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

  BioTextView({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: DISCOVER_POST_COMMENT_SECTION_PADDING),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: text,
          style:const TextStyle(
            color: UNSELECTED_ICON_COLOR,
            fontSize: TEXT_MEDIUM_1,
            fontWeight: FontWeight.w500,
          ),
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
               icon: Icon(Icons.qr_code,size: MARGIN_SIZE_FOR_APP_BAR_ICON,color: Theme.of(context).bottomAppBarColor),
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
        style: TextStyle(
          color: Theme.of(context).bottomAppBarColor,
          fontSize: TEXT_LARGE_1,
          fontWeight: FontWeight.w600,
        ),
        ),
        Text(subtitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).bottomAppBarColor,
          fontSize: TEXT_MEDIUM,
          fontWeight: FontWeight.w400,
        ),
        ),
      ],
    );
  }
}