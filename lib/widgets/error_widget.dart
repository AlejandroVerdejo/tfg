import 'package:flutter/material.dart';
import 'package:tfg_library/lang.dart';

class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(getLang("error")),
    );
  }
}
