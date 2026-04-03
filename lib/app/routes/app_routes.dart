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

  static String productDetailsPath(String id) => '/product/$id';
}
