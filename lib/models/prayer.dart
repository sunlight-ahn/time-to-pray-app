class Prayer {
  final int id;
  final String title;
  final String content;
  final bool isFavorite;
  final String prayType;
  final String prayKey;
  final String version;
  final DateTime registerDate;
  final DateTime modifiedDate;
  Prayer(
      {required this.id,
      required this.title,
      required this.content,
      required this.isFavorite,
      required this.prayType,
      required this.prayKey,
      required this.version,
      required this.registerDate,
      required this.modifiedDate});

  factory Prayer.fromMap(Map<String, dynamic> map) {
    return Prayer(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      //isFavorite: map['isFavorite'],
      isFavorite: map['isFavorite'] == 1, // int 1이면 true, 0이면 false로 변환
      prayType: map['prayType'],
      prayKey: map['prayKey'],
      version: map['version'],
      registerDate: DateTime.parse(map['registerDate']),
      modifiedDate: DateTime.parse(map['modifiedDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isFavorite': isFavorite ? 1 : 0,
      'prayType': prayType,
      'prayKey': prayKey,
      'version': version,
      'registerDate': registerDate.toIso8601String(),
      'modifiedDate': modifiedDate.toIso8601String(),
    };
  }

  Prayer copyWith({
    int? id,
    String? title,
    String? content,
    bool? isFavorite,
    String? prayType,
    String? prayKey,
    String? version,
    DateTime? registerDate,
    DateTime? modifiedDate,
  }) {
    return Prayer(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
      prayType: prayType ?? this.prayType,
      prayKey: prayKey ?? this.prayKey,
      version: version ?? this.version,
      registerDate: registerDate ?? this.registerDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
    );
  }

  @override
  String toString() {
    return 'Prayer(id: $id, title: $title, content: $content, isFavorite: $isFavorite, prayType: $prayType, prayKey: $prayKey, version: $version, registerDate: $registerDate, modifiedDate: $modifiedDate)';
  }
}
