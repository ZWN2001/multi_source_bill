class Source {
  final int id;
  final String sourceName;

  Source({
    required this.id,
    required this.sourceName,

  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      sourceName: json['source_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_name': sourceName,
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