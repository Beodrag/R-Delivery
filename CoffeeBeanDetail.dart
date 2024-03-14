import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'cart_page.dart';
import 'food_item_models.dart';
import 'cart_model.dart';

class CoffeeBeanDetail extends StatefulWidget {
  final Map<String, String> restaurant;

  CoffeeBeanDetail({required this.restaurant});

  @override
  _CoffeeBeanDetailState createState() => _CoffeeBeanDetailState();
}

class _CoffeeBeanDetailState extends State<CoffeeBeanDetail> with SingleTickerProviderStateMixin {
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
        title: Text('Coffee Bean'),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: 'Breakfast Bundle'),
              Tab(text: 'Food|Baked Goods'),
              Tab(text: 'Food|Breakfast'),
              Tab(text: 'Food|Lunch'),
              Tab(text: 'Coffee|Brewed Coffee'),
              Tab(text: 'Coffee|Iced Coffee'),
              Tab(text: 'Coffee|Iced Espresso'),

            ],
          ).preferredSize,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: 'Breakfast Bundle'),
                Tab(text: 'Food|Baked Goods'),
                Tab(text: 'Food|Breakfast'),
                Tab(text: 'Food|Lunch'),
                Tab(text: 'Coffee|Brewed Coffee'),
                Tab(text: 'Coffee|Iced Coffee'),
                Tab(text: 'Coffee|Iced Espresso'),

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
              categoryName: 'Breakfast Bundle',
              isFirstCategory: true,
              foodList: [
                // Example FoodItem, repeat structure for other menu items
                FoodItem(
                  name: 'Breakfast Bundle',
                  description: 'Small Brewed Coffee and a Plain Bagel with Cream Cheese for 5 dollars',
                  image: 'assets/images/coffeeBean/BagelBundle.jpg',
                  price: 5.00,
                  extras: [
                    ExtraOption(name: "Espresso Shot", price: 1.00),
                  ],
                ),
              ],
            ),
          ),
          // Add more AutoScrollTags for other categories
          AutoScrollTag(
            key: _keys[0],
            controller: _scrollController,
            index: 0,
            child: FoodCategory(
              key: _keys[0],
              categoryName: 'Food|Baked Goods',
              isFirstCategory: true,
              foodList: [
                // Example FoodItem, repeat structure for other menu items
                FoodItem(
                  name: 'Bagels & Spreads|Cheese Jalapeno Bagel',
                  description: 'A classic New York-style bagel with a delicious combination of cheese and jalapeño. Ask for it toasted and/or with cream cheese. This has not been Kosher certified. 290 Calories',
                  image: 'assets/images/coffeeBean/BagelCheJalapeno.jpg',
                  price: 2.75,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Cream Cheese", price: 1.00)
                  ],
                ),
            FoodItem(
              name: 'Bagels & Spreads|Everything Bagel',
              description: 'A classic New York-style bagel with a delicious combination of cheese and jalapeño. Ask for it toasted and/or with cream cheese. This has not been Kosher certified. 290 Calories',
              image: 'assets/images/coffeeBean/everythingbagel.jpg',
              price: 2.45,
              requiredOptions: [
                RequiredOption(
                    name: "Would you like this item Oven Toasted?",
                    options: ["Oven Toasted", "Not Warmed"]
                ),
              ],
              extras: [
                ExtraOption(name: "Cream Cheese", price: 1.00)
              ],
            ),
                FoodItem(
                  name: 'Bagels & Spreads|Plain Bagel',
                  description: 'A classic New York-style bagel with a delicious combination of cheese and jalapeño. Ask for it toasted and/or with cream cheese. This has not been Kosher certified. 290 Calories',
                  image: 'assets/images/coffeeBean/plainbagel.jpg',
                  price: 2.45,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Cream Cheese", price: 1.00)
                  ],
                ),

              ],
            ),
          ),
         AutoScrollTag(
            key: _keys[0],
            controller: _scrollController,
            index: 0,
            child: FoodCategory(
              key: _keys[0],
              categoryName: 'Food|Baked Goods',
              isFirstCategory: true,
              foodList: [
                // Example FoodItem, repeat structure for other menu items
                FoodItem(
                  name: 'Cakes & Cake Pops|Strawberry Cake Pop',
                  description: 'A delicious strawberry flavored cake pop dipped in pink chocolate coating and rainbow sprinkles. 150 Calories',
                  image: 'assets/images/coffeeBean/StrawberryCakePop.jpg',
                  price: 2.95,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like Utensils?",
                        options: ["Yes", "No"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Cream Cheese", price: 1.00)
                  ],
                ),
                FoodItem(
                  name: 'Cakes & Cake Pops|Chocolate Cake Pop',
                  description: 'A delicious chocolate flavored cake pop dipped in dark chocolate coating and rainbow sprinkles. 150 Calories',
                  image: 'assets/images/coffeeBean/ChocoCakePop.jpg',
                  price: 2.95,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like Utensils?",
                        options: ["Yes", "No"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Cream Cheese", price: 1.00)
                  ],
                ),
                FoodItem(
                  name: 'Cakes & Cake Pops|Coffee Crumble Cake',
                  description: 'A classic coffee cake with swirled cinnamon sugar and topped with a crunchy streusel topping. This has not been Kosher certified. 350 Calories',
                  image: 'assets/images/coffeeBean/CoffeeCrumble.jpg',
                  price: 3.25,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Utensils", price: 0.00)
                  ],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[0],
            controller: _scrollController,
            index: 0,
            child: FoodCategory(
              key: _keys[0],
              categoryName: 'Food|Breakfast',
              isFirstCategory: true,
              foodList: [
                // Example FoodItem, repeat structure for other menu items
                FoodItem(
                  name: 'Breakfast|Bacon Egg Bites',
                  description: 'Scrambled eggs with Jack Cheese, Swiss Cheese, Potato, & Bacon. 220 Calories',
                  image: 'assets/images/coffeeBean/BaconEggBites.jpg',
                  price: 4.95,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Hot sauce?", price: 0.00)
                  ],
                ),
                FoodItem(
                  name: 'Breakfast|Beyond Breakfast Sausage Sandwich',
                  description: 'Cage-free egg, melted provolone cheese & plant-based Beyond Breakfast Sausage® on a toasted English muffin. 400 Calories',
                  image: 'assets/images/coffeeBean/BaconEggCheese.jpg',
                  price: 5.95,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Hot sauce?", price: 0.00)
                  ],
                ),
                FoodItem(
                  name: 'Breakfast|Egg White & Veggie Bites',
                  description: 'Egg whites scrambled with marinated Red Bell Peppers, Mushrooms & Spinach, Jack, Swiss & Gruyere cheeses. 110 Calories',
                  image: 'assets/images/coffeeBean/EggWhiteVeggie.jpg',
                  price: 4.95,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Hot sauce?", price: 0.00)
                  ],
                ),
                FoodItem(
                  name: 'Breakfast|Bacon Egg Cheese English Muffin',
                  description: 'Crispy bacon and fried egg topped with melted cheddar cheese on a toasted English Muffin. 400 Calories',
                  image: 'assets/images/coffeeBean/BaconEggCheese.jpg',
                  price: 5.50,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Hot sauce?", price: 0.00)
                  ],
                ),
                FoodItem(
                  name: 'Breakfast|Ham Egg and Cheese Brioche ',
                  description: 'A buttery brioche bun filled with fluffy eggs, black forest ham and cheddar cheese. 400 Calories',
                  image: 'assets/images/coffeeBean/HamEggCheese.jpg',
                  price: 5.95,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Hot sauce?", price: 0.00)
                  ],
                ),
              ],
            ),
          ),
         AutoScrollTag(
            key: _keys[0],
            controller: _scrollController,
            index: 0,
            child: FoodCategory(
              key: _keys[0],
              categoryName: 'Food|Lunch',
              isFirstCategory: true,
              foodList: [
                // Example FoodItem, repeat structure for other menu items
                FoodItem(
                  name: 'Sandwiches & Wraps|Caprese Sandwich ',
                  description: 'Sun blushed tomatoes, mozzarella, spinach and pesto dressing on an artisan roll. This has not been Kosher certified. 620 Calories',
                  image: 'assets/images/coffeeBean/Caprese Sandwich.jpg',
                  price: 6.75,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Hot sauce?", price: 0.00)
                  ],
                ),
                FoodItem(
                  name: 'Sandwiches & Wraps|Homestyle Grilled Cheese Sandwich ',
                  description: 'A classic grilled cheese made with mild cheddar and Monterey Jack cheese. Oven toasted to perfection.',
                  image: 'assets/images/coffeeBean/Grilled-Cheese.jpg',
                  price: 3.95,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Hot sauce?", price: 0.00)
                  ],
                ),
                FoodItem(
                  name: 'Sandwiches & Wraps|Turkey Pesto Sandwich',
                  description: 'Turkey Pesto with provolone cheese, tomato and spinach on a ciabatta bun. Great cold or warmed up! 620 Calories',
                  image: 'assets/images/coffeeBean/TurkeyPesto.jpg',
                  price: 6.95,
                  requiredOptions: [
                    RequiredOption(
                        name: "Would you like this item Oven Toasted?",
                        options: ["Oven Toasted", "Not Warmed"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Hot sauce?", price: 0.00)
                  ],
                ),
              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[0],
            controller: _scrollController,
            index: 0,
            child: FoodCategory(
              key: _keys[0],
              categoryName: 'Coffee|Brewed Coffee',
              isFirstCategory: true,
              foodList: [
                // Example FoodItem, repeat structure for other menu items
                FoodItem(
                  name: 'Brewed Coffee',
                  description: 'One of our light, medium, dark, or decaffeinated brews of the day, brewed from only the top 1% of Arabica beans in the world.',
                  image: 'assets/images/coffeeBean/BrewedCoffee.jpg',
                  price: 6.75,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Choose Roast",
                        options: ["Light/Medium Roast", "Dark/Distinctive Roast"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80)
                  ],
                ),
                FoodItem(
                  name: 'Cafe Au lait',
                  description: 'Our light roast coffee with steamed whole milk and topped with thick velvety foam.',
                  image: 'assets/images/coffeeBean/CafeAuLait.jpg',
                  price: 3.58,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Choose Roast",
                        options: ["Light/Medium Roast", "Dark/Distinctive Roast"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80)
                  ],
                ),
                FoodItem(
                  name: 'Cafe Caramel',
                  description: 'Our light roast coffee with steamed whole milk and topped with thick velvety foam.',
                  image: 'assets/images/coffeeBean/CafeCaramel.jpg',
                  price: 4.38,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Choose Roast",
                        options: ["Light/Medium Roast", "Dark/Distinctive Roast"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80)
                  ],
                ),
                FoodItem(
                  name: 'Cafe Cookie Butter',
                  description: 'Our light roast coffee with our sweet and spicy cookie butter powder, steamed non-fat milk and topped with thick foam.',
                  image: 'assets/images/coffeeBean/CafeCookieButter.jpg',
                  price: 4.58,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Choose Roast",
                        options: ["Light/Medium Roast", "Dark/Distinctive Roast"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80)
                  ],
                ),
                FoodItem(
                  name: 'Cafe Dark Chocolate ',
                  description: 'Our light roast coffee with our dark chocolate powder, steamed non-fat milk and topped with thick foam.',
                  image: 'assets/images/coffeeBean/CafeDarkChocolate.jpg',
                  price: 4.38,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Choose Roast",
                        options: ["Light/Medium Roast", "Dark/Distinctive Roast"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80)
                  ],
                ),

              ],
            ),
          ),
          AutoScrollTag(
            key: _keys[0],
            controller: _scrollController,
            index: 0,
            child: FoodCategory(
              key: _keys[0],
              categoryName: 'Coffee|Iced Coffee',
              isFirstCategory: true,
              foodList: [
                // Example FoodItem, repeat structure for other menu items
                FoodItem(
                  name: 'Iced Coffee',
                  description: 'Our specially brewed coffee served over ice for a refreshing and bold coffee taste.',
                  image: 'assets/images/coffeeBean/Iced-Coffee.jpg',
                  price: 3.88,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80),
                    ExtraOption(name: "Add Cream Cap", price: 0.95)
                  ],
                ),
                FoodItem(
                  name: 'Iced Coffees|Caramel Iced Coffee',
                  description: 'Our premium espresso shots blended with caramel sauce, French Deluxe™ vanilla powder, and served over ice for a refreshing and delicious caramel coffee drink.',
                  image: 'assets/images/coffeeBean/CaramelIcedCoffee.jpg',
                  price: 4.68,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),

                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80),
                    ExtraOption(name: "Add Cream Cap?", price: 0.95)
                  ],
                ),
                FoodItem(
                  name: 'Iced Coffees|Cookie Butter Iced Coffee',
                  description: 'Our premium espresso shots blended with our sweet and spicy cookie butter powder and served over ice for a refreshing and delicious cookie butter coffee drink.',
                  image: 'assets/images/coffeeBean/CookieButterIcedCoffee.jpg',
                  price: 4.88,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),

                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80),
                    ExtraOption(name: "Add Cream Cap?", price: 0.95)
                  ],
                ),
                FoodItem(
                  name: 'Iced Coffees|Dark Chocolate Iced Coffee',
                  description: 'Our premium espresso shots blended with our dark chocolate powder and served over ice for a refreshing and delicious chocolate and coffee drink.',
                  image: 'assets/images/coffeeBean/DarkChocoIcedCoffee.jpg',
                  price: 4.68,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),

                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80),
                    ExtraOption(name: "Add Cream Cap?", price: 0.95)
                  ],
                ),
                FoodItem(
                  name: 'Iced Coffees|Hazelnut Iced Coffee',
                  description: 'Our premium espresso shots blended with our specially developed hazelnut powder and served over ice for a refreshing and delicious hazelnut coffee drink.',
                  image: 'assets/images/coffeeBean/hazlenutIcedCoffee.jpg',
                  price: 4.68,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),

                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80),
                    ExtraOption(name: "Add Cream Cap?", price: 0.95)
                  ],
                ),
              ],
            ),
          ),

          AutoScrollTag(
            key: _keys[0],
            controller: _scrollController,
            index: 0,
            child: FoodCategory(
              key: _keys[0],
              categoryName: 'Coffee|Iced Espresso',
              isFirstCategory: true,
              foodList: [
                // Example FoodItem, repeat structure for other menu items
                FoodItem(
                  name: 'Iced Lattes|Iced Salted Caramel Mocha Latte',
                  description: 'Our signature espresso highlighted by a rich, buttery caramel flavor and Special Dutch chocolate powder and served over ice to create a delicious beverage that is good any time of day.',
                  image: 'assets/images/coffeeBean/IcedSaltedCaramel.jpg',
                  price: 5.38,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80),
                    ExtraOption(name: "Add Cream Cap", price: 0.95),
                    ExtraOption(name: "Lighten Your Drink?", price: 0.00)
                  ],
                ),
                FoodItem(
                  name: 'Iced Lattes|Iced Latte',
                  description: 'Freshly pulled shots of espresso and whole milk served over ice.',
                  image: 'assets/images/coffeeBean/IcedLatte.jpg',
                  price: 4.48,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80),
                    ExtraOption(name: "Add Cream Cap", price: 0.95),
                    ExtraOption(name: "Lighten Your Drink?", price: 0.00)
                  ],
                ),
                FoodItem(
                  name: 'Iced Lattes|Vanilla Iced Latte',
                  description: 'Freshly pulled shots of espresso with our French Deluxe™ vanilla powder and non-fat milk over ice.',
                  image: 'assets/images/coffeeBean/VanillaIcedLatte.jpg',
                  price: 5.18,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80),
                    ExtraOption(name: "Add Cream Cap", price: 0.95),
                    ExtraOption(name: "Lighten Your Drink?", price: 0.00)
                  ],
                ),
                FoodItem(
                  name: 'Iced Lattes|Mocha Iced Latte',
                  description: 'Freshly pulled shots of espresso with Special Dutch™ chocolate powder and non-fat milk over ice.',
                  image: 'assets/images/coffeeBean/MochaIcedlatte.jpg',
                  price: 5.18,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80),
                    ExtraOption(name: "Add Cream Cap", price: 0.95),
                    ExtraOption(name: "Lighten Your Drink?", price: 0.00)
                  ],
                ),
                FoodItem(
                  name: 'Iced Lattes|White Chocolate Iced Latte',
                  description: 'Freshly pulled shots of espresso with our White Chocolate powder and non-fat milk over ice.',
                  image: 'assets/images/coffeeBean/WhiteChocolateIcedLatte.jpg',
                  price: 5.18,
                  requiredOptions: [
                    RequiredOption(
                        name: "Choose size",
                        options: ["Small", "Regular", "Large"]
                    ),
                    RequiredOption(
                        name: "Creamer",
                        options: ["Whole Milk", "Non-Fat Milk", "Half & Half", "Almond Milk", "Oat Milk", "Heavy Creamer", "None"]
                    ),
                    RequiredOption(
                        name: "Sweetener",
                        options: ["Add White Sugar", "Add Raw Sugar", "Add Sucralose Sweetener", "Add Stevia", "Side of Honey Sticks", "None"]
                    ),
                    RequiredOption(
                        name: "Whipped Cream",
                        options: ["With Whipped Cream", "Easy Whipped Cream", "Add Mint Whipped Cream"]
                    ),
                  ],
                  extras: [
                    ExtraOption(name: "Add Shot?", price: 0.80),
                    ExtraOption(name: "Add Cream Cap", price: 0.95),
                    ExtraOption(name: "Lighten Your Drink?", price: 0.00)
                  ],
                ),
              ],
            ),
          ),
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
        // If this is the first category, display the image and restaurant name
        if (isFirstCategory) ...[
          Image.asset(
            'assets/images/coffee_bean.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.0,
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              'Coffee Bean',
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
  final Function(FoodItem, Map<String, String?>, Map<String, bool>) onAddToCart;

  DialogWithExtras({Key? key, required this.foodItem, required this.onAddToCart}) : super(key: key);

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
    initializeSelections();
  }

  void initializeSelections() {
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
              // Update the item with the selected options and extras
              widget.foodItem.selectedRequiredOptions = selectedRequiredOptions;
              widget.foodItem.selectedExtras = extrasSelected;
              Provider.of<CartModel>(context, listen: false).addItem(widget.foodItem.clone());
              Navigator.of(context).pop(); // Close the dialog
            } else {
              // Handle the case where not all required options are selected
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
