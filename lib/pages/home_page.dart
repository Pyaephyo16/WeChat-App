import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/home_page_bloc.dart';
import 'package:we_chat_app/pages/tabs/chat_tab.dart';
import 'package:we_chat_app/pages/tabs/contact_tab.dart';
import 'package:we_chat_app/pages/tabs/discover_tab.dart';
import 'package:we_chat_app/pages/tabs/me_tab.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';

class HomePage extends StatelessWidget {

  List<Widget> tabList = [
    ChatTab(),
    ContactTab(),
    DiscoverTab(),
    MeTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePageBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Selector<HomePageBloc,int>(
          selector: (context,bloc) => bloc.current,
          shouldRebuild: (previous,next) => previous != next,
          builder: (context,current,child) =>
           tabList[current]
          ),
        bottomNavigationBar: Selector<HomePageBloc,int>(
          selector: (context,bloc) => bloc.current,
           shouldRebuild: (previous,next) => previous != next,
           builder: (context,current,child) =>
          BottomNavigationBar(
            currentIndex: current,
            backgroundColor: APP_BAR_BACKGROUND_COLOR,
            selectedItemColor: PRIMARY_COLOR,
            unselectedItemColor: UNSELECTED_ICON_COLOR,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            onTap: (index){
              HomePageBloc bloc = Provider.of(context,listen: false);
              bloc.userSelectTab(index);
            },
            items: [
              BottomNavigationBarItem(
                icon:const FaIcon(FontAwesomeIcons.commentDots),
                label: "chat".tr(),
                ),

              BottomNavigationBarItem(
                icon:const FaIcon(FontAwesomeIcons.addressBook),
                label: "contact".tr(),
                ),

              BottomNavigationBarItem(
                icon:const FaIcon(FontAwesomeIcons.eye),
                label: "discover".tr(),
                ),

              BottomNavigationBarItem(
                icon:const FaIcon(FontAwesomeIcons.user),
                label: "me".tr(),
                ),
            ],
            ),
        ),
      ),
    );
  }
}