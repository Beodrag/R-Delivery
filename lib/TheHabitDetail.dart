import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'cart_page.dart';
import 'food_item_models.dart';
import 'cart_model.dart';

class TheHabitDetail extends StatefulWidget {
  final Map<String, String> restaurant;

  TheHabitDetail({required this.restaurant});

  @override
  _TheHabitDetailState createState() => _TheHabitDetailState();
}

class _TheHabitDetailState extends State<TheHabitDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AutoScrollController _scrollController = AutoScrollController();
  List<GlobalKey> _keys = List.generate(11, (index) => GlobalKey());
  Timer? _debounce;
  bool _tabChangeByScroll = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 11, vsync: this);
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
      _scrollToIndex(_tabController.index);
    }
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
        title: Text('The Habit'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: 'Charburgers'),
              Tab(text: 'Signature Sandwiches'),
              Tab(text: 'Popular Meals'),
              Tab(text: 'Seasonal Feature'),
              Tab(text: 'Family Bundles'),
              Tab(text: 'Fresh Salads'),
              Tab(text: 'Sides'),
              Tab(text: 'Frozen Treats'),
              Tab(text: 'Drinks'),
              Tab(text: 'Signature Sauces')
            ],
          ).preferredSize,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: 'Charburgers'),
                Tab(text: 'Signature Sandwiches'),
                Tab(text: 'Popular Meals'),
                Tab(text: 'Seasonal Feature'),
                Tab(text: 'Family Bundles'),
                Tab(text: 'Fresh Salads'),
                Tab(text: 'Sides'),
                Tab(text: 'Frozen Treats'),
                Tab(text: 'Drinks'),
                Tab(text: 'Signature Sauces')
              ],
            ),
          ),
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
              categoryName: 'Charburgers',
              isFirstCategory: true,
              foodList: [
                FoodItem(
                  name: '#1 Original Charburger Meal',
                  description: 'Our award-winning burger topped with caramelized onions, crisp lettuce, fresh tomato, '
                      'pickles, and mayo on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_one.png',
                  price: 11.09,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#2 Original Double Char Meal',
                  description: 'Two freshly chargrilled beef patties, caramelized onions, crisp lettuce, '
                      'fresh tomato, pickles, and mayo on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_two.png',
                  price: 12.69,
                  requiredOptions: [
                    RequiredOption(
                      name: "Double Cheese Type",
                      options: ["No Cheese", "American Double", "White American Double"],
                      optionPrices: {
                        "American Double": 0.9,
                        "White American Double": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Santa Barbara Charburger',
                  description: 'Two freshly chargrilled beef patties, avocado, '
                      'caramelized onions, American cheese, crisp lettuce, '
                      'tomato, pickles and mayo on grilled sourdough.',
                  image: 'assets/images/habit/santa_barbara_char.png',
                  price: 8.49,
                  requiredOptions: [
                    RequiredOption(
                      name: "Double Cheese Type",
                      options: ["No Cheese", "American Double", "White American Double"],
                      optionPrices: {
                        "American Double": 0.9,
                        "White American Double": 0.9,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Charburger',
                  description: 'Our award-winning burger topped with '
                      'caramelized onions, crisp lettuce, fresh tomato, '
                      'pickles, and mayo on a toasted bun.',
                  image: 'assets/images/habit/char.png',
                  price: 5.39,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Double Char',
                  description: 'Two freshly chargrilled beef patties, '
                      'caramelized onions, crisp lettuce, fresh tomato, '
                      'pickles, and mayo on a toasted bun.',
                  image: 'assets/images/habit/double_char.png',
                  price: 6.99,
                  requiredOptions: [
                    RequiredOption(
                      name: "Double Cheese Type",
                      options: ["No Cheese", "American Double", "White American Double"],
                      optionPrices: {
                        "American Double": 0.9,
                        "White American Double": 0.9,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: 'BBQ Bacon Char',
                  description: 'Freshly chargrilled beef patty, '
                      'hickory-smoked bacon, caramelized onions, '
                      'crisp lettuce, fresh tomato, and mayo on a toasted bun.',
                  image: 'assets/images/habit/bbq_char.png',
                  price: 7.29,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Teriyaki Char',
                  description: 'Freshly chargrilled beef patty, grilled pineapple, '
                      'teriyaki sauce, caramelized onions, crisp lettuce, '
                      'fresh tomato, pickle, and mayo on a toasted bun.',
                  image: 'assets/images/habit/teriyaki_char.png',
                  price: 6.29,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Portabella Char',
                  description: 'Freshly chargrilled beef patty, Portabella mushrooms, caramelized onions, '
                      'melted White American cheese, crisp lettuce, '
                      'fresh tomato, pickle, and roasted garlic aioli on a toasted bun.',
                  image: 'assets/images/habit/portabella_char.png',
                  price: 6.99,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Original Impossible (TM) Burger',
                  description: 'A seared Impossible patty (a plant-based alternative patty) '
                      'topped with caramelized onions, crisp lettuce, '
                      'tomato, pickles, mayo on a toasted bun. '
                      'Impossible is a trademark of Impossible Foods, Inc. Used under license.',
                  image: 'assets/images/habit/impossible_char.png',
                  price: 7.99,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Type of Onions",
                      options: ["Grilled Onions", "No Onion", "Raw Onions"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Extra Patty',
                  description: '',
                  price: 1.6,
                  image: '',
                  extras: [],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[1],
            controller: _scrollController,
            index: 1,
            child: FoodCategory(
                key: _keys[1],
                categoryName: 'Signature Sandwiches',
                foodList: [
                  FoodItem(
                    name: 'Spicy Crispy Chicken Sandwich',
                    description: 'Crispy Chicken breast with white '
                        'American cheese, house-made coleslaw, pickles, '
                        'and spicy red pepper sauce on a toasted flaxseed brioche bun ',
                    image: 'assets/images/habit/crispy_chicken.png',
                    price: 9.99,
                    extras: [
                      ExtraOption(name: "Napkins", price: 0.00),
                    ],
                  ),
                  FoodItem(
                    name: 'Ahi Tuna Filet',
                    description: 'Line-caught, sushi-grade tuna steak with a teriyaki glaze, '
                        'crisp shredded lettuce, fresh tomatoes, and tartar sauce',
                    image: 'assets/images/habit/ahi_tuna.png',
                    price: 9.99,
                    requiredOptions: [
                      RequiredOption(
                        name: "Type of Bread",
                        options: ["Seeded Bun", "Ciabatta", "Lettuce Wrap", "Sourdough", "Wheat Bun", "Plain Bun"],
                      ),
                    ],
                    extras: [
                      ExtraOption(name: "Avocado", price: 2.00),
                      ExtraOption(name: "Napkins", price: 0.00),
                    ],
                  ),
                  FoodItem(
                    name: 'Chicken Club',
                    description: 'Hand-filleted marinated chicken breast, green leaf lettuce, tomatoes, hickory-smoked bacon, fresh avocado, and mayo, served on toasted sourdough',
                    price: 9.99,
                    image: 'assets/images/habit/chicken_club.png',
                    extras: [
                      ExtraOption(name: "Napkins", price: 0.00),
                    ],
                  ),
                  FoodItem(
                    name: 'Grilled Chicken',
                    description: 'Hand-filleted marinated chicken breast, melted cheese, crisp shredded lettuce,'
                        ' fresh tomatoes, mayo, and your choice of BBQ or teriyaki sauce.',
                    image: 'assets/images/habit/grilled_chicken.png',
                    price: 7.99,
                    requiredOptions: [
                      RequiredOption(
                          name: "Cheese",
                          options: ["No Cheese", "American", "White American"],
                          optionPrices: {
                            "American": 0.9,
                            "White American": 0.9,
                          },
                      ),
                      RequiredOption(
                        name: "Type of Onions",
                        options: ["Grilled Onions", "No Onion", "Raw Onions"],
                      ),
                      RequiredOption(
                        name: "Type of Sauce",
                        options: ["BBQ Sauce", "Teriyaki Sauce", "No Sauce"],
                      ),
                    ],
                    extras: [
                      ExtraOption(name: "Avocado", price: 2.00),
                      ExtraOption(name: "Napkins", price: 0.00),
                    ],
                  ),
                  FoodItem(
                    name: 'Veggie Burger',
                    description: 'Vegan veggie patty on a toasted wheat bun, green leaf lettuce,'
                        ' fresh tomatoes, and cucumbers, with sweet mustard dressing, and onions.'
                        ' (Grilled onions are not vegetarian)',
                    image: 'assets/images/habit/veggie_burger.png',
                    price: 7.29,
                    requiredOptions: [
                      RequiredOption(
                        name: "Type of Bread",
                        options: ["Seeded Bun", "Ciabatta", "Lettuce Wrap", "Sourdough", "Wheat Bun", "Plain Bun"],
                      ),
                      RequiredOption(
                        name: "Type of Onions",
                        options: ["Grilled Onions", "No Onion", "Raw Onions"],
                      ),
                      RequiredOption(
                        name: "Type of Sauce",
                        options: ["BBQ Sauce", "Teriyaki Sauce", "No Sauce"],
                      ),
                    ],
                    extras: [
                      ExtraOption(name: "Avocado", price: 2.00),
                      ExtraOption(name: "Napkins", price: 0.00),
                    ],
                  ),
                  FoodItem(
                    name: 'Grilled Cheese',
                    description: 'Three slices of American cheese between two buttered slices of grilled sourdough bread',
                    image: 'assets/images/habit/grilled_cheese.png',
                    price: 5.69,
                    extras: [
                      ExtraOption(name: "Avocado", price: 2.00),
                      ExtraOption(name: "Bacon", price: 1.80),
                      ExtraOption(name: "Napkins", price: 0.00),
                    ],
                  ),
                ]
            ),
          ),
          AutoScrollTag(
            key: _keys[2],
            controller: _scrollController,
            index: 2,
            child: FoodCategory(
              key: _keys[2],
              categoryName: 'Popular Meals',
              foodList: [
                FoodItem(
                  name: '#1 Original Charburger Meal',
                  description: 'Our award-winning burger topped with caramelized onions, crisp lettuce, fresh tomato, '
                      'pickles, and mayo on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_one.png',
                  price: 11.09,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#2 Original Double Char Meal',
                  description: 'Two freshly chargrilled beef patties, caramelized onions, crisp lettuce, '
                      'fresh tomato, pickles, and mayo on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_two.png',
                  price: 12.69,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#3 Teriyaki Char Meal',
                  description: 'Freshly chargrilled beef patty, grilled pineapple, teriyaki sauce, caramelized onions, '
                      'crisp lettuce, fresh tomato, pickle, and mayo on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_three.png',
                  price: 11.99,
                  requiredOptions: [
                    RequiredOption(
                      name: "Double Cheese",
                      options: ["No Cheese", "American Double", "White American Double"],
                      optionPrices: {
                        "American Double": 0.9,
                        "White American Double": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#4 BBQ Bacon Char Meal',
                  description: 'Freshly chargrilled beef patty, hickory-smoked bacon, caramelized onions, crisp lettuce,'
                      ' fresh tomato, and mayo on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_four.png',
                  price: 12.99,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#5 Portabella Char Meal',
                  description: 'Freshly chargrilled beef patty, Portabella mushrooms, caramelized onions, melted White American cheese, '
                      'crisp lettuce, fresh tomato, pickle, and roasted garlic aioli on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_five.png',
                  price: 12.69,
                  requiredOptions: [
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#6 Santa Barbara Charburger Meal',
                  description: 'Two freshly chargrilled beef patties, avocado, caramelized onions, American cheese, crisp lettuce, '
                      'tomato, pickles and mayo on grilled sourdough. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_six.png',
                  price: 14.19,
                  requiredOptions: [
                    RequiredOption(
                      name: "Double Cheese",
                      options: ["No Cheese", "American Double", "White American Double"],
                      optionPrices: {
                        "American Double": 0.9,
                        "White American Double": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#7 Impossible Burger Meal',
                  description: 'A seared Impossible patty (a plant-based alternative patty) topped with caramelized onions, crisp lettuce,'
                      ' tomato, pickles, mayo on a toasted bun. Includes fries and a regular drink. Impossible is a trademark of Impossible Foods, Inc. Used under license.',
                  image: 'assets/images/habit/popular_seven.png',
                  price: 13.69,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Type of Onions",
                      options: ["Grilled Onions", "No Onion", "Raw Onions"],
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                    extras: [
                      ExtraOption(name: "Napkins", price: 0.00),
                    ],
                ),
                FoodItem(
                  name: '#8 Grilled Chicken Sandwich Meal',
                  description: 'Hand-filleted marinated chicken breast, melted cheese, crisp shredded lettuce, fresh tomatoes,'
                      ' mayo, and your choice of BBQ or teriyaki sauce. Includes fries and a regular drink. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_eight.png',
                  price: 13.69,
                  requiredOptions: [
                    RequiredOption(
                      name: "Type of Bread",
                      options: ["Seeded Bun", "Ciabatta", "Lettuce Wrap", "Sourdough", "Wheat Bun", "Plain Bun"],
                    ),
                    RequiredOption(
                      name: "Type of Onions",
                      options: ["Grilled Onions", "No Onion", "Raw Onions"],
                    ),
                    RequiredOption(
                      name: "Type of Sauce",
                      options: ["BBQ Sauce", "Teriyaki Sauce", "No Sauce"],
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#9 Chicken Club Sandwich Meal',
                  description: 'Hand-filleted marinated chicken breast, green leaf lettuce, tomatoes, hickory-smoked bacon, fresh avocado, and mayo,'
                      ' served on toasted sourdough. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_nine.png',
                  price: 15.69,
                  requiredOptions: [
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#10 Veggie Burger Meal',
                  description: 'Vegan veggie patty on a toasted wheat bun, green leaf lettuce, fresh tomatoes,'
                      ' and cucumbers, with sweet mustard dressing, and onions. (Grilled onions are not vegetarian) Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_ten.png',
                  price: 12.99,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Type of Onions",
                      options: ["Grilled Onions", "No Onion", "Raw Onions"],
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#11 Ahi Tuna Filet Sandwich Meal',
                  description: 'Line-caught, sushi-grade tuna steak with a teriyaki glaze,'
                      ' crisp shredded lettuce, fresh tomatoes, and tartar sauce. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_eleven.png',
                  price: 15.69,
                  requiredOptions: [
                    RequiredOption(
                      name: "Type of Bread",
                      options: ["Seeded Bun", "Ciabatta", "Lettuce Wrap", "Sourdough", "Wheat Bun", "Plain Bun"],
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '#12 Spicy Chicken Sandwich Meal',
                  description: 'Crispy Chicken breast with white American cheese, house-made coleslaw, pickles,'
                      ' and spicy red pepper sauce on a toasted flaxseed brioche bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_twelve.png',
                  price: 15.69,
                  requiredOptions: [
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Drink",
                      options: ["Regular Fountain Drink", "Large Fountain Drink", "Bottled Water"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[3],
            controller: _scrollController,
            index: 3,
            child: FoodCategory(
              key: _keys[3],
              categoryName: 'Seasonal Feature',
              foodList: [
                FoodItem(
                  name: 'Parmesan Garlic Fries',
                  description: 'Golden crisp fries with topped with shredded Parmesan Cheese and a Parmesan Garlic Sauce',
                  image: 'assets/images/habit/garlic_fries.png',
                  price: 4.19,
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[4],
            controller: _scrollController,
            index: 4,
            child: FoodCategory(
              key: _keys[4],
              categoryName: 'Family Bundles',
              foodList: [
                FoodItem(
                  name: 'Variety Meal',
                  description: 'Two grilled chicken sandwiches, two Charburgers with cheese, '
                      'two onion rings, two french fries, and an entrée garden salad.',
                  image: 'assets/images/habit/variety_meal.png',
                  price: 45.00,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese 1",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Cheese 2",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Type of Bread 1",
                      options: ["Seeded Bun", "Ciabatta", "Lettuce Wrap", "Sourdough", "Wheat Bun", "Plain Bun"],
                    ),
                    RequiredOption(
                      name: "Type of Bread 2",
                      options: ["Seeded Bun", "Ciabatta", "Lettuce Wrap", "Sourdough", "Wheat Bun", "Plain Bun"],
                    ),
                    RequiredOption(
                      name: "Type of Onions 1",
                      options: ["Grilled Onions", "No Onion", "Raw Onions"],
                    ),
                    RequiredOption(
                      name: "Type of Sauce 1",
                      options: ["BBQ Sauce", "Teriyaki Sauce", "No Sauce"],
                    ),
                    RequiredOption(
                      name: "Type of Onions 2",
                      options: ["Grilled Onions", "No Onion", "Raw Onions"],
                    ),
                    RequiredOption(
                      name: "Type of Sauce 2",
                      options: ["BBQ Sauce", "Teriyaki Sauce", "No Sauce"],
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 3",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 4",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 5",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 6",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Ranch 1",
                      options: ["No Sauce", "Ranch Sauce"],
                    ),
                    RequiredOption(
                      name: "Ranch 2",
                      options: ["No Sauce", "Ranch Sauce"],
                    ),
                    RequiredOption(
                      name: "Type of Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                    ),
                    RequiredOption(
                      name: "Extra Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                      optionPrices: {
                        "1000 Island": 1.00,
                        "Bleu Cheese": 1.00,
                        "Caesar": 1.00,
                        "Fat Free Italian Dressing": 1.00,
                        "House Dressing": 1.00,
                        "Ranch": 1.00,
                        "Red Vinaigrette": 1.00,
                        "Sweet Mustard": 1.00,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Family Char Meal',
                  description: 'Four Charburgers with cheese, four french fries, and an entrée garden salad.',
                  image: 'assets/images/habit/family_char.png',
                  price: 40.00,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese 1",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Cheese 2",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Cheese 3",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Cheese 4",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 3",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 4",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 5",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 6",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 7",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 8",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Type of Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                    ),
                    RequiredOption(
                      name: "Extra Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                      optionPrices: {
                        "1000 Island": 1.00,
                        "Bleu Cheese": 1.00,
                        "Caesar": 1.00,
                        "Fat Free Italian Dressing": 1.00,
                        "House Dressing": 1.00,
                        "Ranch": 1.00,
                        "Red Vinaigrette": 1.00,
                        "Sweet Mustard": 1.00,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Chars & Bites Bundle',
                  description: 'Four Charburgers with cheese, four French fries, and a snack 10 piece Crispy Chicken Bites.',
                  image: 'assets/images/habit/char_bites.png',
                  price: 40.00,
                  requiredOptions: [
                    RequiredOption(
                      name: "Cheese 1",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Cheese 2",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Cheese 3",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Cheese 4",
                      options: ["No Cheese", "American", "White American"],
                      optionPrices: {
                        "American": 0.9,
                        "White American": 0.9,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 3",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 4",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 5",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 6",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 7",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Sauce 8",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Chicken Bites Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch","Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                    ),
                    RequiredOption(
                      name: "Chicken Bites Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Boom Sauce", "Sweet Mustard", "Teriyaki Sauce"],
                    ),
                    RequiredOption(
                      name: "Sauce 9",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[5],
            controller: _scrollController,
            index: 5,
            child: FoodCategory(
              key: _keys[5],
              categoryName: 'Fresh Salads',
              foodList: [
                FoodItem(
                  name: 'Santa Barbara Cobb',
                  description: 'Crisp shredded iceberg and Romaine lettuce, diced tomatoes, avocado, '
                      'blue cheese crumbles, hickory-smoked bacon, and egg, tossed in our red wine vinaigrette,'
                      ' topped with chargrilled chicken breast.',
                  image: 'assets/images/habit/barbara_cobb.png',
                  price: 10.29,
                  requiredOptions: [
                    RequiredOption(
                      name: "Type of Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'BBQ Chicken Salad',
                  description: 'Chargrilled chicken breast atop garden greens, hickory-smoked bacon, diced red onions,'
                      ' diced tomatoes, cilantro, and ranch dressing, topped with tangy BBQ sauce.',
                  image: 'assets/images/habit/barbara_cobb.png',
                  price: 10.29,
                  requiredOptions: [
                    RequiredOption(
                      name: "Type of Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                    ),
                    RequiredOption(
                      name: "Extra Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                      optionPrices: {
                        "1000 Island": 1.00,
                        "Bleu Cheese": 1.00,
                        "Caesar": 1.00,
                        "Fat Free Italian Dressing": 1.00,
                        "House Dressing": 1.00,
                        "Ranch": 1.00,
                        "Red Vinaigrette": 1.00,
                        "Sweet Mustard": 1.00,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Grilled Chicken Salad',
                  description: 'Romaine, iceberg, green and red leaf lettuce, red cabbage, Roma tomatoes, '
                      'cucumbers, red onions, carrots and croutons, topped with a chargrilled chicken breast.',
                  image: 'assets/images/habit/grilled_chicken_salad.png',
                  price: 9.79,
                  requiredOptions: [
                    RequiredOption(
                      name: "Type of Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                    ),
                    RequiredOption(
                      name: "Extra Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                      optionPrices: {
                        "1000 Island": 1.00,
                        "Bleu Cheese": 1.00,
                        "Caesar": 1.00,
                        "Fat Free Italian Dressing": 1.00,
                        "House Dressing": 1.00,
                        "Ranch": 1.00,
                        "Red Vinaigrette": 1.00,
                        "Sweet Mustard": 1.00,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Grilled Chicken Caesar',
                  description: 'Chopped Romaine tossed in our Caesar dressing, croutons, grated Parmesan and topped with grilled chicken breast.',
                  image: 'assets/images/habit/grilled_chicken_caesar.png',
                  price: 9.99,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Napkins", price: 0.00),
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Garden Salad',
                  description: 'Romaine, iceberg, green and red leaf lettuce, red cabbage, Roma tomatoes, cucumbers, red onions, carrots and croutons.',
                  image: 'assets/images/habit/garden_salad.png',
                  price: 5.99,
                  requiredOptions: [
                    RequiredOption(
                      name: "Type of Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                    ),
                    RequiredOption(
                      name: "Extra Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                      optionPrices: {
                        "1000 Island": 1.00,
                        "Bleu Cheese": 1.00,
                        "Caesar": 1.00,
                        "Fat Free Italian Dressing": 1.00,
                        "House Dressing": 1.00,
                        "Ranch": 1.00,
                        "Red Vinaigrette": 1.00,
                        "Sweet Mustard": 1.00,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Caesar Salad',
                  description: 'Chopped Romaine tossed in our Caesar dressing, croutons and grated Parmesan cheese.',
                  image: 'assets/images/habit/caesar_salad.png',
                  price: 5.99,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                    ExtraOption(name: "Napkins", price: 0.00),
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[6],
            controller: _scrollController,
            index: 6,
            child: FoodCategory(
              key: _keys[6],
              categoryName: 'Sides',
              foodList: [
                FoodItem(
                  name: 'Parmesan Garlic Fries',
                  description: 'Golden crisp fries with topped with shredded Parmesan Cheese and a Parmesan Garlic Sauce',
                  image: 'assets/images/habit/garlic_fries.png',
                  price: 4.19,
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '10 pcs Crispy Chicken Bites',
                  description: 'All-natural chicken double breaded in our signature spices served with your choice of sauce',
                  image: 'assets/images/habit/ten_chicken_bites.png',
                  price: 7.89,
                  requiredOptions: [
                    RequiredOption(
                      name: "Chicken Bites Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch","Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                    ),
                    RequiredOption(
                      name: "Chicken Bites Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Boom Sauce", "Sweet Mustard", "Teriyaki Sauce"],
                    ),
                    RequiredOption(
                      name: "Extra Sauce",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: '5 pcs Crispy Chicken Bites',
                  description: 'All-natural chicken double breaded in our signature spices served with your choice of sauce',
                  image: 'assets/images/habit/five_chicken_bites.png',
                  price: 5.79,
                  requiredOptions: [
                    RequiredOption(
                      name: "Chicken Bites Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch","Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                    ),
                    RequiredOption(
                      name: "Extra Sauce",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'French Fries',
                  description: '',
                  image: 'assets/images/habit/fries.png',
                  price: 2.99,
                  requiredOptions: [
                    RequiredOption(
                      name: "Extra Sauce 1",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                    RequiredOption(
                      name: "Extra Sauce 2",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Onion Rings',
                  description: 'Choose your sauce. Dipping sauce recommended: Ranch',
                  image: 'assets/images/habit/onion_rings.png',
                  price: 3.79,
                  requiredOptions: [
                    RequiredOption(
                      name: "Ranch",
                      options: ["No Ranch", "Add Ranch"],
                    ),
                    RequiredOption(
                      name: "Extra Sauce",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Tempura Green Beans',
                  description: 'Choose your sauce. Dipping sauce recommended: Ranch',
                  image: 'assets/images/habit/tempura_gb.png',
                  price: 3.99,
                  requiredOptions: [
                    RequiredOption(
                      name: "Ranch",
                      options: ["No Ranch", "Add Ranch"],
                    ),
                    RequiredOption(
                      name: "Extra Sauce",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Sweet Potato Fries',
                  description: 'Choose your sauce. Dipping sauce recommended: Ranch',
                  image: 'assets/images/habit/sp_fries.png',
                  price: 3.99,
                  requiredOptions: [
                    RequiredOption(
                      name: "Ranch",
                      options: ["No Ranch", "Add Ranch"],
                    ),
                    RequiredOption(
                      name: "Extra Sauce",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Half and Half Sides',
                  description: 'Half fries and half another side of your choice',
                  image: 'assets/images/habit/half_and_half.png',
                  price: 3.79,
                  requiredOptions: [
                    RequiredOption(
                      name: "Half Side",
                      options: ["Onion Rings", "Sweet Potato Fries", "Tempura Green Beans"],
                    ),
                    RequiredOption(
                      name: "Ranch",
                      options: ["No Ranch", "Add Ranch"],
                    ),
                    RequiredOption(
                      name: "Extra Sauce",
                      options: ["No Sauce", "BBQ Sauce", "House-made Ranch", "Ketchup", "Spicy Red Pepper", "Sweet Mustard", "Teriyaki Sauce"],
                      optionPrices: {
                        "BBQ Sauce": 0.5,
                        "House-made Ranch": 0.5,
                        "Spicy Red Pepper": 0.5,
                        "Sweet Mustard": 0.5,
                        "Teriyaki Sauce": 0.5,
                      },
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Side Salad',
                  description: 'Romaine, iceberg, and red leaf lettuces, Roma tomatoes, cucumbers, carrots, and croutons.',
                  image: 'assets/images/habit/side_salad.png',
                  price: 3.99,
                  requiredOptions: [
                    RequiredOption(
                      name: "Type of Dressing",
                      options: ["No Dressing", "1000 Island", "Bleu Cheese", "Caesar", "Fat Free Italian Dressing", "House Dressing", "Ranch", "Red Vinaigrette", "Sweet Mustard"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Side Caesar Salad',
                  description: 'Chopped Romaine tossed in our Caesar dressing, croutons and grated Parmesan.',
                  image: 'assets/images/habit/side_caesar.png',
                  price: 3.99,
                  extras: [
                    ExtraOption(name: "Napkins", price: 0.00),
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[7],
            controller: _scrollController,
            index: 7,
            child: FoodCategory(
              key: _keys[7],
              categoryName: 'Frozen Treats',
              foodList: [
                FoodItem(
                  name: 'Oreo Cookie Shake',
                  description: '16 oz. handcrafted and made-to-order. Vanilla ice cream blended with OREO® Cookie pieces,'
                      ' topped with whipped cream and even more OREO Cookie pieces. OREO is a trademark of Mondelez International group, used under license.',
                  image: 'assets/images/habit/oreo_shake.png',
                  price: 5.19,
                  requiredOptions: [
                    RequiredOption(
                      name: "Whipped Cream",
                      options: ["No Whipped Cream", "Whipped Cream"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Chocolate Shake',
                  description: 'Handcrafted and made-to-order.',
                  image: 'assets/images/habit/chocolate_shake.png',
                  price: 5.19,
                  requiredOptions: [
                    RequiredOption(
                      name: "Whipped Cream",
                      options: ["No Whipped Cream", "Whipped Cream"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Strawberry Shake',
                  description: 'Handcrafted and made-to-order.',
                  image: 'assets/images/habit/strawberry_shake.png',
                  price: 5.19,
                  requiredOptions: [
                    RequiredOption(
                      name: "Whipped Cream",
                      options: ["No Whipped Cream", "Whipped Cream"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Vanilla Shake',
                  description: 'Handcrafted and made-to-order.',
                  image: 'assets/images/habit/vanilla_shake.png',
                  price: 5.19,
                  requiredOptions: [
                    RequiredOption(
                      name: "Whipped Cream",
                      options: ["No Whipped Cream", "Whipped Cream"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Mocha Shake',
                  description: 'Handcrafted and made-to-order.',
                  image: 'assets/images/habit/mocha_shake.png',
                  price: 5.19,
                  requiredOptions: [
                    RequiredOption(
                      name: "Whipped Cream",
                      options: ["No Whipped Cream", "Whipped Cream"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Coffee Shake',
                  description: 'Handcrafted and made-to-order.',
                  image: 'assets/images/habit/coffee_shake.png',
                  price: 5.19,
                  requiredOptions: [
                    RequiredOption(
                      name: "Whipped Cream",
                      options: ["No Whipped Cream", "Whipped Cream"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
                FoodItem(
                  name: 'Sundaes',
                  description: "Vanilla soft serve, Hershey's® chocolate, whipped cream & nuts.",
                  image: 'assets/images/habit/sundae.png',
                  price: 3.49,
                  requiredOptions: [
                    RequiredOption(
                      name: "Flavor",
                      options: ["Chocolate", "Strawberry"],
                    ),
                    RequiredOption(
                      name: "Nuts?",
                      options: ["No Nuts", "Nuts"],
                    ),
                    RequiredOption(
                      name: "Whipped Cream",
                      options: ["No Whipped Cream", "Whipped Cream"],
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Utensils", price: 0.00),
                  ],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[8],
            controller: _scrollController,
            index: 8,
            child: FoodCategory(
              key: _keys[8],
              categoryName: 'Drinks',
              foodList: [
                FoodItem(
                  name: 'Fountain Drinks',
                  description: '',
                  image: 'assets/images/habit/fountain_drink.png',
                  price: 2.79,
                  requiredOptions: [
                    RequiredOption(
                      name: "Size",
                      options: ["Regular", "Large"],
                      optionPrices: {
                        "Large": 0.5,
                      }
                    ),
                  ],
                  extras: []
                ),
                FoodItem(
                    name: 'Fresh Brewed Iced Teas',
                    description: '',
                    image: 'assets/images/habit/iced_tea.png',
                    price: 2.79,
                    requiredOptions: [
                      RequiredOption(
                          name: "Size",
                          options: ["Regular", "Large"],
                          optionPrices: {
                            "Large": 0.5,
                          }
                      ),
                      RequiredOption(
                          name: "Flavor",
                          options: ["Iced Tea", "Tropical Tea"],
                      ),
                    ],
                    extras: []
                ),
                FoodItem(
                    name: 'Bottled Water',
                    description: '17 oz Dasani',
                    image: 'assets/images/habit/bottled_water.png',
                    price: 2.79,
                    extras: []
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[9],
            controller: _scrollController,
            index: 9,
            child: FoodCategory(
              key: _keys[9],
              categoryName: 'Signature Sauces',
              foodList: [
                FoodItem(
                    name: 'Ranch',
                    description: '',
                    image: 'assets/images/habit/ranch.png',
                    price: 0.5,
                    extras: []
                ),
                FoodItem(
                    name: 'Spicy Red Pepper Sauce',
                    description: '',
                    image: 'assets/images/habit/pepper_sauce.png',
                    price: 0.5,
                    extras: []
                ),
                FoodItem(
                    name: 'BBQ Sauce',
                    description: '',
                    image: 'assets/images/habit/bbq.png',
                    price: 0.5,
                    extras: []
                ),
                FoodItem(
                    name: 'Sweet Mustard',
                    description: '',
                    image: 'assets/images/habit/sweet_mustard.png',
                    price: 0.5,
                    extras: []
                ),
                FoodItem(
                    name: 'Teriyaki Sauce',
                    description: '',
                    image: 'assets/images/habit/teriyaki.png',
                    price: 0.5,
                    extras: []
                ),
              ],
            ),
          ),
          // Add more AutoScrollTags for other categories
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
              },
              child: Text('Go to Cart'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Restaurant List'),
            ),
          ),
        ],
      ),
    );
  }
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
        if (isFirstCategory) ...[
          Image.asset(
            'assets/images/the_habit.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.0,
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              'The Habit',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16.0),
        ],
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            categoryName,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: foodList.map((foodItem) => FoodOption(foodItem: foodItem)).toList(),
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
            if (foodItem.image != null && foodItem.image!.isNotEmpty)
              Expanded(
                flex: 2,
                child: Image.asset(
                  foodItem.image!,
                  fit: BoxFit.contain,
                  height: 100.0,
                ),
              )
            else
              Container(
                width: 200.0,
                height: 100.0,
              ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodItem.name,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      foodItem.description,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "\$${foodItem.price.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
        return DialogWithExtras(
          foodItem: item,
          onAddToCart: (FoodItem addedItem, Map<String, String?> selectedOptions, Map<String, bool> extras) {
            double totalPrice = addedItem.price;

            // Calculate additional costs for required options
            addedItem.requiredOptions.forEach((option) {
              String? selectedOption = selectedOptions[option.name];
              double? additionalCost = option.optionPrices[selectedOption];
              if (additionalCost != null) {
                totalPrice += additionalCost;
              }
            });

            // Add the price of selected extras
            addedItem.extras.forEach((extra) {
              if (extras[extra.name] == true) {
                totalPrice += extra.price ?? 0.0;
              }
            });

            // Update the price of the item
            addedItem.price = totalPrice;

            Provider.of<CartModel>(context, listen: false).addItem(addedItem);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}


class DialogWithExtras extends StatefulWidget {
  final FoodItem foodItem;

  DialogWithExtras({Key? key, required this.foodItem, required Null Function(FoodItem addedItem, Map<String, String?> selectedOptions, Map<String, bool> extras) onAddToCart}) : super(key: key);

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
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    double tempTotal = widget.foodItem.price;
    widget.foodItem.extras.forEach((extra) {
      if (extrasSelected[extra.name] == true) {
        tempTotal += extra.price ?? 0.0;
      }
    });

    widget.foodItem.requiredOptions.forEach((option) {
      String? selectedOption = selectedRequiredOptions[option.name];
      double? additionalCost = option.optionPrices[selectedOption];
      if (additionalCost != null) {
        tempTotal += additionalCost;
      }
    });

    setState(() {
      totalPrice = tempTotal;
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
            ...buildRequiredOptions(),
            ...buildExtrasOptions(),
          ],
        ),
      ),
      actions: <Widget>[
        Text("Total: \$${totalPrice.toStringAsFixed(2)}"),
        ElevatedButton(
          onPressed: () {
            if (validateRequiredOptions()) {
              widget.foodItem.selectedRequiredOptions = selectedRequiredOptions;
              widget.foodItem.selectedExtras = extrasSelected;
              Provider.of<CartModel>(context, listen: false).addItem(widget.foodItem.clone());
              Navigator.of(context).pop();
            } else {
              print('Validation failed, item not added to cart');
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

  List<Widget> buildRequiredOptions() {
    return widget.foodItem.requiredOptions.map((requiredOption) {
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
                calculateTotalPrice();
              });
            },
            items: [DropdownMenuItem<String>(value: "(Choose an option)", child: Text("(Choose an option)"))]
              ..addAll(requiredOption.options.map((option) {
                double? price = requiredOption.optionPrices[option];
                String optionText = price != null && price > 0 ? "$option (+\$${price.toStringAsFixed(2)})" : option;
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(optionText),
                );
              })),
          ),
          SizedBox(height: 10),
        ],
      );
    }).toList();
  }

  List<Widget> buildExtrasOptions() {
    return widget.foodItem.extras.isNotEmpty ? [
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
              calculateTotalPrice();
            });
          },
        );
      }).toList(),
    ] : [];
  }

  bool validateRequiredOptions() {
    bool allValid = true;
    setState(() {
      for (var option in widget.foodItem.requiredOptions) {
        if (selectedRequiredOptions[option.name] == "(Choose an option)") {
          showError[option.name] = true;
          allValid = false;
        } else {
          showError[option.name] = false;
        }
      }
    });
    return allValid;
  }
}
