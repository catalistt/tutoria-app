rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Autenticación requerida para todas las operaciones
    match /{document=**} {
      allow read, write: if false;
    }
    
    // Reglas para usuarios
    match /users/{userId} {
      allow read: if request.auth != null && (request.auth.uid == userId || isAdmin());
      allow create: if request.auth != null && request.auth.uid == userId && validUser();
      allow update: if request.auth != null && request.auth.uid == userId && validUser();
      allow delete: if request.auth != null && (request.auth.uid == userId || isAdmin());
    }
    
    // Reglas para materias
    match /subjects/{subjectId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && isAdmin();
    }
    
    // Reglas para bancos de preguntas
    match /questionBanks/{bankId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && isAdmin();
    }
    
    // Reglas para preguntas
    match /questions/{questionId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && isAdmin();
    }
    
    // Reglas para progreso de aprendizaje
    match /learningProgress/{progressId} {
      allow read: if request.auth != null && request.auth.uid == resource.data.userId;
      allow create, update: if request.auth != null && request.auth.uid == request.resource.data.userId;
      allow delete: if false;
    }
    
    // Función para verificar administradores
    function isAdmin() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Función para validar datos de usuario
    function validUser() {
      let user = request.resource.data;
      return user.name is string && 
            user.email is string && 
            user.grade is string && 
            user.educationalGoal is string;
    }
  }
}