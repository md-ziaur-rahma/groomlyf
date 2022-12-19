import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';

//video uplaod setting modal
class MyDialog extends StatefulWidget {
  final Uint8List? image;
  final String? video_title;
  final String? video_category;
  final String? video_description;
  final String? video_tag;
  final bool isEditing;
  final String? thumb_url;
  MyDialog(
    this.image, {
    this.video_title = "",
    this.video_category = "",
    this.video_description = "",
    this.video_tag = "",
    this.thumb_url = "",
    this.isEditing = false,
  });
  @override
  _MyDialogState createState() => new _MyDialogState(image);
}

class _MyDialogState extends State<MyDialog> {
  List<String> mockResults = ["*DIY", "*HAIR", "*RANDOM"];
  Uint8List? image;
  _MyDialogState(this.image);

  String? dropdownValue1 = 'DIY';
  String? dropdownValue2 = 'DIY';

  TextEditingController uploadedVideoNameController = TextEditingController();
  TextEditingController uploadedVideoTagController = TextEditingController();

  @override
  void initState() {
    if (widget.isEditing == true) {
      uploadedVideoNameController.text = widget.video_title!;
      dropdownValue1 = widget.video_category;
      dropdownValue2 = widget.video_description;
      uploadedVideoTagController.text = widget.video_tag!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: new Opacity(
        opacity: 1.0,
        child: new Container(
            child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.isEditing ? "Edit Shine" : "New Shine",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "phenomena-bold",
                  fontSize: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Container(
                height: device_height - 175,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: widget.isEditing
                          ? Image.network(
                              widget.thumb_url!,
                              fit: BoxFit.cover,
                              height: (device_height - 435),
                              width: device_width - 80,
                            )
                          : Image.memory(
                              image!,
                              fit: BoxFit.cover,
                              height: (device_height - 435),
                              width: device_width - 80,
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 255,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Title of the Video",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12),
                            ),
                          ),
                          Container(
                              height: 30,
                              padding: EdgeInsets.only(left: 10),
                              child: TextField(
                                controller: uploadedVideoNameController,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                                maxLines: 1,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 10, bottom: 10, right: 0),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1)),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Choose the category",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: (device_width - 120) / 2,
                                          child: DropdownButton<String>(
                                            value: dropdownValue1,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 24,
                                            elevation: 16,
                                            isExpanded: true,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.5,
                                            ),
                                            underline: Container(
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownValue1 = newValue;
                                              });
                                            },
                                            items: <String>[
                                              'Gaming',
                                              'Fashion',
                                              'Music',
                                              'Hair',
                                              'Sports',
                                              'Health and Fitness',
                                              'DIY',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text("$value"),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      width: (device_width - 140) / 2,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: DropdownButton<String>(
                                        value: dropdownValue2,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        isExpanded: true,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.5,
                                        ),
                                        underline: Container(
                                          height: 1,
                                          color: Colors.white,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue2 = newValue;
                                          });
                                        },
                                        items: <String>[
                                          'Gaming',
                                          'Fashion',
                                          'Music',
                                          'Hair',
                                          'Sports',
                                          'Health and Fitness',
                                          'DIY'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                    "assets/category/$value.png")
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "Add * tags",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 12),
                                  ),
                                ),
//                                  Container(
//                                    width: device_width-200,
//                                    height: 30,
//                                    child: ChipsInput(
//                                      initialValue: [
//                                        "*RANDOM"
//                                      ],
//                                      textStyle: TextStyle(
//                                        fontSize:16
//                                      ),
//                                      decoration: InputDecoration(
//                                          contentPadding: EdgeInsets.all(1),
//                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
//                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
//                                      ),
//                                      maxChips: 1,
//                                      findSuggestions: (String query) {
//                                        if (query.length != 0) {
//                                          var lowercaseQuery = query.toLowerCase();
//                                          return mockResults.where((profile) {
//                                            return profile.toLowerCase().contains(query.toLowerCase()) || profile.toLowerCase().contains(query.toLowerCase());
//                                          }).toList(growable: false)
//                                            ..sort((a, b) => a
//                                                .toLowerCase()
//                                                .indexOf(lowercaseQuery)
//                                                .compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
//                                        } else {
//                                          return const <String>[];
//                                        }
//                                      },
//                                      onChanged: (data) {
//                                        print(data);
//                                        uploaded_video_tag = data.isEmpty?"*RANDOM":data[0];
//                                      },
//                                      chipBuilder: (context, state, profile) {
//                                        return Container(
//                                          height: 20,
//                                          padding: EdgeInsets.only(top: 2),
//                                          child: InputChip(
//                                            key: ObjectKey(profile),
//                                            label: Text(profile),
//                                            onDeleted: () => state.deleteChip(profile),
//                                            labelPadding: EdgeInsets.all(0),
//                                            backgroundColor: Colors.white,
//                                            labelStyle: TextStyle(
//                                                fontSize: 12,
//                                                color: Colors.black
//                                            ),
//                                            deleteIcon: Icon(Icons.close,size: 14,),
//                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                                          ),
//                                        );
//                                      },
//                                      suggestionBuilder: (context, state, profile) {
//                                        return ListTile(
//                                          key: ObjectKey(profile),
//                                          title: Text(profile,style: TextStyle(fontSize: 12),),
//                                          onTap: () => state.selectSuggestion(profile),
//                                        );
//                                      },
//                                    ),
//                                  )
                                Container(
                                  width: device_width - 200,
                                  height: 30,
                                  child: TextField(
                                    controller: uploadedVideoTagController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(5),
                                      hintText: "*DIY, *HAIR, *RANDOM",
                                      hintStyle: TextStyle(
                                          fontSize: 10, color: Colors.black87),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black87)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black87)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          InkWell(
                            onTap: () {
                              uploaded_video_title =
                                  uploadedVideoNameController.text;
                              uploaded_video_category = "$dropdownValue1";
                              uploaded_video_description = "$dropdownValue2";
                              uploaded_video_tag =
                                  uploadedVideoTagController.text == ""
                                      ? "Random"
                                      : uploadedVideoTagController.text;
                              Navigator.pop(context, "success");
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                              alignment: Alignment.center,
                              child: Text(
                                widget.isEditing
                                    ? "Update Shine"
                                    : "Add to venue",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
