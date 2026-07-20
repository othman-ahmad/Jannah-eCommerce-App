import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:jannah/features/profile/data/address_model.dart';
import 'package:jannah/features/profile/presentation/addresses_screen.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_state.dart';
import 'package:jannah/features/profile/presentation/widgets/address_tile.dart';

class SelectDeliveryAddressScreen extends StatelessWidget {
  final Address? selectedAddress;

  const SelectDeliveryAddressScreen({super.key, this.selectedAddress});

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
          'Select Address',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                final isSelected =
                    address.addressId == selectedAddress?.addressId;

                return AddressTile(
                  address: address,
                  isEditable: false,
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.of(context).pop(address);
                  },
                  onEdit: () {},
                  onDelete: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }
}
