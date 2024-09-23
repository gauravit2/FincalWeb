import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fincalweb_project/helper/size_config.dart';

class InvestmentResult extends StatelessWidget {
  final double principalAmount;
  final double totalInterestEarned;
  final double maturityValue;

  const InvestmentResult({
    Key? key,
    required this.principalAmount,
    required this.totalInterestEarned,
    required this.maturityValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.w), // Overall padding for layout
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Investment result header
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 10.w,
                  height: 7.w,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade200,
                  ),
                  child: Center(
                    child: Text(
                      "Investment Result",
                      style: TextStyle(fontSize: 2.t, color: Colors.teal.shade800, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 5.w), // Space between header and result section

          // Row for the pie chart, table, and ad section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align pie chart and details
            children: [
              // Pie chart section
              SizedBox(
                height: 30.w,
                width: 35.w, // Adjusted pie chart size
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.green,
                        value: principalAmount,
                        title: '', // No titles in the slices
                        radius: 35,
                      ),
                      PieChartSectionData(
                        color: Colors.orangeAccent,
                        value: totalInterestEarned,
                        title: '',
                        radius: 35,
                      ),
                      PieChartSectionData(
                        color: Colors.blueAccent,
                        value: maturityValue,
                        title: '',
                        radius: 35,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 3.w), // Space between pie chart and table

              // Table section for investment details with updated layout
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(6.w), // Padding inside the table container
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100, // Light background color similar to the image
                    borderRadius: BorderRadius.circular(5), // Rounded corners
                    //border: Border.all(color: Colors.grey.shade400, width: 0), // Border similar to the image
                  ),
                  child: Table(
                    defaultColumnWidth: IntrinsicColumnWidth(),
                    children: [
                      _buildInvestmentDetailRow("Investment Amount", principalAmount, Colors.green),
                      _buildInvestmentDetailRow("Interest Amount", totalInterestEarned, Colors.orange),
                      _buildInvestmentDetailRow("Maturity Amount", maturityValue, Colors.blue),
                    ],
                  ),
                ),
              ),

              // Increase distance between the table and ad
              SizedBox(width: 12.w), // Adjust this value to increase the space

              // Larger Ad section as per your reference
              Container(
                width: 40.w, // Increased width for the ad
                height: 30.w, // Increased height for the ad
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal.shade800),
                ),
                child: Center(
                  child: Text(
                    "Ad",
                    style: TextStyle(fontSize: 2.5.t, color: Colors.teal.shade700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build table rows for investment details
  TableRow _buildInvestmentDetailRow(String label, double value, Color color) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.w), // Reduced padding for compact rows
          child: Row(
            children: [
              Icon(
                Icons.square,
                size: 1.5.t, // Small icon size
                color: color,
              ),
              SizedBox(width: 1.5.w), // Spacing between icon and label
              Text(
                "$label",
                style: TextStyle(fontSize: 1.3.t, color: Colors.black), // Compact font size
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.w),
          child: Text(
            "₹ ${value}",
            style: TextStyle(fontSize: 1.3.t, color: Colors.black), // Compact font size for value
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
