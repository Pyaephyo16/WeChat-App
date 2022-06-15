import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';
import 'package:we_chat_app/data/model/cloud_news_feed_model_impl.dart';
import 'package:we_chat_app/data/model/we_chat_model.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

class ScannerPageBloc extends ChangeNotifier{

  bool isDisposed = false;
  bool isLoading = false;
  UserVO? loggedInUser;
  UserVO? friend;

  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  Barcode? barcode;

  ///Model
  WeChatModel model = CloudNewsFeedModelImpl();

  ///Auth
  AuthModel auth = AuthModelImpl();

    ScannerPageBloc(){

        auth.getLoggedInUser().then((value){
            model.getUserById(value.id ?? "").listen((event) {
                loggedInUser = event;
                _notifySafely();
            });
        });

    }


       void onQRViewCreated(QRViewController controller,{required Function finishedFunction,required Function alreadyExist}){
    controller.resumeCamera();
        this.controller = controller;
        _notifySafely();
      controller.scannedDataStream.listen((code){
            barcode = code;
            _notifySafely();
            addContact(
              alreadyExist: (){
                alreadyExist();
              }
            ).then((isAlreadyAxistAccount){
              print("check qr exist =====> $isAlreadyAxistAccount");
                if(isAlreadyAxistAccount != true){
                   finishedFunction();
                }
            });
      });
    }

     Future<bool> addContact({required Function alreadyExist}){
                 bool isAlreadyInAccount = false;
           if(barcode?.code != null){
            controller!.pauseCamera();
            controller?.dispose();
              model.getUserById(barcode!.code ?? "").listen((event){
                  isLoading = true;
                  friend = event;
                  print("owner ===> $loggedInUser");
                  print(("firend ====> $friend"));
                 
                model.getAllContact(loggedInUser?.id ?? "").listen((event) {
                    event.map((contactFriend){
                      if(contactFriend.id == friend?.id){
                          alreadyExist();
                          isAlreadyInAccount = true;
                          print("same found");
                          isLoading = false;
                          _notifySafely();
                      }
                    });
                    
                  if(isAlreadyInAccount != true){
                    print("work here");
                  model.addContact(loggedInUser!,friend!).then((value) => 
                  model.addContact(friend!,loggedInUser!).then((value){
                    isLoading = false;
                    _notifySafely();
                  }));
                  }
                });
              });
         return Future.value(isAlreadyInAccount);
           }else{
            return Future.value(false);
           }
      }
    //  Future<void> addContact(QRViewController? controller,Barcode? barcode){
    //        if(barcode?.code != null){
    //         controller!.pauseCamera();
    //         controller?.dispose();
    //         print("find user to add ==================> ${barcode?.code}");
    //           model.getUserById(barcode!.code ?? "").listen((event){
    //               isLoading = true;
    //               friend = event;
    //               print("owner ===> $loggedInUser");
    //               print(("firend ====> $friend"));
    //              //model.addContact(loggedInUser!,friend!);
    //               //model.addContact(friend!,loggedInUser!);
    //               model.addContact(loggedInUser!,friend!).then((value) => 
    //               model.addContact(friend!,loggedInUser!).then((value){
    //                 isLoading = false;
    //                 isFinished = true;
    //                 _notifySafely();
    //               }));
    //           });
    //        }
    //      return Future.value();
    //   }


  _notifySafely(){
    if(!isDisposed){
      notifyListeners();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    isDisposed = true;
  }

}