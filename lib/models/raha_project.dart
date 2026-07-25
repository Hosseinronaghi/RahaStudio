enum RahaProjectStatus { draft, processing, ready, failed }

class RahaProject {
  RahaProject({
    required this.id,
    required this.title,
    required this.createdAt,
    this.sourcePath,
    this.status = RahaProjectStatus.draft,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final String? sourcePath;
  final RahaProjectStatus status;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'sourcePath': sourcePath,
    'status': status.name,
  };

  factory RahaProject.fromJson(Map<String, dynamic> json) => RahaProject(
    id: json['id'] as String,
    title: json['title'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    sourcePath: json['sourcePath'] as String?,
    status: RahaProjectStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => RahaProjectStatus.draft,
    ),
  );
}
