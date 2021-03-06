import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:we_chat_app/blocs/scanner_page_bloc.dart';
import 'package:we_chat_app/pages/add_new_post_page.dart';
import 'package:we_chat_app/pages/tabs/contact_tab.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/utils/extension.dart';

class ScannerPage extends StatefulWidget {

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {


//    final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
//  QRViewController? controller;
//  Barcode? barcode;


  // @override
  // void reassemble()async{
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //    await controller!.pauseCamera();
  //   } else{
  //     controller!.resumeCamera();
  //   }
  // }

 
  // @override
  // void reassemble(){
  //   super.reassemble();
  //   if(Platform.isAndroid){
  //      controller!.pauseCamera();
  //   }else if(Platform.isIOS){
  //     controller!.resumeCamera();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScannerPageBloc(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: PRIMARY_COLOR,
          title: AppBarTitleView(title: "qr_scanner".tr()),
          centerTitle: true,
          leading: IconButton(
                    icon: FaIcon(FontAwesomeIcons.xmark,color: Theme.of(context).bottomAppBarColor),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),      
        ),
        body: Consumer<ScannerPageBloc>(
          builder: (context,ScannerPageBloc bloc,child) =>
           Stack(
            alignment: Alignment.center,
           children: [
               buildQrView(
                context,
                qrKey: bloc.qrKey,
                onQRViewCreated: (controller){
                  ScannerPageBloc scanBloc = Provider.of(context,listen: false);
                  scanBloc.onQRViewCreated(
                    controller,
                    finishedFunction: (){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContactTab()));
                    },
                    alreadyExist: (){
                       ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                         content:const Text(ALREADY_EXIST_TEXT),
                        backgroundColor: Colors.green.withOpacity(0.8),
                      ),
    );
                    }
                    );
                }
                ),

               Positioned(
                 bottom: MARGIN_SIZE_FOR_REGISTER_SPACEING,
                 child: Text( (bloc.barcode != null) ?  " ${bloc.barcode!.code}" : "scan_a_code".tr(),
                 style:const TextStyle(
                   color: Colors.white,
                   fontSize: TEXT_MEDIUM_1X,
                 ),
                 ),
                 ),

                 Visibility(
                  visible: bloc.isLoading,
                  child:const LoadingShowView(),
                  ),
           ],
          ),
        ),
      ),
    );
  }

  Widget buildQrView(BuildContext context,{required GlobalKey qrKey,required Function(QRViewController) onQRViewCreated}){
    return QRView(
    key: qrKey,
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(
      borderColor: PRIMARY_COLOR,
     borderWidth: MARGIN_SMALL_1X,
     borderLength: MARGIN_MEDIUM_2,
     borderRadius: MARGIN_SMALL_1X,
     cutOutSize: MediaQuery.of(context).size.width * 0.8,
   
    ),
    );
  }


    // void onQRViewCreated(QRViewController controller){
    // controller.resumeCamera();
    //   setState(() {
    //     this.controller = controller;
    //   });
    //   controller.scannedDataStream.listen((code) {
    //       setState(() {
    //         barcode = code;
    //       });
    //   });
    // }

  //   @override
  // void dispose() {
  // controller?.dispose();
  //   super.dispose();
  // }

}

//_________________________________________________________________________________________
// class ScannerPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _ScanQrPageState();
// }

// class _ScanQrPageState extends State<ScannerPage> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   void _onQRViewCreated(QRViewController controller) {
//       controller.resumeCamera();
//     setState(() => this.controller = controller);
//     controller.scannedDataStream.listen((scanData) {
//       setState(() => result = scanData);
//       ScannerPageBloc bloc = Provider.of(context,listen: false);
//       bloc.addContact(controller,result);
//     });
//   }
  
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller!.resumeCamera();
//     }
//   }

//   void readQr() async {
//     if (result != null) {
//       controller!.pauseCamera();
//       print(result!.code);
//       controller!.dispose();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     readQr();
//     return ChangeNotifierProvider(
//       create: (context) => ScannerPageBloc(),
//       child: Scaffold(
//         body: QRView(
//           key: qrKey,
//           onQRViewCreated: _onQRViewCreated,
//           overlay: QrScannerOverlayShape(
//             borderColor: Colors.orange,
//             borderRadius: 10,
//             borderLength: 30,
//             borderWidth: 10,
//             cutOutSize: 250,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }