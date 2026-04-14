import '../models/user.dart';
import '../services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _apiService;
  User? _currentUser;

  AuthRepository(this._apiService);

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<User?> checkAuthStatus() async {
    try {
      final rawData = await _apiService.fetchCurrentUserRaw();
      _currentUser = _mapUser(rawData);
      return _currentUser;
    } catch (_) {
      _currentUser = null;
      return null;
    }
  }

  Future<User?> signIn(String name, String email) async {
    final rawData = await _apiService.fetchUserRaw(name, email);
    _currentUser = _mapUser(rawData);
    return _currentUser;
  }

  void signOut() {
    _currentUser = null;
  }

  User _mapUser(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      joinDate: DateTime.parse(json['joinDate']),
      dashPoints: json['dashPoints'],
    );
  }
}
