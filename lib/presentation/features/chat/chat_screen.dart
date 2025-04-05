import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String? questionId;
  
  const ChatScreen({Key? key, this.questionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat con TutorIA'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(questionId != null 
                ? 'Chat con pregunta: $questionId' 
                : 'Inicia una conversación con TutorIA'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '¿Qué quieres preguntar?',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}