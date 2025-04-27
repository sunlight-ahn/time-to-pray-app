class Prayer {
  final int id;
  final String title;
  final String content;
  final bool isFavorite;
  Prayer(
      {required this.id,
      required this.title,
      required this.content,
      required this.isFavorite});

  factory Prayer.fromMap(Map<String, dynamic> map) {
    return Prayer(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      //isFavorite: map['isFavorite'],
      isFavorite: map['isFavorite'] == 1, // int 1이면 true, 0이면 false로 변환
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  Prayer copyWith({
    int? id,
    String? title,
    String? content,
    bool? isFavorite,
  }) {
    return Prayer(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Prayer(id: $id, title: $title, content: $content, isFavorite: $isFavorite)';
  }
}
