import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:jannah/features/checkout/presentation/place_order_screen.dart';
import 'package:jannah/features/checkout/presentation/widgets/cart_item_card.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_cubit.dart';

class CheckoutSummary extends StatelessWidget {
  final double subtotal;
  final bool isCheckingOut;
  final Future<void> Function({
    required double deliveryFee,
    required double pakagingFee,
    required String paymentMethod,
  })
  onCheckout;
  final double deliveryFee = 0;
  final double serviceFee = 2;
  final int itemsCount;

  const CheckoutSummary({
    super.key,
    required this.subtotal,
    required this.isCheckingOut,
    required this.onCheckout,
    required this.itemsCount,
  });

  @override
  Widget build(BuildContext context) {
    double total = subtotal + deliveryFee + serviceFee;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Subtotal ($itemsCount)', style: TextStyle(fontSize: 14)),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
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
                deliveryFee == 0
                    ? "Free"
                    : "\$${deliveryFee.toStringAsFixed(2)}",
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
                '\$${serviceFee.toStringAsFixed(2)}',
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
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 54,
            width: double.infinity,
            child: FilledButton(
              onPressed: isCheckingOut
                  ? null
                  : () {
                      final profileCubit = context.read<ProfileCubit>();
                      final navigationCubit = context.read<NavigationCubit>();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (routeContext) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: profileCubit),
                              BlocProvider.value(value: navigationCubit),
                            ],
                            child: PlaceOrderScreen(
                              itemsCount: itemsCount,
                              subtotal: subtotal,
                              deliveryFee: deliveryFee,
                              serviceFee: serviceFee,
                              total: total,
                              isCheckingOut: isCheckingOut,
                              onCheckout:
                                  ({
                                    required double deliveryFee,
                                    required double pakagingFee,
                                    required String paymentMethod,
                                  }) async {
                                    await onCheckout(
                                      deliveryFee: deliveryFee,
                                      pakagingFee: pakagingFee,
                                      paymentMethod: paymentMethod,
                                    );
                                  },
                            ),
                          ),
                        ),
                      );
                    },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isCheckingOut
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
