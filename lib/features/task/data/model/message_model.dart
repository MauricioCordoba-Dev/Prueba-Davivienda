import '../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.text,
    super.imageUrl,
    required super.fromWho,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String?,
      fromWho: json['fromWho'] == 'me' ? FromWho.me : FromWho.hers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'fromWho': fromWho == FromWho.me ? 'me' : 'hers',
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      text: message.text,
      imageUrl: message.imageUrl,
      fromWho: message.fromWho,
    );
  }
} 