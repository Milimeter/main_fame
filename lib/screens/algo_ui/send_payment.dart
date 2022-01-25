import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:get/get.dart';
import 'package:login_signup_screen/controllers/algorand_controller.dart';
import 'package:login_signup_screen/utils/colors.dart';
import 'package:algorand_dart/algorand_dart.dart';

class SendAlgoPayment extends StatefulWidget {
  const SendAlgoPayment({Key key}) : super(key: key);

  @override
  State<SendAlgoPayment> createState() => _SendAlgoPaymentState();
}

class _SendAlgoPaymentState extends State<SendAlgoPayment> {
  double amount = 0;

  final _formKey = GlobalKey<FormState>();

  final recipientController = TextEditingController();
  final AlgorandController _algorandController = Get.find();

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                decimals: 1,
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
                onTap: () {
                  final isValid = _formKey.currentState?.validate() ?? false;
                  if (isValid) {
                    _algorandController.sendPayment(
                        amount: amount,
                        recipientAddress: recipientController.text);
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
