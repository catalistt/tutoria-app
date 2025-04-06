import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutoria_app/services/auth_service.dart';

// Modelo simple para mensajes
class Message {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  
  Message({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
  });
}

// Provider para los mensajes
final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<Message>>((ref) {
  return ChatMessagesNotifier();
});

class ChatMessagesNotifier extends StateNotifier<List<Message>> {
  ChatMessagesNotifier() : super([
    Message(
      text: '¡Hola! Soy TutorIA. ¿En qué puedo ayudarte hoy?',
      isFromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ]);
  
  void addMessage(String text, bool isFromUser) {
    state = [
      ...state,
      Message(
        text: text,
        isFromUser: isFromUser,
        timestamp: DateTime.now(),
      ),
    ];
  }
  
  // Simula una respuesta de la IA
  Future<void> generateAIResponse(String userMessage) async {
    // Añadir mensaje del usuario
    addMessage(userMessage, true);
    
    // Simular un retraso para la respuesta de la IA
    await Future.delayed(const Duration(seconds: 1));
    
    // Respuestas simples basadas en palabras clave
    String response;
    
    if (userMessage.toLowerCase().contains('hola') || 
        userMessage.toLowerCase().contains('buenos días') ||
        userMessage.toLowerCase().contains('buenas')) {
      response = '¡Hola! ¿En qué puedo ayudarte con tus estudios hoy?';
    } else if (userMessage.toLowerCase().contains('matemática') || 
               userMessage.toLowerCase().contains('ecuación') || 
               userMessage.toLowerCase().contains('fórmula')) {
      response = 'Las matemáticas son fundamentales. ¿Qué tema específico te gustaría explorar? Puedo ayudarte con álgebra, geometría, cálculo y más.';
    } else if (userMessage.toLowerCase().contains('lenguaje') || 
               userMessage.toLowerCase().contains('gramática') || 
               userMessage.toLowerCase().contains('leer')) {
      response = 'La comprensión y expresión en lenguaje son habilidades esenciales. ¿Necesitas ayuda con gramática, comprensión lectora o redacción?';
    } else if (userMessage.toLowerCase().contains('ciencia') || 
               userMessage.toLowerCase().contains('física') || 
               userMessage.toLowerCase().contains('química') ||
               userMessage.toLowerCase().contains('biología')) {
      response = 'Las ciencias nos ayudan a entender el mundo. ¿Estás interesado en física, química o biología? ¿Algún tema específico?';
    } else if (userMessage.toLowerCase().contains('gracias')) {
      response = '¡De nada! Estoy aquí para ayudarte en lo que necesites.';
    } else {
      response = 'Entiendo. ¿Podrías darme más detalles para poder ayudarte mejor con ese tema?';
    }
    
    // Añadir respuesta de la IA
    addMessage(response, false);
  }
}

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      ref.read(chatMessagesProvider.notifier).generateAIResponse(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    
    // Scroll to bottom when messages change
    _scrollToBottom();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat con TutorIA'),
        backgroundColor: Colors.green.shade300,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(
                  message, 
                  user?.name ?? 'Usuario',
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {},
                  color: Colors.grey,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: '¿Qué quieres preguntar?',
                      border: InputBorder.none,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageBubble(Message message, String userName) {
    return Align(
      alignment: message.isFromUser 
          ? Alignment.centerRight 
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isFromUser 
              ? Colors.green.shade100 
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.isFromUser ? userName : 'TutorIA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: message.isFromUser 
                    ? Colors.green.shade800 
                    : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(message.text),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}