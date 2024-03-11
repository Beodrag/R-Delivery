// restaurant_detail.dart

import 'package:flutter/material.dart';

class CoffeeBeanDetail extends StatelessWidget {
  final Map<String, String> restaurant;

  CoffeeBeanDetail({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant['Coffee Bean & Tea Leaf'] ?? 'Restaurant Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the restaurant image at the top
            Image.asset(
              restaurant['image'] ?? 'assets/images/coffee_bean.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200.0, // You can adjust the height as needed
            ),
            SizedBox(height: 16.0),

            // Display the restaurant name centered under the image
            Text(
              restaurant['The Coffee Bean & Tea Leaf'] ?? 'The Coffee Bean & Tea Leaf',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),

            // Add a vertical list of food options with categories
            Expanded(
              child: ListView(
                children: [
                  FoodCategory(
                    categoryName: 'Featured',
                    foodList: [
                      FoodItem(
                        name: 'Vanilla Spiced Oat Latte',
                        description: 'A delicious blend of vanilla and spice. '
                            'We are adding a hint of spice and our Oatly Oatmilk '
                            'for the perfect Winter beverage. Plant-Based. Vegan.',
                        image: 'assets/images/Vanilla_Spiced_Oat_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Iced Vanilla Spiced Oat Latte',
                        description: 'A delicious blend of vanilla and spice. '
                            'We are adding a hint of spice and our Oatly Oatmilk '
                            'for the perfect Winter beverage. All served over ice '
                            'for a refreshing treat. Plant-Based. Vegan.',
                        image: 'assets/images/Iced_Vanilla_Spiced_Oat_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Vanilla Spiced Chai Latte',
                        description: 'A twist on our already amazing chai latte'
                            'with an additional boost of spice.',
                        image: 'assets/images/Vanilla_Spiced_Chai_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Vanilla Spiced Chai Cream Latte',
                        description: 'A fun twist on our already amazing chai latte'
                            'with an additional boost of spice and topped with our '
                            'delicious cream cap.',
                        image: 'assets/images/Vanilla_Spiced_Chai_Cream_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Iced Vanilla Spiced Chai Cream Latte',
                        description: 'A twist on our already amazing chai latte'
                            'with an additional boost of spice. All served over ice '
                            'for a refreshing treat.',
                        image: 'assets/images/Iced_Vanilla_Spiced_Chai_Cream_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Vanilla Spiced Oat Cold Brew',
                        description: 'A delicious blend of vanilla and spice. '
                            'We are adding a hint of spice and our Oatly Oatmilk '
                            'for the perfect Winter beverage. All served over ice '
                            'for a refreshing treat. Plant-Based. Vegan.',
                        image: 'assets/images/Vanilla_Spiced_Oat_Cold_Brew.jpg',
                      ),
                      FoodItem(
                        name: 'Dark Chocolate Latte',
                        description: 'Fresh pulled shots of espresso with our rich '
                            'dark chocolate powder, steamed non-fat milk and topped '
                            'with thick foam.',
                        image: 'assets/images/Dark_Chocolate_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'White Chocolate Latte',
                        description: 'Fresh pulled shots of espresso with our white '
                            'chocolate powder, steamed non-fat milk and topped with '
                            'thick foam.',
                        image: 'assets/images/White_Chocolate_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Strawberry Cake Pop',
                        description: 'A delicious strawberry flavored cake pop dipped '
                            'in pink chocolate coating and rainbow sprinkles. 150 calories.',
                        image: 'assets/images/Strawberry_Cake_Pop.jpg',
                      ),
                      FoodItem(
                        name: 'Chocolate Cake Pop',
                        description: 'A delicious chocolate cake pop dipped '
                            'in milk chocolate coating with rainbow sprinkles. 150 calories.',
                        image: 'assets/images/Chocolate_Cake_Pop.jpg',
                      ),
                    ],
                  ),
                  FoodCategory(
                    categoryName: 'Boba & Brew',
                    foodList: [
                      FoodItem(
                        name: 'Chai with Salted Caramel Cream Cap',
                        description: 'Savor comfort in a cup: our Chai Latte, a blend of bold '
                            'black tea and warm spices, meets the silky Salted Caramel Cream '
                            'Cap and Brown Sugar for a rich, delicious treat.',
                        image: 'assets/images/Chai_with_Salted_Caramel_Cream_Cap.jpg',
                      ),
                      FoodItem(
                        name: 'Oolong Tea with Strawberry & Cream Cap',
                        description: 'Discover the delicate depth of our Oolong tea, paired'
                            'with summer berries and crowned with a luscious cream cap.',
                        image: 'assets/images/Oolong_Tea_with_Strawberry_&_Cream_Cap.jpg',
                      ),
                      FoodItem(
                        name: 'Matcha Cream Strawberry Latte',
                        description: 'If you are a Matcha fan, you will adore this harmonious'
                            'blend of strawberries, fresh milk, and creamy Japanese matcha foam.',
                        image: 'assets/images/Matcha_Cream_Strawberry_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Ceylon Milk Tea with Brown Sugar Boba',
                        description: 'Experience a fusion of rich flavors and textures: Ceylon '
                            'black tea infused with caramelized brown sugar and paired with chewy '
                            'brown sugar pearls.',
                        image: 'assets/images/Ceylon_Milk_Tea_with_Brown_Sugar_Boba.jpg',
                      ),
                      //(tea latte)
                      FoodItem(
                        name: 'Chai Iced Tea Latte',
                        description: 'A delicious blend of Chai tea combined with our French Deluxe '
                            'vanilla powder over ice. With bold tea flavor and a sweet vanilla finish, '
                            'this refreshing beverage is the perfect way to keep your day cool.',
                        image: 'assets/images/Chai_Iced_Tea_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Matcha Iced Tea Latte',
                        description: 'Our new and improved Matcha Tea Latte beverage are a creamy, lightly '
                            'sweetened blend of matcha with our classic vanilla powder and milk. With enhanced, '
                            'brighter matcha flavor than ever before, it is a great way to kick off your day or '
                            'enjoy as a refreshing afternoon pick-me-up.',
                        image: 'assets/images/Matcha_Iced_Tea_Latte.jpg',
                      ),
                      //(latte)
                      FoodItem(
                        name: 'Iced Latte',
                        description: 'Freshly pulled shots of espresso and whole milk served over ice.',
                        image: 'assets/images/Iced_Latte.jpg',
                      ),
                    ],
                  ),
                  FoodCategory(
                    categoryName: 'Seasonal Favorites',
                    foodList: [
                      FoodItem(
                        name: 'Cardamom Cold Brew',
                        description: 'Our signature Cold Brew Coffee is perfectly balanced with our new cardamom'
                            'syrup for a delicious beverage that is good any time of day.',
                        image: 'assets/images/Cardamom_Cold_Brew.jpg',
                      ),
                      FoodItem(
                        name: 'Cardamom Cold Brew with Cream Cap',
                        description: 'Our signature Cold Brew Coffee is greatly enhanced by our new cardamom syrup'
                            ' and a frosty cream cap. The cream cap tops the drink, infusing flavor and body to '
                            'the drink!',
                        image: 'assets/images/Cardamom_Cream_Cap.jpg',
                      ),
                      // Add more signature sandwiches
                    ],
                  ),
                  FoodCategory(
                    categoryName: 'Food',
                    foodList: [
                      //$5 breakfast bundle
                      FoodItem(
                        name: '\$5 Breakfast Bundle',
                        description: 'Small Brewed Coffee and a Plain Bagel with Cream Cheese for \$5',
                        image: 'assets/images/Breakfast_Bundle.jpg',
                      ),
                      //baked goods
                      //bagels & spreads
                      FoodItem(
                        name: 'Cheese Jalapeno Bagel',
                        description: 'A classic New York-style bagel with a delicious combination of cheese and '
                            'jalapeno. Ask for it toasted and/or with cream cheese. This has not been Kosher '
                            'certified. 290 calories.',
                        image: 'assets/images/Jalapeno_Bagel.jpg',
                      ),
                      FoodItem(
                        name: 'Everything Bagel',
                        description: 'A classic New York-style everything bagel that can be enjoyed as you like '
                            'it. Ask for it toasted and/or with cream cheese. 240 calories',
                        image: 'assets/images/Everything_Bagel.jpg',
                      ),
                      FoodItem(
                        name: 'Plain Bagel',
                        description: 'A classic New York-style bagel that can be enjoyed as you like '
                            'it. Ask for it toasted and/or with cream cheese. 200 calories',
                        image: 'assets/images/Plain_Bagel.jpg',
                      ),
                      //cakes & cake pops
                      FoodItem(
                        name: 'Strawberry Cake Pop',
                        description: 'A delicious strawberry flavored cake pop dipped '
                            'in pink chocolate coating and rainbow sprinkles. 150 calories.',
                        image: 'assets/images/Strawberry_Cake_Pop.jpg',
                      ),
                      FoodItem(
                        name: 'Chocolate Cake Pop',
                        description: 'A delicious chocolate cake pop dipped '
                            'in milk chocolate coating with rainbow sprinkles. 150 calories.',
                        image: 'assets/images/Chocolate_Cake_Pop.jpg',
                      ),
                      //coffee cakes & loaves
                      FoodItem(
                        name: 'Coffee Crumble Cake',
                        description: 'A classic coffee cake with swirled cinnamon sugar and '
                            'topped with a crunchy streusel topping. This has not been Kosher '
                            'certified. 350 calories.',
                        image: 'assets/images/Crumble_Cake.jpg',
                      ),
                      FoodItem(
                        name: 'Lemon Loaf',
                        description: 'A citrusy, lemon pound cake, topped in lemon icing for '
                            'a refreshing treat.',
                        image: 'assets/images/Lemon_Loaf.jpg',
                      ),
                      FoodItem(
                        name: 'Vegan Banana Walnut Loaf',
                        description: 'A delicious vegan banana bread that is made with real '
                            'banana puree and full of chopped walnut pieces. 290 calories.',
                        image: 'assets/images/Walnut_Loaf.jpg',
                      ),
                      //croissants
                      FoodItem(
                        name: 'Almond Croissant',
                        description: 'A sweet butter croissant filled with a moist filling '
                            'and topped with sliced almonds. This has not been Kosher '
                            'certified. 430 calories.',
                        image: 'assets/images/Almond_Croissant.jpg',
                      ),
                      FoodItem(
                        name: 'Butter Croissant',
                        description: 'A classic butter croissant with the perfect flaky top '
                            'and soft, moist layers inside. This has not been Kosher '
                            'certified. 290 calories.',
                        image: 'assets/images/Butter_Croissant.jpg',
                      ),
                      FoodItem(
                        name: 'Chocolate Croissant',
                        description: 'Layers of flaky, butter croissant dough filled with rich '
                            'chocolate. This has not been Kosher certified. 350 calories.',
                        image: 'assets/images/Chocolate_Croissant.jpg',
                      ),
                      FoodItem(
                        name: 'Jalapeno Cheddar Croissant',
                        description: 'A savory treat, this buttery, flaky croissant has just the '
                            'right balance of cheddar cheese and jalapenos. This has not been Kosher '
                            'certified. 220 calories.',
                        image: 'assets/images/Jalapeno_Cheddar_Croissant.jpg',
                      ),
                      //muffins & scones
                      FoodItem(
                        name: 'Blueberry Muffin',
                        description: 'A flavorful muffin that is moist and full of delicious blueberries, '
                            'topped with a crunchy streusel. This has not been Kosher certified. 360 calories.',
                        image: 'assets/images/Blueberry_Muffin.jpg',
                      ),
                      FoodItem(
                        name: 'Double Chocolate Muffin',
                        description: 'A rich, chocolately muffin with chocolate chips. This has not been Kosher '
                            'certified. 440 calories.',
                        image: 'assets/images/Double_Chocolate_Muffin.jpg',
                      ),
                      //Pastries
                      FoodItem(
                        name: 'Cinnamon Roll',
                        description: 'A buttery croissant roll filled with cinnamon and sugar. This has not been '
                            'Kosher certified. 420 calories.',
                        image: 'assets/images/Cinnamon_Roll.jpg',
                      ),
                      FoodItem(
                        name: 'Cheese Danish',
                        description: 'A buttery croissant roll filled with a creamy cheese topping. This has not '
                            'been Kosher certified. 350 calories.',
                        image: 'assets/images/Cheese_Danish.jpg',
                      ),
                      FoodItem(
                        name: 'Chocolate Chip Cookie',
                        description: 'Delicious, chewy and filled with chocolate chips. This has not been '
                            'Kosher certified. 330 calories.',
                        image: 'assets/images/Chocolate_Chip_Cookie.jpg',
                      ),
                      //breakfast - heading?
                      //breakfast
                      FoodItem(
                        name: 'Bacon Egg Bites',
                        description: 'Scrambled eggs with Jack Cheese, Swiss Cheese, Potato & Bacon. 220 calories.',
                        image: 'assets/images/Bacon_Egg_Bites.jpg',
                      ),
                      FoodItem(
                        name: 'Beyond Breakfast Sausage Sandwich',
                        description: 'Cage-free egg, melted provolone cheese & plant-based Beyond Breakfast Sausage'
                            ' on a toasted English muffin. 400 calories.',
                        image: 'assets/images/Sausage_Sandwich.jpg',
                      ),
                      FoodItem(
                        name: 'Egg White & Veggie Bites',
                        description: 'Egg whites scrambled with marinated Red Bell Peppers, Mushrooms & Spinach, '
                            'Jack, Swiss & Gruyere cheeses. 110 calories.',
                        image: 'assets/images/Veggie_Bites.jpg',
                      ),
                      //sandwiches & wraps
                      FoodItem(
                        name: 'Bacon Egg Cheese English Muffin',
                        description: 'Crispy bacon and fried egg topped with melted cheddar cheese on a toasted '
                            'English Muffin. 400 calories',
                        image: 'assets/images/English_Muffin.jpg',
                      ),
                      FoodItem(
                        name: 'Ham Egg and Cheese Brioche',
                        description: 'A buttery brioche bun filled with fluffy eggs, black forest ham and cheddar '
                            'cheese. 400 calories.',
                        image: 'assets/images/Brioche.jpg',
                      ),
                      FoodItem(
                        name: 'Chorizo Breakfast Burrito',
                        description: 'Fluffy scrambled eggs with Mexican-spiced Chorizo potatoes, melted pepper jack '
                            'cheese, and fire roasted tomato salsa in a crisp flour tortilla. 530 calories.',
                        image: 'assets/images/Chorizo_Burrito.jpg',
                      ),
                      FoodItem(
                        name: 'Egg White Pesto Wrap',
                        description: 'Protein packed egg whites combined with pesto cream cheese spread, roasted tomatoes, '
                            'and mozzarella wrapped in a spinach tortilla. This has not been Kosher certified. 280 calories.',
                        image: 'assets/images/Pesto_Wrap.jpg',
                      ),
                      FoodItem(
                        name: 'Egg, Spinach and Cheddar Ciabatta',
                        description: 'Scrambled eggs, spinach, and cheddar cheese on artisan ciabatta bread. This has not '
                            'been Kosher certified. 470 calories.',
                        image: 'assets/images/Ciabatta.jpg',
                      ),
                      //oatmeal & cereal
                      FoodItem(
                        name: 'Overnight Oats',
                        description: 'Great breakfast option! Oats packed with yogurt, chia seeds, honey, strawberries, '
                            'blueberries, and pecans. This has not been Kosher certified. 520 calories.',
                        image: 'assets/images/Overnight_Oats.jpg',
                      ),
                      FoodItem(
                        name: 'Modern Oats 5 Berry',
                        description: 'This very berry blend of juicy nutrient packed and antioxidant rich oatmeal is loaded '
                            'with blueberries, strawberries, cranberries, blackberries, raspberries and accented with California'
                            ' almonds and pecans. 250 calories.',
                        image: 'assets/images/Modern_Oats.jpg',
                      ),
                      //yogurt
                      FoodItem(
                        name: 'Mixed Berries & Granola Parfait',
                        description: 'Plain Greek yogurt, mixed berries and delicious crunchy granola. This has not been Kosher '
                            'certified. 200 calories.',
                        image: 'assets/images/Parfait.jpg',
                      ),
                      //lunch
                      //sandwiches & wraps
                      FoodItem(
                        name: 'Caprese Sandwich',
                        description: 'Sun blushed tomatoes, mozzarella, spinach and pesto dressing on an artisan roll. This has '
                            'not been Kosher certified. 620 calories.',
                        image: 'assets/images/Caprese_Sandwich.jpg',
                      ),
                      FoodItem(
                        name: 'Homestyle Grilled Cheese Sandwich',
                        description: 'A classic grilled cheese made with mild cheddar and Monterey Jack cheese. Oven toasted to '
                            'perfection.',
                        image: 'assets/images/Homestyle_Grilled_Cheese.jpg',
                      ),
                      FoodItem(
                        name: 'Turkey Pesto Sandwich',
                        description: 'Turkey Pesto with provolone cheese, tomato and spinach on a ciabatta bun. Great cold or '
                            'warmed up! 620 calories.',
                        image: 'assets/images/Turkey_Pesto_Sandwich.jpg',
                      ),
                      //sides (chips, popcorn & cookies)
                      FoodItem(
                        name: 'Kettle Chips - Backyard BBQ',
                        description: 'Kettle Backyard BBQ chips have bold BBQ flavor and hearty crunch and are made from all'
                            ' natural, real food ingredients. Gluten-free. Non-GMO. 150 calories.',
                        image: 'assets/images/Kettle_Chips.jpg',
                      ),
                      FoodItem(
                        name: 'Kettle Chips - Sea Salt',
                        description: 'Kettle Sea Salt chips have bold flavor and hearty crunch and are made from all natural, real '
                            'food ingredients. Gluten-free. Non-GMO. 150 calories.',
                        image: 'assets/images/Kettle_Chips.jpg',
                      ),
                      FoodItem(
                        name: 'Kettle Chips - Sea Salt and Vinegar',
                        description: 'The perfect balance of zesty sea salt, a hint of lip-puckering vinegar and satisfying crunch. '
                            '220 calories.',
                        image: 'assets/images/Kettle_Chips_Vinegar.jpg',
                      ),
                      //snacks & treats
                      //healthy snacks
                      FoodItem(
                        name: 'Kind Cranberry Almond Antioxidants Bar',
                        description: 'Whole almonds and dried cranberries combine to create a snack that is both sweet and satisfying. '
                            'Naturally packed with vitamins and antioxidants. Gluten-Free, Non-GMO. 190 calories.',
                        image: 'assets/images/Almond_Bar.jpg',
                      ),
                      FoodItem(
                        name: 'Kind Dark Choc Nuts & Sea Salt Bar',
                        description: 'A sweet and salty blend of almonds, peanuts, and walnuts drizzled in chocolate with a touch of '
                            'sea salt. 6g of protein and 7g of fiber. Non-GMO and Gluten-Free. 200 calories.',
                        image: 'assets/images/Choc_Nuts_Sea_Salt_Bar.jpg',
                      ),
                      FoodItem(
                        name: 'SkinnyPop White Cheddar Popcorn',
                        description: 'Premium popcorn kernel, sunflower oil and teh perfect amount of salt. Contains no GMOs, gluten '
                            'or preservatives, making SkinnyPop a tasty, guilt-free snack. 90 calories.',
                        image: 'assets/images/SkinnyPop.jpg',
                      ),
                      FoodItem(
                        name: 'Hippeas White Cheddar',
                        description: 'Organic cheddar flavored chickpea puffs that are an entirely plant-based snack with 4g protein '
                            'and 3g fiber. Gluten-free, no GMOs, and vegan. 190 calories.',
                        image: 'assets/images/Hippeas.jpg',
                      ),
                      //sweet treats
                      FoodItem(
                        name: 'Madeleine 3 Pack',
                        description: 'Soft and moist little cakes baked in the traditional French style. 230 calories.',
                        image: 'assets/images/Madeleine.jpg',
                      ),
                      FoodItem(
                        name: 'Lenny and Larry’s Complete Cookie',
                        description: 'Satisfying firm and chewy, this delectable chocolate chip cookie is lovingly '
                            'sprinkled with sizable semi-sweet morsels of chocolate throughout. 360 calories.',
                        image: 'assets/images/Complete_Cookie.jpg',
                      ),
                      FoodItem(
                        name: 'Lenny and Larry’s Snickerdoodle',
                        description: 'Love the taste of cinnamon? Then look no further. Lenny & Larry\'s Complete '
                            'Snickerdoodle Cookie is generously topped with cinnamon and sugar to give you a delightful '
                            'little crunch with each tasty bite. 370 calories.',
                        image: 'assets/images/Snickerdoodle.jpg',
                      ),
                      FoodItem(
                        name: 'Milk Chocolate Sea Salt Almonds',
                        description: 'Fresh roasted California almonds covered in layers of chocolate and a hint of sea '
                            'salt. 350 calories.',
                        image: 'assets/images/Sea_Salt_Almonds.jpg',
                      ),
                      //gourmet chocolate & candy
                      FoodItem(
                        name: 'Milk Chocolate Salted Caramels',
                        description: 'Delicious bite sized pieces of caramel and sea salt covered in creamy milk chocolate. '
                            '2 pieces per pack. 200 calories.',
                        image: 'assets/images/Salted_Caramels.jpg',
                      ),
                    ],
                  ),
                  FoodCategory(
                    categoryName: 'Coffee',
                    foodList: [
                      //Brewed Coffee
                      FoodItem(
                        name: 'Brewed Coffee',
                        description: 'One of our light, medium, dark or decaffeinated brews of the day, brewed from only the '
                            'top 1% of Arabica beans in the world.',
                        image: 'assets/images/Brewed_Coffee.jpg',
                      ),
                      FoodItem(
                        name: 'Cafe Au Lait',
                        description: 'Our light roast coffee with steamed whole milk and topped with thick velvety foam.',
                        image: 'assets/images/Cafe_Au_Lait.jpg',
                      ),
                      FoodItem(
                        name: 'Cafe Caramel',
                        description: 'Our light roast coffee with our French Deluxe vanilla powder, caramel sauce, steamed '
                            'non-fat milk, topped with thick foam, and a drizzle of caramel sauce.',
                        image: 'assets/images/Cafe_Caramel.jpg',
                      ),
                      FoodItem(
                        name: 'Cafe Cookie Butter',
                        description: 'Our light roast coffee with our sweet and spicy cookie butter powder, steamed '
                            'non-fat milk and topped with thick foam.',
                        image: 'assets/images/Cafe_Cookie_Butter.jpg',
                      ),
                      FoodItem(
                        name: 'Cafe Dark Chocolate',
                        description: 'Our light roast coffee with our dark chocolate powder, steamed '
                            'non-fat milk and topped with thick foam.',
                        image: 'assets/images/Cafe_Dark_Chocolate.jpg',
                      ),
                      FoodItem(
                        name: 'Cafe Hazelnut',
                        description: 'Our light roast coffee with our hazelnut powder, steamed '
                            'non-fat milk and topped with thick foam.',
                        image: 'assets/images/Cafe_Hazelnut.jpg',
                      ),
                      FoodItem(
                        name: 'Cafe Mocha',
                        description: 'This signature drink combines our light roast coffee with '
                            'our Special Dutch chocolate powder, steamed non-fat milk and topped '
                            'with thick foam.',
                        image: 'assets/images/Cafe_Mocha.jpg',
                      ),
                      FoodItem(
                        name: 'Cafe Vanilla',
                        description: 'Our light roast coffee with our French Deluxe vanilla powder, '
                            'steamed non-fat milk and topped with thick foam.',
                        image: 'assets/images/Cafe_Vanilla.jpg',
                      ),
                      FoodItem(
                        name: 'Cafe White Chocolate',
                        description: 'Our light roast coffee with our white chocolate powder, steamed '
                            'non-fat milk and topped with thick foam.',
                        image: 'assets/images/Cafe_White_Chocolate.jpg',
                      ),
                      //Iced coffee
                      FoodItem(
                        name: 'Iced Coffee',
                        description: 'Our specially brewed coffee served over ice for a refreshing and bold coffee taste.',
                        image: 'assets/images/Iced_Coffee.jpg',
                      ),
                      FoodItem(
                        name: 'Caramel Iced Coffee',
                        description: 'Our premium espresso shots blended with caramel sauce, French Deluxe vanilla powder, '
                            'and served over ice for a refreshing and delicious caramel coffee drink.',
                        image: 'assets/images/Caramel_Iced_Coffee.jpg',
                      ),
                      FoodItem(
                        name: 'Cookie Butter Iced Coffee',
                        description: 'Our premium espresso shots blended with our sweet and spicy cookie butter powder, '
                            'and served over ice for a refreshing and delicious cookie butter coffee drink.',
                        image: 'assets/images/Cookie_Iced_Coffee.jpg',
                      ),
                      FoodItem(
                        name: 'Dark Chocolate Iced Coffee',
                        description: 'Our premium espresso shots blended with our dark chocolate powder, '
                            'and served over ice for a refreshing and delicious chocolate coffee drink.',
                        image: 'assets/images/Dark_Chocolate_Iced_Coffee.jpg',
                      ),
                      FoodItem(
                        name: 'Hazelnut Iced Coffee',
                        description: 'Our premium espresso shots blended with our specially developed hazelnut powder, '
                            'and served over ice for a refreshing and delicious hazelnut coffee drink.',
                        image: 'assets/images/Hazelnut_Iced_Coffee.jpg',
                      ),
                      FoodItem(
                        name: 'Mocha Iced Coffee',
                        description: 'Our premium espresso shots blended with our Special Dutch chocolate powder, '
                            'and served over ice for a refreshing and delicious chocolate coffee drink.',
                        image: 'assets/images/Mocha_Iced_Coffee.jpg',
                      ),
                      FoodItem(
                        name: 'Vanilla Iced Coffee',
                        description: 'Our premium espresso shots blended with our French Deluxe vanilla powder, '
                            'and served over ice for a refreshing and delicious vanilla coffee drink.',
                        image: 'assets/images/Vanilla_Iced_Coffee.jpg',
                      ),
                      FoodItem(
                        name: 'White Chocolate Iced Coffee',
                        description: 'Our premium espresso shots blended with our white chocolate powder, '
                            'and served over ice for a refreshing and delicious chocolate coffee drink.',
                        image: 'assets/images/White_Chocolate_Iced_Coffee.jpg',
                      ),
                      // Add more signature sandwiches
                    ],
                  ),
                  FoodCategory(
                    categoryName: 'Espresso',
                    foodList: [
                      //Espresso
                      FoodItem(
                        name: 'Vanilla Spiced Oat Latte',
                        description: 'A delicious blend of vanilla and spice. '
                            'We are adding a hint of spice and our Oatly Oatmilk '
                            'for the perfect Winter beverage. Plant-Based. Vegan.',
                        image: 'assets/images/Vanilla_Spiced_Oat_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Winter Dream Tea',
                        description: 'Characteristically sweet rooibos and delicate '
                            'black tea are highlighted by the festive flavor of '
                            'cinnamon and clove. 5 calories.',
                        image: 'assets/images/Winter Dream Tea.jpg',
                      ),
                      FoodItem(
                        name: 'Cafe Latte',
                        description: 'Freshly pulled shots of espresso with steamed'
                            ' milk and topped with thick foam.',
                        image: 'assets/images/Cafe_Au_Lait.jpg',
                      ),
                      FoodItem(
                        name: 'Caramel Latte',
                        description: 'Freshly pulled shot of espresso with our French '
                            'Deluxe vanilla powder, caramel sauce, steamed non-fat milk, '
                            'topped with thick foam, and a drizzle of caramel sauce.',
                        image: 'assets/images/Cafe_Caramel.jpg',
                      ),
                      FoodItem(
                        name: 'Cookie Butter Latte',
                        description: 'Our premium espresso with spice and brown sugar '
                            'cookie notes, garnished with Speculoos Cookie Crumbs for '
                            'a sweet and spicy treat.',
                        image: 'assets/images/Cafe_Cookie_Butter.jpg',
                      ),
                      FoodItem(
                        name: 'Dark Chocolate Latte',
                        description: 'Freshly pulled shots of espresso with our rich '
                            'dark chocolate powder, steamed non-fat milk and topped '
                            'with thick foam.',
                        image: 'assets/images/Cafe_Dark_Chocolate.jpg',
                      ),
                      FoodItem(
                        name: 'Hazelnut Latte',
                        description: 'Freshly pulled shots of espresso with our hazelnut '
                            'powder, steamed non-fat milk and topped with thick foam.',
                        image: 'assets/images/Cafe_Hazelnut.jpg',
                      ),
                      FoodItem(
                        name: 'Mocha Latte',
                        description: 'Freshly pulled shots of espresso with our Special '
                            'Dutch chocolate powder, steamed non-fat milk and topped with '
                            'thick foam.',
                        image: 'assets/images/Cafe_Mocha.jpg',
                      ),
                      FoodItem(
                        name: 'Vanilla Latte',
                        description: 'Freshly pulled shots of espresso with our French Deluxe '
                            'vanilla powder, steamed non-milk and topped with thick foam.',
                        image: 'assets/images/Cafe_Vanilla.jpg',
                      ),
                      FoodItem(
                        name: 'White Chocolate Latte',
                        description: 'Freshly pulled shots of espresso with our white '
                            'chocolate powder, steamed non-fat milk and topped with '
                            'thick foam.',
                        image: 'assets/images/Cafe_White_Chocolate.jpg',
                      ),
                      //flat white
                      FoodItem(
                        name: 'Classic Flat White',
                        description: 'A double shot of espresso (for a 12 oz. drink!) with '
                            'lightly aerated steamed milk to create the perfect, velvety '
                            'espresso beverage.',
                        image: 'assets/images/Classic_Flat_White.jpg',
                      ),
                      FoodItem(
                        name: 'Caramel Flat White',
                        description: 'A double shot of espresso (for a 12 oz. drink!) is combined '
                            'with our signature flavored powders that is finished with lightly '
                            'aerated steamed milk to create the perfect, velvety espresso beverage.',
                        image: 'assets/images/Caramel Flat White.jpg',
                      ),
                      FoodItem(
                        name: 'Cookie Butter Flat White',
                        description: 'A double shot of espresso (for a 12 oz. drink!) is combined '
                            'with our signature flavored powders that is finished with lightly '
                            'aerated steamed milk to create the perfect, velvety espresso beverage.',
                        image: 'assets/images/Cookie Butter Flat White.jpg',
                      ),
                      FoodItem(
                        name: 'Dark Chocolate Flat White',
                        description: 'A double shot of espresso (for a 12 oz. drink!) is combined '
                            'with our signature flavored powders that is finished with lightly '
                            'aerated steamed milk to create the perfect, velvety espresso beverage.',
                        image: 'assets/images/Dark Chocolate Flat White.jpg',
                      ),
                      FoodItem(
                        name: 'Hazelnut Flat White',
                        description: 'A double shot of espresso (for a 12 oz. drink!) is combined '
                            'with our signature flavored powders that is finished with lightly '
                            'aerated steamed milk to create the perfect, velvety espresso beverage.',
                        image: 'assets/images/Hazelnut Flat White.jpg',
                      ),
                      FoodItem(
                        name: 'Mocha Flat White',
                        description: 'A double shot of espresso (for a 12 oz. drink!) is combined '
                            'with our signature flavored powders that is finished with lightly '
                            'aerated steamed milk to create the perfect, velvety espresso beverage.',
                        image: 'assets/images/Mocha Flat White.jpg',
                      ),
                      FoodItem(
                        name: 'Vanilla Flat White',
                        description: 'A double shot of espresso (for a 12 oz. drink!) is combined '
                            'with our signature flavored powders that is finished with lightly '
                            'aerated steamed milk to create the perfect, velvety espresso beverage.',
                        image: 'assets/images/Vanilla Flat White.jpg',
                      ),
                      FoodItem(
                        name: 'White Chocolate Flat White',
                        description: 'A double shot of espresso (for a 12 oz. drink!) is combined '
                            'with our signature flavored powders that is finished with lightly '
                            'aerated steamed milk to create the perfect, velvety espresso beverage.',
                        image: 'assets/images/White Chocolate Flat White.jpg',
                      ),
                      /*
                      //americanos
                      FoodItem(
                        name: 'Americano',
                        description: '',
                        image: 'assets/images/Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Caramel Americano',
                        description: '',
                        image: 'assets/images/Caramel Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Cookie Butter Americano',
                        description: '',
                        image: 'assets/images/Cookie Butter Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Dark Chocolate Americano',
                        description: '',
                        image: 'assets/images/Dark Chocolate Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Hazelnut Americano',
                        description: '',
                        image: 'assets/images/Hazelnut Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Mocha Americano',
                        description: '',
                        image: 'assets/images/Mocha Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Vanilla Americano',
                        description: '',
                        image: 'assets/images/Vanilla Americano.jpg',
                      ),
                      FoodItem(
                        name: 'White Chocolate Americano',
                        description: '',
                        image: 'assets/images/White Chocolate Americano.jpg',
                      ),
                      //cappuccinos
                      FoodItem(
                        name: 'Cappuccino',
                        description: '',
                        image: 'assets/images/Cappuccino.jpg',
                      ),
                      FoodItem(
                        name: 'Caramel Cappuccino',
                        description: '',
                        image: 'assets/images/Cafe_Caramel.jpg',
                      ),
                      //espressos
                      FoodItem(
                        name: 'Espresso',
                        description: '',
                        image: 'assets/images/Espresso.jpg',
                      ),
                      FoodItem(
                        name: 'Macchiato',
                        description: '',
                        image: 'assets/images/Macchiato.jpg',
                      ),
                      FoodItem(
                        name: 'Red Eye',
                        description: '',
                        image: 'assets/images/Red Eye.jpg',
                      ),
                      //iced espresso
                      //iced lattes
                      FoodItem(
                        name: 'Iced Vanilla Spiced Oat Latte',
                        description: '',
                        image: 'assets/images/Iced Vanilla Spiced Oat Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Iced Salted Caramel Mocha Latte',
                        description: '',
                        image: 'assets/images/Iced Salted Caramel Mocha Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Iced Latte',
                        description: '',
                        image: 'assets/images/Iced_Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Caramel Iced Latte',
                        description: '',
                        image: 'assets/images/Caramel Iced Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Cookie Butter Iced Latte',
                        description: '',
                        image: 'assets/images/Cookie Butter Iced Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Dark Chocolate Iced Latte',
                        description: '',
                        image: 'assets/images/Dark Chocolate Iced Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Hazelnut Iced Latte',
                        description: '',
                        image: 'assets/images/Hazelnut Iced Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Mocha Iced Latte',
                        description: '',
                        image: 'assets/images/Mocha Iced Latte.jpg',
                      ),
                      FoodItem(
                        name: 'Vanilla Iced Latte',
                        description: '',
                        image: 'assets/images/Vanilla Iced Latte.jpg',
                      ),
                      FoodItem(
                        name: 'White Chocolate Iced Latte',
                        description: '',
                        image: 'assets/images/White Chocolate Iced Latte.jpg',
                      ),
                      //iced americanos
                      FoodItem(
                        name: 'Iced Americano',
                        description: '',
                        image: 'assets/images/Iced Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Caramel Iced Americano',
                        description: '',
                        image: 'assets/images/Caramel Iced Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Cookie Butter Iced Americano',
                        description: '',
                        image: 'assets/images/Cookie Butter Iced Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Dark Chocolate Iced Americano',
                        description: '',
                        image: 'assets/images/Dark Chocolate Iced Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Hazelnut Iced Americano',
                        description: '',
                        image: 'assets/images/Hazelnut Iced Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Mocha Iced Americano',
                        description: '',
                        image: 'assets/images/Mocha Iced Americano.jpg',
                      ),
                      FoodItem(
                        name: 'Vanilla Iced Americano',
                        description: '',
                        image: 'assets/images/Vanilla Iced Americano.jpg',
                      ),
                      FoodItem(
                        name: 'White Chocolate Iced Americano',
                        description: '',
                        image: 'assets/images/White Chocolate Iced Americano.jpg',
                      ),
                      //cappuccinos
                      FoodItem(
                        name: 'Iced Cappuccino',
                        description: '',
                        image: 'assets/images/Iced Cappuccino.jpg',
                      ),
                      FoodItem(
                        name: 'Caramel Iced Cappuccino',
                        description: '',
                        image: 'assets/images/Caramel Iced Cappuccino.jpg',
                      ),
                     //Add more signature sandwiches
                     */
                    ],
                  ),
                  FoodCategory(
                    categoryName: 'Cold Brew',
                    foodList: [
                      FoodItem(
                        name: '',
                        description: '',
                        image: 'assets/images/.jpg',
                      ),
                      // Add more popular food items for The Habit
                    ],
                  ),
                  FoodCategory(
                    categoryName: 'Size',
                    foodList: [
                      FoodItem(
                        name: '',
                        description: '',
                        image: 'assets/images/.jpg',
                      ),

                      // Add more popular food items for The Habit
                    ],
                  ),


                  // Add more categories and food items as needed
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FoodCategory extends StatelessWidget {
  final String categoryName;
  final List<FoodItem> foodList;

  FoodCategory({required this.categoryName, required this.foodList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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

  FoodItem({required this.name, required this.description, required this.image});
}

class FoodOption extends StatelessWidget {
  final FoodItem foodItem;

  FoodOption({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Display the food image on the left
          Expanded(
            flex: 2,
            child: Image.asset(
              foodItem.image,
              fit: BoxFit.cover,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
