class AppRoutes {
  const AppRoutes._();

  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const home = '/';
  static const search = '/search';
  static const cart = '/cart';
  static const orders = '/orders';
  static const profile = '/profile';
  static const productDetails = '/product/:id';
  static const checkout = '/checkout';
  static const orderConfirmation = '/checkout/confirmation';
  static const addresses = '/addresses';
  static const addressAdd = '/addresses/add';
  static const notifications = '/notifications';

  // Admin
  static const admin = '/admin';
  static const adminProducts = '/admin/products';
  static const adminProductAdd = '/admin/products/add';
  static const adminProductEdit = '/admin/products/edit/:id';
  static const adminCategories = '/admin/categories';
  static const adminCategoryAdd = '/admin/categories/add';
  static const adminCategoryEdit = '/admin/categories/edit/:id';
  static const adminUsers = '/admin/users';

  static String productDetailsPath(String id) => '/product/$id';
  static String adminProductEditPath(String id) => '/admin/products/edit/$id';
  static String adminCategoryEditPath(String id) =>
      '/admin/categories/edit/$id';
}
