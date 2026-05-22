import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../core/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'rentelapp');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchUserData(user.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection(AppConstants.userCollection).doc(uid).get();
      if (doc.exists) {
        _currentUser = UserModel.fromMap(doc.data()!, docId: doc.id);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Login error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(UserModel user) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      
      // Store additional user data in Firestore
      await _firestore.collection(AppConstants.userCollection).doc(credential.user!.uid).set(user.toMap());
      await _fetchUserData(credential.user!.uid);
    } catch (e) {
      print('Signup error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    // Firebase Auth handles persistence automatically.
    // The authStateChanges listener in the constructor will handle the session.
    final user = _auth.currentUser;
    if (user != null) {
      await _fetchUserData(user.uid);
    }
  }

  Future<void> signInWithGoogle(String selectedRole) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Force Google to clear cached sessions so it always displays the account chooser sheet
      await _googleSignIn.signOut();

      // 1. Trigger Google's native account-picker pop-up sheet
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User backed out / canceled the picker
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 2. Fetch the authentication tokens from Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Convert Google auth credentials to Firebase Credentials
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Authenticate into Firebase Auth
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // 5. Query Firestore to check if they have registered an account before
        final doc = await _firestore.collection(AppConstants.userCollection).doc(firebaseUser.uid).get();

        if (!doc.exists) {
          // If a new user, create their landlord/renter profile inside Firestore
          final newUser = UserModel(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? 'Google User',
            email: firebaseUser.email ?? '',
            phone: firebaseUser.phoneNumber ?? '',
            role: selectedRole, // Dynamic role chosen by user (Renter/Landlord)
            password: '',       // OAuth logins don't require passwords
            avatar: firebaseUser.photoURL ?? '', // Capture Google avatar URL
          );

          await _firestore.collection(AppConstants.userCollection).doc(firebaseUser.uid).set(newUser.toMap());
          _currentUser = newUser;
        } else {
          // If an existing user, load their registered profile
          _currentUser = UserModel.fromMap(doc.data()!, docId: doc.id);
        }
      }
    } catch (e) {
      print('Google OAuth Error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserModel user) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _firestore.collection(AppConstants.userCollection).doc(user.id).update(user.toMap());
      _currentUser = user;
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProfile() async {
    if (_currentUser == null) return;
    
    try {
      final uid = _currentUser!.id!;
      await _firestore.collection(AppConstants.userCollection).doc(uid).delete();
      await _auth.currentUser?.delete();
      await logout();
    } catch (e) {
      print('Delete profile error: $e');
      rethrow;
    }
  }

  Future<void> updateProfilePicture(String filePath) async {
    if (_currentUser == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // We are now saving the local path on the device instead of uploading to Firebase Storage
      await _firestore.collection(AppConstants.userCollection).doc(_currentUser!.id).update({
        'avatar': filePath,
      });
      
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        role: _currentUser!.role,
        password: _currentUser!.password,
        avatar: filePath,
      );
    } catch (e) {
      print('Update local profile picture error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
