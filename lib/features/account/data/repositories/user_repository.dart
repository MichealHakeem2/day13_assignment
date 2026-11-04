import 'package:shopping_app/features/account/data/data_sources/user_local_data_source.dart';
import 'package:shopping_app/features/account/data/data_sources/user_remote_data_source.dart';
import 'package:shopping_app/features/account/data/models/profile_model.dart';

class UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepository({
    UserRemoteDataSource? remoteDataSource,
    UserLocalDataSource? localDataSource,
  })  : remoteDataSource = remoteDataSource ?? UserRemoteDataSource(),
        localDataSource = localDataSource ?? UserLocalDataSource();

  Future<ProfileModel> getUserData() async {
    try {
      final remoteProfile = await remoteDataSource.getUserData();
      await localDataSource.cacheProfile(remoteProfile);
      return remoteProfile;
    } catch (_) {
      final cached = await localDataSource.getCachedProfile();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  Future<bool> editUserData({
    required String name,
    required String phone,
    required String address,
    String? image,
  }) async {
    final success = await remoteDataSource.editUserData(
      name: name,
      phone: phone,
      address: address,
      image: image,
    );

    if (success) {
      final cached = await localDataSource.getCachedProfile();
      final updated = ProfileModel(
        id: cached?.id ?? '',
        name: name,
        email: cached?.email ?? '',
        phone: phone,
        address: address,
        image: image ?? cached?.image ?? '',
      );
      await localDataSource.cacheProfile(updated);
    }

    return success;
  }
}
