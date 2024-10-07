import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PartPaymentController extends GetxController {


  TextEditingController partPaymentAmount = TextEditingController();
  TextEditingController principleAmount = TextEditingController();
  TextEditingController interestRateAmount = TextEditingController();

  // Define an observable variable to store the part payment amount
  var partPaymentValue = '0'.obs;
  var principleValue = '2000'.obs;
  var interestRateValue = '8'.obs;



  @override
  void onInit() {
    super.onInit();

    // Add listener to update the observable variable whenever the text changes
    partPaymentAmount.addListener(() {
      partPaymentValue.value = partPaymentAmount.text;

    });
    principleAmount.addListener(() {
      principleValue.value = principleAmount.text;

    });
    interestRateAmount.addListener(() {
      interestRateValue.value = interestRateAmount.text;

    });
  }
}
