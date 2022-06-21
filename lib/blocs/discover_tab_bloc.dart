// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:we_chat_app/data/model/auth_model.dart';
// import 'package:we_chat_app/data/model/auth_model_impl.dart';
// import 'package:we_chat_app/data/model/cloud_news_feed_model_impl.dart';
// import 'package:we_chat_app/data/model/we_chat_model.dart';
// import 'package:we_chat_app/data/vos/favourite_vo/favourite_vo.dart';
// import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
// import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
// import 'package:we_chat_app/dummy/dummy_data.dart';

// class DiscoverTabBloc extends ChangeNotifier{

//   //List<UserDummyVO> usersDummy = userDummyList;

//   String comment = "";
//   bool isDisposed = false;
//   List<NewsFeedVO>? newsFeedList;
//   UserVO? loggedInUser;

//   ///Model
//   WeChatModel model = CloudNewsFeedModelImpl();

//   ///Auth 
//   AuthModel authModel = AuthModelImpl();

//   DiscoverTabBloc(){

//       authModel.getLoggedInUser().then((value){
//           model.getUserById(value.id ?? "").listen((event) {
//               loggedInUser = event;
//               _notifySafely();
//           });
//       });

//         model.getAllPost().listen((event){
//         newsFeedList = event;
//         _notifySafely();
//     });

//   }

//  Future<void> addToFavourite(NewsFeedVO post){
//     FavouriteVO favourite = FavouriteVO(
//       isLike: true,
//       postId: post.id.toString(),
//       userId: loggedInUser?.id,
//       userName: loggedInUser?.userName,
//     );
//     print("user favourite ======> $loggedInUser");
//      print("post id favourite ======> ${post.id}");
//    return model.addToFavourite(favourite,post.id.toString());
//   }

//   commentedChanged(String text){
//     comment = text;
//     print("coment in bloc =======> $comment");
//     _notifySafely();
//   }


//     Future<void> deletePost(int postId)async{
//       await model.deletePost(postId);
//     }


//   _notifySafely(){
//     if(!isDisposed){
//         notifyListeners();
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     isDisposed = true;
//   }

// }

//___________________________________________________________________________________
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';
import 'package:we_chat_app/data/model/cloud_news_feed_model_impl.dart';
import 'package:we_chat_app/data/model/we_chat_model.dart';
import 'package:we_chat_app/data/vos/comment_vo/comment_vo.dart';
import 'package:we_chat_app/data/vos/favourite_vo/favourite_vo.dart';
import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';

class DiscoverTabBloc extends ChangeNotifier{

  //List<UserDummyVO> usersDummy = userDummyList;

  String comment = "";
  bool isDisposed = false;
  List<NewsFeedVO>? newsFeedList;
  UserVO? loggedInUser;
   FavouriteVO? favourite;
   CommentVO? comm;

  ///Model
  WeChatModel model = CloudNewsFeedModelImpl();

  ///Auth 
  AuthModel authModel = AuthModelImpl();

  DiscoverTabBloc(){

      authModel.getLoggedInUser().then((value){
          model.getUserById(value.id ?? "").listen((event) {
              loggedInUser = event;
              _notifySafely();
          });
      });


      authModel.getLoggedInUser().then((value){
          model.getUserById(value.id ?? "").listen((event) {
              model.getAllPost().listen((event){
          event.forEach((posts){
            print("all post length =============> ${event.length} ${posts.userId}");

            ///Favourite
            model.getAllFavourite(posts.id.toString()).listen((fav) {
                  posts.favourites = fav;
                  _notifySafely();
                  print("fav check ${posts.id} ===> ${fav}");
                     if(fav.isNotEmpty){
                      fav.forEach((element){
                      print("element fav in loop ===> $element");
                        if(element.userId == value.id){
                                posts.isLike = true;
                            _notifySafely();
                        }else{
                          posts.isLike = false;
                          _notifySafely();
                        }
                    });
                     }else{
                        posts.isLike = false;
                        _notifySafely();
                     }
            });

            ///Comment
            model.getAllComment(posts.id.toString()).listen((event) {
                posts.comments = event;
                _notifySafely();
            });

        });
        newsFeedList = event;
        _notifySafely();
    });
          });
      });

  }

 Future<void> addToFavourite(NewsFeedVO post){
    bool isRemove = false;
post.favourites?.forEach((element) {
            if(element.userId == loggedInUser?.id){
              isRemove = true;
            }else{
              isRemove = false;
            }
        });
  if(isRemove == true){
     return model.removeFavourite(loggedInUser?.id ?? "",post.id.toString());
  }else{
        favourite = FavouriteVO(
      isLike: true,
      postId: post.id.toString(),
      userId: loggedInUser?.id,
      userName: loggedInUser?.userName,
    );
        print("user favourite ======> $loggedInUser");
     print("post id favourite ======> ${post.id}");
   return model.addToFavourite(favourite!,post.id.toString());
  }
  }



  Future<void> addComment(String text,NewsFeedVO post){
      //comment = text;
      if(text.isNotEmpty){
        comm = CommentVO(
      comment: text,
      postId: post.id.toString(),
      userId: loggedInUser?.id,
      userName: loggedInUser?.userName,
    );
    print("comment check =====> $comm");
    return model.addComment(post.id.toString(),comm!);
    }else{
      return Future.value();
    }
  }


  // commentedChanged(String text){
  //   comment = text;
  //   print("coment in bloc =======> $comment");
  //   _notifySafely();
  // }


    Future<void> deletePost(int postId)async{
      await model.deletePost(postId);
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
