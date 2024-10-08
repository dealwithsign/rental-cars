// data/services/authentication_services.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/users_model.dart';

class AuthServices {
  final supabase = Supabase.instance.client;

  // Metode sign-in menggunakan Supabase
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return UserModel(
      id: res.user!.id,
      email: email,
      username: '',
      phone_number: 081234567890,
      created_at: DateTime.now(),
    );
  }

  // Metode sign-up menggunakan Supabase
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
    required int phone_number,
  }) async {
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    UserModel user = UserModel(
      id: res.user!.id,
      email: email,
      username: username,
      phone_number: phone_number,
      created_at: DateTime.now(),
    );

    try {
      final res = await supabase.from('users').insert(user.toJson());

      if (res != null && res.error != null) {
        throw Exception(res.error!.message);
      }
    } catch (e) {
      final userRes =
          await supabase.from("users").select().eq("id", user.id).single();
      if (userRes.isNotEmpty) {
        user = UserModel.fromJson(userRes);
      }
    }

    return user;
  }

  // Metode sign-out menggunakan Supabase
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Metode sign-in dan sign-up menggunakan Google
  Future<UserModel> googleSignInSignUp() async {
    await dotenv.load(fileName: ".env.dev");

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: dotenv.env['webClientId']!,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in failed');
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw Exception('No access or id token found');
    }

    final AuthResponse res = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (res.user == null) {
      throw Exception('Supabase sign-in failed');
    }

    final user = UserModel(
      id: res.user!.id,
      email: res.user!.userMetadata!['email'] ?? '',
      username: res.user!.userMetadata!['full_name'] ?? '',
      phone_number: res.user!.userMetadata!['phone_number'] ?? 081234567890,
      created_at: DateTime.now(),

      // provider: 'sign_up_with_google',
      // url_profile: res.user!.userMetadata!['avatar_url'] ?? '',
    );

    try {
      final response = await supabase.from('users').insert(user.toJson());

      if (response.error != null) {
        throw Exception('Database insert error: ${response.error!.message}');
      }
    } catch (e) {}

    return user;
  }

  // get current users
  Future<UserModel> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      try {
        final userProfileResponse =
            await supabase.from('users').select().eq('id', user.id).single();
        final name = userProfileResponse['username'] ?? '';
        final email = userProfileResponse['email'] ?? '';
        final phoneNumber =
            int.tryParse(userProfileResponse['phone_number'] ?? '08') ?? 08;
        final urlProfile = userProfileResponse['url_profile'] ?? '';

        return UserModel(
          id: user.id,
          username: name,
          email: email,
          phone_number: phoneNumber,
          created_at: DateTime.now(), // Consider using server timestamp
          // url_profile: urlProfile,

          // provider: 'sign_in_with_email',
        );
      } catch (e) {
        print('Error fetching user: $e');
      }
    }
    return UserModel(
      email: '',
      id: '',
      username: '',
      phone_number: 62,
      created_at: DateTime.now(),
      // url_profile: '',

      // provider: 'Sign in with Email',
    );
  }

  Future<UserModel> updateUser({
    required String id,
    required int phone_number,
  }) async {
    try {
      // Perform the update query
      final response = await supabase
          .from('users')
          .update({'phone_number': phone_number})
          .eq('id', id)
          .select(); // Ensure that you select the data after update

      // Debugging: Print the response to see what it contains
      print('Response: $response');

      // Ensure the response contains data
      if (response.isEmpty) {
        throw Exception('Database update error: No response or data received');
      }

      // Assuming the response is a list of maps
      final updatedUser = response.first;

      return UserModel(
        id: id,
        email: updatedUser['email'],
        username: updatedUser['username'],
        phone_number: phone_number,
        created_at: DateTime.parse(updatedUser['created_at']),
        // url_profile: updatedUser['url_profile'],

        // provider: 'Sign in with Email',
      );
    } catch (e) {
      // Detailed error logging
      print('Exception: $e');
      throw Exception('Database update error: ${e.toString()}');
    }
  }

  // reset password
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      print('Password reset email sent successfully.');
    } catch (e) {
      print('Failed to send password reset email: $e');
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // verify OTP // verify OTP
  Future<void> verifyOTP({
    required String token,
    required OtpType type,
    required String email,
  }) async {
    try {
      await supabase.auth.verifyOTP(
        token: token,
        type: type,
        email: email,
      );
      print('OTP verified successfully.');
    } catch (e) {
      print('Failed to verify OTP: $e');
      throw Exception('Failed to verify OTP: $e');
    }
  }

  //  update password
  Future<void> updatePassword({
    required String newPassword,
  }) async {
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      print('Password reset email sent successfully.');
    } catch (e) {
      print('Failed to send password reset email: $e');
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // add phone number
  Future<UserModel> updatePhoneNumber({
    required int phone_number,
  }) async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      try {
        final response = await supabase
            .from('users')
            .update({'phone_number': phone_number})
            .eq('id', user.id)
            .select();

        if (response.isEmpty) {
          throw Exception(
              'Database update error: No response or data received');
        }

        final updatedUser = response.first;

        return UserModel(
          id: user.id,
          email: updatedUser['email'],
          username: updatedUser['username'],
          phone_number: phone_number,
          created_at: DateTime.parse(updatedUser['created_at']),
          // url_profile: updatedUser['url_profile'],

          // provider: 'Sign in with Email',
        );
      } catch (e) {
        print('Exception: $e');
        throw Exception('Database update error: ${e.toString()}');
      }
    }
    return UserModel(
      email: '',
      id: '',
      username: '',
      phone_number: 08,
      created_at: DateTime.now(),
      // url_profile: '',

      // provider: 'Sign in with Email',
    );
  }
}
