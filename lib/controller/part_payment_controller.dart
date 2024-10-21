import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PartPaymentController extends GetxController {
  TextEditingController partPaymentAmount = TextEditingController();
  TextEditingController principleAmount = TextEditingController();
  TextEditingController interestRateAmount = TextEditingController();

  // Define observable variables to store the part payment amount
  var partPaymentValue = '0'.obs;
  var principleValue = '2000'.obs;
  var interestRateValue = '7'.obs;

  // List to store part payment data
  final List<Map<String, dynamic>> partPayments = <Map<String, dynamic>>[].obs;


  @override
  void onInit() {
    super.onInit();

    // Add listeners to update observable variables whenever the text changes
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

  // Method to add a part payment
  void addPartPayment(int year, String month, double amount) {
    partPayments.add({'year': year, 'month': month, 'amount': amount});
    update(); // Notify listeners of the change
  }

  // Method to retrieve part payments
  List<Map<String, dynamic>> getPartPayments() {
    return partPayments;
  }

  // Optionally, a method to clear part payments if needed
  void clearPartPayments() {
    partPayments.clear();
    update(); // Notify listeners of the change
  }
}


//old code
/*import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PartPaymentController extends GetxController {


  TextEditingController partPaymentAmount = TextEditingController();
  TextEditingController principleAmount = TextEditingController();
  TextEditingController interestRateAmount = TextEditingController();

  // Define an observable variable to store the part payment amount
  var partPaymentValue = '0'.obs;
  var principleValue = '2000'.obs;
  var interestRateValue = '7'.obs;



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

 */
