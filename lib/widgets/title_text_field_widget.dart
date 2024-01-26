import 'package:flutter/material.dart';
import '../../utils/color_constants.dart';

class TitleTextField extends StatelessWidget {
  final Size _size;
  final TextEditingController _titleController;

  const TitleTextField({
    super.key,
    required Size size,
    required TextEditingController controller,
  })  : _size = size,
        _titleController = controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      selectionControls: MaterialTextSelectionControls(),
      autofocus: true,
      controller: _titleController,
      maxLength: 80,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: 'Title',
        hintStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: AppColors.lightGray,
              fontSize: _size.width * 0.08,
            ),
        contentPadding: EdgeInsets.symmetric(
          vertical: _size.width * 0.02,
          horizontal: _size.width * 0.02,
        ),
        border: InputBorder.none,
      ),
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.white,
            fontSize: _size.width * 0.08,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}
