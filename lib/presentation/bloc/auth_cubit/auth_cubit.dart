import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
    : super(
        AuthState(
          enteredEmail: "",
          enteredPassword: "",
          enteredUsername: "",
          isLogin: true,
          isAuthenticating: false,
        ),
      );

  final firebase = FirebaseAuth.instance;


  Future<void> submit(
    BuildContext context,
    GlobalKey<FormState> form,
  ) async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    form.currentState!.save();
    if (state.isLogin) {
      emit(state.copyWith(isAuthenticating: true));
      try {
        final userCredentials = await firebase.signInWithEmailAndPassword(
          email: state.enteredEmail,
          password: state.enteredPassword,
        );

        print(userCredentials);
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Authentication Failed")));
        emit(state.copyWith(isAuthenticating: false));
      }
    } else {
      try {
        emit(state.copyWith(isAuthenticating: true));
        print(state.enteredUsername);
        print(state.enteredPassword);

        final userCredentials = await firebase.createUserWithEmailAndPassword(
          email: state.enteredEmail,
          password: state.enteredPassword,
        );

        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredentials.user!.uid)
            .set({
              "username": state.enteredUsername,
              "email": state.enteredEmail,
              "password": state.enteredPassword,
            });
        emit(state.copyWith(isAuthenticating: false));
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Authentication Failed")));

        emit(state.copyWith(isAuthenticating: false));

      }
    }
  }
  void changeLogin(){
    emit(state.copyWith(isLogin: !state.isLogin));
  }
}
