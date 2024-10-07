

import 'package:fincalweb_project/controller/part_payment_controller.dart';
import 'package:get/get.dart';

Future<void> init() async{

  Get.lazyPut(()=> PartPaymentController(), fenix: true);

}