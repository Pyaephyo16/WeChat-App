import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/data/vos/country_dial_vo.dart';
import 'package:we_chat_app/dummy/az_country_vo.dart';
import 'package:we_chat_app/dummy/country_dial_constants.dart';
import 'package:we_chat_app/pages/tabs/contact_tab.dart';

class CountryPageBloc extends ChangeNotifier{

  List<AZCountryVO>? countryList;
  List<AZCountryVO>? filterList;
  bool isDisposed = false;
  bool isNeedSearch = false;

  CountryPageBloc(){
   countryList =
    countries.map((country) => AZCountryVO(country: country, tag: country.name?[0].toUpperCase() ?? ""))
    .toList();

    filterList =
    countries.map((country) => AZCountryVO(country: country, tag: country.name?[0].toUpperCase() ?? ""))
    .toList();

  SuspensionUtil.sortListBySuspensionTag(countryList);
  SuspensionUtil.setShowSuspensionStatus(countryList);
  }

    typeCountry(String text){
      if(text.isNotEmpty){
       countryList = filterList?.where((element){
          return element.country.name!.toLowerCase().contains(text.toLowerCase());
        }).toList();
      }else{
        countryList = filterList;
      }
      _notifySafely();
    }

    needSearch(){
      isNeedSearch = !isNeedSearch;
      notifyListeners();
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