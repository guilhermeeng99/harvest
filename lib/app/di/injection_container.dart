import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
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
import 'package:harvest/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_users_cubit.dart';
import 'package:harvest/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:harvest/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:harvest/features/auth/domain/repositories/auth_repository.dart';
import 'package:harvest/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:harvest/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:harvest/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:harvest/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
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
import 'package:harvest/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:harvest/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:harvest/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:harvest/features/orders/domain/repositories/orders_repository.dart';
import 'package:harvest/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:harvest/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:harvest/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:harvest/features/search/data/datasources/search_remote_datasource.dart';
import 'package:harvest/features/search/data/repositories/search_repository_impl.dart';
import 'package:harvest/features/search/domain/repositories/search_repository.dart';
import 'package:harvest/features/search/domain/usecases/search_products_usecase.dart';
import 'package:harvest/features/search/presentation/cubit/search_cubit.dart';

final GetIt sl = GetIt.instance;

void initDependencies() {
  _initFirebase();
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
}

void _initFirebase() {
  sl
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
}

void _initAuth() {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton(() => SignInUseCase(sl()))
    ..registerLazySingleton(() => SignUpUseCase(sl()))
    ..registerLazySingleton(() => SignOutUseCase(sl()))
    ..registerLazySingleton(() => GetCurrentUserUseCase(sl()))
    ..registerFactory(
      () => AuthBloc(
        signInUseCase: sl(),
        signUpUseCase: sl(),
        signOutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ),
    );
}

void _initHome() {
  sl
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(firestore: sl()),
    )
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetAllProductsUseCase(sl()))
    ..registerLazySingleton(() => GetCategoriesUseCase(sl()))
    ..registerLazySingleton(() => GetFeaturedProductsUseCase(sl()))
    ..registerLazySingleton(() => GetProductsByCategoryUseCase(sl()))
    ..registerLazySingleton(() => GetProductByIdUseCase(sl()))
    ..registerFactory(
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
    ..registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(sl()))
    ..registerLazySingleton(() => SearchProductsUseCase(sl()))
    ..registerFactory(
      () => SearchCubit(
        searchProductsUseCase: sl(),
        getCategoriesUseCase: sl(),
      ),
    );
}

void _initCart() {
  sl.registerFactory(CartBloc.new);
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
    ..registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetOrdersUseCase(sl()))
    ..registerFactory(() => OrdersBloc(getOrdersUseCase: sl()));
}

void _initProfile() {
  sl.registerFactory(() => ProfileCubit(getCurrentUserUseCase: sl()));
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
  sl.registerFactory(NotificationsCubit.new);
}

void _initAdmin() {
  sl
    ..registerLazySingleton<AdminRemoteDataSource>(
      () => AdminRemoteDataSourceImpl(firestore: sl(), storage: sl()),
    )
    ..registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(sl()))
    ..registerFactory(() => AdminProductsCubit(sl()))
    ..registerFactory(() => AdminCategoriesCubit(sl()))
    ..registerFactory(() => AdminUsersCubit(sl()));
}
