import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:jannah/features/checkout/presentation/widgets/cart_item_card.dart';
import 'package:jannah/features/checkout/presentation/widgets/checkout_summary.dart';
import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/presentation/addresses_screen.dart';
import 'package:jannah/features/profile/presentation/widgets/location_preview.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  Future<void> _refreshCart(BuildContext context) {
    return context.read<CheckoutCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back_button_icon.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () {
            context.read<NavigationCubit>().goHome();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state.status == CheckoutStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.status == CheckoutStatus.loading &&
              state.cartItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CheckoutStatus.failure &&
              state.cartItems.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.errorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          if (state.cartItems.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => _refreshCart(context),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _refreshCart(context),
            child: ListView(
              children: [
                _buildDeliveryAddressSection(),
                Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 12),
                  child: Container(
                    height: 1,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.black, Colors.white],
                        stops: [0.1, 0.5, 0.9],
                      ),
                    ),
                  ),
                ),
                for (final item in state.cartItems)
                  CheckoutItemCard(cartItem: item),
                SizedBox(
                  height:
                      (MediaQuery.of(context).size.height -
                              534 -
                              state.cartItems.length * 100) >
                          0
                      ? (MediaQuery.of(context).size.height -
                            534 -
                            state.cartItems.length * 100)
                      : 0,
                ),
                CheckoutSummary(
                  subtotal: state.total,
                  itemsCount: state.cartItems.length,
                  isCheckingOut: state.isCheckingOut,
                  onCheckout: () =>
                      context.read<CheckoutCubit>().completeCheckout(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeliveryAddressSection() {
    final Address deliveryAddress = Address(
      addressId: 1,
      addressType: 'Home',
      addressLine: '123 Main St',
      city: 'Anytown',
      state: 'Anystate',
      country: 'Anycountry',
      postalCode: '12345',
      latitude: 0.0,
      longitude: 0.0,
      isDefault: true,
    );
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Delivering to ${deliveryAddress.addressType}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${deliveryAddress.addressLine}, ${deliveryAddress.city}, gsdgsdg sdgsdgdsg dsg dsgds gdsg dsg sdgdg sdg sdg sdgsd gsdg sdg ${deliveryAddress.country}',
                    softWrap: true,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              child: LocationPreview(
                height: 100,
                latitude: 32.32,
                longitude: 12.654,
                onTap: () {},
                showError: false,
                isClickable: false,
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
