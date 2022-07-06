import 'package:get/get.dart';
import 'package:remember_app/db_helper.dart';
import 'package:remember_app/task_data.dart';

class TaskController extends GetxController{

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task){
    DBHelper.delete(task);
    getTasks();
  }

  Future<void> markTAskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}