import 'package:flutter/material.dart';

Widget warningDialog(BuildContext context, String warningText){
  return AlertDialog(
        title: const Text('Informacja'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(warningText),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
}