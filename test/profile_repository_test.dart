import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:machine_taskk/features/profiles/data/profile_repository_impl.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDirectory;

  setUp(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('profile_hive_test_');
    Hive.init(hiveDirectory.path);
  });

  tearDown(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  group('ProfileRepository', () {
    test('default profile is personal', () async {
      final repo = ProfileRepositoryImpl();
      final profile = await repo.getCurrentProfile();
      expect(profile, WorkspaceProfile.personal);
    });

    test('save and read profile', () async {
      final repo = ProfileRepositoryImpl();
      await repo.saveProfile(WorkspaceProfile.creative);
      final p = await repo.getCurrentProfile();
      expect(p, WorkspaceProfile.creative);
    });
  });
}
