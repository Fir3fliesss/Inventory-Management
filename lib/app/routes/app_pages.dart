import 'package:get/get.dart';
import 'package:inventory_management/app/core/features/auth/presentation/pages/login_page.dart';
import 'package:inventory_management/app/core/features/auth/presentation/pages/signup_page.dart';
import 'package:inventory_management/app/core/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:inventory_management/app/core/features/product/presentation/pages/product_list_page.dart';
import 'package:inventory_management/app/core/features/product/presentation/pages/add_product_page.dart';
import 'package:inventory_management/app/core/features/product/presentation/pages/edit_product_page.dart';
import 'package:inventory_management/app/core/features/product/presentation/pages/product_detail_page.dart';
import 'package:inventory_management/app/core/features/category/presentation/pages/category_list_page.dart';
import 'package:inventory_management/app/core/features/category/presentation/pages/add_category_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/dashboard';
  static const String productList = '/products';
  static const String productDetail = '/products/detail/:productId';
  static const String addProduct = '/products/add';
  static const String editProduct = '/products/edit/:productId';
  static const String categoryList = '/categories';
  static const String addCategory = '/categories/add';

  static List<GetPage> routes = [
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: signup, page: () => const SignupPage()),
    GetPage(name: home, page: () => const DashboardPage()),
    GetPage(name: productList, page: () => const ProductListPage()),
    GetPage(
        name: productDetail,
        page: () => ProductDetailPage(
              productId: Get.arguments,
            )),
    GetPage(name: addProduct, page: () => const AddProductPage()),
    GetPage(
      name: editProduct,
      page: () {
        // We're only using Get.arguments for the product data
        return EditProductPage(product: Get.arguments);
      },
    ),
    GetPage(name: categoryList, page: () => const CategoryListPage()),
    GetPage(name: addCategory, page: () => const AddCategoryPage()),
  ];
}
