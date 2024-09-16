import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';

class FdCalculator extends StatelessWidget {
  const FdCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
    child: CustomMenuBar(),
    ),
    body: Center(
    child: Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width - 44.w,
    child: ListView(
    physics: const BouncingScrollPhysics(),
    padding: EdgeInsets.all(2.w),
    children: [
    // Breadcrumb Navigation Bar
    BreadcrumbNavBar(
    breadcrumbItems: ['Home', 'Calculators','FD Calculator'],
    routes: ['/', '/get_started','/FD_calculator'],
      currentRoute: ModalRoute.of(context)?.settings.name ?? 'FD Calculator',
    ),
      ],
    ),
    ),
    ), // Corresponding routes
    );
  }
}
