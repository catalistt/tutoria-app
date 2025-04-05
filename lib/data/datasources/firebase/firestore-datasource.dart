import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para el servicio de Firestore
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Obtener un documento
  Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(documentId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener documento: $e');
    }
  }
  
  // Crear o actualizar un documento
  Future<void> setDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).set(
        data,
        SetOptions(merge: merge),
      );
    } catch (e) {
      throw Exception('Error al guardar documento: $e');
    }
  }
  
  // Actualizar campos específicos
  Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).update(data);
    } catch (e) {
      throw Exception('Error al actualizar documento: $e');
    }
  }
  
  // Eliminar un documento
  Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Error al eliminar documento: $e');
    }
  }
  
  // Obtener una colección
  Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
    String? field,
    dynamic isEqualTo,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);
      
      if (field != null && isEqualTo != null) {
        query = query.where(field, isEqualTo: isEqualTo);
      }
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();
    } catch (e) {
      throw Exception('Error al obtener colección: $e');
    }
  }
  
  // Obtener una colección como stream
  Stream<List<Map<String, dynamic>>> streamCollection({
    required String collection,
    String? field,
    dynamic isEqualTo,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    try {
      Query query = _firestore.collection(collection);
      
      if (field != null && isEqualTo != null) {
        query = query.where(field, isEqualTo: isEqualTo);
      }
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      return query.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
            .toList(),
      );
    } catch (e) {
      throw Exception('Error al obtener stream de colección: $e');
    }
  }
  
  // Añadir un documento con ID generado automáticamente
  Future<String> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = await _firestore.collection(collection).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Error al añadir documento: $e');
    }
  }
  
  // Ejecutar transacción
  Future<T> runTransaction<T>({
    required Future<T> Function(Transaction transaction) transaction,
  }) async {
    try {
      return await _firestore.runTransaction(transaction);
    } catch (e) {
      throw Exception('Error en transacción: $e');
    }
  }
  
  // Crear lote de operaciones
  WriteBatch batch() {
    return _firestore.batch();
  }
}