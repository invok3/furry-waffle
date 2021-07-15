import 'package:flutter/material.dart';
import 'package:task_app/view/screens/user_screen.dart';

class ChannelScreen extends StatefulWidget {
  ChannelScreen({Key? key}) : super(key: key);

  @override
  _ChannelScreenState createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: InkWell(
            child: Row(
              children: [
                CircleAvatar(),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Channel Name"),
                    Text(
                      "Online",
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ],
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserScreen()));
            },
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined))
          ],
        ),
        body: Stack(
          children: [
            ListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.emoji_emotions_outlined)),
                  Expanded(
                    child: TextField(),
                  ),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.camera_alt_outlined)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.send_outlined))
                ],
              ),
            )
          ],
        ));
  }
}
