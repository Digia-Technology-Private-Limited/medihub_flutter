class AppConstants {
  static const String digiaHomepageSlotKey = 'digia_homepage_slot';
  static const String digiaPdpSlotKey = 'digia_pdp_slot';

  // Carousel images for homepage banner
  static const List<String> carouselImages = [
    'https://res.cloudinary.com/digia/image/upload/v1756296956/Postpartum-Nutrition-Tips-Tampa-Doula_jibapj.jpg',
    'https://res.cloudinary.com/digia/image/upload/v1756296956/Carbohydrates1_cvf9v5.jpg',
    'https://res.cloudinary.com/digia/image/upload/v1756296956/61cJAaD3OTL._UF1000_1000_QL80__nndtrc.jpg',
    'https://res.cloudinary.com/digia/image/upload/v1756296956/Zero-Pdp-1_bc1ab756-1c44-4704-9b26-4b266063f92d_xgst6q.webp',
  ];

  // Top Brands with logo images
  static const List<Map<String, String>> topBrands = [
    {
      'title': 'ProBulk',
      'handle': 'probulk',
      'imageUrl':
          'https://res.cloudinary.com/digia/image/upload/v1759613882/ProBulk_xgszyv.png',
    },
    {
      'title': 'MuscleMatrix',
      'handle': 'musclematrix',
      'imageUrl':
          'https://res.cloudinary.com/digia/image/upload/v1759613882/MuscleMatrix_p2iths.png',
    },
    {
      'title': 'MaxHydrate',
      'handle': 'maxhydrate',
      'imageUrl':
          'https://res.cloudinary.com/digia/image/upload/v1759613882/MaxHydrate_rmagcg.png',
    },
    {
      'title': 'BounceBack',
      'handle': 'bounceback',
      'imageUrl':
          'https://res.cloudinary.com/digia/image/upload/v1759613881/BounceBack_fhfc84.png',
    },
    {
      'title': 'EnduraPump',
      'handle': 'endurapump',
      'imageUrl':
          'https://res.cloudinary.com/digia/image/upload/v1759613881/EnduraPump_hw72yg.png',
    },
  ];

  // App Configuration
  static const String appName = 'MediHub';

  // Hardcoded values for Phase 1
  static const String expectedDeliveryDate = '10-14 Feb';
  static const String hkCashReward = '₹50';
  static const String sellerName = 'MediHub Pharmacy';
  static const double shippingCharge = 50.0;

  // HK Cash rewards (hardcoded for now)
  static const int hkCashRewardMultiplier = 6; // 6% of total

  // Seller Information (for PDP)
  static const String sellerAddress =
      'parasvnath arcdia, mg road, sector-14, gurugram(haryana) - 122001';

  // Offers (hardcoded for now)
  static const List<String> offers = [
    'Healthkart Ashwaganda 60 Cap @299',
  ];
}
