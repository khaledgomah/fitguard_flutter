import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/profile_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ProfileRepository profileRepository,
    required AuthController authController,
  })  : _profileRepository = profileRepository,
        _authController = authController,
        super(ProfileInitial());

  final ProfileRepository _profileRepository;
  final AuthController _authController;

  Future<void> updateProfile({
    String? name,
    String? email,
    String? sport,
    int? age,
    double? weight,
    double? height,
  }) async {
    emit(ProfileUpdating());
    try {
      final updatedUser = await _profileRepository.updateProfile(
        name: name,
        email: email,
        sport: sport,
        age: age,
        weight: weight,
        height: height,
      );
      
      // Update the AuthController session with the new user data
      _authController.updateUser(updatedUser);
      
      emit(ProfileUpdateSuccess());
    } catch (e) {
      emit(ProfileUpdateError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
