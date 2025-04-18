class Prayer {
  final int id;
  final String title;
  final String content;

  Prayer({required this.id, required this.title, required this.content});

  factory Prayer.fromMap(Map<String, dynamic> map) {
    return Prayer(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}