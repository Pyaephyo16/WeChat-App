import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';

class ChatTabBloc extends ChangeNotifier{

List<UserDummyVO> usersDummy = userDummyList;
 bool isDisposed = false;


  void remoteUser(int index){
      UserDummyVO? removeItem;
  List<UserDummyVO> temp = usersDummy.mapIndexed((num,element){
      if(index == num){
        removeItem = element;
      }
      return element;
  }).toList();
    temp.removeWhere((element) => element.id == removeItem?.id);
    usersDummy = temp;

    print("userDummy bloc =======> ${usersDummy.length}");
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