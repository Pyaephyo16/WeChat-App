import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat_app/data/vos/comment_vo/comment_vo.dart';
import 'package:we_chat_app/data/vos/favourite_vo/favourite_vo.dart';
import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/network/we_chat_data_agent.dart';

const newsFeedCollection = "newsfeed";
const fileUpload = "uploads";
const userCollection = "users";
const contactCollection = "contacts";
const favouriteCollection = "favourites";
const commentCollection = "comments";

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


  ///Firebase Auth
  final FirebaseAuth auth = FirebaseAuth.instance;


  
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

  ///Auth


    @override
  Future registerNewUser(UserVO newUser) {
   return auth  
    .createUserWithEmailAndPassword(email: newUser.email ?? "", password: newUser.password ?? "")
    .then((credential) => 
    credential.user?..updateDisplayName(newUser.userName))
    .then((user){
      newUser.id = user?.uid ?? "";
      newUser.qrCode = user?.uid ?? "";
    print("usercheck network ===> $newUser");
      _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO newUser){
      return cloudFirestore
      .collection(userCollection)
      .doc(newUser.id.toString())
      .set(newUser.toJson());
  }
  
  @override
  Future loginUser(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }


  @override
  Future<UserVO> getLoggedInUser() {
   UserVO user = UserVO(
      id: auth.currentUser?.uid,
      email: auth.currentUser?.email,
      userName: auth.currentUser?.displayName,
      qrCode: auth.currentUser?.uid,
   );
   return Future.value(user);
  }

  @override
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  @override
  Future logout() {
   return auth.signOut();
  }
  
  ///User

    @override
  Stream<UserVO> getUserById(String id) {
    return cloudFirestore
      .collection(userCollection)
      .doc(id)
      .get()
      .asStream()
      .where((documentSnapshot) => documentSnapshot.data() != null)
      .map((documentSnapshot){
        return UserVO.fromJson(documentSnapshot.data()!);
      });
  }
  
  @override
  Future<void> addContact(UserVO owner,UserVO friend) {
    return cloudFirestore
      .collection(userCollection)
      .doc(owner.id.toString())
      .collection(contactCollection)
      .doc(friend.id.toString())
      .set(friend.toJson());
  }
  
  @override
  Stream<List<UserVO>> getAllContact(String id) {
    return cloudFirestore
      .collection(userCollection)
      .doc(id)
      .collection(contactCollection)
      .snapshots()
      .map((querySnapshot){
        return querySnapshot.docs.map<UserVO>((document){
          return UserVO.fromJson(document.data());
        }).toList();
      });
  }

  ///Favourite

  @override
  Future<void> addToFavourite(FavouriteVO favourite,String postId) {
    return cloudFirestore
      .collection(newsFeedCollection)
      .doc(postId)
      .collection(favouriteCollection)
      .doc(favourite.userId.toString())
      .set(favourite.toJson());
  }
  
  @override
  Stream<List<FavouriteVO>> getAllFavourite(String postId) {
    return cloudFirestore
      .collection(newsFeedCollection)
      .doc(postId)
      .collection(favouriteCollection)
      .snapshots()
      .map((querySnapshot){
        return querySnapshot.docs.map<FavouriteVO>((document){
          return FavouriteVO.fromJson(document.data());
        }).toList();
      });
  }
  
  @override
  Future<void> removeFavourite(String favouriteId,String postId) {
    return cloudFirestore
      .collection(newsFeedCollection)
      .doc(postId)
      .collection(favouriteCollection)
      .doc(favouriteId)
      .delete();
  }

  @override
  Future<void> addComment(String postId, CommentVO comment) {
    return cloudFirestore
      .collection(newsFeedCollection)
      .doc(postId)
      .collection(commentCollection)
      .doc(comment.userId.toString())
      .set(comment.toJson());
  }
  
  @override
  Stream<List<CommentVO>> getAllComments(String postId) {
    return cloudFirestore
    .collection(newsFeedCollection)
    .doc(postId)
    .collection(commentCollection)
    .snapshots()
    .map((querySnapshot){
      return querySnapshot.docs.map<CommentVO>((document){
        return CommentVO.fromJson(document.data());
      }).toList();
    });
  }


}