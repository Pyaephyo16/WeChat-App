import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';
import 'package:we_chat_app/data/model/cloud_news_feed_model_impl.dart';
import 'package:we_chat_app/data/model/we_chat_model.dart';
import 'package:we_chat_app/data/vos/az_vo/az_user_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/dummy/az_item_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';

class ContactTabBloc extends ChangeNotifier{

// List<UserDummyVO> usersDummy = userDummyList;
//  List<AZItemVO>? alphabetList;
//  List<AZItemVO>? filterList;

  UserVO? loggedInUser;
  List<UserVO>? contactList;
  List<AZUserVO>? azContactList;
  List<AZUserVO>? filterList;
  bool isDisposed = false;

  ///Model
  WeChatModel model = CloudNewsFeedModelImpl();

  ///Auth
  AuthModel auth = AuthModelImpl();

  ContactTabBloc(){
      auth.getLoggedInUser().then((value){
          model.getAllContact(value.id ?? "").listen((event) {
              contactList = event;
   azContactList = contactList?.map((item) => AZUserVO(person: item, tag: item.userName?[0].toUpperCase() ?? "")).toList();           
   filterList = contactList?.map((item) => AZUserVO(person: item, tag: item.userName?[0].toUpperCase() ?? "")).toList();

   SuspensionUtil.sortListBySuspensionTag(azContactList);
   SuspensionUtil.setShowSuspensionStatus(azContactList);
              _notifySafely();
          });
      });

      auth.getLoggedInUser().then((value){
          model.getUserById(value.id ?? "").listen((event) {
              loggedInUser = event;
              _notifySafely();
              print("contact bloc loggedInuser ==========> $loggedInUser");
          });
      });

  }

  searchByName(String text){
    if(text.isNotEmpty){
     azContactList = filterList?.where((element){
      return element.person.userName!.toLowerCase().contains(text.toLowerCase());
     }).toList();
    }else{
      azContactList = filterList;
    }
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