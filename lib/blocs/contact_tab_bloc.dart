import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/dummy/az_item_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';

class ContactTabBloc extends ChangeNotifier{

List<UserDummyVO> usersDummy = userDummyList;
 List<AZItemVO>? alphabetList;
 List<AZItemVO>? filterList;
 bool isDisposed = false;

  ContactTabBloc(){
    //usersDummy.sort((a,b) => a.name!.compareTo(b.name!));
   alphabetList = usersDummy.map((item) => AZItemVO(person: item, tag: item.name?[0].toUpperCase() ?? "")).toList();
   filterList = usersDummy.map((item) => AZItemVO(person: item, tag: item.name?[0].toUpperCase() ?? "")).toList();

  SuspensionUtil.sortListBySuspensionTag(filterList);
  SuspensionUtil.setShowSuspensionStatus(filterList);

  }

  searchByName(String text){
    if(text.isNotEmpty){
      filterList = alphabetList?.where((element){
            return element.person.name!.toLowerCase().contains(text.toLowerCase());
        }).toList();
    }else{
      filterList = alphabetList;
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