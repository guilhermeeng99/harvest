import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/widgets/error_view.dart';
import 'package:harvest/features/search/presentation/cubit/search_cubit.dart';
import 'package:harvest/features/search/presentation/widgets/search_categories_grid.dart';
import 'package:harvest/features/search/presentation/widgets/search_loading_grid.dart';
import 'package:harvest/features/search/presentation/widgets/search_no_results.dart';
import 'package:harvest/features/search/presentation/widgets/search_results_view.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearAll() {
    _searchController.clear();
    context.read<SearchCubit>().clearCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: TextField(
                controller: _searchController,
                onSubmitted: (query) =>
                    context.read<SearchCubit>().search(query),
                decoration: InputDecoration(
                  hintText: t.search.hint,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16, right: 12),
                    child: FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 18,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(),
                  suffixIcon: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state.query.isEmpty &&
                          state.selectedCategoryId == null) {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.xmark,
                          size: 18,
                        ),
                        onPressed: _clearAll,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) => switch (state.status) {
                  SearchStatus.initial => SearchCategoriesGrid(
                    categories: state.categories,
                  ),
                  SearchStatus.loading => const SearchLoadingGrid(),
                  SearchStatus.error => ErrorView(
                    message: state.errorMessage ?? t.general.error,
                    onRetry: () =>
                        context.read<SearchCubit>().search(state.query),
                  ),
                  SearchStatus.loaded =>
                    state.results.isEmpty
                        ? SearchNoResults(onBack: _clearAll)
                        : SearchResultsView(
                            state: state,
                            onClearAll: _clearAll,
                          ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
