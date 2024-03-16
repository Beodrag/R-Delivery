import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'checkout.dart';

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    void showCheckoutDialog() {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
          String _userName = '';
          String _userPhone = '';

          return AlertDialog(
            title: Text('Checkout Information'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPhone = value!;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.of(dialogContext).pop();
                    // Navigate to CheckoutPage with the order details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          userName: _userName,
                          userPhone: _userPhone,
                          userAddress: cart.userAddress,
                          items: cart.items,
                          userLocation: cart.userLocation,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
    }


    void removeItemFromCart(int index) {
      cart.removeItem(index);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.blue,
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
                ...item.selectedRequiredOptions.entries.map((e) => Text("${e.key}: ${e.value ?? 'Not selected'}")).toList(),
                if (item.selectedExtras.isNotEmpty)
                  Text("Extras: " + item.selectedExtras.entries.where((e) => e.value == true).map((e) => e.key).join(", ")),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("\$${itemTotalPrice.toStringAsFixed(2)}"),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeItemFromCart(index),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.blue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                Text('\$${cart.totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: cart.items.isNotEmpty ? () => showCheckoutDialog() : null,
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
              child: Text('Checkout', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
