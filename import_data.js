const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Inicializar Firebase Admin
const serviceAccount = require('./service-account-key.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Dirección del directorio que contiene los archivos de datos
const dataDir = './firestore_data';

// Función para convertir cadenas ISO a Timestamps de Firestore
function convertTimestamps(obj) {
  if (obj === null || obj === undefined || typeof obj !== 'object') {
    return obj;
  }
  
  // Si es un array, procesamos cada elemento
  if (Array.isArray(obj)) {
    return obj.map(item => convertTimestamps(item));
  }
  
  // Procesar objeto
  const result = {};
  
  for (const key in obj) {
    const value = obj[key];
    
    if (typeof value === 'string' && /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$/.test(value)) {
      // Es una fecha en formato ISO, convertirla a Timestamp
      result[key] = admin.firestore.Timestamp.fromDate(new Date(value));
    } else if (typeof value === 'object') {
      // Es un objeto, procesarlo recursivamente
      result[key] = convertTimestamps(value);
    } else {
      // Valor normal, copiarlo tal cual
      result[key] = value;
    }
  }
  
  return result;
}

// Función para importar un archivo JSON a Firestore
async function importCollection(fileName) {
  console.log(`Importando colección desde ${fileName}...`);
  
  try {
    // Leer el archivo JSON
    const filePath = path.join(dataDir, fileName);
    const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    
    // Obtener datos de la colección
    const collectionName = Object.keys(data.__collection__)[0];
    const documents = data.__collection__[collectionName].__doc__;
    
    // Batch para realizar operaciones en grupo
    const batch = db.batch();
    let batchCount = 0;
    const batchLimit = 500; // Límite de operaciones por batch
    
    // Procesar cada documento
    for (const docId in documents) {
      if (batchCount >= batchLimit) {
        // Ejecutar el batch actual y crear uno nuevo
        await batch.commit();
        console.log(`Commit de batch con ${batchCount} documentos`);
        batchCount = 0;
      }
      
      const docData = convertTimestamps(documents[docId]);
      const docRef = db.collection(collectionName).doc(docId);
      batch.set(docRef, docData);
      batchCount++;
    }
    
    // Ejecutar el último batch
    if (batchCount > 0) {
      await batch.commit();
      console.log(`Commit final de batch con ${batchCount} documentos`);
    }
    
    console.log(`Importación de ${collectionName} completada con éxito.`);
  } catch (error) {
    console.error(`Error al importar ${fileName}:`, error);
  }
}

// Función principal para importar todas las colecciones
async function importAllCollections() {
  try {
    // Leer todos los archivos en el directorio
    const files = fs.readdirSync(dataDir);
    
    // Filtrar solo archivos JSON
    const jsonFiles = files.filter(file => file.endsWith('.json'));
    
    // Importar cada archivo en secuencia
    for (const file of jsonFiles) {
      await importCollection(file);
    }
    
    console.log('Importación de todas las colecciones completada.');
  } catch (error) {
    console.error('Error durante la importación:', error);
  }
}

// Ejecutar la importación
importAllCollections()
  .then(() => {
    console.log('Proceso de importación finalizado.');
    process.exit(0);
  })
  .catch(error => {
    console.error('Error fatal durante la importación:', error);
    process.exit(1);
  });