import 'package:flutter/material.dart';

class CustomTimeField extends StatefulWidget {
  final FormFieldSetter<String> onSaved;
  final String label;

  const CustomTimeField({
    required this.onSaved,
    required this.label,
    Key? key}) : super(key: key);

  @override
  State<CustomTimeField> createState() => _CustomTimeFieldState();
}

class _CustomTimeFieldState extends State<CustomTimeField> {
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    timeController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onSaved: widget.onSaved,
            controller: timeController,
            decoration: InputDecoration(
                icon: Icon(Icons.calendar_today), //icon of text field
                labelText: '${widget.label} Time'
            ),
            onTap: () async {
              TimeOfDay? pickedDate = await showTimePicker(
                  context: context,
                  helpText: '${widget.label} Time',
                  initialTime: TimeOfDay.now(),
                  initialEntryMode: TimePickerEntryMode.input,
                  builder: (context, childWidget) {
                    return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                            alwaysUse24HourFormat: true // Using 24-Hour format
                        ),
                        child: childWidget!
                    );
                  }
              );

              if(pickedDate != null ){
                print(pickedDate);
                final hour = pickedDate.hour.toString().padLeft(2, "0");
                final min = pickedDate.minute.toString().padLeft(2, "0");
                final finalTime = "$hour:$min";
                setState(() {
                  timeController.text = finalTime; //set output date to TextField value.
                });
              }else{
                print("Date is not selected");
              }
            },
          ),
        ),
      ],
    );
  }
}

