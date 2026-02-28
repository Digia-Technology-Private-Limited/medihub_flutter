import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/design_system/design_system.dart';
import '../../core/services/analytics_service.dart';
import '../../providers/products_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AnalyticsService _analytics = AnalyticsService();
  final _searchController = TextEditingController();
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _analytics.trackSearchResultsViewed(
      query: '',
      resultCount: 0,
    );
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    if (productsProvider.allProducts.isEmpty) {
      productsProvider.fetchAllProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() => _hasSearched = false);
      return;
    }
    _analytics.trackSearchInitiated(query);
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    productsProvider.searchProducts(query);
    _analytics.trackSearchResultsViewed(
      query: query,
      resultCount: productsProvider.searchResults.length,
    );
    setState(() => _hasSearched = true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search for medicine & health products',
              hintStyle: AppTextStyles.bodyDefault(
                color: colors.contentSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.close, color: colors.contentSecondary),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              filled: false,
            ),
            onSubmitted: _performSearch,
            onChanged: (value) => setState(() {}),
          ),
        ),
      ),
      body: _buildBody(colors),
    );
  }

  Widget _buildBody(AppColorScheme colors) {
    return Consumer<ProductsProvider>(
      builder: (context, productsProvider, _) {
        if (productsProvider.isLoading) {
          return AppLoading.page();
        }

        if (!_hasSearched) {
          return _buildSuggestions(colors);
        }

        final results = productsProvider.searchResults;

        if (results.isEmpty) {
          return AppEmptyStates.searchResults();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProductCardHorizontal(product: results[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildSuggestions(AppColorScheme colors) {
    final suggestions = [
      'Vitamins',
      'Pain Relief',
      'Skin Care',
      'Cold & Flu',
      'Diabetes Care',
      'Baby Care',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches',
            style: AppTextStyles.headingMedium(
              color: colors.contentPrimary,
            ).copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              return GestureDetector(
                onTap: () {
                  _analytics.trackSearchSuggestionClicked(
                      suggestion: suggestion);
                  _searchController.text = suggestion;
                  _performSearch(suggestion);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(
                    suggestion,
                    style: AppTextStyles.roboto12Medium(
                      color: colors.contentPrimary,
                    ).copyWith(fontSize: 13),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
