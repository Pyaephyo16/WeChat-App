import 'package:flutter/foundation.dart';

class PrivacyPolicyPageBloc extends ChangeNotifier{

  bool isRead = false;
  bool isDisposed = false;


  changeCheck(){
    isRead = !isRead;
    _notifySafely();
  }


    _notifySafely(){
      if(!isDisposed){
        notifyListeners();
      }
    }

    @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

}