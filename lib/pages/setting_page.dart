import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/setting_page_bloc.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/view_items/divide_line_view.dart';

class SettingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: PRIMARY_COLOR,
          title: AppBarTitleView(title: "setting".tr()),
          centerTitle: true,
          leading: IconButton(
                    icon: FaIcon(FontAwesomeIcons.xmark,color: Theme.of(context).bottomAppBarColor,),
                    onPressed: (){
                      Navigator.pop(context);
                },
             ), 
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: MARGIN_MEDIUM_1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Selector<SettingPageBloc,ThemeMode>(
                selector: (context,bloc) => bloc.chooseTheme,
                shouldRebuild: (previous,next) => previous != next,
                builder: (context,chooseTheme,child) =>
                 ChangeTheme(
                  isOn: chooseTheme == ThemeMode.dark,
                  changeTheme: (isOn){
                    SettingPageBloc themeBloc = Provider.of(context,listen: false);
                    themeBloc.changeTheme(isOn);
                  },
                ),
              ),
              const SizedBox(height: 28,),
              ChangeLanguage(
                titleOne: "မြန်မာ",
                titleTwo: "English",
              ),
            ],
          ),
        ),
    );
  }
}

class ChangeTheme extends StatelessWidget {

  final Function(bool) changeTheme;
  final bool isOn;

    ChangeTheme({
      required this.changeTheme,
      required this.isOn,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
         color: Theme.of(context).primaryColorLight,
        border: Border.all(color: CHAT_HEAD_SUBTITLE_COLOR),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              TitleForSettingView(
                title: "theme".tr(),
              ),
              const SizedBox(height: 12,),
          Row(
            children: [
              SettingSubtitleView(
                title: "night_mode".tr(),
              ),
              const Spacer(),
              Switch(
                value: isOn,
                 onChanged: (isOn){
                  changeTheme(isOn);
                 }
                 )
            ],
          ),
        ],
      ),
    );
  }
}

class SettingSubtitleView extends StatelessWidget {

  final String title;

  SettingSubtitleView({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title,
    style: TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    ),
    );
  }
}

class ChangeLanguage extends StatelessWidget {

  final String titleOne;
  final String titleTwo;

  ChangeLanguage({
    required this.titleOne,
    required this.titleTwo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
         color: Theme.of(context).primaryColorLight,
        border: Border.all(color: CHAT_HEAD_SUBTITLE_COLOR),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              TitleForSettingView(
                title: "languages".tr(),
              ),
              const SizedBox(height: 12,),
          ChangeMyanmar(
            titleOne: titleOne,
            changeMyanmar: (){
              context.locale = Locale('my','MM');
            },
            ),
          DivideLineView(),
          ChangeEnglish(
            titleOne: titleTwo,
            changeEnglish: (){
              context.locale = Locale('en','US');
            },
            ),
           DivideLineView(),
        ],
      ),
    );
  }
}

class ChangeMyanmar extends StatelessWidget {
  const ChangeMyanmar({
    Key? key,
    required this.titleOne,
    required this.changeMyanmar,
  }) : super(key: key);

  final String titleOne;
  final Function changeMyanmar;

  @override
  Widget build(BuildContext context) {
    print("locale check myanmar =====> ${EasyLocalization.of(context)!.locale}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
      child: ListTile(
        onTap: (){
          changeMyanmar();
        },
         title: SettingSubtitleView(title: titleOne),
         trailing: EasyLocalization.of(context)!.locale == Locale('my','MM') ?
         const Icon(Icons.check,size: 28,color: PRIMARY_COLOR,) : const Text("Select"),
      ),
    );
  }
}

class ChangeEnglish extends StatelessWidget {
  const ChangeEnglish({
    Key? key,
    required this.titleOne,
    required this.changeEnglish,
  }) : super(key: key);

  final String titleOne;
  final Function changeEnglish;

  @override
  Widget build(BuildContext context) {
     print("locale check english =====> ${EasyLocalization.of(context)!.locale}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
      child: ListTile(
        onTap: (){
          changeEnglish();
        },
         title: SettingSubtitleView(title: titleOne),
         trailing: EasyLocalization.of(context)!.locale == Locale('en','US') ? 
        const Icon(Icons.check,size: 28,color: PRIMARY_COLOR,) : const Text("Select"),
      ),
    );
  }
}

class TitleForSettingView extends StatelessWidget {

  final String title;

  TitleForSettingView({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}