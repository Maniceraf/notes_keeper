import 'package:flutter/material.dart';
import '../../utils/color_constants.dart';
import 'dialog_action_button.dart';

Future<bool> showDeleteNoteDialog(BuildContext context) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete a note',
            style: TextStyle(
              color: AppColors.darkGray,
            )),
        content: const Text(
          'Do you really want to delete the note?',
          style: TextStyle(
            color: AppColors.darkGray,
          ),
        ),
        actions: [
          buildDialogActionButton(
              'No', Colors.redAccent, () => Navigator.pop(context, false)),
          buildDialogActionButton(
              'Yes', Colors.green.shade500, () => Navigator.pop(context, true)),
        ],
      );
    },
  );
}
