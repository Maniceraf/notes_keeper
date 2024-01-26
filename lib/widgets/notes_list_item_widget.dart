import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/note.dart';
import '../../utils/color_constants.dart';
import '../../utils/helper_widgets.dart';

class NotesListItem extends StatelessWidget {
  final Random random = Random();
  final Note note;
  final Size size;
  final VoidCallback onTap;

  NotesListItem({
    super.key,
    required this.size,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.list[random.nextInt(AppColors.list.length)],
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.white,
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title!,
                maxLines: 2,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: size.width * 0.050,
                    ),
              ),
              addVerticalSpace(size.width * 0.015),
              Text(
                DateFormat.yMMMd().format(note.time!),
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: size.width * 0.035,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
