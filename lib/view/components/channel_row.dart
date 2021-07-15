import 'package:flutter/material.dart';

class ChannelRow extends StatefulWidget {
  const ChannelRow({
    Key? key,
  }) : super(key: key);

  @override
  _ChannelRowState createState() => _ChannelRowState();
}

class _ChannelRowState extends State<ChannelRow> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 25),
              Container(
                child: isSelected == true
                    ? Checkbox(
                        value: isSelected,
                        onChanged: (isSelected) {
                          toggleSelected();
                        },
                      )
                    : null,
              ),
            ],
            alignment: AlignmentDirectional.bottomEnd,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Channel Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.double_arrow_outlined,
                      color: Colors.blue,
                    ),
                    Icon(
                      Icons.mic_outlined,
                      color: Colors.blue,
                    ),
                    Text(
                      "0:31",
                      style: TextStyle(color: Colors.black87),
                    )
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text("Yesterday"),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber[800]),
                child: Text(
                  "2",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void toggleSelected() {
    isSelected = !isSelected;
    setState(() {});
  }
}
