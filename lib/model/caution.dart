import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum LifecycleState { created, saved, dirty, invalid, deleted }

class CautionModel extends ChangeNotifier {
  static CollectionReference _cautionsCollection =
      FirebaseFirestore.instance.collection('cautions');
  LifecycleState _lifecycleState;
  String id;
  String _name;
  String _cautionText;

  String get cautionText => _cautionText;

  set cautionText(String cautionText) {
    _cautionText = cautionText;
    setDirty();
  }

  String get name => _name;

  set name(String name) {
    _name = name;
    setDirty();
  }

  void setDirty() {
    _lifecycleState = LifecycleState.dirty;
  }

  void setSaved() {
    _lifecycleState = LifecycleState.saved;
  }

  bool isNew() {
    return _lifecycleState == LifecycleState.created;
  }

  CautionModel(this._name, this._cautionText) {
    _lifecycleState = LifecycleState.created;
  }

  CautionModel.preloaded(this.id, this._name, this._cautionText) {
    _lifecycleState = LifecycleState.saved;
    print("Caution Model preloaded: " + this.name);
  }

  CautionModel.load(String _id) {
    _cautionsCollection.doc(_id).snapshots().listen((docSnap) {
      name = docSnap.get('name');
      cautionText = docSnap.get('cautionText');
    });
  }

  Map<String, dynamic> documentMap() {
    return Map.from({
      "name": name,
      "cautionText": cautionText,
    });
  }

  void save() {
    if (this.isValid()) {
      if (_lifecycleState == LifecycleState.created) {
        setSaved();
        _cautionsCollection.add(documentMap());
      } else if (_lifecycleState == LifecycleState.dirty) {
        setSaved();
        _cautionsCollection.doc(id).set(documentMap());
      } else if (_lifecycleState == LifecycleState.deleted) {
        // throw item deleted
      }
    } else {
      _lifecycleState = LifecycleState.invalid;
      // throw invalid error
    }
  }

  bool isValid() {
    return name.length >= 3 && cautionText.length >= 10;
  }
}

class CautionModelCollection extends ChangeNotifier {
  static CollectionReference _cautionsCollection =
      FirebaseFirestore.instance.collection('cautions');

  Stream<List<CautionModel>> stream() {
    return _cautionsCollection
        .snapshots()
        .map<List<CautionModel>>((collectionSnap) {
      List<CautionModel> modelList = [];
      collectionSnap.docs.forEach((doc) {
        CautionModel cm = CautionModel.preloaded(
          doc.id,
          doc.get('name'),
          doc.get('cautionText'),
        );
        modelList.add(cm);
      });
      return modelList;
    });
  }
}
