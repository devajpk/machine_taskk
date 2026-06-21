import 'package:hive_flutter/hive_flutter.dart';
import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';
import 'package:machine_taskk/features/profiles/domain/repo/profile_repo.dart';



class ProfileRepositoryImpl implements ProfileRepository {
  static const _boxName = 'profiles_box';
  static const _key = 'current_profile';

  Future<Box> _openBox() async => await Hive.openBox(_boxName);

  @override
  Future<WorkspaceProfile> getCurrentProfile() async {
    final box = await _openBox();
    final raw = box.get(_key, defaultValue: 'personal') as String;
    return WorkspaceProfile.values.firstWhere((e) => e.key == raw,
        orElse: () => WorkspaceProfile.personal);
  }

  @override
  Future<void> saveProfile(WorkspaceProfile profile) async {
    final box = await _openBox();
    await box.put(_key, profile.key);
  }
}
