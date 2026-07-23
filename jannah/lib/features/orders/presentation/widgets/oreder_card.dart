import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/orders/data/order_details_model.dart';
import 'package:jannah/features/orders/data/order_item_model.dart';
import 'package:jannah/features/orders/data/order_model.dart';
import 'package:jannah/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';
import 'package:jannah/features/profile/data/address_model.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final bool isExpanded;
  final VoidCallback onToggle;

  /// Called after the order details finish loading (success or failure)
  /// and have had a moment to lay out, so the parent can re-sync the
  /// scroll position once the card reaches its final expanded height.
  final VoidCallback? onDetailsLoaded;

  const OrderCard({
    super.key,
    required this.order,
    required this.isExpanded,
    required this.onToggle,
    this.onDetailsLoaded,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  Future<OrderDetails>? _detailsFuture;

  Order get order => widget.order;

  @override
  void initState() {
    super.initState();
    if (widget.isExpanded) {
      _ensureDetailsFuture();
    }
  }

  @override
  void didUpdateWidget(covariant OrderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isExpanded && widget.isExpanded) {
      _ensureDetailsFuture();
    }
  }

  void _ensureDetailsFuture() {
    if (_detailsFuture != null) return;
    _startDetailsFuture();
  }

  void _startDetailsFuture() {
    final future = context.read<OrdersCubit>().fetchOrderDetails(
      orderId: order.orderId,
    );
    _detailsFuture = future;
    future.whenComplete(() {
      if (!mounted) return;
      // Give AnimatedSize a moment to grow into the newly-loaded content
      // before telling the parent it's safe to re-scroll.
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) widget.onDetailsLoaded?.call();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: widget.isExpanded ? Colors.black : Colors.grey.shade300,
            width: widget.isExpanded ? 1.2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StatusChip(status: order.status),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: widget.isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  child: const Icon(Icons.keyboard_arrow_down, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _DetailRow(label: 'Date', value: _formatDate(order.date)),
            const SizedBox(height: 6),
            _DetailRow(
              label: 'Subtotal',
              value: '\$${order.subtotal.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 6),
            _DetailRow(
              label: 'Delivery',
              value: order.deliveryFee == 0
                  ? 'Free'
                  : '\$${order.deliveryFee.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 6),
            _DetailRow(
              label: 'Service',
              value: '\$${order.pakagingFee.toStringAsFixed(2)}',
            ),
            const Divider(height: 24),
            _DetailRow(
              label: 'Total',
              value: '\$${order.total.toStringAsFixed(2)}',
              isStrong: true,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: widget.isExpanded
                  ? _ExpandedOrderDetails(
                      detailsFuture: _detailsFuture!,
                      onRetry: () {
                        setState(_startDetailsFuture);
                      },
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }
}

class _ExpandedOrderDetails extends StatelessWidget {
  final Future<OrderDetails> detailsFuture;
  final VoidCallback onRetry;

  const _ExpandedOrderDetails({
    required this.detailsFuture,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderDetails>(
      future: detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                Text(
                  snapshot.error?.toString() ??
                      'Order details are not available',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onRetry,
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }

        final details = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StaggeredReveal(
              index: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 28),
                  _InlineSectionTitle(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Items',
                  ),
                  const SizedBox(height: 10),
                  if (details.items.isEmpty)
                    Text(
                      'No items found for this order',
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  else
                    for (
                      var index = 0;
                      index < details.items.length;
                      index++
                    ) ...[
                      _OrderItemRow(item: details.items[index]),
                      if (index != details.items.length - 1)
                        const Divider(height: 18),
                    ],
                ],
              ),
            ),
            _StaggeredReveal(
              index: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 28),
                  _InlineSectionTitle(
                    icon: Icons.payments_outlined,
                    title: 'Payment',
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(label: 'Method', value: details.paymentMethod),
                  const SizedBox(height: 6),
                  _DetailRow(label: 'Order ID', value: '#${details.orderId}'),
                ],
              ),
            ),
            _StaggeredReveal(
              index: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 28),
                  _InlineSectionTitle(
                    icon: Icons.location_on_outlined,
                    title: 'Delivery Address',
                  ),
                  const SizedBox(height: 10),
                  _AddressDetails(address: details.deliveryAddress),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Fades and slides its [child] into view a little after it's built, with
/// a delay based on [index]. Used to reveal the expanded order sections
/// (Items, Payment, Address) one after another instead of all at once.
class _StaggeredReveal extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredReveal({required this.index, required this.child});

  @override
  State<_StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<_StaggeredReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 90 * widget.index), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.06),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _InlineSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _InlineSectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ],
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductNameText(productId: item.productId),
              const SizedBox(height: 4),
              Text(
                '${item.quantity} x ${_formatCurrency(item.price)}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
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

class _ProductNameText extends StatefulWidget {
  final int productId;

  const _ProductNameText({required this.productId});

  @override
  State<_ProductNameText> createState() => _ProductNameTextState();
}

class _ProductNameTextState extends State<_ProductNameText> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _loadProduct();
  }

  @override
  void didUpdateWidget(covariant _ProductNameText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      _productFuture = _loadProduct();
    }
  }

  Future<Product> _loadProduct() {
    final productsCubit = context.read<ProductsCubit>();

    for (final product in productsCubit.state.products) {
      if (product.productId == widget.productId) {
        return Future.value(product);
      }
    }

    final selectedProduct = productsCubit.state.selectedProduct;
    if (selectedProduct?.productId == widget.productId) {
      return Future.value(selectedProduct);
    }

    return productsCubit.getProductById(productId: widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: _productFuture,
      builder: (context, snapshot) {
        final productName = snapshot.data?.productName;
        final title = productName ?? 'Loading product...';

        return Text(
          snapshot.hasError ? 'Product unavailable' : title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        );
      },
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.addressType,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
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

String _formatCurrency(double value) {
  return '\$${value.toStringAsFixed(2)}';
}
