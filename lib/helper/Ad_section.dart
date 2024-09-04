import 'package:flutter/material.dart';
import 'package:fincalweb_project/helper/size_config.dart';

class AdSection extends StatelessWidget {
  final bool rotate; // To rotate the text if needed

  const AdSection({Key? key, this.rotate = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.w,
      color: Colors.blueGrey.shade100,
      child: Center(
        child: rotate
            ? RotatedBox(
          quarterTurns: 4,
          child: Text(
            'Ad',
            style: TextStyle(fontSize: 3.5.t),
          ),
        )
            : Text(
          'Ad',
          style: TextStyle(fontSize: 3.5.t),
        ),
      ),
    );
  }
}
