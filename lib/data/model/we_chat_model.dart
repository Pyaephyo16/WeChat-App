import 'dart:io';

import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

abstract class WeChatModel{

  Stream<List<NewsFeedVO>> getAllPost();
  Future<void> addNewPost(String description,File? post,String? fileType,String profileImage);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedPostById(int postId);
  Future<void> editPost(NewsFeedVO editPost,bool isChangeImage);

  ///User
  Stream<UserVO> getUserById(String id);

}