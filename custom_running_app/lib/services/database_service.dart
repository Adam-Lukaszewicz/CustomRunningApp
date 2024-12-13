import 'package:biezniappka/models/account_model.dart';
import 'package:biezniappka/models/training_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  bool loggedIn = false;
  late AccountModel currentUserData;
  late List<AccountModel> friendsData;
  late CollectionReference _usersRef;
  late DocumentReference _accountRef;
  late CollectionReference _trainingRef;

  DatabaseService() {
    _usersRef = _db.collection("user_data").withConverter<AccountModel>(
        fromFirestore: (snapshots, _) =>
            AccountModel.fromJson(snapshots.data()!),
        toFirestore: (accountModel, _) => accountModel.toJson());
  }

  void assignUserSpecificData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _accountRef = _db
          .collection("user_data")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .withConverter<AccountModel>(
              fromFirestore: (snapshots, _) =>
                  AccountModel.fromJson(snapshots.data()!),
              toFirestore: (accountModel, _) => accountModel.toJson());
      _trainingRef = _db
          .collection("user_data")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("trainings")
          .withConverter<TrainingModel>(
              fromFirestore: (snapshots, _) =>
                  TrainingModel.fromJson(snapshots.data()!),
              toFirestore: (trainingModel, _) => trainingModel.toJson());
      _accountRef.get().then((userData) {
        currentUserData = userData.data() as AccountModel;
        if (currentUserData.code == 0) {
          _db.collection("user_data").count().get().then((countQ) {
            if (countQ.count != null) {
              currentUserData.code = countQ.count!;
            }
          });
        }
      });
      List<AccountModel> allUsers;
      _usersRef.get().then((snapshots) {
        allUsers = snapshots.docs.map((doc) {
          return doc.data()! as AccountModel;
        }).toList();
      friendsData = allUsers.where((user){return currentUserData.friendIds.contains(user.code);}).toList();
      for(var friend in friendsData){
        friend.updateCache();
      }
      });
    }
  }

  ////////////////// ACCOUNT CRUD //////////////////
  Future<DocumentSnapshot> getAccount() {
    return _accountRef.get();
  }

  Stream<DocumentSnapshot> getAccountUpdates() {
    return _accountRef.snapshots();
  }

  void updateAccount(AccountModel accountModel) {
    _accountRef.update(accountModel.toJson());
  }

  ////////////////// TRAINING CRUD //////////////////
  Stream<QuerySnapshot> getTrainings() {
    return _trainingRef.snapshots();
  }
}
