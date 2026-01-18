import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskRepository {
  final Box<TaskModel> _taskBox;

  TaskRepository(this._taskBox);


  List<TaskModel> getTasks() {
    return _taskBox.values.toList();
  }


  Future<void> addTask(TaskModel task) async {
    await _taskBox.put(task.id, task);
  }


  Future<void> updateTask(TaskModel task) async {
    if (_taskBox.containsKey(task.id)) {
      await _taskBox.put(task.id, task);
    }
  }


  Future<void> deleteTask(String taskId) async {
    await _taskBox.delete(taskId);
  }
}
