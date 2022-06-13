import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/country_page_bloc.dart';
import 'package:we_chat_app/data/vos/country_dial_vo.dart';
import 'package:we_chat_app/dummy/az_country_vo.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';

class CountryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CountryPageBloc(), 
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
            const SizedBox(height: 22,),
         Selector<CountryPageBloc,bool>(
          selector: (context,bloc) => bloc.isNeedSearch,
          shouldRebuild: (previous,next) => previous != next,
          builder: (context,isNeedSearch,child) =>
          (!isNeedSearch) ? 
          AppBarView(
            search: (){
              CountryPageBloc bloc = Provider.of(context,listen: false);
            bloc.needSearch();
            },
          ) 
          :
          CountrySearchFieldView(
            back: (){
              CountryPageBloc bloc = Provider.of(context,listen: false);
                  bloc.needSearch();
            },
            typeCountry: (text){
                CountryPageBloc bloc = Provider.of(context,listen: false);
                bloc.typeCountry(text);
            },
          ),
        ),
       const SizedBox(height: 12,),
         Selector<CountryPageBloc,List<AZCountryVO>>(
          selector: (context,bloc) => bloc.countryList ?? [],
          shouldRebuild: (previous,next) => previous != next,
          builder: (context,countryList,child) =>
             CountryListView(
              countryList: countryList,
              chooseCountry: (country){
                Navigator.pop(context,country);
              },
             ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountryListView extends StatelessWidget {

  final List<AZCountryVO> countryList;
  final Function(CountryDialVO) chooseCountry;

  CountryListView({
    required this.countryList,
    required this.chooseCountry,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AzListView(
        data: countryList,
         itemCount: countryList.length,
          itemBuilder: (BuildContext context,int index){
         final tag = countryList[index].getSuspensionTag();    
       final offStage = !countryList[index].isShowSuspension;
            return CountryView(
              chooseCountry: (){
                chooseCountry(countryList[index].country);
              },
              country: countryList[index],
              tag: tag,
              offStage: offStage,
            );
          }
          )
      );
  }
}

class CountryView extends StatelessWidget {

    final Function chooseCountry;
    final AZCountryVO country;
    final String tag;
    final bool offStage;

    CountryView({
      required this.chooseCountry,
      required this.country,
      required this.tag,
      required this.offStage,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        chooseCountry();
      },
      child: Padding(
        padding:const EdgeInsets.all(MARGIN_MEDIUM_1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Offstage(
             offstage: offStage,
            child: Container(
              alignment: Alignment.centerLeft,
               width: MediaQuery.of(context).size.width,
               height: CONTACT_NAME_LIST_TITLE_CONTAINGER_HEIGHT,
               color: Colors.black,
               child: Text("${tag}",
               style:const TextStyle(
                 color: UNSELECTED_ICON_COLOR,
                 fontSize: MARGIN_MEDIUM_2X,
                 fontWeight: FontWeight.bold,
               ),
               ),
             ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text("${country.country.name}",
                  overflow: TextOverflow.ellipsis,
                  style:const TextStyle(
                    color: Colors.white,
                    fontSize:18, 
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                ),
                Text("${country.country.dial}",
                style:const TextStyle(
                  color: CONTACT_SEARCH_TEXT_COLOR,
                  fontSize: 16, 
                  fontWeight: FontWeight.w500,
                ),
                ),
                const SizedBox(width: 20,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarView extends StatelessWidget {
 
  final Function search;

  AppBarView({
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     padding:const EdgeInsets.only(left: MARGIN_MEDIUM_1,right: MARGIN_MEDIUM_1,top: 22),
      color: Colors.black,
     child:Row (
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
         IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
         icon:const Icon(Icons.chevron_left,size: MARGIN_SIZE_FOR_ICON,color: Colors.white,),
         ),
      AppBarTitleView(title: "Region",),
       IconButton(
        onPressed: (){
          search();
        },
         icon:const Icon(Icons.search,size: MARGIN_SIZE_FOR_ICON,color: Colors.white,),
         ),
     ]),
    );
  }
}

class CountrySearchFieldView extends StatelessWidget {

  final Function back;
  final Function typeCountry;

  CountrySearchFieldView({
    required this.back,
    required this.typeCountry,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding:const EdgeInsets.only(left: MARGIN_MEDIUM_1,right: MARGIN_MEDIUM_1,top: 22),
      child: Row(
        children:  [
          Expanded(
            child: TextField(
              onChanged: (text){
                typeCountry(text);
              },
               style:const TextStyle(
                  color: Colors.white,
                  fontSize: TEXT_MEDIUM_1X,
                  fontWeight: FontWeight.w400,
                ),
              decoration:const InputDecoration(
                contentPadding: EdgeInsets.only(left: 16,top: 12),
                focusColor: PRIMARY_COLOR,
                prefixIcon: Icon(Icons.search,color: CONTACT_SEARCH_TEXT_COLOR,size: 22,),
                hintText: "Search",
                hintStyle: TextStyle(
                 color: CONTACT_SEARCH_TEXT_COLOR,
               fontSize: TEXT_MEDIUM_1X,
                   fontWeight: FontWeight.w400,
                    ), 
              ),
            ),
          ),
          TextButton(
            onPressed: (){
              back();
            },
             child:const Text("Cancel",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: TEXT_MEDIUM_1X,
                  fontWeight: FontWeight.w400,
                ),
             )
             ),
        ],
      ),
    );
  }
}