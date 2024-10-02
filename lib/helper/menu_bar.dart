import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:fincalweb_project/view/calculators.dart';
import 'package:flutter/material.dart';
import 'package:fincalweb_project/components/menuBar_components/AppName.dart';
import 'package:fincalweb_project/components/menuBar_components/downloadApp.dart';
import 'package:fincalweb_project/view/Calculators/kvp-calculator.dart';
import 'package:fincalweb_project/view/Calculators/mf-calculator.dart';
import 'package:fincalweb_project/view/Calculators/nsc-calculator.dart';
import 'package:fincalweb_project/view/Calculators/ppf-calculator.dart';
import 'package:fincalweb_project/view/Calculators/rd-calculator.dart';
import 'package:fincalweb_project/view/Calculators/scss-calculator.dart';
import 'package:fincalweb_project/view/Calculators/sip-calculator.dart';
import 'package:fincalweb_project/view/Calculators/fd-calculator.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomMenuBar extends StatefulWidget {
  @override
  _CustomMenuBarState createState() => _CustomMenuBarState();
}

class _CustomMenuBarState extends State<CustomMenuBar> {
  String? _currentCalculator; // Track the current calculator

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 950) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: AppNameWidget(),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            drawer: _buildFullScreenDrawer(context),
            body: Center(
              child: Text(
                'Select an option from the drawer',
                style: TextStyle(fontSize: 2.t, color: Colors.teal.shade700),
              ),
            ),
          );
        } else {
          return Container(
            color: Colors.teal.shade800,
            padding: EdgeInsets.symmetric(horizontal: 10.w,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppNameWidget(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Spacer(flex: 1),
                      _buildDropDown(
                        title: 'Loan Calculators',
                        items: {
                          'EMI Calculator': AllCalculators(
                            title: 'EMI Calculator',
                            content: 'EMI Calculator Content',
                          ),
                        },
                      ),
                      _buildDropDown(
                        title: 'Bank Calculators',
                        items: {
                          'FD Calculator': FdCalculator(),
                          'RD Calculator': RdCalculator(),
                        },
                      ),
                      _buildDropDown(
                        title: 'Post Calculators',
                        items: {
                          'PPF Calculator': PpfCalculator(),
                          'NSC Calculator': NscCalculator(),
                          'KVP Calculator': KvpCalculator(),
                          'SCSS Calculator': ScssCalculator(),
                        },
                      ),
                      _buildDropDown(
                        title: 'Market Calculators',
                        items: {
                          'SIP Calculator': SipCalculator(),
                          'MF Calculator': MfCalculator(),
                        },
                      ),
                      DownloadButton(
                        downloadUrl: 'https://play.google.com/store/apps/details?id=com.gp.emicalculator',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildDropDown({
    required String title,
    required Map<String, Widget> items,
  }) {
    return Container(
      width: 180,
      child: CustomDropdown(
        decoration: CustomDropdownDecoration(
          expandedBorderRadius: BorderRadius.only(
           bottomLeft: Radius.circular(10.0),
           bottomRight: Radius.circular(10.0)
          ),
          closedSuffixIcon: Container(),
          listItemStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          closedFillColor: Colors.transparent,
          expandedFillColor: Colors.teal.shade400,
        ),
        hintText: title,
        items: items.keys.toList(),
        onChanged: (value) {
          if (value != null && items[value] != null) {
            setState(() {
              _currentCalculator = value; // Update current calculator
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => items[value]!,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFullScreenDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal.shade600),
            child: Center(child: AppNameWidget()), // Use the imported AppName widget
          ),
          _buildDrawerItem(
            title: 'Loan Calculators',
            items: {
              'EMI Calculator': AllCalculators(
                title: 'EMI Calculator',
                content: 'EMI Calculator Content',
              ),
            },
          ),
          _buildDrawerItem(
            title: 'Bank Calculators',
            items: {
              'FD Calculator': FdCalculator(),
              'RD Calculator': RdCalculator(),
            },
          ),
          _buildDrawerItem(
            title: 'Post Calculators',
            items: {
              'PPF Calculator': PpfCalculator(),
              'NSC Calculator': NscCalculator(),
              'KVP Calculator': KvpCalculator(),
              'SCSS Calculator': ScssCalculator(),
            },
          ),
          _buildDrawerItem(
            title: 'Market Calculators',
            items: {
              'SIP Calculator': SipCalculator(),
              'MF Calculator': MfCalculator(),
            },
          ),
          ListTile(
            title: Text(
              'Download Android App',
              style: TextStyle(fontSize: 1.3.t),
            ),
            onTap: () => _launchURL(), // Call _launchURL when tapped
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required Map<String, Widget> items,
  }) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontSize: 1.3.t)),
      children: items.keys.map((String item) {
        return ListTile(
          title: Text(
            item,
            style: TextStyle(
              color: _currentCalculator == item ? Colors.grey : Colors.teal,
            ),
          ),
          onTap: () {
            setState(() {
              _currentCalculator = item;
            });
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => items[item]!,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  // Add the _launchURL method for drawer
  void _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.gp.emicalculator';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
