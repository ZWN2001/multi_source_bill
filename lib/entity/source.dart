class Source {
  final int id;
  final String sourceName;
  final List<String> tags;

  Source({
    required this.id,
    required this.sourceName,
    required this.tags,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      sourceName: json['source_name'],
      tags: json['tags'] as List<String>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_name': sourceName,
      'tags': tags,
    };
  }

  //toMap
  Map<String, dynamic> toMap() {
    return {
      'source_name': sourceName,
    };
  }

  @override
  String toString() {
    return 'Source{id: $id, sourceName: $sourceName}';
  }
}