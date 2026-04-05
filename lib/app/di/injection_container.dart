import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:harvest/core/cache/app_data_cache.dart';
import 'package:harvest/core/constants/app_keys.dart';
import 'package:harvest/features/address/data/datasources/address_remote_datasource.dart';
import 'package:harvest/features/address/data/repositories/address_repository_impl.dart';
import 'package:harvest/features/address/domain/repositories/address_repository.dart';
import 'package:harvest/features/address/domain/usecases/add_address_usecase.dart';
import 'package:harvest/features/address/domain/usecases/delete_address_usecase.dart';
import 'package:harvest/features/address/domain/usecases/get_addresses_usecase.dart';
import 'package:harvest/features/address/domain/usecases/set_default_address_usecase.dart';
import 'package:harvest/features/address/presentation/cubit/address_cubit.dart';
import 'package:harvest/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:harvest/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:harvest/features/admin/domain/repositories/admin_repository.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_orders_cubit.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_users_cubit.dart';
import 'package:harvest/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:harvest/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:harvest/features/auth/domain/repositories/auth_repository.dart';
import 'package:harvest/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:harvest/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:harvest/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:harvest/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:harvest/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:harvest/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:harvest/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:harvest/features/checkout/domain/usecases/place_order_usecase.dart';
import 'package:harvest/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:harvest/features/home/data/datasources/home_remote_datasource.dart';
import 'package:harvest/features/home/data/repositories/home_repository_impl.dart';
import 'package:harvest/features/home/domain/repositories/home_repository.dart';
import 'package:harvest/features/home/domain/usecases/get_all_products_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_featured_products_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_product_by_id_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_products_by_category_usecase.dart';
import 'package:harvest/features/home/presentation/bloc/home_bloc.dart';
import 'package:harvest/features/notifications/data/datasources/notifications_local_datasource.dart';
import 'package:harvest/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:harvest/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:harvest/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:harvest/features/orders/domain/repositories/orders_repository.dart';
import 'package:harvest/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:harvest/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:harvest/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:harvest/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:harvest/features/search/data/datasources/search_remote_datasource.dart';
import 'package:harvest/features/search/data/repositories/search_repository_impl.dart';
import 'package:harvest/features/search/domain/repositories/search_repository.dart';
import 'package:harvest/features/search/domain/usecases/search_products_usecase.dart';
import 'package:harvest/features/search/presentation/cubit/search_cubit.dart';
import 'package:harvest/features/startup/presentation/cubit/startup_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  _initFirebase();
  await GoogleSignIn.instance.initialize(
    serverClientId: AppKeys.googleServerClientId,
  );
  _initCache();
  _initAuth();
  _initHome();
  _initSearch();
  _initCart();
  _initCheckout();
  _initOrders();
  _initProfile();
  _initAddress();
  _initNotifications();
  _initAdmin();
  _initStartup();
  await sl.allReady();
}

void _initFirebase() {
  sl
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    )
    ..registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);
}

void _initCache() {
  sl
    ..registerLazySingleton(AppDataCache.new)
    ..registerSingletonAsync<SharedPreferences>(
      SharedPreferences.getInstance,
    );
}

void _initAuth() {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: sl(),
        firestore: sl(),
        googleSignIn: sl(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton(() => SignInUseCase(sl()))
    ..registerLazySingleton(() => SignUpUseCase(sl()))
    ..registerLazySingleton(() => SignOutUseCase(sl()))
    ..registerLazySingleton(() => GetCurrentUserUseCase(sl()))
    ..registerLazySingleton(() => UpdateProfileUseCase(sl()))
    ..registerLazySingleton(() => SignInWithGoogleUseCase(sl()))
    ..registerLazySingleton(
      () => AuthBloc(
        signInUseCase: sl(),
        signUpUseCase: sl(),
        signOutUseCase: sl(),
        getCurrentUserUseCase: sl(),
        signInWithGoogleUseCase: sl(),
        cache: sl(),
      ),
    );
}

void _initHome() {
  sl
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(firestore: sl()),
    )
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(sl(), sl<AppDataCache>()),
    )
    ..registerLazySingleton(() => GetAllProductsUseCase(sl()))
    ..registerLazySingleton(() => GetCategoriesUseCase(sl()))
    ..registerLazySingleton(() => GetFeaturedProductsUseCase(sl()))
    ..registerLazySingleton(() => GetProductsByCategoryUseCase(sl()))
    ..registerLazySingleton(() => GetProductByIdUseCase(sl()))
    ..registerLazySingleton(
      () => HomeBloc(
        getAllProductsUseCase: sl(),
        getCategoriesUseCase: sl(),
        getFeaturedProductsUseCase: sl(),
        getProductsByCategoryUseCase: sl(),
      ),
    );
}

