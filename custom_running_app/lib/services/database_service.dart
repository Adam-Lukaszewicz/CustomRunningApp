import 'package:biezniappka/models/account_model.dart';
import 'package:biezniappka/models/training_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  bool loggedIn = false;
  CurrentUserData currentUserData =
      CurrentUserData(dbId: "dbId", data: AccountModel());
  late Map<String, AccountModel> friendsData;
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
      loggedIn = true;
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
        if (userData.data() != null) {
          currentUserData = CurrentUserData(
              dbId: userData.id, data: userData.data() as AccountModel);
        } else {
          _accountRef.set(currentUserData.data);
          currentUserData.dbId = FirebaseAuth.instance.currentUser!.uid;
        }
        if (currentUserData.data.code == 0) {
          _db.collection("user_data").count().get().then((countQ) {
            if (countQ.count != null) {
              currentUserData.data.code = countQ.count!;
              updateAccount(currentUserData.data);
            }
          });
        }
      });
      _trainingRef.get().then((trainings) {
        currentUserData.data.trainings = trainings.docs.map((doc) {
          return doc.data()! as TrainingModel;
        }).toList();
      });
      updateFriends();
    } else {
      currentUserData.dbId = "guest user";
      currentUserData.data = AccountModel();
    }
  }

  void logout(){
    loggedIn = false;
    currentUserData.dbId = "guest user";
    currentUserData.data = AccountModel();
    FirebaseAuth.instance.signOut();
  }

  void updateFriends() {
    Map<String, AccountModel> allUsers = {};
    _usersRef.get().then((snapshots) {
      for (var doc in snapshots.docs) {
        allUsers.addAll({doc.id: doc.data()! as AccountModel});
      }
      friendsData = {
        for (final key in allUsers.keys)
          if (currentUserData.data.friendIds.contains(allUsers[key]!.code))
            key: allUsers[key]!
      };
      for (final key in friendsData.keys) {
        List<TrainingModel> friendsTrainings;
        _db
            .collection("user_data")
            .doc(key)
            .collection("trainings")
            .get()
            .then((snapshot) {
          friendsTrainings = snapshot.docs.map((doc) {
            return doc.data() as TrainingModel;
          }).toList();
          friendsData[key]!.trainings = friendsTrainings;
        });
      }
    });
  }

  Future<bool> checkCodeViability(int code) async {
    var snapshots = await _usersRef.get(); 
      for (var doc in snapshots.docs) {
        AccountModel model = doc.data() as AccountModel;
        if (model.code == code) {
          return true;
        }
      }
      return false;
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

  void endTraining(TrainingModel training) {
    _trainingRef.add(training);
  }
}

class CurrentUserData {
  String dbId;
  AccountModel data;
  CurrentUserData({required this.dbId, required this.data});
}
