class CatalogApiService {
  Future<List<Map<String, dynamic>>> fetchProductsRaw() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      {
        'id': 'dash-plush',
        'name': 'Dash Plushie',
        'description': 'A soft and cuddly Dash plushie.',
        'price': 19.99,
        'imageUrl': 'assets/images/products/dash-plush.png',
        'category': 'Plushies',
      },
      {
        'id': 'dash-phone-case',
        'name': 'Dash Phone Case',
        'description':
            'Sleek and protective phone case with a gorgeous Dash pattern.',
        'price': 24.99,
        'imageUrl': 'assets/images/products/dash-phone-case.png',
        'category': 'Accessories',
      },
      {
        'id': 'dash-keyboard',
        'name': 'Dash Keyboard',
        'description': 'Mechanical keyboard with Dash-themed keycaps.',
        'price': 89.99,
        'imageUrl': 'assets/images/products/dash-keyboard.png',
        'category': 'Keyboards',
      },
      {
        'id': 'dash-hoodie',
        'name': 'Dash Hoodie',
        'description': 'Warm and cozy hoodie featuring Dash.',
        'price': 45.00,
        'imageUrl': 'assets/images/products/dash-hoodie.png',
        'category': 'Apparel',
      },
      {
        'id': 'dash-stickers',
        'name': 'Dash Stickers',
        'description': 'A pack of high-quality Dash stickers.',
        'price': 5.00,
        'imageUrl': 'assets/images/products/dash-stickers.png',
        'category': 'Stickers',
      },
      {
        'id': 'dash-mug',
        'name': 'Dash Mug',
        'description': 'Start your morning with Dash.',
        'price': 15.00,
        'imageUrl': 'assets/images/products/dash-mug.png',
        'category': 'Home',
      },
      {
        'id': 'dash-backpack',
        'name': 'Dash Backpack',
        'description': 'Spacious backpack for all your gear.',
        'price': 65.00,
        'imageUrl': 'assets/images/products/dash-backpack.png',
        'category': 'Apparel',
      },
    ];
  }
}
