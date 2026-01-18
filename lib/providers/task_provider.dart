import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';

enum TaskFilter { all, completed, pending }

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;

  List<TaskModel> _tasks = [];
  TaskFilter _filter = TaskFilter.all;

  TaskProvider(this._repository) {
    loadTasks();
  }

  List<TaskModel> get tasks => _tasks;
  TaskFilter get filter => _filter;

  List<TaskModel> get filteredTasks {
    switch (_filter) {
      case TaskFilter.completed:
        return _tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.pending:
        return _tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.all:
      default:
        return _tasks;
    }
  }


  Future<void> loadTasks() async {
    _tasks = _repository.getTasks();
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await _repository.addTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    await _repository.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    await _repository.deleteTask(taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> toggleTaskStatus(TaskModel task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  int get pendingCount {
    return _tasks.where((t) => !t.isCompleted).length;
  }


  int get dueTodayCount {
    final now = DateTime.now();
    return _tasks.where((task) {
      final due = task.dueDate;
      return !task.isCompleted &&
          due.year == now.year &&
          due.month == now.month &&
          due.day == now.day;
    }).length;
  }

  int get yesterdayCount {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    return _tasks.where((task) {
      final due = task.dueDate;
      final taskDate = DateTime(due.year, due.month, due.day);

      return !task.isCompleted && taskDate == yesterday;
    }).length;
  }


}

