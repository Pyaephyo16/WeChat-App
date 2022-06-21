import 'dart:io';

import 'package:we_chat_app/data/vos/comment_vo/comment_vo.dart';
import 'package:we_chat_app/data/vos/favourite_vo/favourite_vo.dart';
import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

abstract class WeChatDataAgent{

  Stream<List<NewsFeedVO>> getAllPosts();
  Future<void> addNewPost(NewsFeedVO newPost);
  Future<String> uploadFileToFirebaseStorage(File post);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedPostById(int postId);
  Future<void> addToFavourite(FavouriteVO favourite,String postId);
  Stream<List<FavouriteVO>> getAllFavourite(String postId);
  Future<void> removeFavourite(String favouriteId,String postId);
  Future<void> addComment(String postId,CommentVO comment);
  Stream<List<CommentVO>> getAllComments(String postId);


  //User
  Stream<UserVO> getUserById(String id);
  Future<void> addContact(UserVO owner,UserVO friend);
  Stream<List<UserVO>> getAllContact(String id);


  //Auth
  Future registerNewUser(UserVO newUser);
  Future loginUser(String email,String password);
  bool isLoggedIn();
  Future<UserVO> getLoggedInUser();
  Future logout();

}