import 'package:cloud_firestore/cloud_firestore.dart';

import 'models.dart';

class FirestoreService {
  /// Shorthand to reduce the typing
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  //User related
  Future<List<User>> getUser() async {
    var reference = _database.collection("users");
    var snapshot = await reference.get();
    var data = snapshot.docs.map((document) => document.data());
    var user = data.map((documentData) => User.fromJson(documentData));
    return user.toList();
  }

  Future<User> getUserByName(String name) async {
    var reference = _database.collection("users").doc(name);
    var snapshot = await reference.get();
    var data = snapshot.data();
    if (data == null) {
      throw Exception("User $name does not exist");
    } else {
      return User.fromJson(data);
    }
  }

  Future<void> createUser(User user) async {
    var reference =
        _database.collection("users").doc(user.name).set(user.toJson());
    await reference;
  }

  Future<void> updateUserById(User user) async {
    var reference = _database.collection("users").doc(user.uid.toString());
    var newData = {
      "name": user.name,
      "email": user.email,
      "address": user.address,
      "phone": user.phone,
    };
    return reference.set(newData, SetOptions(merge: true));
  }

  Future<void> deleteUserById(User user) async {
    var reference = _database.collection("users").doc(user.uid.toString());

    return reference.delete();
  }

  //Service related
  Future<List<Service>> getService() async {
    var reference = _database.collection("services");
    var snapshot = await reference.get();
    var data = snapshot.docs.map((document) => document.data());
    var service = data.map((documentData) => Service.fromJson(documentData));
    return service.toList();
  }

  Future<Service> getServiceByName(String name) async {
    var reference = _database.collection("services").doc(name);
    var snapshot = await reference.get();
    var data = snapshot.data();
    if (data == null) {
      throw Exception("Service $name does not exist");
    } else {
      return Service.fromJson(data);
    }
  }

  Future<void> createService(Service service) async {
    var reference = _database
        .collection("services")
        .doc(service.name)
        .set(service.toJson());
    await reference;
  }

  Future<void> updateServiceById(Service service) async {
    var reference =
        _database.collection("services").doc(service.sid.toString());
    var newData = {
      "name": service.name,
      "category": service.category,
      "description": service.description,
    };
    return reference.set(newData, SetOptions(merge: true));
  }

  Future<void> deleteServiceById(Service service) async {
    var reference =
        _database.collection("services").doc(service.sid.toString());

    return reference.delete();
  }

  //ServiceRecord related
  Future<List<ServiceRecord>> getServiceRecord() async {
    var reference = _database.collection("serviceRecords");
    var snapshot = await reference.get();
    var data = snapshot.docs.map((document) => document.data());
    var serviceRecord =
        data.map((documentData) => ServiceRecord.fromJson(documentData));
    return serviceRecord.toList();
  }

  Future<ServiceRecord> getServiceRecordByName(String name) async {
    var reference = _database.collection("serviceRecords").doc(name);
    var snapshot = await reference.get();
    var data = snapshot.data();
    if (data == null) {
      throw Exception("ServiceRecord $name does not exist");
    } else {
      return ServiceRecord.fromJson(data);
    }
  }

  Future<void> createServiceRecord(ServiceRecord serviceRecord) async {
    var reference = _database
        .collection("serviceRecords")
        .doc(serviceRecord.rid.toString())
        .set(serviceRecord.toJson());
    await reference;
  }

  Future<void> updateServiceRecordById(ServiceRecord serviceRecord) async {
    var reference = _database
        .collection("serviceRecords")
        .doc(serviceRecord.rid.toString());
    var newData = {
      "uid": serviceRecord.uid,
      "sid": serviceRecord.sid,
      "pid": serviceRecord.pid,
      "status": serviceRecord.status,
      "createdTime": serviceRecord.createdTime,
      "startTime": serviceRecord.startTime,
      "endTime": serviceRecord.endTime,
    };
    return reference.set(newData, SetOptions(merge: true));
  }

  Future<void> deleteServiceRecordById(ServiceRecord serviceRecord) async {
    var reference = _database
        .collection("serviceRecords")
        .doc(serviceRecord.rid.toString());

    return reference.delete();
  }

  //Provider related
  Future<List<Provider>> getProvider() async {
    var reference = _database.collection("providers");
    var snapshot = await reference.get();
    var data = snapshot.docs.map((document) => document.data());
    var provider = data.map((documentData) => Provider.fromJson(documentData));
    return provider.toList();
  }

  Future<Provider> getProviderByName(String name) async {
    var reference = _database.collection("providers").doc(name);
    var snapshot = await reference.get();
    var data = snapshot.data();
    if (data == null) {
      throw Exception("Provider $name does not exist");
    } else {
      return Provider.fromJson(data);
    }
  }

  Future<void> createProvider(Provider provider) async {
    var reference = _database
        .collection("providers")
        .doc(provider.name)
        .set(provider.toJson());
    await reference;
  }

  Future<void> updateProviderById(Provider provider) async {
    var reference =
        _database.collection("providers").doc(provider.pid.toString());
    var newData = {
      "name": provider.name,
      "email": provider.email,
      "address": provider.address,
      "phone": provider.phone,
    };
    return reference.set(newData, SetOptions(merge: true));
  }

  Future<void> deleteProviderById(Provider provider) async {
    var reference =
        _database.collection("providers").doc(provider.pid.toString());

    return reference.delete();
  }
}
