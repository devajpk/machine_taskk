import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:machine_taskk/features/profiles/data/profile_repository_impl.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  group('ProfileRepository', () {
    final repo = ProfileRepositoryImpl();

    test('default profile is personal', () async {
      final profile = await repo.getCurrentProfile();
      expect(profile, WorkspaceProfile.personal);
    });

    test('save and read profile', () async {
      await repo.saveProfile(WorkspaceProfile.creative);
      final p = await repo.getCurrentProfile();
      expect(p, WorkspaceProfile.creative);
    });
  });
}
