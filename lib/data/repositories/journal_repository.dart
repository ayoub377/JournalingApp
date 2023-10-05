import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/journal_entry.dart';


class JournalRepository{

  Future<void> addEntry(JournalEntry entry) async {
    final user = FirebaseAuth.instance.currentUser;
    final entryCollection = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('entries');
    await entryCollection.add({
      'title':entry.title,
      'content': entry.content,
      'emotion': entry.emotion,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'imageUrl' : entry.imageUrl
    });
  }

  Future<JournalEntry> getEntry(JournalEntry entry){
    final user = FirebaseAuth.instance.currentUser;
    final entryCollection = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('entries');
    // serialize the data and return it
    return entryCollection.get().then((snapshot) {
      return snapshot.docs.map((doc) {
        return JournalEntry.fromJson(doc.data());
      }).toList();
    }).then((value) => value.first);
  }

  Future<List<JournalEntry>> getEntries(){
    final user = FirebaseAuth.instance.currentUser;
    final entryCollection = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('entries');
    // serialize the data and return it
    return entryCollection.get().then((snapshot) {
      return snapshot.docs.map((doc) {
        return JournalEntry.fromJson(doc.data());
      }).toList();
    }).onError((error, stackTrace) => throw Exception("Failed to load entries. Please try again."));
  }

  Future<void> removeEntry(JournalEntry entry) async {
    final user = FirebaseAuth.instance.currentUser;
    final entryCollection = FirebaseFirestore.instance.collection('users').doc(
        user!.uid).collection('entries');
    final entryDoc = await entryCollection.where(
        'created_at', isEqualTo: entry.createdAt?.millisecondsSinceEpoch).get();
    await entryDoc.docs.first.reference.delete();
  }

}