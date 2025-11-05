part of 'auth_cubit.dart';

class AuthState {
  String enteredEmail;
  String enteredPassword;
  String enteredUsername;
  bool isLogin;
  bool isAuthenticating;

  AuthState({
    required this.enteredEmail,
    required this.enteredPassword,
    required this.enteredUsername,
    required this.isLogin,
    required this.isAuthenticating,
  });

  AuthState copyWith({
    String? enteredEmail,
    String? enteredPassword,
    String? enteredUsername,
    bool? isLogin,
    bool? isAuthenticating,
  }) {
    return AuthState(
      enteredEmail: enteredEmail ?? this.enteredEmail,
      enteredPassword: enteredPassword ?? this.enteredPassword,
      enteredUsername: enteredUsername ?? this.enteredUsername,
      isLogin: isLogin ?? this.isLogin,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
    );
  }
}
