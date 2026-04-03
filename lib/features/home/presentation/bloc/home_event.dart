part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoadRequested extends HomeEvent {
  const HomeLoadRequested();
}

class HomeCategorySelected extends HomeEvent {
  const HomeCategorySelected(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}
