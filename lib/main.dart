import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Import your currency converter screens
import 'currency_converter_material.dart';
import 'currency_converter_cupertino.dart';

void main() {
  runApp(const MyApp());
}

/// Set to `true` to use Cupertino style (iOS), `false` for Material (Android)
const bool useCupertino = true;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (useCupertino) {
      return const CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: MultiCurrencyConverterCupertinoPage(),
      );
    } else {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MultiCurrencyConverterMaterialPage(),
      );
    }
  }
}
