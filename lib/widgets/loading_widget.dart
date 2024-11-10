import 'package:flutter/material.dart';
import 'package:tfg_library/styles.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: colors["dark"]["headerBackgroundColor"],
      ),
    );
  }
}
