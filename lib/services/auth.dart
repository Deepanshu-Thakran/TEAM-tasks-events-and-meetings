import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:task_scheduler/models/user.dart';
import 'package:task_scheduler/services/database.dart';

class AuthService{

  final FirebaseAuth auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return auth.onAuthStateChanged
    .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try{
      AuthResult result = await auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }on PlatformException catch(p){
      print(p.toString());
      return 'PlatformException';
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email
  Future signUpWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      //create new user entry for this new user in the userCollection
      await DatabaseService(uid: user.uid).newUserData();
      return _userFromFirebaseUser(user);
    } on PlatformException catch(p){
      print(p.toString());
      return 'PlatformException';
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return await auth.signOut();
    }on PlatformException catch(p){
      print(p.toString());
      return 'PlatformException';
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}