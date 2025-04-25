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
      isFavorite: map['isFavorite'],
    );
  }
}
