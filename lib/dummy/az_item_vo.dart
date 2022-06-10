import 'package:azlistview/azlistview.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';

class AZItemVO extends ISuspensionBean {

   final UserDummyVO person;
   final String tag;

  AZItemVO({
   required this.person,
   required this.tag,
  });

  @override
  String getSuspensionTag() => tag;



}
