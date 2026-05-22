import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ingredient.dart';
import '../models/user_preferences.dart';

class FirestoreKitchenService {
  FirestoreKitchenService({
    required this.userId,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String userId;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _ingredientsCollection {
    return _firestore.collection('users').doc(userId).collection('ingredients');
  }

  DocumentReference<Map<String, dynamic>> get _preferencesDocument {
    return _firestore.collection('users').doc(userId).collection('settings').doc(
          'preferences',
        );
  }

  Future<List<Ingredient>> loadIngredients() async {
    final snapshot = await _ingredientsCollection.get();
    return snapshot.docs
        .map((document) => Ingredient.fromJson(document.data()))
        .toList();
  }

  Future<void> saveIngredient(Ingredient ingredient) {
    return _ingredientsCollection.doc(ingredient.id).set(ingredient.toJson());
  }

  Future<void> deleteIngredient(String id) {
    return _ingredientsCollection.doc(id).delete();
  }

  Future<UserPreferences?> loadPreferences() async {
    final snapshot = await _preferencesDocument.get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return UserPreferences.fromJson(data);
  }

  Future<void> savePreferences(UserPreferences preferences) {
    return _preferencesDocument.set(preferences.toJson());
  }
}
