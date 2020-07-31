import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodly/constants/strings.dart';
import 'package:foodly/enums/authState.dart';
import 'package:foodly/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodly/utilities/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn;
  User _fuser;
  Status _status = Status.Uninitialized;

  static final Firestore _firestore = Firestore.instance;
  static final Firestore firestore = Firestore.instance;

  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;
  User get getUser => _fuser;

  Future<FirebaseUser> getCurrentUser() async {
    try {
      FirebaseUser currentUser;
      currentUser = await _auth.currentUser();
      return currentUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> refreshUser() async {
    User ruser = await getUserDetails();
    _fuser = ruser;
    // Prefs.saveUserRole(ruser.userRole);
    notifyListeners();
  }

  Future<User> getUserDetails() async {
    try {
      FirebaseUser currentUser = await getCurrentUser();

      DocumentSnapshot documentSnapshot =
          await _userCollection.document(currentUser.uid).get();
      return User.fromMap(documentSnapshot.data);
    } catch (e) {
      print("Error while getiing user detail");
      print(e);
      return _fuser;
    }
  }

  Future<User> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.document(id).get();
      return User.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.document(uid).snapshots();

  Future<bool> authenticateUser(FirebaseUser nuser) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: nuser.email)
        .where("uid", isEqualTo: nuser.uid)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    User user = User(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoUrl,
      phoneNumber: null,
      address: null,
      username: username,
    );
    Utils.saveToPrefereces(
      name: currentUser.displayName,
      photo: currentUser.photoUrl,
      userId: currentUser.uid,
      email: currentUser.email,
      phoneNumber: null,
      address: null,
    );

    firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<bool> updateProfile(User upUser) async {
    refreshUser();
    try {
      await firestore
          .collection(USERS_COLLECTION)
          .document(user.uid)
          .updateData(upUser.toMap(upUser));

      Utils.saveToPrefereces(
        name: upUser.name,
        photo: upUser.profilePhoto,
        userId: user.uid,
        email: upUser.email,
        phoneNumber: upUser.phoneNumber,
        address: upUser.address,
      );
      refreshUser();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> addDataToFdb(FirebaseUser newUser, String name) async {
    String username = Utils.getUsername(newUser.email);

    User user = User(
      uid: newUser.uid,
      email: newUser.email,
      name: name,
      profilePhoto: BLANK_IMAGE,
      phoneNumber: null,
      address: null,
      username: username,
    );
    Utils.saveToPrefereces(
      name: name,
      photo: BLANK_IMAGE,
      userId: newUser.uid,
      email: user.email,
      phoneNumber: null,
      address: null,
    );

    Firestore.instance
        .collection(USERS_COLLECTION)
        .document(newUser.uid)
        .setData(user.toMap(user));
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("Error While Sign In");
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        if (result.user != null) {
          authenticateUser(result.user).then((isNewUser) {
            if (isNewUser) addDataToFdb(result.user, name);
          });
        }
      });
      return true;
    } catch (e) {
      print(e.toString());
      Utils.showToast("Error While Sign Up");
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      await _auth.signInWithCredential(credential).then((value) {
        if (value.user != null) {
          authenticateUser(value.user).then((isNewUser) {
            if (isNewUser)
              addDataToDb(value.user);
            else {
              Utils.saveToPrefereces(
                name: getUser.name,
                photo: getUser.profilePhoto,
                userId: value.user.uid,
                email: value.user.email,
                phoneNumber: getUser.phoneNumber,
                address: getUser.address,
              );
            }
          });
        }
      });
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _auth.signOut();
      _googleSignIn.signOut();
      _status = Status.Unauthenticated;

      Utils.saveToPrefereces(
                name: null,
                photo: null,
                userId: null,
                email: null,
                phoneNumber: null,
                address: null,
              );
      notifyListeners();
      return Future.delayed(Duration.zero);
    } catch (e) {
      print(e.toString());
      _status = Status.Authenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      await refreshUser();
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
