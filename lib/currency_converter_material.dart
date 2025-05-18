import 'package:flutter/material.dart';

class MultiCurrencyConverterMaterialPage extends StatefulWidget {
  const MultiCurrencyConverterMaterialPage({super.key});

  @override
  State<MultiCurrencyConverterMaterialPage> createState() =>
      _MultiCurrencyConverterMaterialPageState();
}

class _MultiCurrencyConverterMaterialPageState
    extends State<MultiCurrencyConverterMaterialPage> {
  final TextEditingController controller = TextEditingController();
  double result = 0;

  final List<String> currencies = ['USD', 'INR', 'NPR', 'AUD', 'AED'];
  String fromCurrency = 'USD';
  String toCurrency = 'INR';

  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'INR': 83.0,
    'NPR': 133.5,
    'AUD': 1.5,
    'AED': 3.67,
  };

  final Map<String, String> currencySymbols = {
    'USD': '\$',
    'INR': '₹',
    'NPR': 'Rs',
    'AUD': 'A\$',
    'AED': 'د.إ',
  };

  List<String> history = [];

  void convert() {
    double input = double.tryParse(controller.text) ?? 0;
    if (input == 0) return;

    double inUSD = input / exchangeRates[fromCurrency]!;
    result = inUSD * exchangeRates[toCurrency]!;

    history.add(
      '${currencySymbols[fromCurrency]}$input $fromCurrency → '
      '${currencySymbols[toCurrency]}${result.toStringAsFixed(2)} $toCurrency',
    );

    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(24),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26,
            color: Color(0xFF1E1E1E), // Dark gray color
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E1E1E)),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '${currencySymbols[toCurrency]} ${result.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    border: border,
                    focusedBorder: border,
                    enabledBorder: border,
                    fillColor: const Color(0xFFF4F4F4),
                    filled: true,
                    prefixIcon: const Icon(Icons.money, color: Color(0xFF999999)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'From',
                          border: border,
                          filled: true,
                          fillColor: const Color(0xFFF4F4F4),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                        ),
                        value: fromCurrency,
                        items: currencies
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text('$e (${currencySymbols[e]})'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            fromCurrency = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'To',
                          border: border,
                          filled: true,
                          fillColor: const Color(0xFFF4F4F4),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                        ),
                        value: toCurrency,
                        items: currencies
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text('$e (${currencySymbols[e]})'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            toCurrency = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: convert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Convert'),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: history.isEmpty
                      ? const Center(
                          child: Text(
                            'No conversions yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          itemCount: history.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                history[index],
                                style:
                                    const TextStyle(color: Color(0xFF777777)),
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        history.clear();
                        result = 0;
                        controller.clear();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color:Colors.white10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                      'Clear History',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
