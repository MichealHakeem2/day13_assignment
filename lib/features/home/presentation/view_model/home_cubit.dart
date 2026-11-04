import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/favorite/data/repository/favorite_repository.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';
import 'package:shopping_app/features/home/data/repo/repo/home_repo_interface.dart';
import 'package:shopping_app/features/home/presentation/view_model/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepoInterface homeRepo;
  final FavoriteRepository _favoriteRepository = FavoriteRepository.instance;

  int _skip = 0;
  final int _limit = 10;
  final List<ProductModel> _currentProducts = [];

  HomeCubit({required this.homeRepo}) : super(HomeState.initial());

  Future<void> getAllCategories() async {
    emit(state.copyWith(categoryState: HomeCategoryLoading()));

    try {
      final categories = await homeRepo.getAllCategories();
      emit(state.copyWith(categoryState: HomeCategorySuccess(categories)));
    } catch (e) {
      emit(state.copyWith(categoryState: HomeCategoryError(e.toString())));
    }
  }

  Future<void> getAllProducts({bool reset = false}) async {
    if (reset) {
      _skip = 0;
      _currentProducts.clear();
      emit(state.copyWith(
        productState: HomeProductLoading(),
        hasMore: true,
      ));
    }

    try {
      List<ProductModel> items;
      if (state.selectedCategory == 'All') {
        items = await homeRepo.getAllProducts(skip: _skip, limit: _limit);
      } else {
        items = await homeRepo.getProductsByCategory(
          state.selectedCategory,
          skip: _skip,
          limit: _limit,
        );
      }

      for (var p in items) {
        try {
          p.isFavorite = await _favoriteRepository.isFavorite(p.id);
        } catch (_) {}
      }

      _currentProducts.addAll(items);
      final hasMoreItems = items.length >= _limit;

      emit(state.copyWith(
        productState: HomeProductSuccess(List.from(_currentProducts)),
        hasMore: hasMoreItems,
      ));
    } catch (e) {
      emit(state.copyWith(productState: HomeProductError(e.toString())));
    }
  }

  void selectCategory(String category) {
    if (state.selectedCategory == category) return;
    emit(state.copyWith(selectedCategory: category));
    getAllProducts(reset: true);
  }

  Future<void> loadMoreProducts() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    _skip += _limit;

    try {
      List<ProductModel> items;
      if (state.selectedCategory == 'All') {
        items = await homeRepo.getAllProducts(skip: _skip, limit: _limit);
      } else {
        items = await homeRepo.getProductsByCategory(
          state.selectedCategory,
          skip: _skip,
          limit: _limit,
        );
      }

      for (var p in items) {
        p.isFavorite = await _favoriteRepository.isFavorite(p.id);
      }

      _currentProducts.addAll(items);
      final hasMoreItems = items.length >= _limit;

      emit(state.copyWith(
        productState: HomeProductSuccess(List.from(_currentProducts)),
        isLoadingMore: false,
        hasMore: hasMoreItems,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  void toggleFavorite(ProductModel product) async {
    final isFav = await _favoriteRepository.toggleFavorite(product);
    product.isFavorite = isFav;
    emit(state.copyWith(
      productState: HomeProductSuccess(List.from(_currentProducts)),
    ));
  }
}

