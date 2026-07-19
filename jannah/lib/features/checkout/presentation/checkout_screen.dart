import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:jannah/features/checkout/presentation/select_delivery_address_screen.dart';
import 'package:jannah/features/checkout/presentation/widgets/cart_item_card.dart';
import 'package:jannah/features/checkout/presentation/widgets/checkout_summary.dart';
import 'package:jannah/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_state.dart';
import 'package:jannah/features/profile/presentation/widgets/location_preview.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  Future<void> _refreshCart(BuildContext context) {
    return context.read<CheckoutCubit>().loadCart();
  }

  Address? _effectiveDeliveryAddress({
    required Address? selectedAddress,
    required ProfileState profileState,
  }) {
    if (selectedAddress != null) {
      for (final address in profileState.addresses) {
        if (address.addressId == selectedAddress.addressId) {
          return address;
        }
      }
    }

    return profileState.defaultAddress();
  }

  Address? _currentDeliveryAddress(BuildContext context) {
    final checkoutState = context.read<CheckoutCubit>().state;
    final profileState = context.read<ProfileCubit>().state;

    return _effectiveDeliveryAddress(
      selectedAddress: checkoutState.selectedDeliveryAddress,
      profileState: profileState,
    );
  }

  Future<void> _openDeliveryAddressSelector(
    BuildContext context,
    Address? currentAddress,
  ) async {
    final profileCubit = context.read<ProfileCubit>();
    final selectedAddress = await Navigator.of(context).push<Address>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: profileCubit,
          child: SelectDeliveryAddressScreen(selectedAddress: currentAddress),
        ),
      ),
    );

    if (selectedAddress == null || !context.mounted) {
      return;
    }

    context.read<CheckoutCubit>().selectDeliveryAddress(selectedAddress);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
                _buildDeliveryAddressSection(context),
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
                  deliveryAddress: _currentDeliveryAddress(context),
                  isCheckingOut: state.isCheckingOut,
                  onCheckout:
                      ({
                        required double deliveryFee,
                        required double pakagingFee,
                        required String paymentMethod,
                      }) async {
                        final deliveryAddress = _currentDeliveryAddress(
                          context,
                        );

                        if (deliveryAddress == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Select a delivery address'),
                            ),
                          );
                          return;
                        }

                        await context.read<CheckoutCubit>().completeCheckout(
                          addressId: deliveryAddress.addressId,
                          deliveryFee: deliveryFee,
                          pakagingFee: pakagingFee,
                          paymentMethod: paymentMethod,
                        );
                        if (context.mounted) {
                          await context.read<OrdersCubit>().loadOrders();
                        }
                      },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeliveryAddressSection(BuildContext context) {
    final selectedDeliveryAddress = context.select<CheckoutCubit, Address?>(
      (cubit) => cubit.state.selectedDeliveryAddress,
    );
    final profileState = context.select<ProfileCubit, ProfileState>(
      (cubit) => cubit.state,
    );
    final deliveryAddress = _effectiveDeliveryAddress(
      selectedAddress: selectedDeliveryAddress,
      profileState: profileState,
    );

    final addressText = [
      deliveryAddress?.addressLine,
      deliveryAddress?.city,
      deliveryAddress?.state,
      deliveryAddress?.country,
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openDeliveryAddressSelector(context, deliveryAddress),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    'Delivering to ${deliveryAddress?.addressType ?? 'Address'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    addressText.isNotEmpty
                        ? addressText
                        : 'No default address selected',
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
          const SizedBox(width: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              child: LocationPreview(
                key: ValueKey(
                  '${deliveryAddress?.addressId ?? 'default'}:${deliveryAddress?.latitude ?? 'null'}:${deliveryAddress?.longitude ?? 'null'}',
                ),
                height: 100,
                latitude: deliveryAddress?.latitude ?? 32.32,
                longitude: deliveryAddress?.longitude ?? 12.654,
                onTap: () =>
                    _openDeliveryAddressSelector(context, deliveryAddress),
                showError: false,
                isClickable: false,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
