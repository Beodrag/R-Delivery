import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
        title: Text('The Habit'),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: [
            Tab(text: 'Charburgers'),
            Tab(text: 'Signature Sandwiches'),
            Tab(text: 'Popular Meals'),
            Tab(text: 'Seasonal Feature'),
            Tab(text: 'Family Bundles'),
            Tab(text: 'Fresh Salads'),
            Tab(text: 'Sides'),
            Tab(text: 'Kids Favorites'),
            Tab(text: 'Frozen Treats'),
            Tab(text: 'Drinks'),
            Tab(text: 'Signature Sauces')
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
              categoryName: 'Charburgers',
              isFirstCategory: true,
              foodList: [
                FoodItem(
                name: '#1 Original Charburger',
                description: 'A seared Impossible patty (a plant-based alternative patty) '
                    'topped with caramelized onions, crisp lettuce, '
                    'tomato, pickles, mayo on a toasted bun. ',
                image: 'assets/images/habit/#1.png',
                price: 11.09,
                extras: [
                  ExtraOption(name: "Cheese", price: 1.00, ),
                  ExtraOption(name: "Avocado", price: 2.00,),
                  ExtraOption(name: "Bacon", price: 1.80,),
                  AdditionalOption(name: "Bacon"),
                ],
              ),
                FoodItem(
                  name: '#2 Original Double Char',
                  description: 'Two freshly chargrilled beef patties, caramelized onions,'
                      ' crisp lettuce, fresh tomato, pickles, and mayo on a toasted bun. '
                      'Includes fries and a regular drink.',
                  image: 'assets/images/habit/#2.png',
                  price: 12.69,
                  extras: [
                    ExtraOption(name: "Cheese", price: 1.00),
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: 'Patty Melt',
                  description: 'Two chargrilled patties served on a toasted '
                      'corn rye, with one slice of yellow American cheese '
                      'and one slice of white American cheese, caramelized'
                      ' onions, and Thousand Island spread.',
                  image: 'assets/images/habit/patty_melt.png',
                  price: 8.79,
                  extras: [
                    ExtraOption(name: "Cheese", price: 1.00),
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: 'Santa Barbara Charburger',
                  description: 'Two freshly chargrilled beef patties, avocado, '
                      'caramelized onions, American cheese, crisp lettuce, '
                      'tomato, pickles and mayo on grilled sourdough.',
                  image: 'assets/images/habit/santa_barbara_char.png',
                  price: 8.49,
                  extras: [
                    ExtraOption(name: "Cheese", price: 1.00),
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: 'Charburger',
                  description: 'Our award-winning burger topped with '
                      'caramelized onions, crisp lettuce, fresh tomato, '
                      'pickles, and mayo on a toasted bun.',
                  image: 'assets/images/habit/char.png',
                  price: 5.39,
                  extras: [
                    ExtraOption(name: "Cheese", price: 1.00),
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: 'Double Char',
                  description: 'Two freshly chargrilled beef patties, '
                      'caramelized onions, crisp lettuce, fresh tomato, '
                      'pickles, and mayo on a toasted bun.',
                  image: 'assets/images/habit/double_char.png',
                  price: 6.99,
                  extras: [
                    ExtraOption(name: "Cheese", price: 1.00),
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
                  extras: [
                    ExtraOption(name: "Cheese", price: 1.00),
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: 'Teriyaki Char',
                  description: 'Freshly chargrilled beef patty, grilled pineapple, '
                      'teriyaki sauce, caramelized onions, crisp lettuce, '
                      'fresh tomato, pickle, and mayo on a toasted bun.',
                  image: 'assets/images/habit/teriyaki_char.png',
                  price: 6.29,
                  extras: [
                    ExtraOption(name: "Cheese", price: 1.00),
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
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
                    ExtraOption(name: "Cheese", price: 1.00),
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
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
                  extras: [
                    ExtraOption(name: "Cheese", price: 1.00),
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
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
                  ],
                ),
                  FoodItem(
                    name: 'Ahi Tuna Filet',
                    description: 'Line-caught, sushi-grade tuna steak with a teriyaki glaze, '
                        'crisp shredded lettuce, fresh tomatoes, and tartar sauce',
                    image: 'assets/images/habit/ahi_tuna.png',
                    price: 9.99,
                    extras: [
                      ExtraOption(name: "Avocado", price: 2.00),
                    ],
                  ),
                  FoodItem(
                    name: 'Chicken Club',
                    description: 'Due to an interruption in supply chain, green leaf lettuce may be '
                        'substituted with iceberg lettuce. Hand-filleted marinated chicken breast, '
                        'green leaf lettuce, tomatoes, hickory-smoked bacon, fresh avocado, and mayo, served on toasted sourdough',
                    price: 9.99,
                    image: 'assets/images/habit/chicken_club.png',
                    extras: [
                    ],
                  ),
                  FoodItem(
                    name: 'Grilled Chicken',
                    description: 'Hand-filleted marinated chicken breast, melted cheese, crisp shredded lettuce,'
                        ' fresh tomatoes, mayo, and your choice of BBQ or teriyaki sauce.',
                    image: 'assets/images/habit/grilled_chicken.png',
                    price: 7.99,
                    extras: [
                      ExtraOption(name: "Avocado", price: 2.00),
                    ],
                  ),
                  FoodItem(
                    name: 'Veggie Burger',
                    description: 'Vegan veggie patty on a toasted wheat bun, green leaf lettuce,'
                        ' fresh tomatoes, and cucumbers, with sweet mustard dressing, and onions.'
                        ' (Grilled onions are not vegetarian)',
                    image: 'assets/images/habit/veggie_burger.png',
                    price: 7.29,
                    extras: [
                      ExtraOption(name: "Cheese", price: 1.00),
                      ExtraOption(name: "Avocado", price: 2.00),
                      ExtraOption(name: "Bacon", price: 1.80),
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
                extras: [
                  ExtraOption(name: "Avocado", price: 2.00),
                  ExtraOption(name: "Bacon", price: 1.80),
                ],
              ),
                FoodItem(
                  name: '#2 Original Double Char Meal',
                  description: 'Two freshly chargrilled beef patties, caramelized onions, crisp lettuce, '
                      'fresh tomato, pickles, and mayo on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_two.png',
                  price: 12.69,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: '#3 Teriyaki Char Meal',
                  description: 'Freshly chargrilled beef patty, grilled pineapple, teriyaki sauce, caramelized onions, '
                      'crisp lettuce, fresh tomato, pickle, and mayo on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_three.png',
                  price: 11.99,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: '#4 BBQ Bacon Char Meal',
                  description: 'Freshly chargrilled beef patty, hickory-smoked bacon, caramelized onions, crisp lettuce,'
                      ' fresh tomato, and mayo on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_four.png',
                  price: 12.99,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                  ],
                ),
                FoodItem(
                  name: '#5 Portabella Char Meal',
                  description: 'Freshly chargrilled beef patty, Portabella mushrooms, caramelized onions, melted White American cheese, '
                      'crisp lettuce, fresh tomato, pickle, and roasted garlic aioli on a toasted bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_five.png',
                  price: 12.69,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: '#6 Santa Barbara Charburger Meal',
                  description: 'Two freshly chargrilled beef patties, avocado, caramelized onions, American cheese, crisp lettuce, '
                      'tomato, pickles and mayo on grilled sourdough. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_six.png',
                  price: 14.19,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: '#7 Impossible Burger Meal',
                  description: 'A seared Impossible patty (a plant-based alternative patty) topped with caramelized onions, crisp lettuce,'
                      ' tomato, pickles, mayo on a toasted bun. Includes fries and a regular drink. Impossible is a trademark of Impossible Foods, Inc. Used under license.',
                  image: 'assets/images/habit/popular_seven.png',
                  price: 13.69,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: '#8 Grilled Chicken Sandwich Meal',
                  description: 'Hand-filleted marinated chicken breast, melted cheese, crisp shredded lettuce, fresh tomatoes,'
                      ' mayo, and your choice of BBQ or teriyaki sauce. Includes fries and a regular drink. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_eight.png',
                  price: 13.69,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: '#9 Chicken Club Sandwich Meal',
                  description: 'Hand-filleted marinated chicken breast, green leaf lettuce, tomatoes, hickory-smoked bacon, fresh avocado, and mayo,'
                      ' served on toasted sourdough. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_nine.png',
                  price: 15.69,
                  extras: [
                  ],
                ),
                FoodItem(
                  name: '#10 Veggie Burger Meal',
                  description: 'Vegan veggie patty on a toasted wheat bun, green leaf lettuce, fresh tomatoes,'
                      ' and cucumbers, with sweet mustard dressing, and onions. (Grilled onions are not vegetarian) Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_ten.png',
                  price: 12.99,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: '#11 Ahi Tuna Filet Sandwich Meal',
                  description: 'Line-caught, sushi-grade tuna steak with a teriyaki glaze,'
                      ' crisp shredded lettuce, fresh tomatoes, and tartar sauce. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_eleven.png',
                  price: 15.69,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
                  ],
                ),
                FoodItem(
                  name: '#12 Spicy Chicken Sandwich Meal',
                  description: 'Crispy Chicken breast with white American cheese, house-made coleslaw, pickles,'
                      ' and spicy red pepper sauce on a toasted flaxseed brioche bun. Includes fries and a regular drink.',
                  image: 'assets/images/habit/popular_twelve.png',
                  price: 15.69,
                  extras: [
                    ExtraOption(name: "Avocado", price: 2.00),
                    ExtraOption(name: "Bacon", price: 1.80),
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
                  name: 'Patty Melt',
                  description: 'Two chargrilled patties served on a toasted corn rye, with one slice of yellow'
                      ' American cheese and one slice of white American cheese, caramelized onions, and Thousand Island spread.',
                  image: 'assets/images/habit/patty_melt.png',
                  price: 8.79,
                  extras: [],
                ),
                FoodItem(
                  name: 'Spicy Crispy Chicken Sandwich',
                  description: 'Crispy Chicken breast with white American cheese,'
                      ' house-made coleslaw, pickles, and spicy red pepper sauce on a toasted flaxseed brioche bun',
                  image: 'assets/images/habit/crispy_chicken.png',
                  price: 9.99,
                  extras: [],
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
                  extras: [
                    ExtraOption(name: "Cheese", price: 1.00, ),
                    ExtraOption(name: "Avocado", price: 2.00,),
                    ExtraOption(name: "Bacon", price: 1.80,),
                  ],
                ),
                FoodItem(
                  name: 'Family Char Meal',
                  description: 'Four Charburgers with cheese, four french fries, and an entrée garden salad.',
                  image: 'assets/images/habit/family_char.png',
                  price: 40.00,
                  extras: [],
                ),
                FoodItem(
                  name: 'Chars & Bites Bundle',
                  description: 'Four Charburgers with cheese, four French fries, and a snack 10 piece Crispy Chicken Bites.',
                  image: 'assets/images/habit/char_bites.png',
                  price: 40.00,
                  extras: [],
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
                        name: "Dressing",
                        options: ["Ranch", "Italian", "Blue Cheese", "No Dressing"],
                      ),
                    ],
                    extras: [
                      ExtraOption(name: "Cheese", price: 1.00, ),
                      ExtraOption(name: "Avocado", price: 2.00,),
                      ExtraOption(name: "Bacon", price: 1.80,),
                    ],
                  ),
                  FoodItem(
                    name: 'BBQ Chicken Salad',
                    description: 'Chargrilled chicken breast atop garden greens, hickory-smoked bacon, diced red onions,'
                        ' diced tomatoes, cilantro, and ranch dressing, topped with tangy BBQ sauce.',
                    image: 'assets/images/habit/barbara_cobb.png',
                    price: 10.29,
                    extras: [
                      ExtraOption(name: "Cheese", price: 1.00, ),
                      ExtraOption(name: "Avocado", price: 2.00,),
                      ExtraOption(name: "Bacon", price: 1.80,),
                    ],
                  ),
                ],
              ),
          ),
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
            'assets/images/the_habit.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.0,
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              'The Habit',
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

class FoodItem {
  final String name;
  final String description;
  final String image;
  final double price;
  final List<Option> extras;
  final List<RequiredOption> requiredOptions;

  FoodItem({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.extras,
    this.requiredOptions = const [],
  });
}

abstract class Option{
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

  RequiredOption({required this.name, required this.options});

  @override
  String toString() {
    return '$name (Options: $options)';
  }


  @override
  double? get price => 0.0;
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
