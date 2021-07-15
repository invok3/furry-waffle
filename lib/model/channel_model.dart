import 'message_model.dart';

class ChannelModel {
  String channelName;
  String channelImage;
  List<MessageModel> messages;

  ChannelModel(
      {required this.channelImage,
      required this.channelName,
      required this.messages});
}
