import 'package:flutter/material.dart';

import 'cautionForm.dart';
import 'model/caution.dart';

class CautionManagementUI extends StatefulWidget {
  CautionManagementUI({Key key}) : super(key: key);

  @override
  _CautionManagementUIState createState() => _CautionManagementUIState();
}

class _CautionManagementUIState extends State<CautionManagementUI> {
  CautionModel newCM;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    setState(() {
                      newCM = CautionModel(
                        '',
                        '',
                      );
                    });
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
          Visibility(
            visible: newCM != null,
            child: CautionWidget(
              cautionModel: newCM,
              onDeleted: () {
                setState(() {
                  newCM = null;
                });
              },
            ),
          ),
          StreamBuilder<List<CautionModel>>(
            stream: CautionModelCollection().stream(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Column(
                      children: snapshot.data
                          .map<CautionWidget>(
                              (cm) => CautionWidget(cautionModel: cm))
                          .toList())
                  : Text('Add some cautions');
            },
          ),
        ],
      ),
    );
  }
}
