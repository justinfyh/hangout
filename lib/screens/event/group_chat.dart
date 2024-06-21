import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class ChatMessage {
  final String text;
  final String userId;

  ChatMessage({required this.text, required this.userId});
}

class GroupChatPage extends StatefulWidget {
  final String eventId;

  GroupChatPage({required this.eventId});

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    DatabaseService db = DatabaseService(uid: user!.uid);

    void sendMessage(String text) async {
      if (text.trim().isEmpty) return;
      await db.sendMessage(widget.eventId, text);
      _controller.clear();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Group Chat for Event: ${widget.eventId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db.getMessages(widget.eventId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<ChatBubble> messages = snapshot.data!.docs.map((doc) {
                    return ChatBubble(
                      text: doc['text'],
                      userId: doc['userId'],
                      isUser: doc['userId'] == user.uid,
                    );
                  }).toList();

                  return ListView(
                    reverse: true,
                    children: messages,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onSubmitted: sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final String userId;
  final bool isUser;

  ChatBubble({required this.text, required this.userId, required this.isUser});

  Future<UserModel?> _getUser(String userId) async {
    DatabaseService db = DatabaseService(uid: userId);
    return await db.getUserById(userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _getUser(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(); // Or some placeholder
        }

        UserModel? user = snapshot.data;
        String userName = user?.name ?? 'Unknown';
        String profileImageUrl = user?.profileImageUrl ?? '';

        return Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 5),
                child: Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isUser && profileImageUrl.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, right: 8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(profileImageUrl),
                      radius: 15,
                    ),
                  ),
                ],
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.orange : Colors.grey.shade200,
                    borderRadius: isUser
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
