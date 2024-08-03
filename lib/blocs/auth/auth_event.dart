abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;

  SignUpRequested(this.email, this.password, this.name, this.phoneNumber);
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

class SignInWithGoogleRequested extends AuthEvent {}

class GetCurrentUserRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class UpdateUserRequested extends AuthEvent {
  final String id;
  final int phoneNumber;

  UpdateUserRequested(this.id, this.phoneNumber, {required userId});
}
