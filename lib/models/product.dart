class ProductImage {
  final String id;
  final String url;
  final String? altText;

  ProductImage({
    required this.id,
    required this.url,
    this.altText,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      altText: json['altText'] as String?,
    );
  }
}

class Variant {
  final String id;
  final String title;
  final bool? availableForSale;
  final String? sku;
  final PriceInfo price;
  final PriceInfo? compareAtPrice;
  final String? imageUrl;
  final List<SelectedOption>? selectedOptions;

  Variant({
    required this.id,
    required this.title,
    this.availableForSale,
    this.sku,
    required this.price,
    this.compareAtPrice,
    this.imageUrl,
    this.selectedOptions,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      availableForSale: json['availableForSale'] as bool?,
      sku: json['sku'] as String?,
      price: PriceInfo.fromJson(json['price'] as Map<String, dynamic>? ?? {}),
      compareAtPrice: json['compareAtPrice'] != null
          ? PriceInfo.fromJson(json['compareAtPrice'] as Map<String, dynamic>)
          : null,
      imageUrl: json['image'] != null
          ? (json['image'] as Map<String, dynamic>)['url'] as String?
          : null,
      selectedOptions: json['selectedOptions'] != null
          ? (json['selectedOptions'] as List)
              .map((e) => SelectedOption.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class SelectedOption {
  final String name;
  final String value;

  SelectedOption({
    required this.name,
    required this.value,
  });

  factory SelectedOption.fromJson(Map<String, dynamic> json) {
    return SelectedOption(
      name: json['name'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }
}

class PriceInfo {
  final String amount;
  final String currencyCode;

  PriceInfo({
    required this.amount,
    required this.currencyCode,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      amount: json['amount'] as String? ?? '0',
      currencyCode: json['currencyCode'] as String? ?? 'INR',
    );
  }

  double get amountAsDouble => double.tryParse(amount) ?? 0.0;
}

class PriceRange {
  final PriceInfo minVariantPrice;
  final PriceInfo maxVariantPrice;

  PriceRange({
    required this.minVariantPrice,
    required this.maxVariantPrice,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      minVariantPrice: PriceInfo.fromJson(
          json['minVariantPrice'] as Map<String, dynamic>? ?? {}),
      maxVariantPrice: PriceInfo.fromJson(
          json['maxVariantPrice'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Metafield {
  final String key;
  final String namespace;
  final String value;
  final String type;

  Metafield({
    required this.key,
    required this.namespace,
    required this.value,
    required this.type,
  });

  factory Metafield.fromJson(Map<String, dynamic> json) {
    return Metafield(
      key: json['key'] as String? ?? '',
      namespace: json['namespace'] as String? ?? '',
      value: json['value'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }
}

class Product {
  final String id;
  final String title;
  final String handle;
  final String? description;
  final String? descriptionHtml;
  final String? vendor;
  final List<String>? tags;
  final String? featuredImageUrl;
  final List<ProductImage> images;
  final List<Variant> variants;
  final PriceRange priceRange;
  final PriceRange? compareAtPriceRange;
  final bool? availableForSale;
  final List<Metafield> metafields;

  Product({
    required this.id,
    required this.title,
    required this.handle,
    this.description,
    this.descriptionHtml,
    this.vendor,
    this.tags,
    this.featuredImageUrl,
    this.images = const [],
    this.variants = const [],
    required this.priceRange,
    this.compareAtPriceRange,
    this.availableForSale,
    this.metafields = const [],
  });

  double? get rating {
    final ratingMeta = metafields.firstWhere(
      (m) => m.namespace == 'reviews' && m.key == 'rating',
      orElse: () => Metafield(key: '', namespace: '', value: '0', type: ''),
    );
    return double.tryParse(ratingMeta.value);
  }

  int? get reviewCount {
    final countMeta = metafields.firstWhere(
      (m) => m.namespace == 'reviews' && m.key == 'rating_count',
      orElse: () => Metafield(key: '', namespace: '', value: '0', type: ''),
    );
    return int.tryParse(countMeta.value);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      description: json['description'] as String?,
      descriptionHtml: json['descriptionHtml'] as String?,
      vendor: json['vendor'] as String?,
      tags:
          json['tags'] != null ? List<String>.from(json['tags'] as List) : null,
      featuredImageUrl: json['featuredImage'] != null
          ? (json['featuredImage'] as Map<String, dynamic>)['url'] as String?
          : null,
      images: json['images'] != null
          ? (json['images']['nodes'] as List? ??
                  json['images']['edges'] as List? ??
                  [])
              .map((e) {
                final node = e is Map && e.containsKey('node') ? e['node'] : e;
                return ProductImage.fromJson(node as Map<String, dynamic>);
              })
              .toList()
              .cast<ProductImage>()
          : [],
      variants: json['variants'] != null
          ? (json['variants']['nodes'] as List? ??
                  json['variants']['edges'] as List? ??
                  [])
              .map((e) {
                final node = e is Map && e.containsKey('node') ? e['node'] : e;
                return Variant.fromJson(node as Map<String, dynamic>);
              })
              .toList()
              .cast<Variant>()
          : [],
      priceRange: PriceRange.fromJson(
          json['priceRange'] as Map<String, dynamic>? ?? {}),
      compareAtPriceRange: json['compareAtPriceRange'] != null
          ? PriceRange.fromJson(
              json['compareAtPriceRange'] as Map<String, dynamic>)
          : null,
      availableForSale: json['availableForSale'] as bool?,
      metafields: json['metafields'] != null
          ? (json['metafields'] as List)
              .where((e) => e != null)
              .map((e) => Metafield.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
