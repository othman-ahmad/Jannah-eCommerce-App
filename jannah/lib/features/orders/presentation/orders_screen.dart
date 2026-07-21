import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:jannah/features/orders/presentation/cubit/orders_state.dart';
import 'package:jannah/features/orders/presentation/widgets/oreder_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int? _expandedOrderId;
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _cardKeys = {};

  GlobalKey _keyFor(int orderId) =>
      _cardKeys.putIfAbsent(orderId, () => GlobalKey());

  void _toggleOrder(int orderId) {
    final isCollapsing = _expandedOrderId == orderId;

    setState(() {
      _expandedOrderId = isCollapsing ? null : orderId;
    });

    if (!isCollapsing) {
      // First pass: scroll right away so the card starts moving into view
      // as soon as it begins expanding.
      _scrollOrderIntoView(orderId);
    }
  }

  void _scrollOrderIntoView(int orderId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_expandedOrderId != orderId) return; // was collapsed/switched
      final keyContext = _cardKeys[orderId]?.currentContext;
      if (keyContext == null) return;
      Scrollable.ensureVisible(
        keyContext,
        alignment: 0.0,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          'My Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state.status == OrdersStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.status == OrdersStatus.loading && state.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == OrdersStatus.failure && state.orders.isEmpty) {
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

          if (state.orders.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => context.read<OrdersCubit>().loadOrders(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'No orders yet',
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
            onRefresh: () => context.read<OrdersCubit>().loadOrders(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];

                return OrderCard(
                  key: _keyFor(order.orderId),
                  order: order,
                  isExpanded: _expandedOrderId == order.orderId,
                  onToggle: () => _toggleOrder(order.orderId),
                  onDetailsLoaded: () => _scrollOrderIntoView(order.orderId),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
