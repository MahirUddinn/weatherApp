import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit/auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 300,
                child: Image.asset("asset/image/sun.png"),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return Card(
                    margin: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  label: Text("Email Address"),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      !value.contains("@") ||
                                      value.trim().isEmpty) {
                                    return "Enter valid email";
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  state.enteredEmail = value!;
                                },
                              ),
                              if (!state.isLogin)
                                TextFormField(
                                  decoration: InputDecoration(
                                    label: Text("Username"),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        value.trim().length < 3) {
                                      return "Enter valid username";
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    state.enteredUsername = value!;
                                  },
                                ),
                              TextFormField(
                                decoration: InputDecoration(
                                  label: Text("Password"),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 8) {
                                    return "Enter valid password";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  state.enteredPassword = value!;
                                },
                              ),
                              SizedBox(height: 12),
                              if (!state.isAuthenticating)
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthCubit>().submit(
                                      context,
                                      _form,
                                    );
                                  },
                                  child: Text(
                                    state.isLogin ? "Login" : "Sign Up",
                                  ),
                                ),
                              if (!state.isAuthenticating)
                                TextButton(
                                  onPressed: () {
                                    context.read<AuthCubit>().changeLogin();
                                  },
                                  child: Text(
                                    state.isLogin
                                        ? "Create an account"
                                        : "I already have an account",
                                  ),
                                ),
                              if (state.isAuthenticating)
                                CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
