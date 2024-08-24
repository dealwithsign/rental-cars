// blocs/auth/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:rents_cars_app/blocs/auth/auth_event.dart'; // Import event otentikasi

import '../../data/models/users_model.dart';
import '../../data/services/authentication_services.dart'; // Import kelas layanan otentikasi

part 'auth_state.dart'; // Bagian dari state otentikasi

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthServices authServices;

  AuthBloc(this.authServices) : super(AuthInitial()) {
    // handler untuk event SignInRequested
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading()); // Emit status loading saat proses login dimulai
      try {
        // Memanggil metode sign in dari layanan otentikasi
        final user = await authServices.signIn(
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccess(user)); // Emit status sukses dengan model pengguna
      } catch (e) {
        emit(AuthFailure(
            e.toString())); // Tangani kesalahan dan emit status gagal
      }
    });
    // Handler untuk event SignUpRequested
    on<SignUpRequested>((event, emit) async {
      emit(
          AuthLoading()); // Emit status loading saat proses pendaftaran dimulai
      try {
        // Memanggil metode sign up dari layanan otentikasi
        final user = await authServices.signUp(
          email: event.email,
          password: event.password,
          username: event.name,
          phone_number: int.parse(event.phoneNumber),
        );
        print(user);
        emit(AuthSuccess(user)); // Emit status sukses dengan model pengguna
      } catch (e) {
        emit(AuthFailure(
            e.toString())); // Tangani kesalahan dan emit status gagal
      }
    });

    // Handler untuk event SignOutRequested
    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading()); // Emit status loading saat proses logout dimulai
      try {
        await authServices
            .signOut(); // Panggil metode logout dari layanan otentikasi
        emit(AuthInitial()); // Emit status awal setelah logout berhasil
      } catch (e) {
        emit(AuthFailure(
            e.toString())); // Tangani kesalahan dan emit status gagal
      }
    });
    // sign google
    on<SignInSignUpWithGoogleRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authServices.googleSignInSignUp();
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Handler untuk event current user
    on<GetCurrentUserRequested>((event, emit) async {
      print('FetchUser event received, fetching user...');
      emit(
          AuthLoading()); // Emit status loading saat proses mendapatkan data pengguna dimulai
      try {
        final user = await authServices.getCurrentUser();
        print('Current user: $user'); // Debug print
        print('Current user id: ${user.id}'); // Debug print
        print('Current user email: ${user.email}'); // Debug print
        print(user.username);
        emit(
          AuthSuccess(user),
        ); // Emit status sukses dengan model pengguna
      } catch (e) {
        print('Error fetching user: $e');
        emit(AuthFailure(
            e.toString())); // Tangani kesalahan dan emit status gagal
      }
    });
    on<UpdateUserRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authServices.updateUser(
          id: event.id,
          phone_number: event.phoneNumber,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
    on<VerifyOTPRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authServices.verifyOTP(
          token: event.token,
          type: event.type,
          email: event.email,
        );
        emit(AuthInitial()); // Emit initial state if verification is successful
      } catch (e) {
        emit(AuthFailure(
            e.toString())); // Emit failure state if verification fails
      }
    });
    on<ResetPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authServices.resetPassword(
          email: event.email,
        );
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
    on<UpdatePasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authServices.updatePassword(
          newPassword: event.newPassword,
        );
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
