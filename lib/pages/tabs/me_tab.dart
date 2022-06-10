import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/data/vos/conservation_fun_icon_vo.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';


List<ConservationFunIconVO> iconFun = [

  ConservationFunIconVO(
    icon: Icon(Icons.photo,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: ME_PHOTO_ICON_TEXT,
  ),

  ConservationFunIconVO(
    icon: Icon(Icons.favorite_border_outlined,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
    title: ME_FAVOURITE_ICON_TEXT,
  ),

  ConservationFunIconVO(
    icon: Icon(Icons.wallet,size: MARGIN_SIZE_FOR_ICON,color: UNSELECTED_ICON_COLOR,),
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
    return Scaffold(
      body: Stack(
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
                  child: ProfileAppBarView(),
                ),
                Expanded(
                  child: Container(
                    color: CONTACT_PAGE_BG_COLOR,
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
                 image: NetworkImage("https://preview.keenthemes.com/metronic-v4/theme_rtl/assets/pages/media/profile/profile_user.jpg"),
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
               //left: 0,
               //right: 0,
               top: MediaQuery.of(context).size.height * 0.46,
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
                 child: LogoutButtonView(
                   logout: (){
                     print("logout tap");
                   },
                 )
                 )


        ],
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
      padding: EdgeInsets.symmetric(horizontal: 46),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: RichText(
        textAlign: TextAlign.center,
        //overflow: TextOverflow.ellipsis,
        //maxLines: 3,
        text: TextSpan(
          text: text,
          style: TextStyle(
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
              style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Container()),
        Expanded(
          flex: 3,
          child: ProfileNameView(
            title: "Alberto Calvo",
            subtitle: "alberto203",
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: (){},
               icon: Icon(Icons.qr_code,size: MARGIN_SIZE_FOR_APP_BAR_ICON,color: Colors.white,),
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
          color: Colors.white,
          fontSize: TEXT_LARGE_1,
          fontWeight: FontWeight.w600,
        ),
        ),
        Text(subtitle,
        style: TextStyle(
          color: Colors.white,
          fontSize: TEXT_MEDIUM_1X,
          fontWeight: FontWeight.w400,
        ),
        ),
      ],
    );
  }
}