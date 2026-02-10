import 'package:flutter/material.dart';

/// Address model for in-memory storage
class Address {
  final String id;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String pincode;
  final AddressType type;

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.pincode,
    this.type = AddressType.home,
  });

  String get fullAddress =>
      '$addressLine1${addressLine2.isNotEmpty ? ', $addressLine2' : ''}, $city - $pincode';

  String get shortLabel => '$addressLine1, $city...';
}

enum AddressType { home, work, other }

class AddressProvider extends ChangeNotifier {
  // Default addresses for demo
  List<Address> _addresses = [
    Address(
      id: '1',
      name: 'Bruce Wayne',
      phone: '555-0123',
      addressLine1: 'Wayne Manor',
      addressLine2: '1007 Mountain Drive',
      city: 'Gotham City',
      pincode: '12345',
      type: AddressType.home,
    ),
    Address(
      id: '2',
      name: 'Clark Kent',
      phone: '555-0456',
      addressLine1: 'Apartment 344',
      addressLine2: '344 Clinton Street',
      city: 'Metropolis',
      pincode: '54321',
      type: AddressType.home,
    ),
    Address(
      id: '3',
      name: 'Diana Prince',
      phone: '555-0789',
      addressLine1: 'Themyscira Embassy',
      addressLine2: 'Gateway City',
      city: 'Washington D.C.',
      pincode: '20001',
      type: AddressType.work,
    ),
    Address(
      id: '4',
      name: 'Tony Stark',
      phone: '555-9999',
      addressLine1: 'Stark Tower',
      addressLine2: '200 Park Avenue',
      city: 'New York City',
      pincode: '10166',
      type: AddressType.work,
    ),
  ];

  String? _selectedAddressId = '1';

  List<Address> get addresses => _addresses;

  Address? get selectedAddress {
    try {
      return _addresses.firstWhere((a) => a.id == _selectedAddressId);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  void selectAddress(String addressId) {
    _selectedAddressId = addressId;
    notifyListeners();
  }

  void addAddress(Address address) {
    _addresses = [..._addresses, address];
    notifyListeners();
  }

  void removeAddress(String addressId) {
    _addresses = _addresses.where((a) => a.id != addressId).toList();
    if (_selectedAddressId == addressId && _addresses.isNotEmpty) {
      _selectedAddressId = _addresses.first.id;
    }
    notifyListeners();
  }

  String generateNewId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
