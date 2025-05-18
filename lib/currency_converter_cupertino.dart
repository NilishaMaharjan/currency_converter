import 'package:flutter/cupertino.dart';

class MultiCurrencyConverterCupertinoPage extends StatefulWidget {
  const MultiCurrencyConverterCupertinoPage({super.key});

  @override
  State<MultiCurrencyConverterCupertinoPage> createState() =>
      _MultiCurrencyConverterCupertinoPageState();
}

class _MultiCurrencyConverterCupertinoPageState
    extends State<MultiCurrencyConverterCupertinoPage> {
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
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Currency Converter'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '${currencySymbols[toCurrency]} ${result.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: controller,
                placeholder: 'Enter amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CupertinoColors.systemGrey),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CupertinoPickerButton(
                      label: 'From',
                      value: fromCurrency,
                      items: currencies,
                      onSelected: (value) {
                        setState(() {
                          fromCurrency = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CupertinoPickerButton(
                      label: 'To',
                      value: toCurrency,
                      items: currencies,
                      onSelected: (value) {
                        setState(() {
                          toCurrency = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: convert,
                child: const Text('Convert'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: history.isEmpty
                    ? const Text(
                        'No conversions yet',
                        style: TextStyle(color: CupertinoColors.systemGrey),
                      )
                    : ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(history[index]),
                          );
                        },
                      ),    
              ),        
    CupertinoButton(
      color: CupertinoColors.systemRed,
      onPressed: () {
        setState(() {
          history.clear();
        });
      },
      child: const Text('Clear History'),
    ),
            ],
          ),
        ),
      ),
    );
  }
}

class CupertinoPickerButton extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onSelected;

  const CupertinoPickerButton({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(12),
      color: CupertinoColors.white,
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: CupertinoColors.systemGrey)),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, color: CupertinoColors.black)),
        ],
      ),
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) => Container(
            height: 250,
            color: CupertinoColors.systemBackground,
            child: CupertinoPicker(
              backgroundColor: CupertinoColors.systemBackground,
              itemExtent: 40,
              scrollController:
                  FixedExtentScrollController(initialItem: items.indexOf(value)),
              onSelectedItemChanged: (index) => onSelected(items[index]),
              children: items.map((item) => Center(child: Text(item))).toList(),
            ),
          ),
        );
      },
    );
  }
}
