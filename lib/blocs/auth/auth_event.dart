// blocs/auth/auth_event.dart
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String phoneNumber;

  SignUpRequested(
    this.email,
    this.password,
    this.username,
    this.phoneNumber,
  );
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

class SignInSignUpWithGoogleRequested extends AuthEvent {}

class GetCurrentUserRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class UpdateUserRequested extends AuthEvent {
  final String id;
  final int phoneNumber;

  UpdateUserRequested(this.id, this.phoneNumber, {required userId});
}

class VerifyOTPRequested extends AuthEvent {
  final String token;
  final OtpType type;
  final String email;

  VerifyOTPRequested(
    this.token,
    this.type,
    this.email,
  );

  List<Object> get props => [token, type];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;

  ResetPasswordRequested(this.email);
}

class UpdatePasswordRequested extends AuthEvent {
  final String newPassword;

  UpdatePasswordRequested(this.newPassword);
  @override
  List<Object> get props => [newPassword];
}
