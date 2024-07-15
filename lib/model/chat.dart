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

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'writer': writer.toJson(),
      'contact': contact.toJson(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}

class ChatMember {
  String name;
  String id;
  String role;

  ChatMember({
    required this.name,
    required this.id,
    required this.role,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      name: json['name'],
      id: json['id'],
      role: json['role'],
    );
  }

   toJson() {
    return {
      'name': name,
      'id': id,
      'role': role,
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
