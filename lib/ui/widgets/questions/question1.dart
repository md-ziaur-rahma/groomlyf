import 'package:flutter/material.dart';
import 'package:groomlyfe/providers/gl_academy_provider.dart';
import 'package:groomlyfe/ui/widgets/questions/question2.dart';
import 'package:provider/provider.dart';

import 'dropdown/gzx_dropdown_menu.dart';

class Question1 extends StatefulWidget {
  @override
  _Question1State createState() => _Question1State();
}

class _Question1State extends State<Question1> {
  TextEditingController otherController = TextEditingController();
  FocusNode focusNode = FocusNode();
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  GlobalKey _stackKey = GlobalKey();
  bool isOtherCategory = false;
  String? answer1 = 'Business Category';
  bool dropdown = false;
  Map? map;

  TextStyle style1 = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    fontFamily: "phenomena-bold",
  );

  double height = 120.0;

  TextStyle style2 = TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    fontFamily: "phenomena-bold",
  );

  late GlAcademyProvider glAcademyProvider;

  @override
  void initState() {
    super.initState();
    glAcademyProvider = Provider.of<GlAcademyProvider>(context, listen: false);
    if (glAcademyProvider.question1 != null) {
      map = glAcademyProvider.question1;
      answer1 = glAcademyProvider.answer1;
      _selectTempFirstLevelIndex = glAcademyProvider.selectTempFirstLevelIndex;
      _selectFirstLevelIndex = glAcademyProvider.selectFirstLevelIndex;
      _selectSecondLevelIndex = glAcademyProvider.selectSecondLevelIndex;
    }
    glAcademyProvider.moveToLastPage();
  }

  @override
  void dispose() {
    otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          child: Stack(
            key: _stackKey,
            fit: StackFit.expand,
            alignment: Alignment.topCenter,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Question: What is your business category?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      fontFamily: "phenomena-bold",
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  GZXDropDownHeader(
                    items: [GZXDropDownHeaderItem(answer1)],
                    stackKey: _stackKey,
                    controller: _dropdownMenuController,
                    height: 50.0,
                    iconSize: 30.0,
                    iconColor: Colors.black,
                    borderColor: Colors.black,
                    borderWidth: 4.0,
                    iconDropDownColor: Colors.white,
                    dropDownStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "phenomena-bold",
                    ),
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      fontFamily: "phenomena-bold",
                    ),
                    onItemTap: (_) {
                      if (dropdown) {
                        height = 120.0;
                        dropdown = false;
                      } else {
                        height = 560;
                        dropdown = true;
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
              GZXDropDownMenu(
                controller: _dropdownMenuController,
                animationMilliseconds: 10,
                menus: [
                  GZXDropdownMenuBuilder(
                    dropDownHeight: 40 * 16.0,
                    dropDownWidget: _buildAddressWidget(
                      (selectValue) {
                        answer1 = selectValue;
                        map = {
                          firstLevels[_selectFirstLevelIndex]: selectValue
                        };
                        _dropdownMenuController.hide();
                        height = 120;
                        dropdown = false;
                        glAcademyProvider.setQuestion1(map, selectValue);
                        setState(() {});
                        glAcademyProvider.moveToLastPage();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (map != null) Question2(),
      ],
    );
  }

  List firstLevels = [
    'Beauty',
    'Fitness',
    'Nutrition',
    'Fashion',
    'Life Coaching',
    'Interior Design',
    'Photography',
    'Modeling',
    'Pet Grooming',
    'Tatooing',
    'Other',
  ];

  List<List> secondLevels = [
    [
      'Barber',
      'Stylist',
      'Loctician',
      'Braider',
      'Products (Hair)',
      'Hair Sales (Lashes)',
      'Skin Care',
      'Make Up Artist',
      'Start your own brand (Make up)',
    ],
    [
      'Coaching A Club',
      'Coaching A School',
      'Training',
      'Starting your Faciility',
      'Non Facility Owner of Fitness Brand',
    ],
    [
      'Meal Planning / Meal Prep',
      'Starting a restaurant or food truck',
      'Baking and Pastry',
      'Weight Loss',
      'B2B Sales',
    ],
    [
      'Men Apparel',
      'Men Shoes',
      'Women Apparel',
      'Women Shoes',
    ],
    ['Life Coaching'],
    ['Interior Design'],
    ['Photography'],
    ['Modeling'],
    ['Pet Grooming'],
    ['Body Piercing']
  ];

  int _selectTempFirstLevelIndex = 0;
  int _selectFirstLevelIndex = 0;
  int _selectSecondLevelIndex = -1;

  _buildAddressWidget(void itemOnTap(String selectValue)) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 120,
            child: ListView(
              children: firstLevels.map((item) {
                int index = firstLevels.indexOf(item);
                return InkWell(
                  onTap: () {
                    print(index);
                    if (item != "Other") {
                      isOtherCategory = false;
                      glAcademyProvider.selectTempFirstLevelIndex = index;
                    } else {
                      isOtherCategory = true;
                    }
                    setState(() {
                      _selectTempFirstLevelIndex = index;
                    });
                  },
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 5.0),
                    alignment: Alignment.centerLeft,
                    color: _selectTempFirstLevelIndex == index
                        ? Colors.grey[300]
                        : Colors.white,
                    child: _selectTempFirstLevelIndex == index
                        ? Text(
                            '$item',
                            overflow: TextOverflow.ellipsis,
                            style: style2,
                          )
                        : Text(
                            '$item',
                            overflow: TextOverflow.ellipsis,
                            style: style1,
                          ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: _selectTempFirstLevelIndex == 10
                  ? buildOtherWidget()
                  : ListView(
                      children:
                          secondLevels[_selectTempFirstLevelIndex].map((item) {
                        int index = secondLevels[_selectTempFirstLevelIndex]
                            .indexOf(item);
                        return InkWell(
                          autofocus: true,
                          highlightColor: Colors.blue.withOpacity(0.5),
                          onTap: () {
                            _selectSecondLevelIndex = index;
                            _selectFirstLevelIndex = _selectTempFirstLevelIndex;
                            glAcademyProvider.selectSecondLevelIndex = index;
                            glAcademyProvider.selectTempFirstLevelIndex =
                                _selectTempFirstLevelIndex;
                            itemOnTap(item);
                          },
                          child: Card(
                            child: Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                color: _selectFirstLevelIndex ==
                                            _selectTempFirstLevelIndex &&
                                        _selectSecondLevelIndex == index
                                    ? Colors.black87
                                    : Colors.transparent,
                                child: Text(
                                  '$item',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: "phenomena-bold",
                                    color: _selectFirstLevelIndex ==
                                                _selectTempFirstLevelIndex &&
                                            _selectSecondLevelIndex == index
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                )),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          )
        ],
      ),
    );
  }

  buildOtherWidget() {
    return Container(
      // color: Colors.green,
      child: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(left: 10, right: 50, top: 30),
        child: Column(
          children: [
            TextField(
              controller: otherController,
              focusNode: focusNode,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                hintText: 'Enter your business category',
              ),
              onChanged: (v) {},
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 6.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black, width: 3.0),
                ),
              ),
              child: Text(
                "Submit",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: "phenomena-bold",
                ),
              ),
              onPressed: () {
                print(otherController.text);
                if (otherController.text != "") {
                  glAcademyProvider.selectSecondLevelIndex = 100;
                  glAcademyProvider.selectTempFirstLevelIndex = 10;

                  answer1 = otherController.text;
                  map = {
                    firstLevels[_selectFirstLevelIndex]: otherController.text
                  };
                  _dropdownMenuController.hide();
                  height = 120;
                  dropdown = false;
                  glAcademyProvider.setQuestion1(map, otherController.text);
                  setState(() {});
                  glAcademyProvider.moveToLastPage();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
