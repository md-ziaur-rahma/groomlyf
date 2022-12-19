import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ToastShow{
  ToastShow(this.msg,this.context,this.textcolor);
  final Color? textcolor;
  final String msg;
  final BuildContext? context;
  init(){
    ToastContext().init(context!);
    Toast.show(msg, textStyle: TextStyle(color: textcolor),backgroundColor: Colors.white,backgroundRadius: 1, border: Border.all(color:Colors.black,width: 1),duration: Toast.lengthLong,gravity: Toast.bottom);
  }
}