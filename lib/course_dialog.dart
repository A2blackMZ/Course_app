// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsmart/provider/course_provider.dart';

class CourseDialog extends StatefulWidget {
  final Course? course;

  const CourseDialog({Key? key, this.course}) : super(key: key);

  @override
  _CourseDialogState createState() => _CourseDialogState();
}

class _CourseDialogState extends State<CourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _articleNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.course != null) {
      _articleNameController.text = widget.course!.articleName;
      _categoryController.text = widget.course!.category;
      _quantityController.text = widget.course!.quantity.toString();
    }
  }

  @override
  void dispose() {
    _articleNameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _performSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<CourseProvider>(context, listen: false);

    if (widget.course == null) {
      provider.addCourse(
        _articleNameController.text,
        _categoryController.text,
        int.parse(_quantityController.text),
      );
    } else {
      provider.updateCourse(
        widget.course!.id,
        _articleNameController.text,
        _categoryController.text,
        int.parse(_quantityController.text),
      );
    }

    Navigator.of(context).pop();
  }

  String? _validateStringField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    } else if (fieldName.toLowerCase() == 'category' && int.tryParse(value) != null) {
      return "Please enter a valid string for $fieldName";
    }
    return null;
  }

  String? _validateIntField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    } else if (int.tryParse(value) == null) {
      return "Please enter a valid integer for $fieldName";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.course == null
                  ? "Add New Shopping Item"
                  : "Edit Shopping Item",
              style: textTheme.headline6,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _articleNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Article Name",
              ),
              validator: (value) => _validateStringField(value, "Article Name"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Category",
              ),
              validator: (value) => _validateStringField(value, "Category"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Quantity",
              ),
              validator: (value) => _validateIntField(value, "Quantity"),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextButton(
                      onPressed: _performSave,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Add"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
