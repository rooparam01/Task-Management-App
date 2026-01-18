import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/core/constants/common_colors.dart';
import 'package:taskmanager/ui/widgets/custom_text_form_field.dart';

import '../../../data/models/task_model.dart';
import '../../../providers/task_provider.dart';
import '../../widgets/custom_app_bar.dart';

class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({super.key, this.task, });
  final TaskModel? task;

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime? _dueDate;
  bool _isCompleted = false;
  TaskModel? _editingTask;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _editingTask = widget.task;
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _isCompleted = widget.task!.isCompleted;
      _dateController.text =
          DateFormat('dd MMM yyyy').format(widget.task!.dueDate);
    }
  }


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateController.text =
            DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select due date')),
      );
      return;
    }

    final provider = context.read<TaskProvider>();

    if (_editingTask != null) {
      provider.updateTask(
        _editingTask!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _dueDate!,
          isCompleted: _isCompleted,
        ),
      );
    } else {
      provider.addTask(
        TaskModel(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _dueDate!,
          isCompleted: _isCompleted,
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: CustomAppBar(
            title: _editingTask != null ? 'Edit Task' : 'Add Task',
            backgroundColor: AppColors.background,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildField(
                  controller: _titleController,
                  label: 'Title',
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Title required' : null,
                ),

                const SizedBox(height: 16),

                _buildField(
                  controller: _descriptionController,
                  label: 'Description',
                  maxLines: 3,
                ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: _pickDueDate,
                  child: AbsorbPointer(
                    child: _buildField(
                      controller: _dateController,
                      label: 'Due Date',
                      suffixIcon: Icons.calendar_today_outlined,
                      validator: (v) =>
                      v == null || v.isEmpty ? 'Due Date required' : null,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SwitchListTile(
                  value: _isCompleted,
                  onChanged: (val) {
                    setState(() => _isCompleted = val);
                  },
                  title: const Text('Mark as Completed'),
                  activeColor: const Color(0xFF16A34A),
                  inactiveThumbColor: AppColors.primary,
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _editingTask != null ? 'Update Task' : 'Add Task',
                    style: const TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    IconData? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return CustomTextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      labelText: label,
    );
  }
}

