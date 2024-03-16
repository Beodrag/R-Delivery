import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'cart_page.dart';
import 'food_item_models.dart';
import 'cart_model.dart';

class PandaExpressDetail extends StatefulWidget {
  final Map<String, String> restaurant;

  PandaExpressDetail({required this.restaurant});

  @override
  _PandaExpressDetailState createState() => _PandaExpressDetailState();
}

class _PandaExpressDetailState extends State<PandaExpressDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AutoScrollController _scrollController = AutoScrollController();
  List<GlobalKey> _keys = List.generate(8, (index) => GlobalKey());
  Timer? _debounce;
  bool _tabChangeByScroll = false;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
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


    return WillPopScope(
      onWillPop: () async {
        final result = await _showExitConfirmationDialog(context);
        if (result) {
          Provider.of<CartModel>(context, listen: false).clearCart();
        }
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Panda Express'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: TabBar(
              isScrollable: true,
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: 'Bowl'),
                Tab(text: 'Plate'),
                Tab(text: 'Bigger Plate'),
                Tab(text: 'Family Meal'),
                Tab(text: 'A La Carte'),
                Tab(text: 'Drinks'),
                Tab(text: 'Appetizers and More'),
                Tab(text: 'Catering'),
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
                  Tab(text: 'Bowl'),
                  Tab(text: 'Plate'),
                  Tab(text: 'Bigger Plate'),
                  Tab(text: 'Family Meal'),
                  Tab(text: 'A La Carte'),
                  Tab(text: 'Drinks'),
                  Tab(text: 'Appetizers and More'),
                  Tab(text: 'Catering'),
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
                categoryName: 'Bowl',
                isFirstCategory: true,
                foodList: [
                  FoodItem(
                    name: 'Bowl',
                    description: '1 Side & 1 Entree',
                    image: 'assets/images/panda/bowl.webp',
                    price: 8.40,
                    requiredOptions: [
                      RequiredOption(
                          name: "Side First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                        name: "Entree",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                        "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 1.60,
                          "Black Pepper Angus Steak": 1.60,
                          "Honey Walnut Shrimp": 1.60,
                        },
                      ),
                    ],
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
                categoryName: 'Plate',
                isFirstCategory: false,
                foodList: [
                  FoodItem(
                    name: 'Plate',
                    description: '1 Side & 2 Entrees',
                    image: 'assets/images/panda/plate.webp',
                    price: 9.90,
                    requiredOptions: [
                      RequiredOption(
                          name: "Side First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                        name: "Entree 1",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 1.60,
                          "Black Pepper Angus Steak": 1.60,
                          "Honey Walnut Shrimp": 1.60,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 2",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 1.60,
                          "Black Pepper Angus Steak": 1.60,
                          "Honey Walnut Shrimp": 1.60,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                ],
              ),
            ),
            AutoScrollTag(
              key: _keys[2],
              controller: _scrollController,
              index: 2,
              child: FoodCategory(
                key: _keys[2],
                categoryName: 'Bigger Plate',
                isFirstCategory: false,
                foodList: [
                  FoodItem(
                    name: 'Bigger Plate',
                    description: '1 Side & 3 Entrees',
                    image: 'assets/images/panda/bigger_plate.webp',
                    price: 11.40,
                    requiredOptions: [
                      RequiredOption(
                          name: "Side First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                        name: "Entree 1",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 1.60,
                          "Black Pepper Angus Steak": 1.60,
                          "Honey Walnut Shrimp": 1.60,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 2",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 1.60,
                          "Black Pepper Angus Steak": 1.60,
                          "Honey Walnut Shrimp": 1.60,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 3",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 1.60,
                          "Black Pepper Angus Steak": 1.60,
                          "Honey Walnut Shrimp": 1.60,
                        },
                      ),
                    ],
                    extras: [],
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
                categoryName: 'Family Meal',
                isFirstCategory: false,
                foodList: [
                  FoodItem(
                    name: 'Family Meal',
                    description: '2 Large Sides & 3 Large Entrees',
                    image: 'assets/images/panda/family_meal.webp',
                    price: 43.00,
                    requiredOptions: [
                      RequiredOption(
                          name: "Side 1",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 2",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                        name: "Entree 1",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 3.75,
                          "Black Pepper Angus Steak": 3.75,
                          "Honey Walnut Shrimp": 3.75,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 2",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 3.75,
                          "Black Pepper Angus Steak": 3.75,
                          "Honey Walnut Shrimp": 3.75,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 3",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 3.75,
                          "Black Pepper Angus Steak": 3.75,
                          "Honey Walnut Shrimp": 3.75,
                        },
                      ),
                    ],
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
                categoryName: 'A La Carte',
                isFirstCategory: false,
                foodList: [
                  FoodItem(
                    name: 'Firecracker Shrimp',
                    description: 'A Wok Smart menu item that features large, succulent shrimp, red and yellow bell peppers,'
                        ' onions, string beans, and whole dried chilis, wok-tossed in a savory and spicy black bean sauce.',
                    image: 'assets/images/panda/firecracker_shrimp.webp',
                    price: 6.45,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 4.55,
                          "Large": 8.5,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'The Original Orange Chicken',
                    description: 'Our signature dish. Crispy chicken wok-tossed in a sweet and spicy orange sauce.',
                    image: 'assets/images/panda/orange_chicken.webp',
                    price: 5.20,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 3.3,
                          "Large": 6,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Black Pepper Angus Steak',
                    description: 'Angus steak wok-seared with green beans, onions, red bell peppers and mushrooms in a savory black pepper sauce.',
                    image: 'assets/images/panda/pepper_steak.webp',
                    price: 6.45,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 4.55,
                          "Large": 8.5,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Honey Walnut Shrimp',
                    description: 'Large tempura-battered shrimp, wok-tossed in a honey sauce and topped with glazed walnuts.',
                    image: 'assets/images/panda/honey_shrimp.webp',
                    price: 6.45,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 4.55,
                          "Large": 8.5,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Grilled Teriyaki Chicken',
                    description: 'Grilled chicken hand-sliced to order and served with teriyaki sauce.',
                    image: 'assets/images/panda/teriyaki_chicken.webp',
                    price: 5.20,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 3.3,
                          "Large": 6,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Broccoli Beef',
                    description: 'A classic favorite. Tender beef and fresh broccoli in a ginger soy sauce.',
                    image: 'assets/images/panda/broccoli_beef.webp',
                    price: 5.20,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 3.3,
                          "Large": 6,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Kung Pao Chicken',
                    description: 'A Szechwan-inspired dish with chicken, peanuts and vegetables, finished with chili peppers.',
                    image: 'assets/images/panda/kung_pao_chicken.webp',
                    price: 5.20,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 3.3,
                          "Large": 6,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Honey Sesame Chicken Breast',
                    description: 'Juicy chicken & fresh-cut veggies coated in a sauce made with organic honey.',
                    image: 'assets/images/panda/honey_chicken.webp',
                    price: 5.20,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 3.3,
                          "Large": 6,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Beijing Beef',
                    description: 'Crispy beef, bell peppers and onions in a sweet-tangy sauce.',
                    image: 'assets/images/panda/beijing_beef.webp',
                    price: 5.20,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 3.3,
                          "Large": 6,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Mushroom Chicken',
                    description: 'A delicate combination of chicken, mushrooms and zucchini wok-tossed with a light ginger soy sauce.',
                    image: 'assets/images/panda/mushroom_chicken.webp',
                    price: 5.20,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 3.3,
                          "Large": 6,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'String Bean Chicken Breast',
                    description: 'Chicken breast, string beans and onions wok-tossed in a mild ginger soy sauce.',
                    image: 'assets/images/panda/stringbean_chicken.webp',
                    price: 5.20,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 3.3,
                          "Large": 6,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Eggplant Tofu',
                    description: 'Lightly browned tofu, eggplant and red bell peppers tossed in a sweet and spicy sauce.',
                    image: 'assets/images/panda/eggplant_tofu.webp',
                    price: 5.20,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 3.3,
                          "Large": 6,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Super Greens',
                    description: 'A healthful medley of broccoli, cabbage, and kale.',
                    image: 'assets/images/panda/super_greens.webp',
                    price: 4.40,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Medium", "Large"],
                        optionPrices: {
                          "Large": 1,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Chow Mein',
                    description: 'Stir-fried wheat noodles with onions, celery and cabbage.',
                    image: 'assets/images/panda/chow_mein.webp',
                    price: 4.40,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Medium", "Large"],
                        optionPrices: {
                          "Large": 1,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Fried Rice',
                    description: 'Prepared steamed white rice with soy sauce, eggs, peas, carrots and green onions.',
                    image: 'assets/images/panda/fried_rice.webp',
                    price: 4.40,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Medium", "Large"],
                        optionPrices: {
                          "Large": 1,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'White Steamed Rice',
                    description: '',
                    image: 'assets/images/panda/white_rice.webp',
                    price: 4.40,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Medium", "Large"],
                        optionPrices: {
                          "Large": 1,
                        },
                      ),
                    ],
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
                categoryName: 'Drinks',
                isFirstCategory: false,
                foodList: [
                  FoodItem(
                    name: 'Dr Pepper',
                    description: '',
                    image: 'assets/images/panda/drpepper.webp',
                    price: 2.59,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 0.4,
                          "Large": 0.8,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Pepsi',
                    description: '',
                    image: 'assets/images/panda/pepsi.webp',
                    price: 2.59,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 0.4,
                          "Large": 0.8,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Diet Pepsi',
                    description: '',
                    image: 'assets/images/panda/diet_pepsi.webp',
                    price: 2.59,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 0.4,
                          "Large": 0.8,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Mountain Dew',
                    description: '',
                    image: 'assets/images/panda/mountain_dew.webp',
                    price: 2.59,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 0.4,
                          "Large": 0.8,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Lipton Brisk Raspberry Iced Tea',
                    description: '',
                    image: 'assets/images/panda/brisk.webp',
                    price: 2.59,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 0.4,
                          "Large": 0.8,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Sierra Mist',
                    description: '',
                    image: 'assets/images/panda/sierra_mist.webp',
                    price: 2.59,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 0.4,
                          "Large": 0.8,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Sobe Yumberry Pomegranate',
                    description: '',
                    image: 'assets/images/panda/sobe.webp',
                    price: 2.59,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 0.4,
                          "Large": 0.8,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Tropicana Lemonade',
                    description: '',
                    image: 'assets/images/panda/tropicana.webp',
                    price: 2.59,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 0.4,
                          "Large": 0.8,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Tropicana Pink Lemonade',
                    description: '',
                    image: 'assets/images/panda/tropicana_pink.webp',
                    price: 2.59,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Medium", "Large"],
                        optionPrices: {
                          "Medium": 0.4,
                          "Large": 0.8,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Aquafina',
                    description: '20oz Bottle',
                    image: 'assets/images/panda/aquafina.webp',
                    price: 2.40,
                    extras: [],
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
                categoryName: 'Appetizers and More',
                isFirstCategory: false,
                foodList: [
                  FoodItem(
                    name: 'Chicken Egg Roll',
                    description: 'Cabbage, carrots, green onions and chicken in a crispy wonton wrapper.',
                    image: 'assets/images/panda/chicken_eggroll.webp',
                    price: 2.00,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small", "Large (6pcs)"],
                        optionPrices: {
                          "Large (6pcs)": 9.2,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Veggie Spring Roll',
                    description: 'Cabbage, carrots, green onions and chicken in a crispy wonton wrapper.',
                    image: 'assets/images/panda/springroll.webp',
                    price: 2.00,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small (2pcs)", "Large (12pcs)"],
                        optionPrices: {
                          "Large (12pcs)": 9.2,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Cream Cheese Rangoon',
                    description: 'Wonton wrappers filled with cream cheese and served with sweet and sour sauce.',
                    image: 'assets/images/panda/rangoon.webp',
                    price: 2.00,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Small (3pcs)", "Large (12pcs)"],
                        optionPrices: {
                          "Large (12pcs)": 6.4,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Hot & Sour Soup',
                    description: '',
                    image: 'assets/images/panda/soup.webp',
                    price: 1.50,
                    requiredOptions: [
                      RequiredOption(
                        name: "Size",
                        options: ["Cup (12oz)", "Bowl (17oz)"],
                        optionPrices: {
                          "Bowl (17oz)": 1.5,
                        },
                      ),
                    ],
                    extras: [],
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
                categoryName: 'Catering',
                isFirstCategory: false,
                foodList: [
                  FoodItem(
                    name: 'Party Size Side',
                    description: '10-12 Servings Per Party Tray',
                    image: 'assets/images/panda/party_side.webp',
                    price: 16.00,
                    requiredOptions: [
                      RequiredOption(
                          name: "Side First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Party Size Entree',
                    description: '12-14 Servings Per Party Tray',
                    image: 'assets/images/panda/party_entree.webp',
                    price: 41.00,
                    requiredOptions: [
                      RequiredOption(
                        name: "Entree",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu"],
                        optionPrices: {
                          "Firecracker Shrimp": 15.00,
                          "Black Pepper Angus Steak": 15.00,
                          "Honey Walnut Shrimp": 15.00,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: 'Party Size Appetizer',
                    description: '12-14 Servings Per Party Tray',
                    image: 'assets/images/panda/party_appetizer.webp',
                    price: 34.00,
                    requiredOptions: [
                      RequiredOption(
                        name: "Appetizer",
                        options: ["Cream Cheese Rangoon", "Veggie Spring Roll", "Chicken Egg Roll"],
                        optionPrices: {
                          "Veggie Spring Roll": 7.00,
                          "Chicken Egg Roll": 7.00,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: '12-16 Person Party Bundle',
                    description: '2 Party Tray Entrees, 2 Party Tray Sides, Fortune Cookies',
                    image: 'assets/images/panda/party_bundle.webp',
                    price: 108.00,
                    requiredOptions: [
                      RequiredOption(
                          name: "Side 1 First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 1 Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 2 First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 2 Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                        name: "Entree 1",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 15.00,
                          "Black Pepper Angus Steak": 15.00,
                          "Honey Walnut Shrimp": 15.00,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 2",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 15.00,
                          "Black Pepper Angus Steak": 15.00,
                          "Honey Walnut Shrimp": 15.00,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: '18-22 Person Party Bundle',
                    description: '3 Party Tray Entrees, 3 Party Tray Sides, Fortune Cookies',
                    image: 'assets/images/panda/party_bundle.webp',
                    price: 154.00,
                    requiredOptions: [
                      RequiredOption(
                          name: "Side 1 First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 1 Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 2 First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 2 Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 3 First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 3 Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                        name: "Entree 1",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 15.00,
                          "Black Pepper Angus Steak": 15.00,
                          "Honey Walnut Shrimp": 15.00,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 2",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 15.00,
                          "Black Pepper Angus Steak": 15.00,
                          "Honey Walnut Shrimp": 15.00,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 3",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 15.00,
                          "Black Pepper Angus Steak": 15.00,
                          "Honey Walnut Shrimp": 15.00,
                        },
                      ),
                    ],
                    extras: [],
                  ),
                  FoodItem(
                    name: '26-30 Person Party Bundle',
                    description: '4 Party Tray Entrees, 4 Party Tray Sides, Fortune Cookies',
                    image: 'assets/images/panda/party_bundle.webp',
                    price: 194.00,
                    requiredOptions: [
                      RequiredOption(
                          name: "Side 1 First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 1 Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 2 First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 2 Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 3 First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 3 Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 4 First Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                          name: "Side 4 Second Half",
                          options: ["Chow Mein", "Fried Rice", "White Steamed Rice", "Super Greens"]
                      ),
                      RequiredOption(
                        name: "Entree 1",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 15.00,
                          "Black Pepper Angus Steak": 15.00,
                          "Honey Walnut Shrimp": 15.00,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 2",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 15.00,
                          "Black Pepper Angus Steak": 15.00,
                          "Honey Walnut Shrimp": 15.00,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 3",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 15.00,
                          "Black Pepper Angus Steak": 15.00,
                          "Honey Walnut Shrimp": 15.00,
                        },
                      ),
                      RequiredOption(
                        name: "Entree 4",
                        options: ["Firecracker Shrimp", "The Original Orange Chicken", "Black Pepper Angus Steak",
                          "Honey Walnut Shrimp", "Grilled Teriyaki Chicken", "Kung Pao Chicken",
                          "Honey Sesame Chicken Breast", "Beijing Beef", "Mushroom Chicken", "String Bean Chicken Breast",
                          "Broccoli Beef", "Eggplant Tofu", "Super Greens"],
                        optionPrices: {
                          "Firecracker Shrimp": 15.00,
                          "Black Pepper Angus Steak": 15.00,
                          "Honey Walnut Shrimp": 15.00,
                        },
                      ),
                    ],
                    extras: [],
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(key: UniqueKey())));
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
      )
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Do you want to go back to the restaurant list?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
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
            'assets/images/panda_express.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.0,
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              'Panda Express',
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