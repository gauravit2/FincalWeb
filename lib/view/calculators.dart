import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/menu_bar.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/helper/breadcrumb_navBar.dart';

class AllCalculators extends StatelessWidget {
  const AllCalculators({super.key, required String title, required String content});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 3;
    } else if (screenWidth >= 800) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
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
              BreadcrumbNavBar(
                breadcrumbItems: ['Home', 'Calculators'],
                routes: ['/', '/calculators'],
                currentRoute: ModalRoute.of(context)?.settings.name ?? 'Calculators',
              ),
              const SizedBox(height: 20),
              Text(
                'All Financial Calculators',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 2.t,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              const SizedBox(height: 40),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 70.0,
                  mainAxisSpacing: 70.0,
                  childAspectRatio: 1,
                ),
                itemCount: 9,
                itemBuilder: (BuildContext context, int index) {
                  return CalculatorCard(
                    imageUrl: cardData[index]['imageUrl']!,
                    title: cardData[index]['title']!,
                    description: cardData[index]['description']!,
                    buttonText: cardData[index]['buttonText']!,
                    onPressed: () {
                      if (cardData[index]['title'] == 'FD Calculator') {
                        Navigator.pushNamed(context, '/fd-calculator');
                      }
                      if (cardData[index]['title'] == 'RD Calculator') {
                        Navigator.pushNamed(context, '/rd-calculator');
                      }
                      if (cardData[index]['title'] == 'SIP Calculator') {
                        Navigator.pushNamed(context, '/sip-calculator');
                      }
                      if (cardData[index]['title'] == 'MF Calculator') {
                        Navigator.pushNamed(context, '/mf-calculator');
                      }
                      if (cardData[index]['title'] == 'PPF Calculator') {
                        Navigator.pushNamed(context, '/ppf-calculator');
                      }
                      if (cardData[index]['title'] == 'NSC Calculator') {
                        Navigator.pushNamed(context, '/nsc-calculator');
                      }
                      if (cardData[index]['title'] == 'KVP Calculator') {
                        Navigator.pushNamed(context, '/kvp-calculator');
                      }
                      if (cardData[index]['title'] == 'SCSS Calculator') {
                        Navigator.pushNamed(context, '/scss-calculator');
                      }
                      if (cardData[index]['title'] == 'EMI Calculator') {
                        Navigator.pushNamed(context, '/emi-calculator');
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
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                imageUrl,
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade900,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 1),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,  // Full teal background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),  // Rounded corners
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,  // White text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
