/// Constants used throughout the app
class AppConstants {
  // Note Categories
  static const List<String> categories = [
    'Work',
    'Personal',
    'Ideas',
    'Shopping',
    'Travel',
    'Other',
  ];

  // Priority Levels
  static const String priorityLow = 'low';
  static const String priorityMedium = 'medium';
  static const String priorityHigh = 'high';

  static const List<String> priorities = [
    priorityLow,
    priorityMedium,
    priorityHigh,
  ];

  // Common Tags
  static const List<String> commonTags = [
    'urgent',
    'meeting',
    'important',
    'todo',
    'reminder',
    'project',
  ];

  // Date Filter Options
  static const String filterAll = 'All';
  static const String filterRecent = 'Recent (7 days)';
  static const String filterOld = 'Old (>30 days)';
  static const String filterWithReminders = 'With Reminders';

  static const List<String> dateFilters = [
    filterAll,
    filterRecent,
    filterOld,
    filterWithReminders,
  ];
}

