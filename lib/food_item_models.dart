class FoodItem {
  static int _idCounter = 0;
  final int id;
  final String name;
  final String description;
  final String? image;
  double price;
  final List<Option> extras;
  final List<RequiredOption> requiredOptions;
  Map<String, String?> selectedRequiredOptions;
  Map<String, bool> selectedExtras;

  FoodItem({
    int? id,
    required this.name,
    required this.description,
    this.image,
    required this.price,
    this.extras = const [],
    this.requiredOptions = const [],
    Map<String, String?>? selectedRequiredOptions,
    Map<String, bool>? selectedExtras,
  })  : this.id = id ?? FoodItem._getNextId(),
        this.selectedRequiredOptions = Map.from(selectedRequiredOptions ?? {}),
        this.selectedExtras = Map.from(selectedExtras ?? {});

  static int _getNextId() {
    return _idCounter++;
  }

  FoodItem clone() {
    return FoodItem(
      name: this.name,
      description: this.description,
      image: this.image,
      price: this.price,
      extras: this.extras,
      requiredOptions: this.requiredOptions,
      selectedRequiredOptions: Map.from(this.selectedRequiredOptions),
      selectedExtras: Map.from(this.selectedExtras),
    );
  }

  void updatePrice(Map<String, String?> selectedOptions, Map<String, bool> selectedExtras) {
    double extrasPrice = extras
        .where((extra) => selectedExtras[extra.name] == true)
        .fold(0.0, (total, current) => total + (current.price ?? 0.0));

    double optionsPrice = requiredOptions
        .map((option) => option.optionPrices[selectedOptions[option.name]] ?? 0)
        .fold(0.0, (total, current) => total + current);

    this.price += extrasPrice + optionsPrice;
  }

  double getTotalPrice() {
    double total = price;

    // Add the price of the selected required options
    for (var option in requiredOptions) {
      if (selectedRequiredOptions.containsKey(option.name)) {
        String? selectedOptionName = selectedRequiredOptions[option.name];
        if (selectedOptionName != null && option.optionPrices.containsKey(selectedOptionName)) {
          total += option.optionPrices[selectedOptionName] ?? 0.0;
        }
      }
    }

    // Add the price of the selected extras
    for (var extra in extras) {
      if (selectedExtras[extra.name] == true) {
        total += extra.price ?? 0.0;  // Use the null-coalescing operator to provide a default value
      }
    }

    return total;
  }
}


abstract class Option {
  get name => null;
  num? get price => null;
}

class ExtraOption implements Option {
  final String name;
  final double price;
  ExtraOption({required this.name, required this.price});
}

class AdditionalOption implements Option {
  final String name;

  AdditionalOption({required this.name});

  @override
  num get price => 0.0; // Provide a default value or logic for the price
}

class RequiredOption implements Option {
  final String name;
  final List<String> options;
  final Map<String, double?> optionPrices; // Map option names to their prices

  RequiredOption({required this.name, required this.options, this.optionPrices = const {}});

  @override
  String toString() {
    return '$name (Options: $options, Prices: $optionPrices)';
  }

  @override
  double? get price => null; // This remains, ensuring compliance with the Option interface
}