import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remember_app/button.dart';
import 'package:remember_app/input_field.dart';
import 'package:remember_app/task_controller.dart';
import 'package:remember_app/task_data.dart';
import 'package:remember_app/themes.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({ Key? key }) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [ 5, 10, 15, 20, ];
  String _selectedRepeat = "None";
  List<String> repeatList = [ "None", "Daily", "Weekly", "Monthly", ];
  int _selectedColor = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingstyle,
              ),
              MyInputField(title: "Title", hint: 'Enter your title', controller: _titleController,),
              MyInputField(title: "Note", hint: 'Enter your note', controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined, color: Colors.grey,),
                onPressed: (){
                  _getDateFromUser();
                },
              ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(title: "Start Date", hint: _startTime,
                    widget: IconButton(
                      onPressed: () {
                         _getTimeFromUser(isStartTime: true);
                      },
                      icon: Icon(Icons.access_time_rounded, color: Colors.grey,),
                    ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(title: "End Date", hint: _endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: Icon(Icons.access_time_rounded, color: Colors.grey,),
                    ),
                    ),
                  )
                ],
              ),
              MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
              widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                iconSize: 32,
                underline: Container(height: 0,),
                elevation: 4,
                style: subtitleStyle,
                items: remindList.map<DropdownMenuItem<String>>((int value){
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString())
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    _selectedRemind = int.parse(newValue!);
                  });
                },
              ),
              ),
              MyInputField(title: "Repeat", hint: _selectedRepeat,
              widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                iconSize: 32,
                underline: Container(height: 0,),
                elevation: 4,
                style: subtitleStyle,
                items: repeatList.map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.grey),)
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    _selectedRepeat = newValue!;
                  });
                },
              ),
              ),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallete(),
                  MyButton(label: 'Create Task', onTap: () => _valiDateDate()),
                ],
              ),
              Container(height: 20,),

            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor ,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color:Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        const CircleAvatar(
          backgroundImage: AssetImage(
            "img/mine.jpg",
          ),
        ),
        const SizedBox(width: 15,)
      ],
    );
  }

  _getDateFromUser()  async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2025)
    );
    if(_pickerDate != null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }else{
      print('something is wrong baby');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker(); 
    
    if(pickedTime == null){
      print("Time canceled");
    }else if(isStartTime == true){
      String _formatedTime = pickedTime.format(context);
        setState(() {
          _startTime = _formatedTime;
        });
    }else if (isStartTime == false){
      String _formatedTime = pickedTime.format(context);
        setState(() {
          _endTime = _formatedTime;
        });
    }
  }

  _showTimePicker(){
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: int.parse(_startTime.split(":")[0]), minute: int.parse(_startTime.split(":")[1].split(" ")[0])),
      initialEntryMode: TimePickerEntryMode.input,
    );
  }

  _colorPallete(){
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Color",
              style: titleStyle,
              ),
              SizedBox(height: 8,),
              Wrap(
                children: List<Widget>.generate(
                  3,
                  (int index){
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectedColor = index ;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: index == 0 ? primaryClr : index == 1 ? pinkClr : yellowClr,
                          child: _selectedColor == index ? Icon(Icons.done,
                          color: Colors.white,
                          size: 16,
                        ) : Container(),
                      ),
                    ));
                  }
                ),
              )
            ],
          );
}

  _valiDateDate(){
    if(_noteController.text.isNotEmpty && _titleController.text.isNotEmpty){
      _addTaskToDb();
      Get.back();
    }else if(_noteController.text.isEmpty || _titleController.text.isEmpty || _titleController.){
      Get.snackbar("Required", "All fields are required !!",
        snackPosition: SnackPosition.BOTTOM,
        colorText: pinkClr,
        backgroundColor: Colors.white,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red,)
      );
    }
  }

  _addTaskToDb() async {
    int id = await _taskController.addTask(
      task: Task(
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0,
    )
    );
    print("My id is"+"$id");
  }

}