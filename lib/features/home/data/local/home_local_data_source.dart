import 'package:shopping_app/core/database/sqflite_helper.dart';
import 'package:shopping_app/features/home/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class HomeLocalDataSource {
  final SqfliteHelper dbHelper;

  HomeLocalDataSource({SqfliteHelper? dbHelper})
      : dbHelper = dbHelper ?? SqfliteHelper.instance;

  Future<void> cacheProducts(List<ProductModel> products) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    for (var product in products) {
      batch.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<ProductModel>> getCachedProducts() async {
    final db = await dbHelper.database;
    final results = await db.query('products');

    return results.map((map) => ProductModel.fromMap(map)).toList();
  }

  Future<ProductModel?> getCachedProductById(int id) async {
    final db = await dbHelper.database;
    final results = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return ProductModel.fromMap(results.first);
    }
    return null;
  }

  Future<List<ProductModel>> getCachedProductsByCategory(String category) async {
    final db = await dbHelper.database;
    final results = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
    return results.map((map) => ProductModel.fromMap(map)).toList();
  }

  Future<List<ProductModel>> searchCachedProducts(String query) async {
    final db = await dbHelper.database;
    final results = await db.query(
      'products',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return results.map((map) => ProductModel.fromMap(map)).toList();
  }

  Future<void> toggleFavorite(int productId, bool isFavorite) async {
    final db = await dbHelper.database;
    await db.update(
      'products',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }
}
