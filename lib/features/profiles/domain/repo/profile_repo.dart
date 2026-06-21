import 'package:machine_taskk/features/profiles/domain/entities/workspace_profile.dart';

abstract class ProfileRepository {
  Future<WorkspaceProfile> getCurrentProfile();
  Future<void> saveProfile(WorkspaceProfile profile);
}