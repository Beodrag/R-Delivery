import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart'; // Import your CartModel

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final item = cart.items[index];
          double itemTotalPrice = item.getTotalPrice();

          return ListTile(
            title: Text(item.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${item.description} - \$${itemTotalPrice.toStringAsFixed(2)}"),
                // Iterate through selected required options and display them
                ...item.selectedRequiredOptions.entries.map((e) {
                  return Text("${e.key}: ${e.value ?? 'Not selected'}");
                }).toList(),
                // Display the selected extras
                if (item.selectedExtras.isNotEmpty)
                  Text("Extras: " +
                      item.selectedExtras.entries
                          .where((e) => e.value == true)
                          .map((e) => e.key)
                          .join(", ")),
              ],
            ),
            trailing: Text("\$${itemTotalPrice.toStringAsFixed(2)}"),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('\$${cart.totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10), // Add some space before the button
            ElevatedButton(
              onPressed: cart.items.isNotEmpty ? () {
                // Place your checkout logic here
                print('Proceeding to checkout');
                // You can navigate to a new page or show a confirmation dialog
              } : null, // Disable the button if the cart is empty
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50), // make the button larger
              ),
              child: Text('Checkout', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
