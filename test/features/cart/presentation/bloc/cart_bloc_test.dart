import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:harvest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockCartLocalDataSource extends Mock implements CartLocalDataSource {}

void main() {
  late MockCartLocalDataSource mockLocalDataSource;

  const apple = ProductEntity(
    id: 'apple-1',
    name: 'Organic Apple',
    description: 'Fresh',
    price: 3.5,
    unit: 'kg',
    categoryId: 'fruits',
    imageUrl: '',
    farmName: 'Farm A',
    stock: 20,
  );

  const carrot = ProductEntity(
    id: 'carrot-1',
    name: 'Organic Carrot',
    description: 'Fresh',
    price: 2,
    unit: 'kg',
    categoryId: 'vegetables',
    imageUrl: '',
    farmName: 'Farm B',
    stock: 15,
  );

  setUp(() {
    mockLocalDataSource = MockCartLocalDataSource();
    when(() => mockLocalDataSource.saveCart(any())).thenAnswer((_) async {});
    when(() => mockLocalDataSource.loadCart()).thenReturn([]);
  });

  setUpAll(() {
    registerFallbackValue(<CartItemEntity>[]);
  });

  group('CartBloc', () {
    test('initial state is empty cart', () {
      final bloc = CartBloc(localDataSource: mockLocalDataSource);
      expect(bloc.state.isEmpty, isTrue);
      expect(bloc.state.itemCount, 0);
      expect(bloc.state.subtotal, 0);
    });

    blocTest<CartBloc, CartState>(
      'CartLoadRequested loads items from local storage',
      setUp: () {
        when(() => mockLocalDataSource.loadCart()).thenReturn([
          const CartItemEntity(product: apple, quantity: 2),
        ]);
      },
      build: () => CartBloc(localDataSource: mockLocalDataSource),
      act: (bloc) => bloc.add(const CartLoadRequested()),
      expect: () => [
        const CartState(
          items: [CartItemEntity(product: apple, quantity: 2)],
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'CartItemAdded adds new product to cart',
      build: () => CartBloc(localDataSource: mockLocalDataSource),
      act: (bloc) => bloc.add(const CartItemAdded(apple)),
      expect: () => [
        const CartState(
          items: [CartItemEntity(product: apple, quantity: 1)],
        ),
      ],
      verify: (_) {
        verify(() => mockLocalDataSource.saveCart(any())).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'CartItemAdded increments quantity if product already in cart',
      build: () => CartBloc(localDataSource: mockLocalDataSource),
      seed: () => const CartState(
        items: [CartItemEntity(product: apple, quantity: 1)],
      ),
      act: (bloc) => bloc.add(const CartItemAdded(apple)),
      expect: () => [
        const CartState(
          items: [CartItemEntity(product: apple, quantity: 2)],
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'CartItemAdded can add multiple different products',
      build: () => CartBloc(localDataSource: mockLocalDataSource),
      act: (bloc) {
        bloc
          ..add(const CartItemAdded(apple))
          ..add(const CartItemAdded(carrot));
      },
      expect: () => [
        const CartState(
          items: [CartItemEntity(product: apple, quantity: 1)],
        ),
        const CartState(
          items: [
            CartItemEntity(product: apple, quantity: 1),
            CartItemEntity(product: carrot, quantity: 1),
          ],
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'CartItemRemoved removes product from cart',
      build: () => CartBloc(localDataSource: mockLocalDataSource),
      seed: () => const CartState(
        items: [
          CartItemEntity(product: apple, quantity: 2),
          CartItemEntity(product: carrot, quantity: 1),
        ],
      ),
      act: (bloc) => bloc.add(const CartItemRemoved('apple-1')),
      expect: () => [
        const CartState(
          items: [CartItemEntity(product: carrot, quantity: 1)],
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'CartItemQuantityUpdated changes item quantity',
      build: () => CartBloc(localDataSource: mockLocalDataSource),
      seed: () => const CartState(
        items: [CartItemEntity(product: apple, quantity: 1)],
      ),
      act: (bloc) => bloc.add(
        const CartItemQuantityUpdated(productId: 'apple-1', quantity: 5),
      ),
      expect: () => [
        const CartState(
          items: [CartItemEntity(product: apple, quantity: 5)],
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'CartItemQuantityUpdated with 0 removes the item',
      build: () => CartBloc(localDataSource: mockLocalDataSource),
      seed: () => const CartState(
        items: [CartItemEntity(product: apple, quantity: 2)],
      ),
      act: (bloc) => bloc.add(
        const CartItemQuantityUpdated(productId: 'apple-1', quantity: 0),
      ),
      expect: () => [
        const CartState(),
      ],
    );

    blocTest<CartBloc, CartState>(
      'CartCleared empties the cart',
      build: () => CartBloc(localDataSource: mockLocalDataSource),
      seed: () => const CartState(
        items: [
          CartItemEntity(product: apple, quantity: 2),
          CartItemEntity(product: carrot, quantity: 3),
        ],
      ),
      act: (bloc) => bloc.add(const CartCleared()),
      expect: () => [const CartState()],
      verify: (_) {
        verify(() => mockLocalDataSource.saveCart([])).called(1);
      },
    );
  });

  group('CartState computed properties', () {
    test('itemCount sums all quantities', () {
      const state = CartState(
        items: [
          CartItemEntity(product: apple, quantity: 2),
          CartItemEntity(product: carrot, quantity: 3),
        ],
      );
      expect(state.itemCount, 5);
    });

    test('subtotal sums all item totals', () {
      const state = CartState(
        items: [
          CartItemEntity(product: apple, quantity: 2), // 3.50 * 2 = 7.00
          CartItemEntity(product: carrot, quantity: 3), // 2.00 * 3 = 6.00
        ],
      );
      expect(state.subtotal, 13.00);
    });

    test('deliveryFee is 0 when subtotal > 50', () {
      const expensiveProduct = ProductEntity(
        id: 'exp',
        name: 'Truffle',
        description: '',
        price: 60,
        unit: 'kg',
        categoryId: 'c',
        imageUrl: '',
        farmName: 'Farm',
      );
      const state = CartState(
        items: [CartItemEntity(product: expensiveProduct, quantity: 1)],
      );
      expect(state.deliveryFee, 0);
    });

    test('deliveryFee is 4.99 when subtotal <= 50', () {
      const state = CartState(
        items: [CartItemEntity(product: apple, quantity: 1)],
      );
      expect(state.deliveryFee, 4.99);
    });

    test('total is subtotal + deliveryFee', () {
      const state = CartState(
        items: [CartItemEntity(product: apple, quantity: 1)],
      );
      expect(state.total, 3.50 + 4.99);
    });
  });
}
