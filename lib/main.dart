import 'package:fincalweb_project/view/Calculators/emi-calculator.dart';
import 'package:fincalweb_project/view/Calculators/fd-calculator.dart';
import 'package:fincalweb_project/view/Calculators/kvp-calculator.dart';
import 'package:fincalweb_project/view/Calculators/mf-calculator.dart';
import 'package:fincalweb_project/view/Calculators/nsc-calculator.dart';
import 'package:fincalweb_project/view/Calculators/ppf-calculator.dart';
import 'package:fincalweb_project/view/Calculators/rd-calculator.dart';
import 'package:fincalweb_project/view/Calculators/scss-calculator.dart';
import 'package:fincalweb_project/view/Calculators/sip-calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helper/get_di.dart' as di;
import 'helper/size_config.dart';
import 'package:fincalweb_project/view/HomePage.dart';
import 'package:fincalweb_project/view//calculators.dart';
import 'package:fincalweb_project/components/emi_calculator_components/partpayment_table.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return OrientationBuilder(
            builder: (BuildContext context2, Orientation orientation) {
              SizeConfig.init(constraints, orientation);
              return GetMaterialApp(
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF3D48A)),
                  primaryColor: Color(0xFFF3D48A),
                ),
               //home: PartPaymentTable(),
                initialRoute: '/',
                routes: {
                  '/': (context) => HomePage(),
                  '/calculators': (context) => AllCalculators(title: '', content: '',),
                  '/fd-calculator':(context) => FdCalculator(),
                  '/rd-calculator':(context) => RdCalculator(),
                  '/sip-calculator':(context) => SipCalculator(),
                  '/mf-calculator':(context) => MfCalculator(),
                  '/ppf-calculator':(context) => PpfCalculator(),
                  '/nsc-calculator':(context) =>NscCalculator(),
                  '/kvp-calculator':(context) =>KvpCalculator(),
                  '/scss-calculator':(context) =>ScssCalculator(),
                  '/emi-calculator':(context) =>EmiCalculator(),
                },
                debugShowCheckedModeBanner: false,
              );
            },
          );
        });
  }
}
