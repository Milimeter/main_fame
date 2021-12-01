import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:login_signup_screen/controllers/feeds_controller.dart';
import 'package:login_signup_screen/model/like.dart';
import 'package:login_signup_screen/model/user_data.dart';
import 'package:login_signup_screen/screens/callscreens/pickup/pickup_layout.dart';
import 'package:login_signup_screen/screens/feeds/comments_screen.dart';
import 'package:login_signup_screen/screens/feeds/likes_screen.dart';
import 'package:login_signup_screen/screens/feeds/post_detail_screen.dart';
import 'package:login_signup_screen/utils/colors.dart';
import 'package:login_signup_screen/utils/utilities.dart';
import 'package:login_signup_screen/widgets/show_full_image.dart';

class FriendsFeedsProfile extends StatefulWidget {
  final String name;
  FriendsFeedsProfile({this.name});

  @override
  _FriendsFeedsProfileState createState() => _FriendsFeedsProfileState();
}

class _FriendsFeedsProfileState extends State<FriendsFeedsProfile> {
  String currentUserId, followingUserId;
  Color _gridColor = Colors.blue;
  Color _listColor = Colors.grey;
  bool _isGridActive = true;
  UserData _user, currentuser;
  IconData icon;
  Color color;
  Future<List<DocumentSnapshot>> _future;
  bool _isLiked = false;
  bool isFollowing = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  FeedsController _feedsController = Get.find();
  FirebaseAuth _auth = FirebaseAuth.instance;

  fetchUidBySearchedName(String name) async {
    print("NAME : $name");
    String uid = await _feedsController.fetchUidBySearchedName(name);
    setState(() {
      followingUserId = uid;
    });
    fetchUserDetailsById(uid);
    _future = _feedsController.retrieveUserPosts(uid);
  }

  fetchUserDetailsById(String userId) async {
    UserData user = await _feedsController.fetchUserDetailsById(userId);
    setState(() {
      _user = user;
      print("USER : ${_user.name}");
    });
  }

  @override
  void initState() {
    super.initState();
    _feedsController.getCurrentUser().then((user) {
      _feedsController.fetchUserDetailsById(user.uid).then((currentUser) {
        setState(() {
          currentuser = currentUser;
        });
      });
      _feedsController.checkIsFollowing(widget.name, user.uid).then((value) {
        print("VALUE : $value");
        setState(() {
          isFollowing = value;
        });
      });
      setState(() {
        currentUserId = user.uid;
      });
    });
    fetchUidBySearchedName(widget.name);
  }

  followUser() {
    print('following user');
    _feedsController.followUser(
        currentUserId: currentUserId, followingUserId: followingUserId);
    setState(() {
      isFollowing = true;
      followButtonClicked = true;
    });
  }

