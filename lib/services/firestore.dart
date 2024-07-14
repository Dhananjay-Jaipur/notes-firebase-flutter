import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {

  // creating variable to access firebase database
  final CollectionReference notes = FirebaseFirestore.instance.collection("notes");

  // add new note in firebase - function
  Future<void> addNote(String note)
  {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  // getting data from the database(firebase)
  // querysnapshot - class Contains the results of a query. It contain DocumentSnapshot objects
  // query - request for information or data
  Stream<QuerySnapshot> getNote(){
    final notesString = notes.orderBy('timestamp', descending: true).snapshots();

    return notesString;
  }

  // future - refers to an object that represents a value that is not yet available but will be at some point in the future. A Future can be used to represent an asynchronous operation that is being performed, such as fetching data from a web API, reading from a file
  // updating note::
  Future<void> update(String docId, String newNote){
    return notes.doc(docId).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // delete note
  Future<void> delete(String docId){
    return notes.doc(docId).delete();
  }
}