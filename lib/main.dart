import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helper/get_di.dart' as di;
import 'helper/size_config.dart';
import 'package:fincalweb_project/view/HomePage.dart';



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
                home: HomePage(),
              );
            },
          );
        });
  }
}
