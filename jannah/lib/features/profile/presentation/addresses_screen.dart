import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/core/custom_widgets/primary_button.dart';
import 'package:jannah/core/custom_widgets/secondry_button.dart';
import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_state.dart';
import 'package:jannah/features/profile/presentation/location_picker_screen.dart';
import 'package:latlong2/latlong.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  Future<void> _showAddressSheet(
    BuildContext context, {
    Address? address,
  }) async {
    final cubit = context.read<ProfileCubit>();
    final typeController = TextEditingController(
      text: address?.addressType ?? '',
    );
    final lineController = TextEditingController(
      text: address?.addressLine ?? '',
    );
    final cityController = TextEditingController(text: address?.city ?? '');
    final stateController = TextEditingController(text: address?.state ?? '');
    final countryController = TextEditingController(
      text: address?.country ?? '',
    );
    final postalCodeController = TextEditingController(
      text: address?.postalCode ?? '',
    );
    final formKey = GlobalKey<FormState>();
    // Latitude/longitude are only ever set via the map picker now — no
    // free-text entry — so they're plain state rather than controllers.
    double? latitude = address?.latitude;
    double? longitude = address?.longitude;
    var showLocationError = false;
    var isDefault = address?.isDefault ?? false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              Future<void> pickOnMap() async {
                final result = await Navigator.of(context).push<PickedLocation>(
                  MaterialPageRoute(
                    builder: (_) => LocationPickerScreen(
                      initialLatLng: (latitude != null && longitude != null)
                          ? LatLng(latitude!, longitude!)
                          : null,
                    ),
                  ),
                );

                if (result == null) return;

                setSheetState(() {
                  latitude = result.latitude;
                  longitude = result.longitude;
                  showLocationError = false;

                  // Only overwrite fields the user hasn't already filled in,
                  // so we don't clobber manual edits with a reverse-geocode guess.
                  // if (lineController.text.trim().isEmpty &&
                  //     result.addressLine.isNotEmpty) {
                  lineController.text = result.addressLine;
                  // }
                  // if (cityController.text.trim().isEmpty &&
                  //     result.city.isNotEmpty) {
                  cityController.text = result.city;
                  // }
                  // if (stateController.text.trim().isEmpty &&
                  //     result.state.isNotEmpty) {
                  stateController.text = result.state;
                  // }
                  // if (countryController.text.trim().isEmpty &&
                  //     result.country.isNotEmpty) {
                  countryController.text = result.country;
                  // }
                  // if (postalCodeController.text.trim().isEmpty &&
                  //     result.postalCode.isNotEmpty) {
                  postalCodeController.text = result.postalCode;
                  // }
                });
              }

              return BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 20,
                      bottom:
                          MediaQuery.of(sheetContext).viewInsets.bottom + 20,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            address == null ? 'Add Address' : 'Edit Address',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _LocationPreview(
                            latitude: latitude,
                            longitude: longitude,
                            onTap: pickOnMap,
                            showError: showLocationError,
                          ),
                          const SizedBox(height: 16),
                          _AddressTextField(
                            controller: typeController,
                            label: 'Address Type',
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 12),
                          _AddressTextField(
                            controller: lineController,
                            label: 'Address Line',
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _AddressTextField(
                                  controller: cityController,
                                  label: 'City',
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _AddressTextField(
                                  controller: stateController,
                                  label: 'State',
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _AddressTextField(
                                  controller: countryController,
                                  label: 'Country',
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _AddressTextField(
                                  controller: postalCodeController,
                                  label: 'Postal Code',
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 30,
                            width: double.infinity,
                            child: SecondryButton(
                              onPressed: () {
                                setSheetState(() {
                                  isDefault = !isDefault;
                                });
                              },
                              text: isDefault
                                  ? 'Default address ✓'
                                  : 'Set as default address',
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 54,
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: state.isAddressSaving
                                  ? null
                                  : () async {
                                      final isFormValid =
                                          formKey.currentState?.validate() ??
                                          false;
                                      final hasLocation =
                                          latitude != null && longitude != null;

                                      if (!hasLocation) {
                                        setSheetState(() {
                                          showLocationError = true;
                                        });
                                      }

                                      if (!isFormValid || !hasLocation) {
                                        return;
                                      }

                                      final addressToSave = Address(
                                        addressId: address?.addressId ?? 0,
                                        addressType: typeController.text.trim(),
                                        addressLine: lineController.text.trim(),
                                        city: cityController.text.trim(),
                                        state: stateController.text.trim(),
                                        country: countryController.text.trim(),
                                        postalCode: postalCodeController.text
                                            .trim(),
                                        latitude: latitude!,
                                        longitude: longitude!,
                                        isDefault: isDefault,
                                      );

                                      await cubit.saveUserAddress(
                                        addressToSave,
                                      );

                                      if (sheetContext.mounted) {
                                        Navigator.of(sheetContext).pop();
                                      }
                                    },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: state.isAddressSaving
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, Address address) async {
    final cubit = context.read<ProfileCubit>();
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: Text('Remove ${address.addressType} from saved addresses?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await cubit.removeAddress(address.addressId);
    }
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Addresses',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressSheet(context),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.addressesStatus == ProfileStatus.loading &&
              state.addresses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.addressesStatus == ProfileStatus.failure &&
              state.addresses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.addressesErrorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          if (state.addresses.isEmpty) {
            return const Center(
              child: Text(
                'No saved addresses yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ProfileCubit>().loadAddresses(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final address = state.addresses[index];

                return _AddressTile(
                  address: address,
                  onEdit: () => _showAddressSheet(context, address: address),
                  onDelete: () => _confirmDelete(context, address),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressTile({
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        address.addressType,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  address.addressLine,
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${address.city}, ${address.state}, ${address.country}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                if (address.postalCode.isNotEmpty)
                  Text(
                    address.postalCode,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit address',
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete address',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputAction? textInputAction;

  const _AddressTextField({
    required this.controller,
    required this.label,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

/// 150px container that shows the currently selected map location, or a
/// prompt to pick one. Tapping anywhere on it opens the map picker.
class _LocationPreview extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final VoidCallback onTap;
  final bool showError;

  const _LocationPreview({
    required this.latitude,
    required this.longitude,
    required this.onTap,
    required this.showError,
  });

  bool get _hasLocation => latitude != null && longitude != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: showError ? Colors.red : Colors.grey.shade400,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: _hasLocation
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      // The mini map is purely a preview — all gestures on
                      // it are ignored so the InkWell above handles taps
                      // and opens the full picker instead.
                      IgnorePointer(
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(latitude!, longitude!),
                            initialZoom: 15,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.none,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.jannah.app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(latitude!, longitude!),
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.topCenter,
                                  child: const Icon(
                                    Icons.location_on,
                                    size: 36,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          color: Colors.black.withValues(alpha: 0.55),
                          child: const Text(
                            'Tap to change location',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 28,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pick location on map',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to open the map and drop a pin',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Please pick a location on the map',
              style: TextStyle(color: Colors.red.shade700, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
