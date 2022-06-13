// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class ScannerPageBloc extends ChangeNotifier{

//  final qrKey = GlobalKey(debugLabel: "QR");
//  QRViewController? qrController;
//  Barcode? barcode;


//     onQRViewCreated(QRViewController controller){
//       qrController = controller;
//       qrController?.scannedDataStream.listen((barcode){
//           this.barcode = barcode;
//           notifyListeners();
//       }); 
//       notifyListeners();
//     }


//   @override
//   void dispose() {
//     qrController?.dispose();
//     super.dispose();
//   }

// }