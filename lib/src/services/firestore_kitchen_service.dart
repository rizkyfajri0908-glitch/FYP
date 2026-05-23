import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/assistant_knowledge.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
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

  CollectionReference<Map<String, dynamic>> get _recipesCollection {
    return _firestore.collection('recipes');
  }

  CollectionReference<Map<String, dynamic>> get _assistantKnowledgeCollection {
    return _firestore.collection('assistant_knowledge');
  }

  DocumentReference<Map<String, dynamic>> get _preferencesDocument {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc(
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

  Future<List<Recipe>> loadRecipes() async {
    final snapshot = await _recipesCollection.get();
    return snapshot.docs
        .map((document) => Recipe.fromJson(document.data()))
        .toList();
  }

  Future<void> saveRecipe(Recipe recipe) {
    return _recipesCollection.doc(recipe.id).set(recipe.toJson());
  }

  Future<List<AssistantKnowledge>> loadAssistantKnowledge() async {
    final snapshot = await _assistantKnowledgeCollection.get();
    return snapshot.docs
        .map((document) => AssistantKnowledge.fromJson(document.data()))
        .toList();
  }

  Future<void> saveAssistantKnowledge(AssistantKnowledge knowledge) {
    return _assistantKnowledgeCollection
        .doc(knowledge.id)
        .set(knowledge.toJson());
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
