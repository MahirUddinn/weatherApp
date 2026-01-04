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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.grey.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  width: 150,
                  child: Image.asset("asset/image/sun.png"),
                ),
                Text(
                  "Welcome Back",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 30),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return Card(
                      elevation: 8,
                      margin: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Email Address",
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
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
                              SizedBox(height: 16),
                              if (!state.isLogin) ...[
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Username",
                                    prefixIcon: Icon(Icons.person_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
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
                                SizedBox(height: 16),
                              ],
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 8) {
                                    return "Enter valid password (min 8 chars)";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  state.enteredPassword = value!;
                                },
                              ),
                              SizedBox(height: 24),
                              if (!state.isAuthenticating)
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthCubit>().submit(
                                          context,
                                          _form,
                                        );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  child: Text(
                                    state.isLogin ? "Login" : "Sign Up",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
