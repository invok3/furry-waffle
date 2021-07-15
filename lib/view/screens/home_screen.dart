import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_app/controller/firebase_auth.dart';
import 'package:task_app/view/components/channel_row.dart';
import 'package:task_app/view/screens/channel_screen.dart';
import 'package:task_app/view/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> fetchedUsers =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task App"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined)),
          PopupMenuButton(
              onSelected: (item) => mPager(context, item),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(value: 0, child: Text("Profile")),
                    PopupMenuItem<int>(value: 1, child: Text("Channels")),
                    PopupMenuItem<int>(value: 2, child: Text("Logout")),
                  ]),
        ],
      ),
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.15,
              // child: ListView(
              //   scrollDirection: Axis.horizontal,
              //   children: [
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 5),
              //       child: CircleAvatar(
              //         child: Text("+"),
              //       ),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 5),
              //       child: CircleAvatar(
              //         child: Text("U"),
              //       ),
              //     ),
              //   ],
              // ),
              child: StreamBuilder(
                  stream: fetchedUsers,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return new ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs.map((e) {
                        Map<String, dynamic> data =
                            e.data() as Map<String, dynamic>;
                        return new Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(data['imageurl']),
                                ),
                              ),
                              Text(data['name'])
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  })),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: getChannels(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getChannels() {
    List<Widget> xx = [];
    for (var i = 0; i < 10; i++) {
      xx.add(InkWell(
        child: ChannelRow(),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChannelScreen()));
        },
        onLongPress: () {},
      ));
    }
    return xx;
  }

  mPager(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
      case 1:
        break;
      default:
        FBAuthService(FirebaseAuth.instance).signOut();
    }
  }
}
