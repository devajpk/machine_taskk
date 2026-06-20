import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machine_taskk/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:machine_taskk/features/profiles/data/profile_repository_impl.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/presentation/bloc/profile_bloc.dart';

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) =>
              ProfileBloc(_FakeProfileRepository())..add(LoadProfileEvent()),
          child: const DashboardPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Multi Profile Workspace Engine'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
  });
}

class _FakeProfileRepository implements ProfileRepository {
  WorkspaceProfile _profile = WorkspaceProfile.personal;

  @override
  Future<WorkspaceProfile> getCurrentProfile() async => _profile;

  @override
  Future<void> saveProfile(WorkspaceProfile profile) async {
    _profile = profile;
  }
}
