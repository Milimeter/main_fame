import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String currentUserUid;
  String imgUrl;
  String caption;
  String location;
  FieldValue time;
  String postOwnerName;
  String postOwnerPhotoUrl;
  String type;
  String fcmToken;
  String imageName;
  String postID;
  int timestamp;

  String question;
  Map options;
  String creatorID;
  Map usersWhoVoted;
  String quantity;
  String price;
  String paymentOption;

  Post({
    this.currentUserUid,
    this.imgUrl,
    this.caption,
    this.location,
    this.time,
    this.postOwnerName,
    this.postOwnerPhotoUrl,
    this.type,
    this.fcmToken,
    this.imageName,
    this.postID,
    this.timestamp,
    this.quantity,
    this.price,
    this.paymentOption,
  });
  Post.poll({
    this.currentUserUid,
    this.question,
    this.options,
    this.creatorID,
    this.usersWhoVoted,
    this.postOwnerName,
    this.postOwnerPhotoUrl,
    this.type,
    this.fcmToken,
    this.postID,
    this.timestamp,
    this.time,
  });

  Map toMap(Post post) {
    var data = Map<String, dynamic>();
    data['ownerUid'] = post.currentUserUid;
    data['imgUrl'] = post.imgUrl;
    data['caption'] = post.caption;
    data['location'] = post.location;
    data['time'] = post.time;
    data['postOwnerName'] = post.postOwnerName;
    data['postOwnerPhotoUrl'] = post.postOwnerPhotoUrl;
    data['type'] = post.type;
    data['fcmToken'] = post.fcmToken;
    data['imageName'] = post.imageName;
    data['postID'] = post.postID;
    data['timestamp'] = post.timestamp;
    data['price'] = post.price;
    data['quantity'] = post.quantity;
    data['paymentOption'] = post.paymentOption;
    return data;
  }

  Map toPollMap(Post post) {
    var data = Map<String, dynamic>();
    data['ownerUid'] = post.currentUserUid;
    data['question'] = post.question;
    data['options'] = post.options;
    data['creatorID'] = post.creatorID;
    data['usersWhoVoted'] = post.usersWhoVoted;
    data['postOwnerName'] = post.postOwnerName;
    data['type'] = post.type;
    data['fcmToken'] = post.fcmToken;
    data['postID'] = post.postID;
    data['timestamp'] = post.timestamp;
    data['time'] = post.time;
    data['quantity'] = post.quantity;
    data['price'] = post.price;
    data['paymentOption'] = post.paymentOption;
    return data;
  }

  Post.fromMap(Map<String, dynamic> mapData) {
    this.currentUserUid = mapData['ownerUid'];
    this.imgUrl = mapData['imgUrl'];
    this.caption = mapData['caption'];
    this.location = mapData['location'];
    this.time = mapData['time'];
    this.postOwnerName = mapData['postOwnerName'];
    this.postOwnerPhotoUrl = mapData['postOwnerPhotoUrl'];
    this.type = mapData['type'];
    this.fcmToken = mapData['fcmToken'];
    this.imageName = mapData['imageName'];
    this.postID = mapData['postID'];
    this.timestamp = mapData['timestamp'];
    this.quantity = mapData['quantity'];
    this.price = mapData['price'];
    this.paymentOption = mapData['paymentOption'];
  }
}
