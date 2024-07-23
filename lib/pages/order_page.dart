// import 'package:flutter/material.dart';
//
// class OrderPage extends StatefulWidget {
//   @override
//   _OrderPageState createState() => _OrderPageState();
// }
//
// class _OrderPageState extends State<OrderPage> {
//   // final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _cardNumberController = TextEditingController();
//   final TextEditingController _expiryDateController = TextEditingController();
//   final TextEditingController _cvvController = TextEditingController();
//   final TextEditingController _zipCodeController = TextEditingController();
//
//   @override
//   void dispose() {
//     _cardNumberController.dispose();
//     _expiryDateController.dispose();
//     _cvvController.dispose();
//     _zipCodeController.dispose();
//     super.dispose();
//   }
//
//   void _savePaymentDetails() {
//     if (_formKey.currentState!.validate()) {
//       // Save payment details logic here
//       String cardNumber = _cardNumberController.text;
//       String expiryDate = _expiryDateController.text;
//       String cvv = _cvvController.text;
//       String zipCode = _zipCodeController.text;
//
//       // You can add your logic to save these details to a database or process the payment
//       print('Card Number: $cardNumber');
//       print('Expiry Date: $expiryDate');
//       print('CVV: $cvv');
//       print('ZIP Code: $zipCode');
//
//       // Show a confirmation message or navigate to another page
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Payment details saved successfully')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
//         child: Column(
//           children: [
//             const Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Add Payment Details',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     TextFormField(
//                       controller: _cardNumberController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: 'Card Number',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your card number';
//                         } else if (value.length < 16) {
//                           return 'Card number must be 16 digits';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _expiryDateController,
//                       keyboardType: TextInputType.datetime,
//                       decoration: const InputDecoration(
//                         labelText: 'Expiry Date (MM/YY)',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your card\'s expiry date';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _cvvController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: 'CVV',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your card\'s CVV';
//                         } else if (value.length != 3) {
//                           return 'CVV must be 3 digits';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _zipCodeController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: 'ZIP Code',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your ZIP code';
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: ElevatedButton(
//                 onPressed: _savePaymentDetails,
//                 child: const Text('Save'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
