import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculateController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    callDB();
  }

  /*
  UserInput = What User entered with the keyboard .
  UserOutput = Calculate the numbers that the user entered and put into userOutPut variable.
  */

  var userInput = "";
  var userOutput = "";

  ///LIST OF LAST 10 TRANSACTIONS:
  RxList<String> listOfLastTransactions = RxList();
  RxList<String> listOfLastTransactionsOutput = RxList();

  callDB() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      List<String>? items = prefs.getStringList('calculations');
      listOfLastTransactions = RxList(items as List<String>);
      List<String>? outputs = prefs.getStringList('output');
      listOfLastTransactionsOutput = RxList(outputs as List<String>);
    } on Exception catch (e) {
      print("Catched Error on callDB ==> $e");
    }
    print('Printing Created List on INIT ==> ${listOfLastTransactions}');
    print('Printing Created List on INIT ==> ${listOfLastTransactionsOutput}');
    update();
  }

  transactionSavetoDB() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('calculations', listOfLastTransactions);
    await prefs.setStringList('output', listOfLastTransactionsOutput);
    print("${listOfLastTransactions} Saved on sharedPreference ");
    print("${listOfLastTransactionsOutput} Saved on sharedPreference ");
  }

  transactionClear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('calculations');
    await prefs.remove('output');
    print("Successfully Cleared DB");
    listOfLastTransactions.clear();
    listOfLastTransactionsOutput.clear();

    update();
  }

  /// Equal Button Pressed Func
  equalPressed() {
    String userInputFC = userInput;
    userInputFC = userInputFC.replaceAll("x", "*");
    Parser p = Parser();
    Expression exp = p.parse(userInputFC);
    ContextModel ctx = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, ctx);

    userOutput = eval.toString();
    listOfLastTransactions.add("${userInput.toString()}");
    listOfLastTransactionsOutput.add("${userOutput.toString()}");
    transactionSavetoDB();
    update();
  }

  /// Clear Button Pressed Func
  clearInputAndOutput() {
    userInput = "";
    userOutput = "";
    update();
  }

  /// Delet Button Pressed Func
  deleteBtnAction() {
    userInput = userInput.substring(0, userInput.length - 1);
    update();
  }

  /// on Number Button Tapped
  onBtnTapped(List<String> buttons, int index) {
    userInput += buttons[index];
    update();
  }
}
