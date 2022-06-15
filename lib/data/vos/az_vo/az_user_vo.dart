import 'package:azlistview/azlistview.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

class AZUserVO extends ISuspensionBean {

   final UserVO person;
   final String tag;

  AZUserVO({
   required this.person,
   required this.tag,
  });

  @override
  String getSuspensionTag() => tag;



}
