import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_users_cubit.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_users_state.dart';
import 'package:harvest/features/admin/presentation/widgets/animated_list_item.dart';
import 'package:harvest/features/auth/domain/entities/user_entity.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<AdminUsersCubit>();
        unawaited(cubit.loadUsers());
        return cubit;
      },
      child: const _AdminUsersView(),
    );
  }
}

class _AdminUsersView extends StatelessWidget {
  const _AdminUsersView();

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Scaffold(
      body: BlocBuilder<AdminUsersCubit, AdminUsersState>(
        builder: (context, state) {
          if (state.status == AdminUsersStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == AdminUsersStatus.error) {
            return Center(child: Text(state.errorMessage ?? ''));
          }
          if (state.users.isEmpty) {
            return Center(child: Text(i18n.noUsers));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return AnimatedListItem(
                index: index,
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null
                          ? const FaIcon(FontAwesomeIcons.user)
                          : null,
                    ),
                    title: Text(user.name ?? user.email),
                    subtitle: user.name != null ? Text(user.email) : null,
                    onTap: () => _showUserDetails(context, user),
                    trailing: IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.trashCan,
                        size: 18,
                      ),
                      onPressed: () => _confirmDelete(
                        context,
                        user.id,
                        user.name ?? user.email,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUserDetails(BuildContext context, UserEntity user) {
    unawaited(context.push(AppRoutes.adminUserDetail, extra: user));
  }

  void _confirmDelete(BuildContext context, String id, String name) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(t.admin.confirmDelete),
          content: Text(name),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.general.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                unawaited(context.read<AdminUsersCubit>().deleteUser(id));
              },
              child: Text(
                t.general.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
