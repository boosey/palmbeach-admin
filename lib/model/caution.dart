import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum LifecycleState { created, saved, invalid, deleted, unknown }

class CautionModel extends ChangeNotifier {
  static CollectionReference _cautionsCollection =
      FirebaseFirestore.instance.collection('cautions');

  String? id;
  String _name = '';
  String _cautionText = '';
  LifecycleState lifecycleState = LifecycleState.unknown;
  bool _dirty = false;

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
    _dirty = true;
  }

  void clearDirty() {
    _dirty = false;
  }

  bool isDirty() {
    return _dirty;
  }

  void setSaved() {
    lifecycleState = LifecycleState.saved;
  }

  bool isSaved() {
    return lifecycleState == LifecycleState.saved;
  }

  bool isNew() {
    return lifecycleState == LifecycleState.created;
  }

  bool isDeleted() {
    return lifecycleState == LifecycleState.deleted;
  }

  bool isUnknownState() {
    return lifecycleState == LifecycleState.unknown;
  }

  CautionModel.empty();

  CautionModel.createNew() {
    lifecycleState = LifecycleState.created;
  }

  CautionModel.preloaded(
    this.id,
    this._name,
    this._cautionText,
    int lifecycleStateIdx,
  ) {
    this.lifecycleState = LifecycleState.values.elementAt(lifecycleStateIdx);
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
      "lifecycleStateIdx": lifecycleState.index,
    });
  }

  void save() {
    if (isDirty()) {
      if (isDeleted()) {
        _cautionsCollection.doc(id).set(documentMap());
        clearDirty();
      } else if (isNew() || isSaved()) {
        if (isValid()) {
          setSaved();
          _cautionsCollection.doc(id).set(documentMap());
        } else {
          lifecycleState = LifecycleState.invalid;
        }
      }
    }
  }

  void delete() {
    lifecycleState = LifecycleState.deleted;
    _cautionsCollection.doc(id).set(documentMap());
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
        .where('lifecycleStateIdx', isEqualTo: LifecycleState.saved.index)
        .snapshots()
        .map<List<CautionModel>>((collectionSnap) {
      List<CautionModel> modelList = [];
      var docs = collectionSnap.docs;

      docs.sort((d1, d2) {
        return (d1.data()!['name'] as String)
            .compareTo(d2.data()!['name'] as String);
      });

      docs.forEach((doc) {
        CautionModel cm = CautionModel.preloaded(
          doc.id,
          doc.get('name'),
          doc.get('cautionText'),
          doc.get('lifecycleStateIdx'),
        );
        modelList.add(cm);
      });
      return modelList;
    });
  }
}
