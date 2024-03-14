import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'food_item_models.dart';

class SubwayDetail extends StatefulWidget {
  final Map<String, String> restaurant;

  SubwayDetail({required this.restaurant});

  @override
  _SubwayDetailState createState() => _SubwayDetailState();
}

class _SubwayDetailState extends State<SubwayDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AutoScrollController _scrollController = AutoScrollController();
  List<GlobalKey> _keys = List.generate(7, (index) => GlobalKey());
  Timer? _debounce;
  bool _tabChangeByScroll = false;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      int? closestIndex;
      double closestDistance = double.infinity;
      for (int i = 0; i < _keys.length; i++) {
        final keyContext = _keys[i].currentContext;
        if (keyContext != null) {
          final RenderBox box = keyContext.findRenderObject() as RenderBox;
          final Offset position = box.localToGlobal(Offset.zero);
          final double itemTop = position.dy;
          final double viewportTop = _scrollController.position.pixels;
          final double viewportBottom = viewportTop + _scrollController.position.viewportDimension;

          // Check if the item is in the viewport
          if (itemTop <= viewportBottom && (itemTop >= viewportTop || position.dy <= viewportBottom)) {
            final double distance = (viewportTop - itemTop).abs();
            if (distance < closestDistance) {
              closestDistance = distance;
              closestIndex = i;
            }
          }
        }
      }

      if (!_tabChangeByScroll && closestIndex != null && closestIndex != _tabController.index) {
        setState(() {
          _tabChangeByScroll = true;
          _tabController.animateTo(closestIndex!);
        });
      }
    });
  }




  void _handleTabSelection() {
    if (_tabController.indexIsChanging && !_tabChangeByScroll) {
      // User initiated tab change through direct interaction
      _scrollToIndex(_tabController.index);
    }
    // Always reset the flag after handling tab selection
    _tabChangeByScroll = false;
  }


  Future _scrollToIndex(int index) async {
    await _scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _tabController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }



  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Subway Menu'),
      bottom: TabBar(
        isScrollable: true,
        controller: _tabController,
        tabs: [
          Tab(text: 'Sandwiches'),
          Tab(text: 'Sides'),
          Tab(text: 'Drinks'),
        ],
      ),
    ),
    body: ListView(
      controller: _scrollController,
      children: [
        AutoScrollTag(
          key: _keys[0],
          controller: _scrollController,
          index: 0,
          child: FoodCategory(
            key: _keys[0],
            categoryName: 'Sandwiches',
            isFirstCategory: true,
            foodList: [
              FoodItem(
                name: 'B.L.T.',
                description: 'Bacon, lettuce, and tomato with choice of bread',
                image: 'assets/images/subway/blt.jpg',
                price: 6.99,
                requiredOptions: [
                  RequiredOption(
                    name: "Bread",
                    options: ["Italian", "Honey Oat", "Wheat", "Flatbread"],
                    optionPrices: {},
                  ),
                  RequiredOption(
                    name: "Toppings",
                    options: ["Mayonnaise", "Mustard", "Lettuce", "Tomato", "Onion", "Bell Pepper", "Olives", "Peppercinis", "Salt", "Pepper"],
                    extras: ["Vinagerette", "Red Vinegar", "Baja Chipotle", "Mayo"],
                  ),
                ],
              ),
              
              // Add more sandwich items here
            ],
          ),
        ),
        
        // Add more AutoScrollTags for other categories
      ],
    ),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Back to Restaurant List'),
      ),
    ),
  );
}


class FoodCategory extends StatelessWidget {
  final GlobalKey key;
  final String categoryName;
  final List<FoodItem> foodList;
  final bool isFirstCategory;