  unfollowUser() {
    _feedsController.unFollowUser(
        currentUserId: currentUserId, followingUserId: followingUserId);
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });
  }

  Widget buildButton(
      {String text,
      Color backgroundcolor,
      Color textColor,
      Color borderColor,
      Function function}) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 210.0,
        height: 30.0,
        decoration: BoxDecoration(
            color: backgroundcolor,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: borderColor)),
        child: Center(
          child: Text(text, style: TextStyle(color: textColor)),
        ),
      ),
    );
  }

  Widget buildProfileButton() {
    // already following user - should show unfollow button
    if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey,
        function: unfollowUser,
      );
    }

    // does not follow user - should show follow button
    if (!isFollowing) {
      return buildButton(
        text: "Follow",
        backgroundcolor: kPrimaryColor,
        textColor: Colors.white,
        borderColor: kPrimaryColor,
        function: followUser,
      );
    }

    return buildButton(
        text: "loading...",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PickupLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_left, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            backgroundColor: new Color(0xfff8faf8),
            elevation: 1,
            title: Text('Profile', style: TextStyle(color: Colors.black)),
          ),
          body: _user != null
              ? ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Container(
                              width: 110.0,
                              height: 110.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                                image: DecorationImage(
                                    image: _user.profilePhoto.isEmpty
                                        ? AssetImage('assets/no_image.png')
                                        : NetworkImage(_user.profilePhoto),
                                    fit: BoxFit.cover),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  StreamBuilder(
                                    stream: _feedsController
                                        .fetchStats(
                                            uid: followingUserId,
                                            label: 'posts')
                                        .asStream(),
                                    builder: ((context,
                                        AsyncSnapshot<List<DocumentSnapshot>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        return detailsWidget(
                                            snapshot.data.length.toString(),
                                            'posts');
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }),
                                  ),

                                  StreamBuilder(
                                    stream: _feedsController
                                        .fetchStats(
                                            uid: followingUserId,
                                            label: 'followers')
                                        .asStream(),
                                    builder: ((context,
                                        AsyncSnapshot<List<DocumentSnapshot>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 24.0),
                                          child: detailsWidget(
                                              snapshot.data.length.toString(),
                                              'followers'),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }),
                                  ),

                                  StreamBuilder(
                                    stream: _feedsController
                                        .fetchStats(
                                            uid: followingUserId,
                                            label: 'following')
                                        .asStream(),
                                    builder: ((context,
                                        AsyncSnapshot<List<DocumentSnapshot>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: detailsWidget(
                                              snapshot.data.length.toString(),
                                              'following'),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }),
                                  ),

                                  //   detailsWidget(_user.posts, 'posts'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, left: 20.0, right: 20.0),
                                child: buildProfileButton(),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, top: 30.0),
                      child: Text(_user.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, top: 10.0),
                      child:
                          _user.bio.isNotEmpty ? Text(_user.bio) : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.grid_on,
                              color: _gridColor,
                            ),
                            onTap: () {
                              setState(() {
                                _isGridActive = true;
                                _gridColor = Colors.blue;
                                _listColor = Colors.grey;
                              });
                            },
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.stay_current_portrait,
                              color: _listColor,
                            ),
                            onTap: () {
                              setState(() {
                                _isGridActive = false;
                                _listColor = Colors.blue;
                                _gridColor = Colors.grey;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: postImagesWidget(),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget postImagesWidget() {
    return _isGridActive == true
        ? FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0),
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data[index].get('imgUrl'),
                          placeholder: ((context, s) => Center(
                                child: CircularProgressIndicator(),
                              )),
                          width: 125.0,
                          height: 125.0,
                          fit: BoxFit.cover,
                        ),
                        onTap: () {
                          print(
                              "SNAPSHOT : ${snapshot.data[index].reference.path}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => PostDetailScreen(
                                        user: _user,
                                        currentuser: currentuser,
                                        documentSnapshot: snapshot.data[index],
                                      ))));
                        },
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('No Posts Found'),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
          )
        : FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                      height: 600.0,
                      child: ListView.builder(
                          //shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: ((context, index) => ListItem(
                              list: snapshot.data,
                              index: index,
                              user: _user,
                              currentuser: currentuser))));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          );
  }

  Widget detailsWidget(String count, String label) {
    return Column(
      children: <Widget>[
        Text(count,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black)),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child:
              Text(label, style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        )
      ],
    );
  }
}

class ListItem extends StatefulWidget {
  List<DocumentSnapshot> list;
  UserData user, currentuser;
  int index;

