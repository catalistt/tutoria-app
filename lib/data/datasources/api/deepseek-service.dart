import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final deepseekServiceProvider = Provider<DeepseekService>((ref) {
  return DeepseekService();
});

class DeepseekService {
  final String apiUrl = "https://api.deepseek.com/v1/chat/completions";
  final String? apiKey = dotenv.env['DEEPSEEK_API_KEY'];
  final Logger _logger = Logger();
  
  Future<Map<String, dynamic>> sendMessage({
    required List<Map<String, String>> messages,
    double temperature = 0.7,
    int maxTokens = 1000,
  }) async {
    if (apiKey == null) {
      throw Exception('API key no encontrada. Asegúrate de configurar el archivo .env');
    }
    
    try {
      final data = {
        "model": "deepseek-chat",
        "messages": messages,
        "temperature": temperature,
        "max_tokens": maxTokens,
      };
      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(data),
      );
      
      if (response.statusCode != 200) {
        _logger.e('Error en la API de DeepSeek: ${response.body}');
        throw Exception('Error en la API de DeepSeek: ${response.statusCode}');
      }
      
      return jsonDecode(response.body);
    } catch (e) {
      _logger.e('Error al enviar mensaje a DeepSeek: $e');
      throw Exception('Error al enviar mensaje a DeepSeek: $e');
    }
  }
  
  Future<String> generateWelcomeMessage({
    required String studentName,
    String? grade,
    String? educationalGoal,
  }) async {
    try {
      final systemContent = "Eres un guía educativo amigable y conversacional llamado 'TutorIA'. "
          "Siempre te presentas como 'TutorIA' y nunca usas placeholders como '[tu nombre]'. "
          "Genera un saludo personalizado para un estudiante según su perfil.";
      
      final userPrompt = """
      Genera un saludo personalizado para un estudiante con el siguiente perfil:
      
      Nombre: $studentName
      ${grade != null ? 'Curso: $grade' : ''}
      ${educationalGoal != null ? 'Objetivo: $educationalGoal' : ''}
      
      IMPORTANTE: Preséntate como 'TutorIA' y NO uses placeholders como '[tu nombre]'.
      
      El saludo debe:
      1. Ser cálido, amigable y conversacional
      2. Presentarte como 'TutorIA', un guía de aprendizaje de IA
      3. Explicar brevemente cómo puedes ayudarle con su aprendizaje
      4. Mencionar que puedes adaptar el contenido a sus necesidades
      5. Ser motivador y positivo
      6. Tener máximo 3 párrafos cortos
      """;
      
      final messages = [
        {"role": "system", "content": systemContent},
        {"role": "user", "content": userPrompt}
      ];
      
      final response = await sendMessage(messages: messages);
      String greeting = response["choices"][0]["message"]["content"];
      
      // Post-procesamiento para reemplazar cualquier [tu nombre] que aún pueda aparecer
      greeting = greeting
          .replaceAll("[tu nombre]", "TutorIA")
          .replaceAll("[Tu nombre]", "TutorIA")
          .replaceAll("[TU NOMBRE]", "TutorIA");
      
      return greeting;
    } catch (e) {
      _logger.e('Error al generar saludo: $e');
      return "¡Hola $studentName! Soy TutorIA, tu guía de aprendizaje personalizado. Estoy aquí para ayudarte a alcanzar tus metas educativas de una manera efectiva y adaptada a tus necesidades. ¿En qué puedo ayudarte hoy?";
    }
  }
  
  Future<String> generateExplanation({
    required String questionText,
    String? subjectName,
    List<String>? thematicAxis,
  }) async {
    try {
      final systemContent = "Eres un tutor educativo experto que explica conceptos de manera clara y adaptada al nivel del estudiante. "
          "Proporciona explicaciones paso a paso, utilizando ejemplos prácticos y analogías cuando sea apropiado.";
      
      final userPrompt = """
      Explica el siguiente problema o concepto de manera clara y didáctica:
      
      Problema: $questionText
      
      ${subjectName != null ? 'Materia: $subjectName' : ''}
      ${thematicAxis != null && thematicAxis.isNotEmpty ? 'Ejes temáticos: ${thematicAxis.join(', ')}' : ''}
      
      Tu explicación debe:
      1. Comenzar con una introducción al concepto
      2. Explicar paso a paso cómo resolver el problema
      3. Incluir ejemplos o analogías si es necesario
      4. Ser clara y adecuada para un estudiante de secundaria
      5. Tener un tono motivador y positivo
      """;
      
      final messages = [
        {"role": "system", "content": systemContent},
        {"role": "user", "content": userPrompt}
      ];
      
      final response = await sendMessage(messages: messages);
      return response["choices"][0]["message"]["content"];
    } catch (e) {
      _logger.e('Error al generar explicación: $e');
      return "Lo siento, no puedo generar una explicación en este momento. Por favor, intenta de nuevo más tarde.";
    }
  }
  
  Future<List<Map<String, dynamic>>> generateLearningPath({
    required String subjectName,
    required String studentGrade,
    required String educationalGoal,
    List<String>? strengths,
    List<String>? weaknesses,
  }) async {
    try {
      final systemContent = "Eres un asesor pedagógico experto. Responde ÚNICAMENTE con un JSON válido, "
          "SIN TEXTO EXTRA, SIN COMENTARIOS.";
      
      final userPrompt = """
      # TAREA
      Genera una ruta de aprendizaje personalizada para un estudiante basada en su perfil.
      
      # PERFIL DEL ESTUDIANTE
      - Curso: $studentGrade
      - Objetivo: $educationalGoal
      - Materia: $subjectName
      ${strengths != null && strengths.isNotEmpty ? '- Fortalezas: ${strengths.join(', ')}' : ''}
      ${weaknesses != null && weaknesses.isNotEmpty ? '- Áreas a mejorar: ${weaknesses.join(', ')}' : ''}
      
      # FORMATO DE RESPUESTA
      Responde ÚNICAMENTE con un JSON con la siguiente estructura:
      [
        {
          "order": 1,
          "title": "Título del paso 1",
          "description": "Descripción del paso 1",
          "type": "video|reading|quiz|exercise",
          "estimatedTime": "30 minutos",
          "difficulty": "beginner|intermediate|advanced"
        },
        {
          "order": 2,
          "title": "Título del paso 2",
          "description": "Descripción del paso 2",
          "type": "video|reading|quiz|exercise",
          "estimatedTime": "45 minutos",
          "difficulty": "beginner|intermediate|advanced"
        }
      ]
      
      Proporciona exactamente 5 pasos para la ruta de aprendizaje.
      """;
      
      final messages = [
        {"role": "system", "content": systemContent},
        {"role": "user", "content": userPrompt}
      ];
      
      final response = await sendMessage(
        messages: messages,
        temperature: 0.3,
      );
      
      String rawJson = response["choices"][0]["message"]["content"];
      
      // Limpiar el JSON en caso de que venga con marcadores de código
      rawJson = rawJson
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();
      
      List<dynamic> parsedJson = jsonDecode(rawJson);
      return parsedJson.cast<Map<String, dynamic>>();
    } catch (e) {
      _logger.e('Error al generar ruta de aprendizaje: $e');
      
      // Retornar una ruta predeterminada en caso de error
      return [
        {
          "order": 1,
          "title": "Fundamentos básicos",
          "description": "Repaso de conceptos fundamentales de $subjectName",
          "type": "reading",
          "estimatedTime": "30 minutos",
          "difficulty": "beginner"
        },
        {
          "order": 2,
          "title": "Conceptos intermedios",
          "description": "Profundización en los temas principales",
          "type": "video",
          "estimatedTime": "45 minutos",
          "difficulty": "intermediate"
        },
        {
          "order": 3,
          "title": "Práctica guiada",
          "description": "Ejercicios con soluciones paso a paso",
          "type": "exercise",
          "estimatedTime": "60 minutos",
          "difficulty": "intermediate"
        },
        {
          "order": 4,
          "title": "Evaluación de conocimientos",
          "description": "Quiz para evaluar lo aprendido",
          "type": "quiz",
          "estimatedTime": "20 minutos",
          "difficulty": "intermediate"
        },
        {
          "order": 5,
          "title": "Práctica avanzada",
          "description": "Ejercicios desafiantes para consolidar conocimientos",
          "type": "exercise",
          "estimatedTime": "90 minutos",
          "difficulty": "advanced"
        }
      ];
    }
  }
  
  Future<Map<String, dynamic>> analyzeLearningProgress({
    required int questionsAnswered,
    required int correctAnswers,
    required int totalStudyTime,
    required String subjectName,
  }) async {
    try {
      final systemContent = "Eres un asesor pedagógico experto. Responde ÚNICAMENTE con un JSON válido, "
          "SIN TEXTO EXTRA, SIN COMENTARIOS.";
      
      final userPrompt = """
      # TAREA
      Analiza el progreso de aprendizaje de un estudiante en base a sus métricas.
      
      # MÉTRICAS
      - Preguntas respondidas: $questionsAnswered
      - Respuestas correctas: $correctAnswers
      - Tiempo total de estudio (minutos): $totalStudyTime
      - Materia: $subjectName
      
      # FORMATO DE RESPUESTA
      Responde ÚNICAMENTE con un JSON con la siguiente estructura:
      {
        "currentLevel": "beginner|intermediate|advanced",
        "accuracy": 85.5,
        "recommendations": [
          "Primera recomendación específica basada en las métricas",
          "Segunda recomendación específica"
        ],
        "nextSteps": [
          "Primer paso sugerido",
          "Segundo paso sugerido"
        ],
        "estimatedProgress": 42
      }
      
      La 'accuracy' debe calcularse como porcentaje de respuestas correctas.
      El 'estimatedProgress' debe ser un número entre 0 y 100 que represente el progreso estimado en la materia.
      """;
      
      final messages = [
        {"role": "system", "content": systemContent},
        {"role": "user", "content": userPrompt}
      ];
      
      final response = await sendMessage(
        messages: messages,
        temperature: 0.2,
      );
      
      String rawJson = response["choices"][0]["message"]["content"];
      
      // Limpiar el JSON
      rawJson = rawJson
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();
      
      return jsonDecode(rawJson);
    } catch (e) {
      _logger.e('Error al analizar progreso: $e');
      
      // Calcular valores predeterminados
      double accuracy = questionsAnswered > 0 
          ? (correctAnswers / questionsAnswered) * 100 
          : 0;
      
      int estimatedProgress = questionsAnswered > 50 ? 50 : questionsAnswered;
      
      // Retornar análisis predeterminado en caso de error
      return {
        "currentLevel": "beginner",
        "accuracy": accuracy.roundToDouble(),
        "recommendations": [
          "Dedica tiempo regular al estudio de $subjectName para mejorar tu comprensión",
          "Practica con más ejercicios para consolidar lo aprendido"
        ],
        "nextSteps": [
          "Revisa los conceptos fundamentales",
          "Realiza ejercicios prácticos"
        ],
        "estimatedProgress": estimatedProgress
      };
    }
  }
  
  Future<String> generateChatResponse({
    required List<Map<String, String>> chatHistory,
    required String question,
    String? questionContext,
    String? subjectName,
  }) async {
    try {
      final systemContent = """
      Eres TutorIA, un asistente educativo amigable y conversacional. 
      Tu objetivo es ayudar a los estudiantes a entender conceptos y resolver problemas.
      Proporciona explicaciones claras y paso a paso, adaptadas al nivel del estudiante.
      Usa un tono amigable y motivador, pero siempre mantén el rigor académico.
      Si no conoces la respuesta a algo, admítelo honestamente.
      """;
      
      // Crear el historial de chat en formato para la API
      final messages = [
        {"role": "system", "content": systemContent},
      ];
      
      // Añadir contexto si existe
      if (questionContext != null && questionContext.isNotEmpty) {
        messages.add({
          "role": "system", 
          "content": "Contexto del problema: $questionContext"
        });
        
        if (subjectName != null && subjectName.isNotEmpty) {
          messages.add({
            "role": "system", 
            "content": "Materia: $subjectName"
          });
        }
      }
      
      // Añadir historial de chat
      messages.addAll(chatHistory);
      
      // Añadir la pregunta actual
      messages.add({"role": "user", "content": question});
      
      final response = await sendMessage(
        messages: messages,
        temperature: 0.7,
        maxTokens: 1500,
      );
      
      return response["choices"][0]["message"]["content"];
    } catch (e) {
      _logger.e('Error al generar respuesta de chat: $e');
      return "Lo siento, estoy teniendo problemas para procesar tu pregunta en este momento. ¿Podrías intentarlo de nuevo o reformular tu pregunta?";
    }
  }
}