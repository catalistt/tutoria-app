import 'package:flutter/material.dart';

class SubjectScreen extends StatelessWidget {
  final String subjectId;
  
  const SubjectScreen({Key? key, required this.subjectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materia'),
      ),
      body: Center(
        child: Text('Detalle de la materia: $subjectId'),
      ),
    );
  }
}