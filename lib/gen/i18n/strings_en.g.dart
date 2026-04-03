///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAppEn app = TranslationsAppEn._(_root);
	late final TranslationsGeneralEn general = TranslationsGeneralEn._(_root);
	late final TranslationsOnboardingEn onboarding = TranslationsOnboardingEn._(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn._(_root);
	late final TranslationsNavEn nav = TranslationsNavEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsSearchEn search = TranslationsSearchEn._(_root);
	late final TranslationsProductEn product = TranslationsProductEn._(_root);
	late final TranslationsCartEn cart = TranslationsCartEn._(_root);
	late final TranslationsCheckoutEn checkout = TranslationsCheckoutEn._(_root);
	late final TranslationsOrdersEn orders = TranslationsOrdersEn._(_root);
	late final TranslationsProfileEn profile = TranslationsProfileEn._(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Harvest'
	String get name => 'Harvest';

	/// en: 'Fresh from the farm. Direct to your community.'
	String get tagline => 'Fresh from the farm. Direct to your community.';
}

// Path: general
class TranslationsGeneralEn {
	TranslationsGeneralEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Something went wrong'
	String get error => 'Something went wrong';

	/// en: 'No results found'
	String get noResults => 'No results found';

	/// en: 'See all'
	String get seeAll => 'See all';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Skip'
	String get skip => 'Skip';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'or'
	String get or => 'or';
}

// Path: onboarding
class TranslationsOnboardingEn {
	TranslationsOnboardingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsOnboardingStep1En step1 = TranslationsOnboardingStep1En._(_root);
	late final TranslationsOnboardingStep2En step2 = TranslationsOnboardingStep2En._(_root);
	late final TranslationsOnboardingStep3En step3 = TranslationsOnboardingStep3En._(_root);

	/// en: 'Get Started'
	String get getStarted => 'Get Started';
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sign In'
	String get signIn => 'Sign In';

	/// en: 'Sign Up'
	String get signUp => 'Sign Up';

	/// en: 'Sign Out'
	String get signOut => 'Sign Out';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Full Name'
	String get name => 'Full Name';

	/// en: 'Enter your email'
	String get emailHint => 'Enter your email';

	/// en: 'Enter your password'
	String get passwordHint => 'Enter your password';

	/// en: 'Enter your full name'
	String get nameHint => 'Enter your full name';

	/// en: 'Forgot password?'
	String get forgotPassword => 'Forgot password?';

	/// en: 'Don't have an account?'
	String get noAccount => 'Don\'t have an account?';

	/// en: 'Already have an account?'
	String get hasAccount => 'Already have an account?';

	/// en: 'Sign in with Google'
	String get signInWithGoogle => 'Sign in with Google';

	/// en: 'Welcome back!'
	String get welcomeBack => 'Welcome back!';

	/// en: 'Create your account'
	String get createAccount => 'Create your account';

	/// en: 'Sign in to get fresh produce delivered to your door.'
	String get signInSubtitle => 'Sign in to get fresh produce delivered to your door.';

	/// en: 'Join Harvest and start eating fresh today.'
	String get signUpSubtitle => 'Join Harvest and start eating fresh today.';
}

// Path: nav
class TranslationsNavEn {
	TranslationsNavEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Cart'
	String get cart => 'Cart';

	/// en: 'Orders'
	String get orders => 'Orders';

	/// en: 'Profile'
	String get profile => 'Profile';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Hello, $name!'
	String greeting({required Object name}) => 'Hello, ${name}!';

	/// en: 'What fresh produce do you need today?'
	String get subtitle => 'What fresh produce do you need today?';

	/// en: 'Categories'
	String get categories => 'Categories';

	/// en: 'Featured Products'
	String get featured => 'Featured Products';

	/// en: 'Popular Now'
	String get popular => 'Popular Now';

	/// en: 'Organic'
	String get organic => 'Organic';

	/// en: 'All Products'
	String get allProducts => 'All Products';
}

// Path: search
class TranslationsSearchEn {
	TranslationsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search'
	String get title => 'Search';

	/// en: 'Search fruits, vegetables...'
	String get hint => 'Search fruits, vegetables...';

	/// en: 'Filters'
	String get filters => 'Filters';

	/// en: 'Sort by'
	String get sortBy => 'Sort by';

	/// en: 'Price Range'
	String get priceRange => 'Price Range';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Organic only'
	String get organicOnly => 'Organic only';

	/// en: 'Apply Filters'
	String get applyFilters => 'Apply Filters';

	/// en: 'Clear Filters'
	String get clearFilters => 'Clear Filters';

	/// en: 'Results for "$query"'
	String resultsFor({required Object query}) => 'Results for "${query}"';
}

// Path: product
class TranslationsProductEn {
	TranslationsProductEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add to Cart'
	String get addToCart => 'Add to Cart';

	/// en: 'Added to cart!'
	String get added => 'Added to cart!';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Nutrition Facts'
	String get nutritionFacts => 'Nutrition Facts';

	/// en: 'Farm'
	String get farm => 'Farm';

	/// en: 'In Stock'
	String get inStock => 'In Stock';

	/// en: 'Out of Stock'
	String get outOfStock => 'Out of Stock';

	/// en: 'per $unit'
	String perUnit({required Object unit}) => 'per ${unit}';

	/// en: 'Organic'
	String get organic => 'Organic';

	/// en: 'Calories'
	String get calories => 'Calories';

	/// en: 'Protein'
	String get protein => 'Protein';

	/// en: 'Fiber'
	String get fiber => 'Fiber';

	/// en: 'Vitamins'
	String get vitamins => 'Vitamins';
}

// Path: cart
class TranslationsCartEn {
	TranslationsCartEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cart'
	String get title => 'Cart';

	/// en: 'Your cart is empty'
	String get empty => 'Your cart is empty';

	/// en: 'Start adding fresh products to your cart!'
	String get emptySubtitle => 'Start adding fresh products to your cart!';

	/// en: 'Browse Products'
	String get browseProducts => 'Browse Products';

	/// en: 'Subtotal'
	String get subtotal => 'Subtotal';

	/// en: 'Delivery Fee'
	String get deliveryFee => 'Delivery Fee';

	/// en: 'Total'
	String get total => 'Total';

	/// en: 'Free'
	String get free => 'Free';

	/// en: 'Proceed to Checkout'
	String get checkout => 'Proceed to Checkout';

	/// en: '$count item(s)'
	String itemCount({required Object count}) => '${count} item(s)';

	/// en: 'Remove item?'
	String get removeItem => 'Remove item?';
}

// Path: checkout
class TranslationsCheckoutEn {
	TranslationsCheckoutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Checkout'
	String get title => 'Checkout';

	/// en: 'Delivery Address'
	String get deliveryAddress => 'Delivery Address';

	/// en: 'Street Address'
	String get street => 'Street Address';

	/// en: 'City'
	String get city => 'City';

	/// en: 'ZIP Code'
	String get zipCode => 'ZIP Code';

	/// en: 'Payment Method'
	String get paymentMethod => 'Payment Method';

	/// en: 'Credit Card'
	String get creditCard => 'Credit Card';

	/// en: 'Apple Pay'
	String get applePay => 'Apple Pay';

	/// en: 'Google Pay'
	String get googlePay => 'Google Pay';

	/// en: 'Order Summary'
	String get orderSummary => 'Order Summary';

	/// en: 'Place Order'
	String get placeOrder => 'Place Order';

	late final TranslationsCheckoutConfirmationEn confirmation = TranslationsCheckoutConfirmationEn._(_root);
}

// Path: orders
class TranslationsOrdersEn {
	TranslationsOrdersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Orders'
	String get title => 'My Orders';

	/// en: 'No orders yet'
	String get empty => 'No orders yet';

	/// en: 'Your order history will appear here.'
	String get emptySubtitle => 'Your order history will appear here.';

	late final TranslationsOrdersStatusEn status = TranslationsOrdersStatusEn._(_root);

	/// en: 'Order #$number'
	String orderNumber({required Object number}) => 'Order #${number}';

	/// en: '$count item(s)'
	String items({required Object count}) => '${count} item(s)';

	/// en: 'Placed on $date'
	String placedOn({required Object date}) => 'Placed on ${date}';
}

// Path: profile
class TranslationsProfileEn {
	TranslationsProfileEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Profile'
	String get title => 'Profile';

	/// en: 'Edit Profile'
	String get editProfile => 'Edit Profile';

	/// en: 'My Orders'
	String get myOrders => 'My Orders';

	/// en: 'Delivery Addresses'
	String get deliveryAddresses => 'Delivery Addresses';

	/// en: 'Payment Methods'
	String get paymentMethods => 'Payment Methods';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Help Center'
	String get helpCenter => 'Help Center';

	/// en: 'About Harvest'
	String get about => 'About Harvest';

	/// en: 'Version $version'
	String version({required Object version}) => 'Version ${version}';
}

// Path: onboarding.step1
class TranslationsOnboardingStep1En {
	TranslationsOnboardingStep1En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Place Your Order'
	String get title => 'Place Your Order';

	/// en: 'Browse fresh produce from local farms and add your favorites to the cart.'
	String get description => 'Browse fresh produce from local farms and add your favorites to the cart.';
}

// Path: onboarding.step2
class TranslationsOnboardingStep2En {
	TranslationsOnboardingStep2En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Farmers Harvest'
	String get title => 'Farmers Harvest';

	/// en: 'Your order is sent to local farmers who harvest fresh produce just for you.'
	String get description => 'Your order is sent to local farmers who harvest fresh produce just for you.';
}

// Path: onboarding.step3
class TranslationsOnboardingStep3En {
	TranslationsOnboardingStep3En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Direct to You'
	String get title => 'Direct to You';

	/// en: 'Get truly fresh food delivered directly from the farm to your doorstep.'
	String get description => 'Get truly fresh food delivered directly from the farm to your doorstep.';
}

// Path: checkout.confirmation
class TranslationsCheckoutConfirmationEn {
	TranslationsCheckoutConfirmationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Order Confirmed!'
	String get title => 'Order Confirmed!';

	/// en: 'Your order has been placed successfully.'
	String get subtitle => 'Your order has been placed successfully.';

	/// en: 'Local farmers are now preparing your fresh produce. You'll receive updates on your order status.'
	String get description => 'Local farmers are now preparing your fresh produce. You\'ll receive updates on your order status.';

	/// en: 'Order #$number'
	String orderNumber({required Object number}) => 'Order #${number}';

	/// en: 'Back to Home'
	String get backToHome => 'Back to Home';

	/// en: 'View My Orders'
	String get viewOrders => 'View My Orders';
}

// Path: orders.status
class TranslationsOrdersStatusEn {
	TranslationsOrdersStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pending'
	String get pending => 'Pending';

	/// en: 'Confirmed'
	String get confirmed => 'Confirmed';

	/// en: 'Harvesting'
	String get harvesting => 'Harvesting';

	/// en: 'On the way'
	String get delivering => 'On the way';

	/// en: 'Delivered'
	String get delivered => 'Delivered';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Harvest',
			'app.tagline' => 'Fresh from the farm. Direct to your community.',
			'general.retry' => 'Retry',
			'general.cancel' => 'Cancel',
			'general.save' => 'Save',
			'general.delete' => 'Delete',
			'general.confirm' => 'Confirm',
			'general.loading' => 'Loading...',
			'general.error' => 'Something went wrong',
			'general.noResults' => 'No results found',
			'general.seeAll' => 'See all',
			'general.done' => 'Done',
			'general.next' => 'Next',
			'general.back' => 'Back',
			'general.skip' => 'Skip',
			'general.search' => 'Search',
			'general.close' => 'Close',
			'general.or' => 'or',
			'onboarding.step1.title' => 'Place Your Order',
			'onboarding.step1.description' => 'Browse fresh produce from local farms and add your favorites to the cart.',
			'onboarding.step2.title' => 'Farmers Harvest',
			'onboarding.step2.description' => 'Your order is sent to local farmers who harvest fresh produce just for you.',
			'onboarding.step3.title' => 'Direct to You',
			'onboarding.step3.description' => 'Get truly fresh food delivered directly from the farm to your doorstep.',
			'onboarding.getStarted' => 'Get Started',
			'auth.signIn' => 'Sign In',
			'auth.signUp' => 'Sign Up',
			'auth.signOut' => 'Sign Out',
			'auth.email' => 'Email',
			'auth.password' => 'Password',
			'auth.name' => 'Full Name',
			'auth.emailHint' => 'Enter your email',
			'auth.passwordHint' => 'Enter your password',
			'auth.nameHint' => 'Enter your full name',
			'auth.forgotPassword' => 'Forgot password?',
			'auth.noAccount' => 'Don\'t have an account?',
			'auth.hasAccount' => 'Already have an account?',
			'auth.signInWithGoogle' => 'Sign in with Google',
			'auth.welcomeBack' => 'Welcome back!',
			'auth.createAccount' => 'Create your account',
			'auth.signInSubtitle' => 'Sign in to get fresh produce delivered to your door.',
			'auth.signUpSubtitle' => 'Join Harvest and start eating fresh today.',
			'nav.home' => 'Home',
			'nav.search' => 'Search',
			'nav.cart' => 'Cart',
			'nav.orders' => 'Orders',
			'nav.profile' => 'Profile',
			'home.greeting' => ({required Object name}) => 'Hello, ${name}!',
			'home.subtitle' => 'What fresh produce do you need today?',
			'home.categories' => 'Categories',
			'home.featured' => 'Featured Products',
			'home.popular' => 'Popular Now',
			'home.organic' => 'Organic',
			'home.allProducts' => 'All Products',
			'search.title' => 'Search',
			'search.hint' => 'Search fruits, vegetables...',
			'search.filters' => 'Filters',
			'search.sortBy' => 'Sort by',
			'search.priceRange' => 'Price Range',
			'search.category' => 'Category',
			'search.organicOnly' => 'Organic only',
			'search.applyFilters' => 'Apply Filters',
			'search.clearFilters' => 'Clear Filters',
			'search.resultsFor' => ({required Object query}) => 'Results for "${query}"',
			'product.addToCart' => 'Add to Cart',
			'product.added' => 'Added to cart!',
			'product.description' => 'Description',
			'product.nutritionFacts' => 'Nutrition Facts',
			'product.farm' => 'Farm',
			'product.inStock' => 'In Stock',
			'product.outOfStock' => 'Out of Stock',
			'product.perUnit' => ({required Object unit}) => 'per ${unit}',
			'product.organic' => 'Organic',
			'product.calories' => 'Calories',
			'product.protein' => 'Protein',
			'product.fiber' => 'Fiber',
			'product.vitamins' => 'Vitamins',
			'cart.title' => 'Cart',
			'cart.empty' => 'Your cart is empty',
			'cart.emptySubtitle' => 'Start adding fresh products to your cart!',
			'cart.browseProducts' => 'Browse Products',
			'cart.subtotal' => 'Subtotal',
			'cart.deliveryFee' => 'Delivery Fee',
			'cart.total' => 'Total',
			'cart.free' => 'Free',
			'cart.checkout' => 'Proceed to Checkout',
			'cart.itemCount' => ({required Object count}) => '${count} item(s)',
			'cart.removeItem' => 'Remove item?',
			'checkout.title' => 'Checkout',
			'checkout.deliveryAddress' => 'Delivery Address',
			'checkout.street' => 'Street Address',
			'checkout.city' => 'City',
			'checkout.zipCode' => 'ZIP Code',
			'checkout.paymentMethod' => 'Payment Method',
			'checkout.creditCard' => 'Credit Card',
			'checkout.applePay' => 'Apple Pay',
			'checkout.googlePay' => 'Google Pay',
			'checkout.orderSummary' => 'Order Summary',
			'checkout.placeOrder' => 'Place Order',
			'checkout.confirmation.title' => 'Order Confirmed!',
			'checkout.confirmation.subtitle' => 'Your order has been placed successfully.',
			'checkout.confirmation.description' => 'Local farmers are now preparing your fresh produce. You\'ll receive updates on your order status.',
			'checkout.confirmation.orderNumber' => ({required Object number}) => 'Order #${number}',
			'checkout.confirmation.backToHome' => 'Back to Home',
			'checkout.confirmation.viewOrders' => 'View My Orders',
			'orders.title' => 'My Orders',
			'orders.empty' => 'No orders yet',
			'orders.emptySubtitle' => 'Your order history will appear here.',
			'orders.status.pending' => 'Pending',
			'orders.status.confirmed' => 'Confirmed',
			'orders.status.harvesting' => 'Harvesting',
			'orders.status.delivering' => 'On the way',
			'orders.status.delivered' => 'Delivered',
			'orders.orderNumber' => ({required Object number}) => 'Order #${number}',
			'orders.items' => ({required Object count}) => '${count} item(s)',
			'orders.placedOn' => ({required Object date}) => 'Placed on ${date}',
			'profile.title' => 'Profile',
			'profile.editProfile' => 'Edit Profile',
			'profile.myOrders' => 'My Orders',
			'profile.deliveryAddresses' => 'Delivery Addresses',
			'profile.paymentMethods' => 'Payment Methods',
			'profile.notifications' => 'Notifications',
			'profile.helpCenter' => 'Help Center',
			'profile.about' => 'About Harvest',
			'profile.version' => ({required Object version}) => 'Version ${version}',
			_ => null,
		};
	}
}
