import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  static User? get currentUser => _client.auth.currentUser;
  static String? get currentUserId => currentUser?.id;
  static bool get isAuthenticated => currentUser != null;

  static Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }
  static Future<AuthResponse> signUpWithEmail(String email, String password, {Map<String, dynamic>? data}) async {
    return await _client.auth.signUp(email: email, password: password, data: data);
  }
  static Future<void> signOut() async => await _client.auth.signOut();
  static Future<void> resetPassword(String email) async => await _client.auth.resetPasswordForEmail(email);

  static Future<bool> addRating({required String productId, required double rating, String? comment, List<String>? images}) async {
    try {
      final userId = currentUserId;
      if (userId == null) return false;
      await _client.from('ratings').insert({
        'product_id': productId,
        'user_id': userId,
        'rating': rating,
        'comment': comment,
        'images': images,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) { print('Error adding rating: $e'); return false; }
  }

  static Future<List<Map<String, dynamic>>> getRatings(String productId) async {
    try {
      final response = await _client.from('ratings').select('*').eq('product_id', productId).order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) { print('Error getting ratings: $e'); return []; }
  }

  static Future<List<Map<String, dynamic>>> getProducts({String? category, int limit = 20}) async {
    try {
      var query = _client.from('products').select('*');
      if (category != null) {
        query = query.eq('category', category);
      }
      // لا نعيد تعيين query هنا لأن .limit() يغير النوع، نستخدم متغيراً جديداً أو نستدعي مباشرة
      final result = await query.limit(limit).order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(result);
    } catch (e) { print('Error getting products: $e'); return []; }
  }

  static Future<bool> addProduct(Map<String, dynamic> product) async {
    try { await _client.from('products').insert(product); return true; }
    catch (e) { print('Error adding product: $e'); return false; }
  }

  static Future<String?> uploadImage(String path, Uint8List fileBytes) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$path';
      await _client.storage.from('images').uploadBinary(fileName, fileBytes, fileOptions: const FileOptions(contentType: 'image/jpeg'));
      return _client.storage.from('images').getPublicUrl(fileName);
    } catch (e) { print('Error uploading image: $e'); return null; }
  }
}
