import 'dart:io';

import 'package:we_chat_app/data/vos/comment_vo/comment_vo.dart';
import 'package:we_chat_app/data/vos/favourite_vo/favourite_vo.dart';
import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

abstract class WeChatModel{

  Stream<List<NewsFeedVO>> getAllPost();
  Future<void> addNewPost(String description,File? post,String? fileType,String profileImage,String userId);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedPostById(int postId);
  Future<void> editPost(NewsFeedVO editPost,bool isChangeImage);
  Future<void> addToFavourite(FavouriteVO favourite,String postId);
  Stream<List<FavouriteVO>> getAllFavourite(String postId);
  Future<void> removeFavourite(String favouriteId,String postId);
  Future<void> addComment(String postId,CommentVO comment);
  Stream<List<CommentVO>> getAllComment(String postId);

  ///User
  Stream<UserVO> getUserById(String id);
  Future<void> addContact(UserVO owner,UserVO friend);
  Stream<List<UserVO>> getAllContact(String id);

}