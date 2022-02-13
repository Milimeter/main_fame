import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:login_signup_screen/constants/controllers.dart';
import 'package:login_signup_screen/controllers/algorand_controller.dart';
import 'package:login_signup_screen/sevices/algorand.dart';
import 'package:login_signup_screen/utils/colors.dart';
import 'package:algorand_dart/algorand_dart.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SendAlgoPayment extends StatefulWidget {
  const SendAlgoPayment({Key key}) : super(key: key);

  @override
  State<SendAlgoPayment> createState() => _SendAlgoPaymentState();
}

class _SendAlgoPaymentState extends State<SendAlgoPayment> {
  double amount = 15;

  final _formKey = GlobalKey<FormState>();

  final recipientController = TextEditingController();
  final AlgorandController _algorandController = Get.find();
  int balance = 0;
  getAccount() async {
    try {
      // print(userController.userData.value.publicAddress);
      // Account myAccount = await algorand
      //     .loadAccountFromSeed(userController.userData.value.seedPhrase);
      // final recipient = Address.fromAlgorandAddress(
      //     address: userController.userData.value.publicAddress);

      // print(userController.userData.value.publicAddress);
      //balance = info.amountWithoutPendingRewards;
      List<int> seed =
          List.from(userController.userData.value.privateKey.toList());
      // print("=====================--------1-----============ihf");
      // final myAccount =
      //     await _algorandController.algorand.loadAccountFromSeed(seed);

      // print("=====================-------2------============ihf");
      // // myAccount.publicKey 2KYBQ4WRCNWBDVJ76BK7W2QF4GXEBRECRUBP3GQNFN4R2O7MUODANEXKU4
      // print(myAccount.publicKey);

      //Method 1 to get balance
      AccountInformation info = await _algorandController.algorand
          .getAccountByAddress(userController.userData.value.publicAddress);

      print(info.amount);
      print(info.amountWithoutPendingRewards);
      //Method 2 to get balance
      balance = await _algorandController.algorand.getBalance(info.address);

      setState(() {});
      print("=====================-------------============ihf");
      print(balance);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'New transaction',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
              onPressed: () {
                showBarModalBottomSheet(
                  duration: Duration(milliseconds: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  context: context,
                  barrierColor: Colors.black.withOpacity(.6),
                  builder: (context) => Container(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: AlgoTransaction(),
                  ),
                );
              },
              icon: Icon(
                Icons.query_stats_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Balance',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.black),
              ),
              Text(
                "${balance.toString()} Algo",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 20),
              Text(
                'Amount',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.black),
              ),
              SpinBox(
                min: 1,
                max: double.infinity,
                value: 0,
                onChanged: (value) {
                  amount = value;
                },
                cursorColor: kPrimaryColor,
                step: 0.1,
                decimals: 2,
              ),
              const SizedBox(height: 20),
              Text(
                'Recipient wallet',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.black),
              ),
              TextFormField(
                controller: recipientController,
                decoration: InputDecoration(
                  hintText: "Enter Receiver Address",
                ),
                validator: (String v) {
                  final value = v ?? '';
                  if (!Address.isAlgorandAddress(value)) {
                    return 'Invalid Algorand address';
                  }

                  return null;
                },
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  final isValid = _formKey.currentState?.validate() ?? false;
                  if (isValid) {
                    await _algorandController.sendPayment(
                        amount: amount,
                        recipientAddress: recipientController.text);

                    setState(() {});
                  } else {
                    Get.snackbar("Error!", "Invalid Algorand Address");
                  }
                },
                child: Container(
                  height: 70,
                  width: size.width,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Send Payment",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlgoTransaction extends StatefulWidget {
  const AlgoTransaction({Key key}) : super(key: key);

  @override
  State<AlgoTransaction> createState() => _AlgoTransactionState();
}

class _AlgoTransactionState extends State<AlgoTransaction> {
  final AlgorandController _algorandController = Get.find();
  List<Transaction> transactions = [];
  getHistory() async {
    SearchTransactionsResponse transactionsResponse = await _algorandController
        .algorand
        .indexer()
        .transactions()
        .forAccount(userController.userData.value.publicAddress)
        .whereTransactionType(TransactionType.PAYMENT)
        .search(limit: 50);
    transactions = transactionsResponse.transactions;
    setState(() {});
  }

  @override
  void initState() {
    getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.02),
                Text(
                  " Your transaction details",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                transactions.isEmpty
                    ? Text("You have no payment transactions at the moment")
                    : Flexible(
                      child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: transactions.length,
                          itemBuilder: (widget, index) => Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    transactions[index].id,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                                Spacer(),
                                Icon(Octicons.sync_icon),
                                Text((transactions[index]
                                    .closingAmount
                                    .toString()))
                              ],
                            ),
                          ),
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(color: kPrimaryColor);
                          },
                        ),
                    ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
