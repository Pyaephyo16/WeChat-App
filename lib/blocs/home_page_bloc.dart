import 'package:flutter/foundation.dart';

class HomePageBloc extends ChangeNotifier{

  int current = 0;

  userSelectTab(int index){
    current = index;
    notifyListeners();
  }

}