import 'dart:io';

import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';

abstract class WeChatDataAgent{

  Stream<List<NewsFeedVO>> getAllPosts();
  Future<void> addNewPost(NewsFeedVO newPost);
  Future<String> uploadFileToFirebaseStorage(File post);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedPostById(int postId);

}