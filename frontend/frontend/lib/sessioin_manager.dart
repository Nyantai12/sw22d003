import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _uidKey = 'uid';

  // Save user ID (uid)
  static Future<void> saveUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidKey, uid);
  }

  // Retrieve user ID (uid)
  static Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uidKey);
  }

  // Remove user ID (uid) to log out
  static Future<void> removeUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_uidKey);
  }
  static Future<void> clearSession() async {
    // Clear all stored preferences (e.g., UID or any other session data).
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  // Save user data to SharedPreferences
  static Future<void> saveUserData(Map<String, String> userData) async {
    final prefs = await SharedPreferences.getInstance();

    // Save data
    await prefs.setString("fname", userData["fname"]!);
    await prefs.setString("lname", userData["lname"]!);
    await prefs.setString("uname", userData["uname"]!);

    // Debugging to ensure data is saved
    print("User data saved: $userData");
  }

  // Get user data from SharedPreferences
  static Future<Map<String, String>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? fname = prefs.getString("fname");
    String? lname = prefs.getString("lname");
    String? uname = prefs.getString("uname");

    if (fname == null || lname == null || uname == null) {
      print("Error: Missing user data in SharedPreferences");
      return null;
    }

    return {
      "fname": fname,
      "lname": lname,
      "uname": uname,
    };
  }

  // Clear user data (for logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("uid");
    await prefs.remove("fname");
    await prefs.remove("lname");
    await prefs.remove("uname");
  }

}

