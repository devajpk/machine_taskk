enum WorkspaceProfile { personal, work, corporate, creative }

extension WorkspaceProfileX on WorkspaceProfile {
  String get key {
    switch (this) {
      case WorkspaceProfile.personal:
        return 'personal';
      case WorkspaceProfile.work:
        return 'work';
      case WorkspaceProfile.corporate:
        return 'corporate';
      case WorkspaceProfile.creative:
        return 'creative';
    }
  }
}
