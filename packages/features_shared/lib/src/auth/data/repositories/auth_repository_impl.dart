import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final user = await _remote.login(email: email, password: password);
    await _local.saveUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } catch (_) {
      // Fail-safe: even if backend logout fails (e.g. offline), 
      // we must still clear the local user session.
    } finally {
      await _local.clearUser();
    }
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await _remote.register(
      name: name,
      email: email,
      password: password,
    );
    await _local.saveUser(user);
    return user;
  }

  @override
  Future<User?> getCurrentUser() => _local.getUser();

  @override
  Future<User> updateProfile({
    required String name,
    required String email,
  }) async {
    final updated = await _remote.updateProfile(name: name, email: email);
    
    // Retrieve current user to keep the auth token!
    final currentUser = await _local.getUser();
    final merged = UserModel(
      id: updated.id,
      name: updated.name,
      email: updated.email,
      phone: updated.phone ?? currentUser?.phone,
      avatarUrl: updated.avatarUrl ?? currentUser?.avatarUrl,
      roles: updated.roles.isNotEmpty ? updated.roles : (currentUser?.roles ?? const []),
      token: currentUser?.token,
    );
    
    await _local.saveUser(merged);
    return merged;
  }
}