void _initSearch() {
  sl
    ..registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(firestore: sl()),
    )
    ..registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(sl(), sl<AppDataCache>()),
    )
    ..registerLazySingleton(() => SearchProductsUseCase(sl()))
    ..registerLazySingleton(
      () => SearchCubit(
        searchProductsUseCase: sl(),
        getCategoriesUseCase: sl(),
      ),
    );
}

void _initCart() {
  sl
    ..registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(sl<SharedPreferences>()),
    )
    ..registerLazySingleton(() => CartBloc(localDataSource: sl()));
}

void _initCheckout() {
  sl
    ..registerLazySingleton<CheckoutRepository>(
      () => CheckoutRepositoryImpl(firestore: sl(), firebaseAuth: sl()),
    )
    ..registerLazySingleton(() => PlaceOrderUseCase(sl()))
    ..registerFactory(() => CheckoutBloc(placeOrderUseCase: sl()));
}

void _initOrders() {
  sl
    ..registerLazySingleton<OrdersRemoteDataSource>(
      () => OrdersRemoteDataSourceImpl(firestore: sl(), firebaseAuth: sl()),
    )
    ..registerLazySingleton<OrdersRepository>(
      () => OrdersRepositoryImpl(sl(), sl<AppDataCache>()),
    )
    ..registerLazySingleton(() => GetOrdersUseCase(sl()))
    ..registerLazySingleton(() => CancelOrderUseCase(sl()))
    ..registerLazySingleton(
      () => OrdersBloc(
        getOrdersUseCase: sl(),
        cancelOrderUseCase: sl(),
      ),
    );
}

void _initProfile() {
  sl.registerLazySingleton(
    () => ProfileCubit(
      getCurrentUserUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );
}

void _initAddress() {
  sl
    ..registerLazySingleton<AddressRemoteDataSource>(
      () => AddressRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
    )
    ..registerLazySingleton<AddressRepository>(
      () => AddressRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetAddressesUseCase(sl()))
    ..registerLazySingleton(() => AddAddressUseCase(sl()))
    ..registerLazySingleton(() => DeleteAddressUseCase(sl()))
    ..registerLazySingleton(() => SetDefaultAddressUseCase(sl()))
    ..registerFactory(
      () => AddressCubit(
        getAddressesUseCase: sl(),
        addAddressUseCase: sl(),
        deleteAddressUseCase: sl(),
        setDefaultAddressUseCase: sl(),
      ),
    );
}

void _initNotifications() {
  sl
    ..registerLazySingleton<NotificationsLocalDataSource>(
      () => NotificationsLocalDataSourceImpl(sl<SharedPreferences>()),
    )
    ..registerFactory(
      () => NotificationsCubit(localDataSource: sl()),
    );
}

void _initAdmin() {
  sl
    ..registerLazySingleton<AdminRemoteDataSource>(
      () => AdminRemoteDataSourceImpl(firestore: sl()),
    )
    ..registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(sl()))
    ..registerFactory(() => AdminProductsCubit(sl()))
    ..registerFactory(() => AdminCategoriesCubit(sl()))
    ..registerFactory(() => AdminOrdersCubit(sl()))
    ..registerFactory(() => AdminUsersCubit(sl()));
}

void _initStartup() {
  sl.registerFactory(
    () => StartupCubit(
      getCategoriesUseCase: sl(),
      getAllProductsUseCase: sl(),
      getFeaturedProductsUseCase: sl(),
      getOrdersUseCase: sl(),
      authBloc: sl(),
      homeBloc: sl(),
      ordersBloc: sl(),
      profileCubit: sl(),
      cartBloc: sl(),
    ),
  );
}
