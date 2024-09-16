import 'package:cached_network_image/cached_network_image.dart';
import 'package:fincalweb_project/view/get_started.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fincalweb_project/helper/size_config.dart';
import 'package:fincalweb_project/view//FD_calculator.dart'; // Import FD Calculator

class CustomMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 950) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: _buildAppName(),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            drawer: _buildFullScreenDrawer(context),
            body: Center(
              child: Text('Select an option from the drawer',
                  style: TextStyle(fontSize: 2.t, color: Colors.teal.shade700)),
            ),
          );
        } else {
          return Container(
            color: Colors.teal.shade800,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildAppName(),
                Spacer(),
                _buildMenuDropdown(
                  title: 'Loan Calculators',
                  items: {'EMI Calculator': AllCalculators(title: 'EMI Calculator', content: 'EMI Calculator Content')},
                  context: context,
                ),
                _buildMenuDropdown(
                  title: 'Bank Calculators',
                  items: {
                    'FD Calculator': FdCalculator(), // FD Calculator widget
                    'RD Calculator': AllCalculators(title: 'RD Calculator', content: 'RD Calculator Content'),
                  },
                  context: context,
                ),
                _buildMenuDropdown(
                  title: 'Post Calculators',
                  items: {
                    'PPF Calculator': AllCalculators(title: 'PPF Calculator', content: 'PPF Calculator Content'),
                    'NSC Calculator': AllCalculators(title: 'NSC Calculator', content: 'NSC Calculator Content'),
                    'KVP Calculator': AllCalculators(title: 'KVP Calculator', content: 'KVP Calculator Content'),
                    'SCSS Calculator': AllCalculators(title: 'SCSS Calculator', content: 'SCSS Calculator Content'),
                  },
                  context: context,
                ),
                _buildMenuDropdown(
                  title: 'Market Calculators',
                  items: {
                    'SIP Calculator': AllCalculators(title: 'SIP Calculator', content: 'SIP Calculator Content'),
                    'MF Calculator': AllCalculators(title: 'MF Calculator', content: 'MF Calculator Content'),
                  },
                  context: context,
                ),
                _buildDownloadButton(),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMenuDropdown({
    required String title,
    required Map<String, Widget> items, // Map stores widgets instead of strings
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.5.w),
      child: DropdownButton<String>(
        dropdownColor: Colors.teal.shade300,
        underline: SizedBox.shrink(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
        hint: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 1.2.t),
        ),
        items: items.keys.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.white, fontSize: 1.2.t),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null && items[value] != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => items[value]!, // Navigate to the widget
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
            child: Center(child: _buildAppName()),
          ),
          _buildDrawerItem(
            context: context,
            title: 'Loan Calculators',
            items: {'EMI Calculator': AllCalculators(title: 'EMI Calculator', content: 'EMI Calculator Content')},
          ),
          _buildDrawerItem(
            context: context,
            title: 'Bank Calculators',
            items: {
              'FD Calculator': FdCalculator(), // FD Calculator widget
              'RD Calculator': AllCalculators(title: 'RD Calculator', content: 'RD Calculator Content'),
            },
          ),
          _buildDrawerItem(
            context: context,
            title: 'Post Calculators',
            items: {
              'PPF Calculator': AllCalculators(title: 'PPF Calculator', content: 'PPF Calculator Content'),
              'NSC Calculator': AllCalculators(title: 'NSC Calculator', content: 'NSC Calculator Content'),
              'KVP Calculator': AllCalculators(title: 'KVP Calculator', content: 'KVP Calculator Content'),
              'SCSS Calculator': AllCalculators(title: 'SCSS Calculator', content: 'SCSS Calculator Content'),
            },
          ),
          _buildDrawerItem(
            context: context,
            title: 'Market Calculators',
            items: {
              'SIP Calculator': AllCalculators(title: 'SIP Calculator', content: 'SIP Calculator Content'),
              'MF Calculator': AllCalculators(title: 'MF Calculator', content: 'MF Calculator Content'),
            },
          ),
          ListTile(
            title: Text(
              'Download Android App',
              style: TextStyle(fontSize: 1.3.t),
            ),
            onTap: () {
              _launchURL();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppName() {
    return Row(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: 'assets/images/logo1.jpeg',
            height: 4.t,
            width: 4.t,
            fit: BoxFit.fill,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          'Fincal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 2.t,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required Map<String, Widget> items, // Map stores widgets instead of strings
  }) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontSize: 1.3.t)),
      children: items.keys.map((String item) {
        return ListTile(
          title: Text(item),
          onTap: () {
            Navigator.pop(context);
            if (items[item] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => items[item]!, // Navigate to the widget
                ),
              );
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildDownloadButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.5.w),
      child: TextButton(
        onPressed: _launchURL,
        child: Text(
          'Download Android App',
          style: TextStyle(color: Colors.white, fontSize: 1.3.t),
        ),
      ),
    );
  }

  void _launchURL() async {
    final String _url =
        'https://play.google.com/store/apps/details?id=com.gp.emicalculator';
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }
}
