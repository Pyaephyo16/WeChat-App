import 'dart:io';

import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';
import 'package:we_chat_app/data/model/we_chat_model.dart';
import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/network/cloud_news_feed_data_agent_impl.dart';
import 'package:we_chat_app/network/we_chat_data_agent.dart';

class CloudNewsFeedModelImpl extends WeChatModel{

  static final CloudNewsFeedModelImpl _singleton = CloudNewsFeedModelImpl._internal();

  factory CloudNewsFeedModelImpl(){
    return _singleton;
  }

  CloudNewsFeedModelImpl._internal();

  ///Other Model
  AuthModel authModel = AuthModelImpl();

  ///Data Agent
  WeChatDataAgent dataAgent = CloudNewsFeedDataAgentImpl();


  @override
  Future<void> addNewPost(String description,File? post,String? fileType,String profileImage) {
    print("data lyer post check =========> $post");
    print("data layer filetype check =======> $fileType");
      if(post != null && fileType != null){
       return dataAgent
        .uploadFileToFirebaseStorage(post)
        .then((postUrl) => addPostData(description,postUrl,fileType,profileImage))
        .then((newPost) => dataAgent.addNewPost(newPost));
      }else{
       return addPostData(description,"","",profileImage)
        .then((newPost) => dataAgent.addNewPost(newPost),);
      }
  }

  Future<NewsFeedVO> addPostData(String description,String postUrl,String fileType,String profileImage)async{
    var postId = DateTime.now().millisecondsSinceEpoch;
    var data = await authModel.getLoggedInUser();
    var newPost = NewsFeedVO(
      id: postId,
    description: description,
    fileType: fileType,
    post: postUrl,
    userName: data.userName,
    profileImage: profileImage,
    );
    return Future.value(newPost);
  }
  
  @override
  Stream<List<NewsFeedVO>> getAllPost() {
    return dataAgent.getAllPosts();
  }
  
  @override
  Future<void> deletePost(int postId) {
    return dataAgent.deletePost(postId);
  }

     @override
  Stream<NewsFeedVO> getNewsFeedPostById(int postId) {
    return dataAgent.getNewsFeedPostById(postId);
  }
  
  @override
  Future<void> editPost(NewsFeedVO editPost,bool isChangeImage) {
      if(editPost.post != null && editPost.fileType != null){
          if(isChangeImage == true){
            return dataAgent
              .uploadFileToFirebaseStorage(File(editPost.post!))
              .then((downlaodUrl) => changeImageSetupPost(editPost, downlaodUrl))
              .then((editPost){
                return dataAgent.addNewPost(editPost);
              });
          }else{
            return changeImageSetupPost(editPost,editPost.post!).then((value) => dataAgent.addNewPost(editPost));
          }
      }else{
       return changeImageSetupPost(editPost,"").then((value) =>  dataAgent.addNewPost(editPost));
      }
  }

  Future<NewsFeedVO> changeImageSetupPost(NewsFeedVO editPost,String downlaodUrl){
    var editData = NewsFeedVO(
      id: editPost.id,
    userName: editPost.userName,
    profileImage: editPost.profileImage,
    fileType: editPost.fileType ?? "",
    post: downlaodUrl,
    description: editPost.description,
    );
    return Future.value(editData);
  }

    ///User

  @override
  Stream<UserVO> getUserById(String id) {
    return dataAgent.getUserById(id);
  }
  

}