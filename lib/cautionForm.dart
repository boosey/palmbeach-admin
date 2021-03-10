import 'package:flutter/material.dart';
import 'package:admin/model/caution.dart';
import 'package:quiver/async.dart';

class CautionWidget extends StatefulWidget {
  final CautionModel cautionModel;
  final Function? onDeleted;
  final Function? onSaved;

  CautionWidget({
    required Key key,
    required this.cautionModel,
    this.onDeleted,
    this.onSaved,
  }) : super(key: key);

  @override
  _CautionWidgetState createState() => _CautionWidgetState();
}

class _CautionWidgetState extends State<CautionWidget> {
  late TextEditingController nameCtlr;
  late TextEditingController cautionCtlr;
  CountdownTimer timer = CountdownTimer(
    Duration(seconds: 0),
    Duration(seconds: 1),
  );
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameCtlr = TextEditingController(text: widget.cautionModel.name);
    cautionCtlr = TextEditingController(text: widget.cautionModel.cautionText);
  }

  @override
  void dispose() {
    nameCtlr.dispose();
    cautionCtlr.dispose();
    super.dispose();
  }

  void validateAndSave(String value) {
    timer.cancel();
    timer = CountdownTimer(Duration(seconds: 1), Duration(seconds: 1));
    timer.forEach((element) {
      if (!widget.cautionModel.isNew()) {
        widget.cautionModel.name = nameCtlr.text;
        widget.cautionModel.cautionText = cautionCtlr.text;
        widget.cautionModel.save();
        widget.onSaved?.call();
      }
    });
  }

  void validateAndSaveNew() {
    widget.cautionModel.setSaved();
    validateAndSave('');
  }

  void delete() {
    widget.cautionModel.delete();
    widget.onDeleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nameCtlr,
                  onChanged: validateAndSave,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.length >= 3) {
                      return null;
                    } else {
                      return "Names must be at least 3 characters";
                    }
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                      child: TextFormField(
                        controller: cautionCtlr,
                        maxLines: null,
                        onChanged: validateAndSave,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Caution',
                        ),
                        validator: (value) {
                          if (value!.length >= 10) {
                            return null;
                          } else {
                            return "Cautions must be at least 10 characters";
                          }
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.cautionModel.isNew(),
                    child: IconButton(
                      icon: Icon(Icons.check),
                      splashRadius: 18,
                      iconSize: 24,
                      padding: EdgeInsets.fromLTRB(12, 22, 12, 22),
                      onPressed: () {
                        validateAndSaveNew();
                      },
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              splashRadius: 18,
              iconSize: 24,
              padding: EdgeInsets.fromLTRB(12, 22, 12, 22),
              onPressed: delete,
            ),
          ],
        ),
      ),
    );
  }
}
