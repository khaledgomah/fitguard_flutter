import 'package:dio/dio.dart';
import '../../../../features/auth/data/models/auth_user.dart';

class ProfileRepository {
  ProfileRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<AuthUser> updateProfile({
    String? name,
    String? email,
    String? sport,
    int? age,
    double? weight,
    double? height,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (sport != null) data['sport'] = sport;
      if (age != null) data['age'] = age;
      if (weight != null) data['weight'] = weight;
      if (height != null) data['height'] = height;

      final response = await _dio.put('/api/user/profile', data: data);
      
      if (response.data['success'] == true) {
        return AuthUser.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update profile');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
