import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';

class AllCalculators extends StatelessWidget {
  const AllCalculators({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the number of cards per row based on screen size
    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 3; // 3 cards per row for large screens
    } else if (screenWidth >= 800) {
      crossAxisCount = 2; // 2 cards per row for medium screens
    } else {
      crossAxisCount = 1; // 1 card per row for small screens
    }

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
                breadcrumbItems: ['Home', 'Calculators'], // Breadcrumb items
                routes: ['/', '/calculators'], // Corresponding routes
              ),
              const SizedBox(height: 20),

              // Heading below Breadcrumb
              Text(
                'All Financial Calculators',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 2.t, // Responsive text size
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              const SizedBox(height: 20),

              // Responsive Grid of Cards
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(), // Prevents scrolling inside the grid
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // Dynamically set the number of cards per row
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.5, // Aspect ratio to control card size
                ),
                itemCount: 9, // 9 cards in total
                itemBuilder: (BuildContext context, int index) {
                  return CalculatorCard(
                    imageUrl: cardData[index]['imageUrl']!,
                    title: cardData[index]['title']!,
                    description: cardData[index]['description']!,
                    buttonText: cardData[index]['buttonText']!,
                    onPressed: () {
                      // Handle navigation to specific calculator
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy data for the 9 calculator cards with network image URLs
final List<Map<String, String>> cardData = [
  {
    'imageUrl': 'assets/calculator_icons/loan.png',
    'title': 'EMI Calculator',
    'description': 'Calculate EMI on your loans by adding Multiple Part Payments',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/fd.png',
    'title': 'FD Calculator',
    'description': 'Calculate your returns on Fixed Deposits (FDs)',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/rd.png',
    'title': 'RD Calculator',
    'description': 'Calculate your returns on Recurring Deposits (RDs)',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/ppf.png',
    'title': 'PPF Calculator',
    'description': 'Calculate returns on Public Provident Fund (PPF)',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/nsc.png',
    'title': 'NSC Calculator',
    'description': 'Calculate your returns on National Saving Certificate (NSC)',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/kvp.png',
    'title': 'KVP Calculator',
    'description': 'Calculate your returns on Kisan Vikas Patra (KVP)',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/scss.png',
    'title': 'SCSS Calculator',
    'description': 'Calculate your returns on Senior Citizen Savings Scheme (SCSS)',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/mf.png',
    'title': 'MF Calculator',
    'description': 'Calculate your returns on Mutual Fund investment (MF)',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/sip.png',
    'title': 'SIP Calculator',
    'description': 'Calculate your returns on Systematic Investment Plan (SIP)',
    'buttonText': 'Calculate Now'
  },
];

// Custom Card Widget with network image
class CalculatorCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const CalculatorCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Set card color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Network image above the title
            Image.network(
              imageUrl,
              height: 50.0, // Adjust size as needed
              width: 50.0,  // Adjust size as needed
              fit: BoxFit.cover, // Ensures the image covers the space without distortion
            ),
            const SizedBox(height: 10), // Space between image and title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
