import 'package:flutter/material.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
    super.key,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("Catalogo"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Text("Prueba"),
      ),
    );
  }
}
