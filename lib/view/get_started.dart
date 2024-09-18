import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';

class AllCalculators extends StatelessWidget {
  const AllCalculators({super.key, required String title, required String content});

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;


    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 3;
    } else if (screenWidth >= 800) {
      crossAxisCount = 2;
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
                breadcrumbItems: ['Home', 'Calculators'],  // name that display on screen
                routes: ['/', '/get_started'],   // name of route
                currentRoute: ModalRoute.of(context)?.settings.name ?? 'Calculators',  //current page
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
                  crossAxisSpacing: 16.0, // Increased spacing between cards
                  mainAxisSpacing: 20.0, // Increased spacing between rows
                  childAspectRatio: 1, // Square shape for the card
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
                      if (cardData[index]['title'] == 'FD Calculator') {
                        Navigator.pushNamed(context, '/FD_calculator');
                      }
                      if (cardData[index]['title'] == 'RD Calculator') {
                        Navigator.pushNamed(context, '/RD_calculator');
                      }
                      else {
                        // Handle other calculator navigation or display a message
                        // Navigator.pushNamed(context, '/other-calculator');
                      }
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
    'description': 'Calculate EMI on your loans by adding Multiple Prepayments',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/sip.png',
    'title': 'SIP Calculator',
    'description': 'Calculate your returns on Systematic Investment Plan (SIP)',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/mf.png',
    'title': 'MF Calculator',
    'description': 'Calculate your returns on Mutual Fund investment (MF)',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/fd.png',
    'title': 'FD Calculator',
    'description': 'Calculate your returns on Fixed Deposits (FDs) calculator',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/rd.png',
    'title': 'RD Calculator',
    'description': 'Calculate your returns on Recurring Deposits (RDs) calculator',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/ppf.png',
    'title': 'PPF Calculator',
    'description': 'Calculate returns on Public Provident Fund (PPF) calculator',
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
    'description': 'Calculate your returns on Kisan Vikas Patra (KVP) calculator',
    'buttonText': 'Calculate Now'
  },
  {
    'imageUrl': 'assets/calculator_icons/scss.png',
    'title': 'SCSS Calculator',
    'description': 'Calculate your returns on Senior Citizen Savings Scheme (SCSS)',
    'buttonText': 'Calculate Now'
  },


];

// Custom Card Widget with the desired design
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
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      elevation: 2.0, // Subtle shadow
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Inner padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image container with border
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 2), // Border around the image
                borderRadius: BorderRadius.circular(8), // Rounded corners for image container
              ),
              child: Image.network(
                imageUrl,
                height: 50.0, // Adjust size as needed
                width: 50.0,  // Adjust size as needed
                fit: BoxFit.cover, // Ensures the image covers the space without distortion
              ),
            ),
            const SizedBox(height: 20), // Space between image and title
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 4), // Space between title and description
            Text(
              description,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 15), // Space between description and button

            // Outlined button with green text and border
            OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.teal), // Green border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded button
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.teal), // Green text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
