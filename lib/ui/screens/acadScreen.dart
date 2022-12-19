import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
/*import 'package:flutter_pin_code/flutter_pin_code.dart';*/


class QuestoionsScreen extends StatefulWidget {
  @override
  _QuestoionsScreenState createState() => _QuestoionsScreenState();
}

class _QuestoionsScreenState extends State<QuestoionsScreen> {

  final format = DateFormat("yyyy-MM-dd HH:mm");
  TextEditingController _mobile_controller = TextEditingController(text: "");
  TextEditingController _date_controller = TextEditingController(text: "");
  TextEditingController _message_controller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _mobile_controller,
                style: TextStyle(
                  fontSize: 20
                ),
                maxLength: 10,
                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                decoration: InputDecoration(
                  icon: Icon(Icons.phone,),
                ),
              ),
              DateTimeField(
                controller: _date_controller,
                format: format,
                decoration: InputDecoration(
                  icon: Icon(Icons.date_range)
                ),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _message_controller,
                minLines: 6,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "message",
                  hintStyle: TextStyle(
                    color: Colors.grey
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1)
                  )
                ),
              ),
              SizedBox(
                height: 50,
              ),
              FloatingActionButton.extended(onPressed: (){
                if(_mobile_controller.text!=""&&_date_controller.text!=""&&_message_controller.text!=""){
                  _newTaskModalBottomSheet(context, 999999);

                }else{
                }
              }, label: Text("Booking now"))
            ],
          ),
        ),
      )
    );
  }

  _send_otp(){}
  
  _postbooking(){}
  
  void _newTaskModalBottomSheet(context, int code) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
         /* return PinCodeView(
            correctPin: code,
            title: Text(
              'Please input PIN to continue',
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            subTitle: InkWell(
              onTap: () {
                Navigator.pop(context);
                _send_otp();
              },
              child: Text(
                'Forgot PIN?',
                style: TextStyle(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),
            errorMsg: 'Wrong PIN',
            onSuccess: (pin) {
              _postbooking();
              Navigator.pop(context);

            },
          );*/
          return Container();
        });

  }

}
