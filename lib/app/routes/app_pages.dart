import 'package:get/get.dart';
import 'package:inventory_management/app/core/features/auth/presentation/pages/login_page.dart';
import 'package:inventory_management/app/core/features/auth/presentation/pages/signup_page.dart';
import 'package:inventory_management/app/core/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:inventory_management/app/core/features/product/presentation/pages/product_list_page.dart';
import 'package:inventory_management/app/core/features/product/presentation/pages/add_product_page.dart';
import 'package:inventory_management/app/core/features/product/presentation/pages/edit_product_page.dart';
import 'package:inventory_management/app/core/features/product/presentation/pages/product_detail_page.dart';
import 'package:inventory_management/app/core/features/product/presentation/pages/low_stock_page.dart';
import 'package:inventory_management/app/core/features/category/presentation/pages/category_list_page.dart';
import 'package:inventory_management/app/core/features/category/presentation/pages/add_category_page.dart';
import 'package:inventory_management/app/core/features/transactions/presentation/pages/transaction_list_page.dart';
import 'package:inventory_management/app/core/features/transactions/presentation/pages/add_transaction_page.dart';
import 'package:inventory_management/app/core/features/report/presentation/pages/report_page.dart';

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
  static const String transactionList = '/transaction/list';
  static const String addTransaction = '/transaction/add';
  static const String lowStock = '/products/low-stock';
  static const String report = '/report';

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
        return EditProductPage(product: Get.arguments);
      },
    ),
    GetPage(name: categoryList, page: () => const CategoryListPage()),
    GetPage(name: addCategory, page: () => const AddCategoryPage()),
    GetPage(name: transactionList, page: () => const TransactionListPage()),
    GetPage(name: addTransaction, page: () => const AddTransactionPage()),
    GetPage(name: lowStock, page: () => const LowStockPage()),
    GetPage(name: report, page: () => const ReportPage()),
  ];
}