  ListItem({this.list, this.user, this.index, this.currentuser});

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  FeedsController _feedsController = Get.find();
  bool _isLiked = false;
  Future<List<DocumentSnapshot>> _future;

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _feedsController.fetchPostCommentDetails(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'View all ${snapshot.data.length} comments',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: widget.currentuser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    print("INDEX : ${widget.index}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 15.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image(
                            width: 50.0,
                            height: 50.0,
                            image: NetworkImage(widget.user.profilePhoto),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )),
                title: InkWell(
                    onTap: () {},
                    child: Text(
                      widget.user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                subtitle: Row(
                  children: [
                    widget.list[widget.index].get('location') != null
                        ? new Text(
                            widget.list[widget.index].get('location'),
                            style: TextStyle(color: Colors.grey),
                          )
                        : Container(),
                    SizedBox(width: 10),
                    Text(
                        Utils.readTimestamp(
                            widget.list[widget.index].get('timestamp')),
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_horiz),
                  color: Colors.black,
                  onPressed: () => print('More'),
                ),
              ),
              InkWell(
                onDoubleTap: () {
                  if (!_isLiked) {
                    setState(() {
                      _isLiked = true;
                    });

                    postLike(widget.list[widget.index].reference);
                  } else {
                    setState(() {
                      _isLiked = false;
                    });

                    postUnlike(widget.list[widget.index].reference);
                  }
                },
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ShowFullImage(
                  //       photoUrl: widget.list[widget.index].data()['imgUrl'],
                  //     ),
                  //   ),
                  // );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => ViewPostScreen(post: posts[index]),
                  //   ),
                  // );
                },
                child: FocusedMenuHolder(
                  menuWidth: MediaQuery.of(context).size.width * 0.50,
                  blurSize: 5.0,
                  menuItemExtent: 45,
                  menuBoxDecoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  duration: Duration(milliseconds: 100),
                  animateMenuItems: true,
                  blurBackgroundColor: Colors.black54,
                  bottomOffsetHeight: 100,
                  openWithTap: true,
                  menuItems: <FocusedMenuItem>[
                    FocusedMenuItem(
                        title: Text("View media"),
                        trailingIcon: Icon(Entypo.documents),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowFullImage(
                                photoUrl:
                                    widget.list[widget.index].get('imgUrl'),
                              ),
                            ),
                          );
                        }),
                    FocusedMenuItem(
                        title: Text("Share Feed"),
                        trailingIcon: Icon(Entypo.paper_plane),
                        onPressed: () {}),
                    FocusedMenuItem(
                        title: Text("Download Feed"),
                        trailingIcon: Icon(Entypo.download),
                        onPressed: () {}),
                    FocusedMenuItem(
                        title: Text("Unfollow User",
                            style: TextStyle(color: Colors.redAccent)),
                        trailingIcon:
                            Icon(Entypo.log_out, color: Colors.redAccent),
                        onPressed: () async {}),
                  ],
                  onPressed: () {},
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    width: double.infinity,
                    height: 400.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          offset: Offset(0.0, 8.0),
                          blurRadius: 8.0,
                        ),
                      ],
                      // image: DecorationImage(
                      //   image: NetworkImage(list[index].data()['imgUrl']),
                      //   fit: BoxFit.fitWidth,
                      // ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(27),
                      child: CachedNetworkImage(
                        imageUrl: widget.list[widget.index].get('imgUrl'),
                        placeholder: ((context, s) => Center(
                              child: CircularProgressIndicator(),
                            )),
                        //width: 125.0,
                        // height: 250.0,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: _isLiked
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(
                                  FontAwesomeIcons.heart,
                                  color: null,
                                ),
                          iconSize: 30.0,
                          onPressed: () {
                            if (!_isLiked) {
                              setState(() {
                                _isLiked = true;
                              });

                              postLike(widget.list[widget.index].reference);
                            } else {
                              setState(() {
                                _isLiked = false;
                              });

                              postUnlike(widget.list[widget.index].reference);
                            }
                          },
                        ),
                        // Text(
                        //   '2,515', // get likes length
                        //   style: TextStyle(
                        //     fontSize: 14.0,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        SizedBox(width: 20.0),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(FontAwesomeIcons.comment),
                              color: Colors.black,
                              iconSize: 30.0,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => CommentsScreen(
                                              documentReference: widget
                                                  .list[widget.index].reference,
                                              user: widget.currentuser,
                                            ))));
                              },
                            ),
                            // Text(
                            //   '2,515', // get comment length
                            //   style: TextStyle(
                            //     fontSize: 14.0,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.bookmark_border),
                      iconSize: 30.0,
                      onPressed: () => print('Save post'),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: _feedsController
                    .fetchPostLikeDetails(widget.list[widget.index].reference),
                builder: ((context,
                    AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                  if (likesSnapshot.hasData) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => LikesScreen(
                                      user: widget.user,
                                      documentReference:
                                          widget.list[widget.index].reference,
                                    ))));
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: likesSnapshot.data.length > 1
                              ? Text(
                                  "Liked by ${likesSnapshot.data[0].get('ownerName')} and ${(likesSnapshot.data.length - 1).toString()} others",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Text(likesSnapshot.data.length == 1
                                  ? "Liked by ${likesSnapshot.data[0].get('ownerName')}"
                                  : "0 Likes"),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: widget.list[widget.index].get('caption') != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Wrap(
                                children: <Widget>[
                                  Text(widget.user.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(widget.list[widget.index]
                                        .get('caption')),
                                  )
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: commentWidget(
                                      widget.list[widget.index].reference))
                            ],
                          )
                        : commentWidget(widget.list[widget.index].reference)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: widget.currentuser.name,
        ownerPhotoUrl: widget.currentuser.profilePhoto,
        ownerUid: widget.currentuser.uid,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .doc(widget.currentuser.uid)
        .set(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .doc(widget.currentuser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}
