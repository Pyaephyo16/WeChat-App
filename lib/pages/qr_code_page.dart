import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/pages/scanner_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/view_items/text_field_for_login_and_register.dart';
import 'package:we_chat_app/utils/extension.dart';

class QrCodePage extends StatelessWidget {

  final UserVO loggedInUser;

  QrCodePage({
    required this.loggedInUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: PRIMARY_COLOR,
        title: AppBarTitleView(title: "QR Code"),
        centerTitle: true,
        leading: IconButton(
                  icon:const FaIcon(FontAwesomeIcons.xmark,color: Colors.white,),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),      
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.68,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: UNSELECTED_ICON_COLOR,width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: Offset(10,10),
                        blurRadius: 8
                      ),
                    ]
                  ),
                  child: QrImage(
                          data: loggedInUser.qrCode ?? "",
                         version: QrVersions.auto,
                  size: MediaQuery.of(context).size.width * 0.6,
                             ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToNextScreen(context,ScannerPage());
        },
        child:const Icon(Icons.qr_code_scanner_sharp,size: 28,color: Colors.white,),
      ),
    );
  }
}

