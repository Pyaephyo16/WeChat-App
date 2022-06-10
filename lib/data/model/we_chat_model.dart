import 'dart:io';

import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';

abstract class WeChatModel{

  Stream<List<NewsFeedVO>> getAllPost();
  Future<void> addNewPost(String description,File? post,String? fileType);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedPostById(int postId);
  Future<void> editPost(NewsFeedVO editPost,bool isChangeImage);


}