import 'package:flutter/material.dart';
import 'package:fincalweb_project/components/Home_page_components/stat_item_content.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/hover_image.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart'; // Import the BreadcrumbNavBar
import 'package:fincalweb_project/view/get-started.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> _isHoveringStatItems = [false, false, false];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(2.w),
            children: [
              // Breadcrumb Navigation Bar
              BreadcrumbNavBar(
                breadcrumbItems: [''], // Breadcrumb items
                routes: ['/'],
                currentRoute: ModalRoute.of(context)?.settings.name ?? '', // Corresponding routes
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: StatItemContent(
                      isHoveringStatItems: _isHoveringStatItems,
                      onHover: _handleHover,
                      screenWidth: screenWidth,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: HoverImage(
                        imageUrl:
                        'https://images.pexels.com/photos/5816283/pexels-photo-5816283.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                        height: 25.0,
                        borderRadius: 10.0,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Centered Text
                              Center(
                                child: Text(
                                  'All Financial Calculators in Fingertip',
                                  style: TextStyle(
                                    color: Colors.teal.shade800,
                                    fontSize: 2.t,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.white, // Set the background color to white
                                          padding: EdgeInsets.all(1.w), // Optional: Add padding
                                          child: HoverImage(
                                            imageUrl: 'assets/images/bank1.png',
                                            height: 15.0,
                                            width: 45.0,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          'Bank',
                                          style: TextStyle(fontSize: 2.t, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.white, // Set the background color to white
                                          padding: EdgeInsets.all(1.w), // Optional: Add padding
                                          child: HoverImage(
                                            imageUrl: 'assets/images/post.png',
                                            height: 15.0,
                                            width: 45.0,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          'Post',
                                          style: TextStyle(fontSize: 2.t, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.white, // Set the background color to white
                                          padding: EdgeInsets.all(1.w), // Optional: Add padding
                                          child: HoverImage(
                                            imageUrl: 'assets/images/emi1.png',
                                            height: 15.0,
                                            width: 45.0,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          'Loan',
                                          style: TextStyle(fontSize: 2.t, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.h),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllCalculators(title: '', content: '',)),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal.shade900,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.h, horizontal: 4.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Get Started',
                                    style: TextStyle(fontSize: 1.5.t),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 6.h),
                                  Text(
                                    'Visualize your investment more\n easily',
                                    style: TextStyle(
                                      fontSize: 2.0.t,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    '- Best breakdown of invested amount, interest, returns',
                                    style: TextStyle(
                                      fontSize: 1.0.t,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Transform.translate(
                                            offset: Offset(13.w, -9.h), // Shift right (X-axis) and upwards (Y-axis)
                                            child: Image.network(
                                              'assets/images/pie.PNG',
                                              height: 40.h,
                                              width: 40.w,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                offset: Offset(-10.w, -10.h),
                                                child: Image.network(
                                                  'assets/images/mobile.jpg',
                                                  height: 40.h,
                                                  width: 40.w,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleHover(int index) {
    setState(() {
      for (int i = 0; i < _isHoveringStatItems.length; i++) {
        _isHoveringStatItems[i] = i == index;
      }
    });
  }
}