  FoodCategory({required this.key, required this.categoryName, required this.foodList, this.isFirstCategory = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // If this is the first category, display the image and restaurant name
        if (isFirstCategory) ...[
          Image.asset(
            'assets/images/subway.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.0,
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              'Subway',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],

        // Category title
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            categoryName,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),

        // Food items in this category
        Column(
          children: foodList.map((foodItem) {
            return FoodOption(foodItem: foodItem);
          }).toList(),
        ),

        SizedBox(height: 16.0),
      ],
    );
  }
}

class FoodOption extends StatelessWidget {
  final FoodItem foodItem;

  FoodOption({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCustomizationOptions(context, foodItem),
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Display the food image on the left
            Expanded(
              flex: 2,
              child: Image.asset(
                foodItem.image,
                fit: BoxFit.contain,
                height: 100.0, // You can adjust the height of the food image
              ),
            ),
            // Display the food name and description on the right
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodItem.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      foodItem.description,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "\$${foodItem.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomizationOptions(BuildContext context, FoodItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogWithExtras(foodItem: item);
      },
    );
  }
}


class DialogWithExtras extends StatefulWidget {
  final FoodItem foodItem;

  DialogWithExtras({Key? key, required this.foodItem}) : super(key: key);

  @override
  _DialogWithExtrasState createState() => _DialogWithExtrasState();
}

class _DialogWithExtrasState extends State<DialogWithExtras> {
  late double totalPrice;
  Map<String, bool> extrasSelected = {};
  Map<String, String?> selectedRequiredOptions = {};
  Map<String, bool> showError = {};

  @override
  void initState() {
    super.initState();
    totalPrice = widget.foodItem.price;
    widget.foodItem.extras.forEach((extra) {
      extrasSelected[extra.name] = false;
    });
    widget.foodItem.requiredOptions.forEach((option) {
      selectedRequiredOptions[option.name] = "(Choose an option)";
      showError[option.name] = false;
    });
  }

  void _updateTotalPrice(String extraName, bool isSelected) {
    setState(() {
      extrasSelected[extraName] = isSelected;
      totalPrice = widget.foodItem.price;
      extrasSelected.forEach((name, isSelected) {
        if (isSelected) {
          final extra = widget.foodItem.extras.firstWhere((extra) => extra.name == name, orElse: () => ExtraOption(name: '', price: 0.0));
          totalPrice += extra.price ?? 0.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Customize Your Order"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.foodItem.requiredOptions.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Customizations",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...widget.foodItem.requiredOptions.map((requiredOption) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showError[requiredOption.name] == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          "Please select an option",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: requiredOption.name),
                      value: selectedRequiredOptions[requiredOption.name],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRequiredOptions[requiredOption.name] = newValue;
                          showError[requiredOption.name] = newValue == "(Choose an option)";
                        });
                      },
                      items: [DropdownMenuItem<String>(value: "(Choose an option)", child: Text("(Choose an option)"))]
                        ..addAll(requiredOption.options.map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ],

            if (widget.foodItem.extras.isNotEmpty) ...[
              SizedBox(height: widget.foodItem.requiredOptions.isNotEmpty ? 16.0 : 0.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Extras",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...widget.foodItem.extras.map((extra) {
                return CheckboxListTile(
                  title: Text("${extra.name} (\$${extra.price?.toStringAsFixed(2)})"),
                  value: extrasSelected[extra.name],
                  onChanged: (bool? value) {
                    setState(() {
                      extrasSelected[extra.name] = value!;
                      _updateTotalPrice(extra.name, value);
                    });
                  },
                );
              }).toList(),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        Text("Total: \$${totalPrice.toStringAsFixed(2)}"),
        ElevatedButton(
          onPressed: () {
            bool canProceed = true;
            setState(() {
              for (var option in widget.foodItem.requiredOptions) {
                if (selectedRequiredOptions[option.name] == "(Choose an option)") {
                  showError[option.name] = true;
                  canProceed = false;
                } else {
                  showError[option.name] = false;
                }
              }
            });

            if (canProceed) {
              Navigator.of(context).pop();
            }
          },
          child: Text('Add to Cart'),
        ),
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
