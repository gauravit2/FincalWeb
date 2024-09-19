import 'package:fincalweb_project/view/Calculators/FD_calculator.dart';
import 'package:fincalweb_project/view/Calculators/KVP_calculator.dart';
import 'package:fincalweb_project/view/Calculators/MF_calculator.dart';
import 'package:fincalweb_project/view/Calculators/NSC_calculator.dart';
import 'package:fincalweb_project/view/Calculators/PPF_calculator.dart';
import 'package:fincalweb_project/view/Calculators/RD_calculator.dart';
import 'package:fincalweb_project/view/Calculators/SCSS_calculator.dart';
import 'package:fincalweb_project/view/Calculators/SIP_calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helper/get_di.dart' as di;
import 'helper/size_config.dart';
import 'package:fincalweb_project/view/HomePage.dart';
import 'package:fincalweb_project/view//get_started.dart';



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
                //home: HomePage(),
                initialRoute: '/',
                routes: {
                  '/': (context) => HomePage(),
                  '/get_started': (context) => AllCalculators(title: '', content: '',),
                  '/FD_calculator':(context) => FdCalculator(),
                  '/RD_calculator':(context) => RdCalculator(),
                  '/SIP_calculator':(context) => SipCalculator(),
                  '/MF_calculator':(context) => MfCalculator(),
                  '/PPF_calculator':(context) => PpfCalculator(),
                  '/NSC_calculator':(context) =>NscCalculator(),
                  '/KVP_calculator':(context) =>KvpCalculator(),
                  '/SCSS_calculator':(context) =>ScssCalculator(),
                },
                debugShowCheckedModeBanner: false,
              );
            },
          );
        });
  }
}
