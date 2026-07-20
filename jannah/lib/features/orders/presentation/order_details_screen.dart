import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/orders/data/order_details_model.dart';
import 'package:jannah/features/orders/data/order_item_model.dart';
import 'package:jannah/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:jannah/features/orders/presentation/cubit/orders_state.dart';
import 'package:jannah/features/profile/data/address_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadOrderDetails(orderId: widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state.detailsStatus == OrdersStatus.loading &&
              state.orderDetails == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.detailsStatus == OrdersStatus.failure) {
            return _ErrorState(
              message: state.detailsErrorMessage ?? 'Something went wrong',
              onRetry: () => context.read<OrdersCubit>().loadOrderDetails(
                orderId: widget.orderId,
              ),
            );
          }

          final details = state.orderDetails;
          if (details == null) {
            return _ErrorState(
              message: 'Order details are not available',
              onRetry: () => context.read<OrdersCubit>().loadOrderDetails(
                orderId: widget.orderId,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<OrdersCubit>().loadOrderDetails(
              orderId: widget.orderId,
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _HeaderSection(details: details),
                const SizedBox(height: 12),
                _Section(
                  title: 'Items',
                  child: details.items.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'No items found for this order',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : Column(
                          children: [
                            for (
                              var index = 0;
                              index < details.items.length;
                              index++
                            ) ...[
                              _OrderItemRow(item: details.items[index]),
                              if (index != details.items.length - 1)
                                const Divider(height: 20),
                            ],
                          ],
                        ),
                ),
                const SizedBox(height: 12),
                _Section(
                  title: 'Payment',
                  child: Column(
                    children: [
                      _DetailRow(label: 'Method', value: details.paymentMethod),
                      const SizedBox(height: 8),
                      _DetailRow(
                        label: 'Subtotal',
                        value: _formatCurrency(details.subtotal),
                      ),
                      const SizedBox(height: 8),
                      _DetailRow(
                        label: 'Delivery',
                        value: details.deliveryFee == 0
                            ? 'Free'
                            : _formatCurrency(details.deliveryFee),
                      ),
                      const SizedBox(height: 8),
                      _DetailRow(
                        label: 'Service',
                        value: _formatCurrency(details.pakagingFee),
                      ),
                      const Divider(height: 24),
                      _DetailRow(
                        label: 'Total',
                        value: _formatCurrency(details.total),
                        isStrong: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Section(
                  title: 'Delivery Address',
                  child: _AddressDetails(address: details.deliveryAddress),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final OrderDetails details;

  const _HeaderSection({required this.details});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: details.orderNumber,
      trailing: _StatusChip(status: details.status),
      child: Column(
        children: [
          _DetailRow(label: 'Items', value: '${details.items.length}'),
          const SizedBox(height: 8),
          _DetailRow(label: 'Date', value: _formatDate(details.date)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Section({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 12), trailing!],
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItem item;

  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.shopping_bag_outlined, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product #${item.productId}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.quantity} x ${_formatCurrency(item.price)}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          _formatCurrency(item.price * item.quantity),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _AddressDetails extends StatelessWidget {
  final Address address;

  const _AddressDetails({required this.address});

  @override
  Widget build(BuildContext context) {
    final location = [
      address.city,
      address.state,
      address.country,
    ].where((value) => value.trim().isNotEmpty).join(', ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on_outlined, color: Colors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.addressType,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                address.addressLine,
                style: TextStyle(color: Colors.grey.shade800),
              ),
              if (location.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(location, style: TextStyle(color: Colors.grey.shade600)),
              ],
              if (address.postalCode.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  address.postalCode,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStrong;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 14,
      fontWeight: isStrong ? FontWeight.w700 : FontWeight.w400,
      color: Colors.black,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style),
        const SizedBox(width: 16),
        Flexible(
          child: Text(value, textAlign: TextAlign.end, style: style),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

String _formatCurrency(double value) {
  return '\$${value.toStringAsFixed(2)}';
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute';
}
