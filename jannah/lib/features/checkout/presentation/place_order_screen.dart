// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/core/custom_widgets/primary_button.dart';
import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/presentation/addresses_screen.dart';
import 'package:jannah/features/profile/presentation/widgets/address_tile.dart';

class PlaceOrderScreen extends StatefulWidget {
  PlaceOrderScreen({
    super.key,
    required this.itemsCount,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.total,
    required this.deliveryAddress,
    required this.isCheckingOut,
    required this.onCheckout,
  });
  final int itemsCount;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double total;
  final Address deliveryAddress;
  final bool isCheckingOut;
  final Future<void> Function({
    required double deliveryFee,
    required double pakagingFee,
    required String paymentMethod,
  })
  onCheckout;
  String selectedPayment = 'Cash on Delivery';

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Place Order',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back_button_icon.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildDeleiveryAddressSection(),
            const SizedBox(height: 16),
            _buildOrderSummarySection(),
            const SizedBox(height: 32),
            Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.black, Colors.white],
                  stops: [0.1, 0.5, 0.9],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildPaymentMethodSection(),
            Spacer(),
            _buildPlaceOrderButton(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleiveryAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivering to',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        AddressTile(
          isEditable: false,
          isSelected: true,
          address: widget.deliveryAddress,
          onEdit: () {},
          onDelete: () {},
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildOrderSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Subtotal (${widget.itemsCount})',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '\$${widget.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Delivery Fee', style: TextStyle(fontSize: 14)),
                  Text(
                    widget.deliveryFee == 0
                        ? "Free"
                        : "\$${widget.deliveryFee.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Service Fee', style: TextStyle(fontSize: 14)),
                  Text(
                    '\$${widget.serviceFee.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${widget.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                widget.selectedPayment = 'Cash on Delivery';
              });
            },
            leading: Radio<String>(
              activeColor: Colors.black,
              value: 'Cash on Delivery',
              groupValue: widget.selectedPayment,
              onChanged: (value) {
                setState(() {
                  widget.selectedPayment = value!;
                });
              },
            ),
            title: const Text('Cash on Delivery'),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                widget.selectedPayment = 'Card / PayPal';
              });
            },
            leading: Radio<String>(
              activeColor: Colors.black,
              value: 'Card / PayPal',
              groupValue: widget.selectedPayment,
              onChanged: (value) {
                setState(() {
                  widget.selectedPayment = value!;
                });
              },
            ),
            title: const Text('Card / PayPal'),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return PrimaryButton(
      onPressed: widget.isCheckingOut
          ? () {}
          : () async {
              await widget
                  .onCheckout(
                    deliveryFee: widget.deliveryFee,
                    pakagingFee: widget.serviceFee,
                    paymentMethod: widget.selectedPayment,
                  )
                  .then((_) {
                    context.read<NavigationCubit>().goToTab(4);
                  })
                  .then((_) {
                    Navigator.of(context).pop();
                  });
            },
      text: 'Place Order',
    );
  }
}
