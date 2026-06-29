class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String message;
  final bool read;
  final DateTime createdAt;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      read: json['read'] == true,
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}
