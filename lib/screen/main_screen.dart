import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/calculate_controller.dart';

///
import '../controller/theme_controller.dart';
import '../utils/colors.dart';
import '../widget/button.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isHistoryOn = false;

  final List<String> buttons = [
    "C",
    "DEL",
    "%",
    "/",
    "7",
    "8",
    "9",
    "x",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "",
    "0",
    ".",
    "=",
  ];

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CalculateController>();
    var themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(builder: (context) {
      return Scaffold(
        backgroundColor: themeController.isDark
            ? DarkColors.scaffoldBgColor
            : LightColors.scaffoldBgColor,
        body: SafeArea(
          child: Column(
            children: [
              GetBuilder<CalculateController>(builder: (context) {
                return outPutSection(themeController, controller);
              }),
              inPutSection(themeController, controller),
            ],
          ),
        ),
      );
    });
  }

  /// In put Section - Enter Numbers
  Expanded inPutSection(
      ThemeController themeController, CalculateController controller) {
    return Expanded(
        flex: 3,
        child: Container(
          padding: const EdgeInsets.all(3),
          child: Column(children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isHistoryOn = !isHistoryOn;
                        });

                        print("History option clicked");
                      },
                      icon: Icon(
                        Icons.history,
                        color: themeController.isDark
                            ? Colors.white
                            : Colors.black,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.straighten,
                        color: themeController.isDark
                            ? Colors.white
                            : Colors.black,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calculate,
                        color: themeController.isDark
                            ? Colors.white
                            : Colors.black,
                      )),
                  Container(),
                  Container(),
                  Container(),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.backspace_outlined,
                        color: themeController.isDark
                            ? Colors.white
                            : Colors.black,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Divider(
                  thickness: 1.5,
                  color: themeController.isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            isHistoryOn == true
                ? Column(
                    children: [
                      Container(
                        height: 300,
                        child: Obx(() => (ListView.builder(
                            shrinkWrap: true,
                            primary: true,

                            ///history
                            scrollDirection: Axis.vertical,
                            itemCount: controller.listOfLastTransactions.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${controller.listOfLastTransactions[index]}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: themeController.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 22),
                                    ),
                                    Text(
                                      '${controller.listOfLastTransactionsOutput[index]}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: themeController.isDark
                                              ? Colors.green
                                              : Colors.green,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              );
                            }))),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.transactionClear();
                          Get.snackbar("History Cleared",
                              "Last Calculation History Cleared",
                              colorText: Colors.white);
                        },
                        child: Container(
                          height: 60,
                          width: 200,
                          decoration: BoxDecoration(
                              color: themeController.isDark
                                  ? Colors.green
                                  : LightColors.btnBgColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: Text(
                              "Clear History",
                              style: TextStyle(
                                color: themeController.isDark
                                    ? Colors.white
                                    : LightColors.leftOperatorColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: buttons.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemBuilder: (contex, index) {
                      switch (index) {

                        /// CLEAR BTN
                        case 0:
                          return CustomButton(
                              buttonTapped: () {
                                controller.clearInputAndOutput();
                              },
                              color: themeController.isDark
                                  ? DarkColors.btnBgColor
                                  : LightColors.btnBgColor,
                              textColor: themeController.isDark
                                  ? Colors.red
                                  : LightColors.leftOperatorColor,
                              text: buttons[index]);

                        /// DELETE BTN
                        case 1:
                          return CustomButton(
                              buttonTapped: () {
                                controller.deleteBtnAction();
                              },
                              color: themeController.isDark
                                  ? DarkColors.btnBgColor
                                  : LightColors.btnBgColor,
                              textColor: themeController.isDark
                                  ? DarkColors.leftOperatorColor
                                  : LightColors.leftOperatorColor,
                              text: buttons[index]);

                        /// EQUAL BTN
                        case 19:
                          return CustomButton(
                              buttonTapped: () {
                                controller.equalPressed();
                              },
                              color: themeController.isDark
                                  ? Colors.green
                                  : LightColors.btnBgColor,
                              textColor: themeController.isDark
                                  ? Colors.white
                                  : LightColors.leftOperatorColor,
                              text: buttons[index]);

                        default:
                          return CustomButton(
                              buttonTapped: () {
                                controller.onBtnTapped(buttons, index);
                              },
                              color: themeController.isDark
                                  ? DarkColors.btnBgColor
                                  : LightColors.btnBgColor,
                              textColor: isOperator(buttons[index])
                                  ? LightColors.operatorColor
                                  : themeController.isDark
                                      ? Colors.white
                                      : Colors.black,
                              text: buttons[index]);
                      }
                    }),
          ]),
        ));
  }

  /// Out put Section - Show Result
  Expanded outPutSection(
      ThemeController themeController, CalculateController controller) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.topCenter,
          width: 100,
          height: 45,
          decoration: BoxDecoration(
              color: themeController.isDark
                  ? DarkColors.sheetBgColor
                  : LightColors.sheetBgColor,
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    themeController.lightTheme();
                  },
                  child: Icon(
                    Icons.light_mode_outlined,
                    color: themeController.isDark ? Colors.grey : Colors.black,
                    size: 25,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    themeController.darkTheme();
                  },
                  child: Icon(
                    Icons.dark_mode_outlined,
                    color: themeController.isDark ? Colors.white : Colors.grey,
                    size: 25,
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 70),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  controller.userInput,
                  style: TextStyle(
                      color:
                          themeController.isDark ? Colors.white : Colors.black,
                      fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(controller.userOutput,
                    style: TextStyle(
                        color: themeController.isDark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 32)),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  ///
  bool isOperator(String y) {
    if (y == "%" || y == "/" || y == "x" || y == "-" || y == "+" || y == "=") {
      return true;
    }
    return false;
  }
}
