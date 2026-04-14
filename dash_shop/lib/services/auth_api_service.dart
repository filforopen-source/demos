class AuthApiService {
  Future<Map<String, dynamic>> fetchUserRaw(String name, String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'id': '1',
      'name': name,
      'email': email,
      'joinDate': DateTime(
        2023,
        10,
        15,
      ).toIso8601String(), // Use ISO 8601 string to represent data as standard raw map
      'dashPoints': 750,
    };
  }

  Future<Map<String, dynamic>> fetchCurrentUserRaw() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'id': '1',
      'name': 'Dash',
      'email': 'dash@example.com',
      'joinDate': DateTime(2023, 10, 15).toIso8601String(),
      'dashPoints': 750,
    };
  }
}
