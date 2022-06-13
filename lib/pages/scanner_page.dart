import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:we_chat_app/blocs/scanner_page_bloc.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';

class ScannerPage extends StatefulWidget {

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {


   final qrKey = GlobalKey(debugLabel: "QR");
 QRViewController? controller;
 Barcode? barcode;


  @override
  void reassemble()async{
    super.reassemble();
    if (Platform.isAndroid) {
     await controller!.pauseCamera();
    } else{
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 1,
      //   backgroundColor: PRIMARY_COLOR,
      //   title: AppBarTitleView(title: "QR Scanner"),
      //   centerTitle: true,
      //   leading: IconButton(
      //             icon:const FaIcon(FontAwesomeIcons.xmark,color: Colors.white,),
      //             onPressed: (){
      //               Navigator.pop(context);
      //             },
      //           ),      
      // ),
      body: Stack(
        alignment: Alignment.center,
       children: [
           buildQrView(context),

           Positioned(
             bottom: 30,
             child: Text( (barcode != null) ?  "your qrcode is ${barcode!.code}" : "Scan a code",
             style: TextStyle(
               color: Colors.black,
               fontSize: 22,
             ),
             ),
             )
       ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) =>
   QRView(
    key: qrKey,
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(
      borderColor: PRIMARY_COLOR,
     borderWidth: 10,
     borderLength: 20,
     borderRadius: 10,
     cutOutSize: MediaQuery.of(context).size.width * 0.8,
   
    ),
    );


    void onQRViewCreated(QRViewController controller){
      setState(() {
        this.controller = controller;
      });
      controller.scannedDataStream.listen((barcode) {
          setState(() {
            this.barcode = barcode;
            print("barcdoe =====> $barcode");
          });
      });
    }

    @override
  void dispose() {
  controller?.dispose();
    super.dispose();
  }

}

