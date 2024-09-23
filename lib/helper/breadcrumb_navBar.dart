import 'package:flutter/material.dart';

class BreadcrumbNavBar extends StatelessWidget {
  final List<String> breadcrumbItems;
  final List<String> routes;
  final String currentRoute;

  BreadcrumbNavBar({
    required this.breadcrumbItems,
    required this.routes,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: List.generate(breadcrumbItems.length, (index) {
          // Check if the current route matches the breadcrumb route
          final bool isCurrentPage = routes[index] == currentRoute;

          return Row(
            children: [
              // Wrap the GestureDetector with MouseRegion to change the cursor
              MouseRegion(
                cursor: isCurrentPage ? SystemMouseCursors.basic : SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: isCurrentPage
                      ? null
                      : () {
                    Navigator.pushNamed(context, routes[index]);
                  },
                  child: Text(
                    breadcrumbItems[index],
                    style: TextStyle(
                      color: isCurrentPage ? Colors.grey : Colors.teal,
                      fontSize: 12,
                      // decoration: isCurrentPage ? TextDecoration.none : TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              if (index < breadcrumbItems.length - 1)
                Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                  size: 16,
                ),
            ],
          );
        }),
      ),
    );
  }
}
