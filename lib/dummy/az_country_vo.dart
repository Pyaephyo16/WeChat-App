import 'package:azlistview/azlistview.dart';

import 'package:we_chat_app/data/vos/country_dial_vo.dart';

class AZCountryVO extends ISuspensionBean {

  final CountryDialVO country;
  final String tag;

  AZCountryVO({
    required this.country,
    required this.tag,
  });
  

  @override
  String getSuspensionTag() => tag;

}
