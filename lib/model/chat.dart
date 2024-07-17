import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  String chatRoomId;
  ChatMember writer;
  ChatMember contact;
  List<Message> messages;

  ChatRoom({
    required this.chatRoomId,
    required this.writer,
    required this.contact,
    required this.messages,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
        chatRoomId: json['chatRoomId'],
        writer: json['writer'].map((writer) => ChatMember.fromJson(writer)),
        contact: json['contact'].map((contact) => ChatMember.fromJson(contact)),
        messages: json['messages']
            .map((message) => Message.fromJson(message))
            .toList());
  }

  factory ChatRoom.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final List<Message> messages = [];
    final messageSnapshot = List<Map>.from(snapshot['messages'] as List);
    for (var e in messageSnapshot) {
      messages.add(Message.fromJson(e as Map<String, dynamic>));
    }
    return ChatRoom(
      chatRoomId: snapshot['chatRoomId'],
      writer: ChatMember.fromJson(snapshot['writer'] as Map<String, dynamic>),
      contact: ChatMember.fromJson(snapshot['contact'] as Map<String, dynamic>),
      messages: messages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'writer': writer.toJson(),
      'contact': contact.toJson(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  factory ChatRoom.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final List<Message> message = [];
    final messageSnapshot = List<Map>.from(snapshot['messages'] as List);
    for (var e in messageSnapshot) {
      message.add(Message.fromJson(e as Map<String, dynamic>));
    }
    return ChatRoom(
        chatRoomId: snapshot['chatRoomId'],
        writer: ChatMember.fromJson(snapshot['writer'] as Map<String, dynamic>),
        contact: ChatMember.fromJson(snapshot['contact'] as Map<String, dynamic>),
        messages: message);
  }
}

class ChatMember {
  String name;
  String id;
  String? photoUrl;

  ChatMember({
    required this.name,
    required this.id,
    this.photoUrl,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      name: json['name'],
      id: json['id'],
      photoUrl: json['photoUrl'],
    );
  }

  toJson() {
    return {
      'name': name,
      'id': id,
      'photoUrl': photoUrl,
    };
  }
}

class Message {
  String content;
  String sender;
  String createAt;

  Message({
    required this.content,
    required this.sender,
    required this.createAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      sender: json['sender'],
      createAt: json['createAt'],
    );
  }

  toJson() {
    return {
      'content': content,
      'sender': sender,
      'createAt': createAt,
    };
  }
}
