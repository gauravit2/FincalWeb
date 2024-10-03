import 'package:flutter/material.dart';

class PaymentTable extends StatefulWidget {
  @override
  _PaymentTableState createState() => _PaymentTableState();
}

class _PaymentTableState extends State<PaymentTable> {
  // To keep track of which year is expanded
  bool is2024Expanded = false;
  bool is2025Expanded = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Table(
            border: TableBorder.all(
              color: Colors.teal.shade300,
              width: 1,
            ),
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2.5),
              5: FlexColumnWidth(2),
            },
            children: [
              _buildHeaderRow(),
              _buildExpandableRow('2024', is2024Expanded), // The expandable row for 2024
              if (is2024Expanded) // Conditionally show child rows
                _buildDataRow('  Nov', '50000', '3500', '2500', '56000', '200000', Colors.white),
              if (is2024Expanded)
                _buildDataRow('  Dec', '50000', '3500', '2500', '56000', '50000', Colors.white),
              _buildExpandableRow('2025', is2025Expanded), // For future expandable year
              if (is2025Expanded) // Conditionally show child rows
                _buildDataRow('  Nov', '50000', '3500', '2500', '56000', '200000', Colors.white),
              if (is2025Expanded)
                _buildDataRow('  Dec', '50000', '3500', '2500', '56000', '50000', Colors.white),

              _buildTotalRow('Total', '189000', '13000', '10000', '212000', '0'),


            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(children: [
      _buildHeaderCell('Year'),
      _buildHeaderCell('Principal (A)'),
      _buildHeaderCell('Interest (B)'),
      _buildHeaderCell('Part Payments (C)'),
      _buildHeaderCell('Total Payment (A+B+C)'),
      _buildHeaderCell('Outstanding'),
    ]);
  }

  // Method to build rows that can expand/collapse
  TableRow _buildExpandableRow(String year, bool isExpanded) {
    return TableRow(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (year == '2024') {
                is2024Expanded = !is2024Expanded; // Toggle expanded state
              }
              if (year == '2025') {
                is2025Expanded = !is2025Expanded; // Toggle expanded state
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            color: Colors.teal.shade400,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon( // Add the icon here before the text
                    isExpanded ? Icons.remove : Icons.add,
                    size: 16.0, // Minimize icon size
                    color: Colors.black,
                  ),
                  SizedBox(width: 5.0), // Add spacing between icon and text
                  Text(
                    year,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black,
                      decoration: TextDecoration.none, // Removes any yellow underline
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildDataCell('100000', Colors.white),
        _buildDataCell('7000', Colors.white),
        _buildDataCell('5000', Colors.white),
        _buildDataCell('112000', Colors.white),
        _buildDataCell('100000', Colors.white),
      ],
    );
  }

  TableRow _buildDataRow(String year, String principal, String interest, String partPayments, String totalPayment, String outstanding, Color bgColor) {
    return TableRow(children: [
      _buildDataCell(year, bgColor),
      _buildDataCell(principal, bgColor),
      _buildDataCell(interest, bgColor),
      _buildDataCell(partPayments, bgColor),
      _buildDataCell(totalPayment, bgColor),
      _buildDataCell(outstanding, bgColor),
    ]);
  }

  TableRow _buildTotalRow(String label, String principal, String interest, String partPayments, String totalPayment, String outstanding) {
    return TableRow(children: [
      _buildTotalCell(label),
      _buildTotalCell(principal),
      _buildTotalCell(interest),
      _buildTotalCell(partPayments),
      _buildTotalCell(totalPayment),
      _buildTotalCell(outstanding),
    ]);
  }

  Widget _buildHeaderCell(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      color: Colors.teal.shade700,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 14,
            decoration: TextDecoration.none, // Removes any yellow underline
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataCell(String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      color: bgColor,
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Colors.black,
            decoration: TextDecoration.none, // Removes any yellow underline
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTotalCell(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      color: Colors.grey.shade700,
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Colors.white,
            decoration: TextDecoration.none, // Removes any yellow underline
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
