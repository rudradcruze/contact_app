import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

void showSingleTextInputDialog({
  required BuildContext context,
  required String title,
  required String hintText,
  TextInputType textInputType = TextInputType.text,
  String positiveButtonText = 'UPDATE',
  String negativeButtonText = 'CANCEL',
  required IconData iconData,
  required Function(String) onSave,
}) {
  var controller = TextEditingController();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: TextFormField(
              keyboardType: textInputType,
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: Icon(iconData),
                hintText: hintText,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.isEmpty) return;
                  Navigator.of(context).pop();
                  onSave(controller.text);
                  // updateContact(fromEditKey, context, id, column, controller);
                },
                child: const Text(
                  'UPDATE',
                ),
              ),
            ],
          ));
}
