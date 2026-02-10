import 'product.dart';

class CartLine {
  final String id;
  final int quantity;
  final Variant merchandise;
  final CartLineCost cost;
  final String productTitle;
  final String productHandle;

  CartLine({
    required this.id,
    required this.quantity,
    required this.merchandise,
    required this.cost,
    required this.productTitle,
    required this.productHandle,
  });

  factory CartLine.fromJson(Map<String, dynamic> json) {
    final merchandiseJson = json['merchandise'] as Map<String, dynamic>? ?? {};
    final productJson =
        merchandiseJson['product'] as Map<String, dynamic>? ?? {};

    return CartLine(
      id: json['id'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      merchandise: Variant.fromJson(merchandiseJson),
      cost: CartLineCost.fromJson(json['cost'] as Map<String, dynamic>? ?? {}),
      productTitle: productJson['title'] as String? ?? '',
      productHandle: productJson['handle'] as String? ?? '',
    );
  }
}

class CartLineCost {
  final PriceInfo amountPerQuantity;
  final PriceInfo totalAmount;
  final PriceInfo? compareAtAmountPerQuantity;

  CartLineCost({
    required this.amountPerQuantity,
    required this.totalAmount,
    this.compareAtAmountPerQuantity,
  });

  factory CartLineCost.fromJson(Map<String, dynamic> json) {
    return CartLineCost(
      amountPerQuantity: PriceInfo.fromJson(
          json['amountPerQuantity'] as Map<String, dynamic>? ?? {}),
      totalAmount: PriceInfo.fromJson(
          json['totalAmount'] as Map<String, dynamic>? ?? {}),
      compareAtAmountPerQuantity: json['compareAtAmountPerQuantity'] != null
          ? PriceInfo.fromJson(
              json['compareAtAmountPerQuantity'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CartCost {
  final PriceInfo? subtotalAmount;
  final PriceInfo? totalAmount;

  CartCost({
    this.subtotalAmount,
    this.totalAmount,
  });

  factory CartCost.fromJson(Map<String, dynamic> json) {
    return CartCost(
      subtotalAmount: json['subtotalAmount'] != null
          ? PriceInfo.fromJson(json['subtotalAmount'] as Map<String, dynamic>)
          : null,
      totalAmount: json['totalAmount'] != null
          ? PriceInfo.fromJson(json['totalAmount'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DiscountCode {
  final String code;
  final bool applicable;

  DiscountCode({
    required this.code,
    required this.applicable,
  });

  factory DiscountCode.fromJson(Map<String, dynamic> json) {
    return DiscountCode(
      code: json['code'] as String? ?? '',
      applicable: json['applicable'] as bool? ?? false,
    );
  }
}

class DiscountAllocation {
  final PriceInfo discountedAmount;

  DiscountAllocation({
    required this.discountedAmount,
  });

  factory DiscountAllocation.fromJson(Map<String, dynamic> json) {
    return DiscountAllocation(
      discountedAmount: PriceInfo.fromJson(
          json['discountedAmount'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Cart {
  final String id;
  final String checkoutUrl;
  final int totalQuantity;
  final List<CartLine> lines;
  final CartCost? cost;
  final List<DiscountCode>? discountCodes;
  final List<DiscountAllocation>? discountAllocations;

  Cart({
    required this.id,
    required this.checkoutUrl,
    required this.totalQuantity,
    this.lines = const [],
    this.cost,
    this.discountCodes,
    this.discountAllocations,
  });

  double get totalSavings {
    double savings = 0.0;
    for (var line in lines) {
      if (line.cost.compareAtAmountPerQuantity != null) {
        final compareAt = line.cost.compareAtAmountPerQuantity!.amountAsDouble;
        final current = line.cost.amountPerQuantity.amountAsDouble;
        savings += (compareAt - current) * line.quantity;
      }
    }
    return savings;
  }

  double get totalDiscount {
    if (discountAllocations == null) return 0.0;
    return discountAllocations!
        .fold(0.0, (sum, alloc) => sum + alloc.discountedAmount.amountAsDouble);
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as String? ?? '',
      checkoutUrl: json['checkoutUrl'] as String? ?? '',
      totalQuantity: json['totalQuantity'] as int? ?? 0,
      lines: json['lines'] != null
          ? ((json['lines'] as Map<String, dynamic>)['edges'] as List)
              .map((e) => CartLine.fromJson(
                  (e as Map<String, dynamic>)['node'] as Map<String, dynamic>))
              .toList()
          : [],
      cost: json['cost'] != null
          ? CartCost.fromJson(json['cost'] as Map<String, dynamic>)
          : null,
      discountCodes: json['discountCodes'] != null
          ? (json['discountCodes'] as List)
              .map((e) => DiscountCode.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      discountAllocations: json['discountAllocations'] != null
          ? (json['discountAllocations'] as List)
              .map(
                  (e) => DiscountAllocation.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
