import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
import 'package:we_chat_app/network/we_chat_data_agent.dart';

const newsFeedCollection = "newsfeed";
const fileUpload = "uploads";

class CloudNewsFeedDataAgentImpl extends WeChatDataAgent{

  static final CloudNewsFeedDataAgentImpl _singleton = CloudNewsFeedDataAgentImpl._internal();

  factory CloudNewsFeedDataAgentImpl(){
    return _singleton;
  }

  CloudNewsFeedDataAgentImpl._internal();

  ///cloud Firestore
  final FirebaseFirestore cloudFirestore = FirebaseFirestore.instance;

  ///Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;


  
  @override
  Stream<List<NewsFeedVO>> getAllPosts() {
    return cloudFirestore
      .collection(newsFeedCollection)
      .snapshots()
      .map((querySnapshot){
        return  querySnapshot.docs.map<NewsFeedVO>((document){
          return NewsFeedVO.fromJson(document.data());
        }).toList();
      });
  }


  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return cloudFirestore
          .collection(newsFeedCollection)
          .doc(newPost.id.toString())
          .set(newPost.toJson());
  }

  @override
  Future<String> uploadFileToFirebaseStorage(File post) {
    return storage
      .ref(fileUpload)
      .child("${DateTime.now().millisecondsSinceEpoch}")
      .putFile(post)
      .then((postUrl) => postUrl.ref.getDownloadURL());
  }
  
  @override
  Future<void> deletePost(int postId) {
      return cloudFirestore
        .collection(newsFeedCollection)
        .doc(postId.toString())
        .delete();
  }
  
  @override
  Stream<NewsFeedVO> getNewsFeedPostById(int postId) {  
    return cloudFirestore
      .collection(newsFeedCollection)
      .doc(postId.toString())
      .get()
      .asStream()
      .where((documentSnapshot) => documentSnapshot.data() != null)
      .map((documentSnapshot){
        return NewsFeedVO.fromJson(documentSnapshot.data()!);
      });
  }


}