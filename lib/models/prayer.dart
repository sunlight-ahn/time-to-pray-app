class Prayer {
  final int id;
  final String title;
  final String content;
  final bool isFavorite;
  final bool isShow;
  final String? prayType;
  final String prayKey;
  final String version;
  final DateTime registerDate;
  final DateTime modifiedDate;
  Prayer(
      {required this.id,
      required this.title,
      required this.content,
      required this.isFavorite,
      required this.isShow,
      required this.prayType,
      required this.prayKey,
      required this.version,
      required this.registerDate,
      required this.modifiedDate});

  factory Prayer.fromMap(Map<String, dynamic> map) {
    return Prayer(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      isFavorite: map['isFavorite'] as bool,
      isShow: map['isShow'] as bool,
      prayType: map['prayType'] as String?,
      prayKey: map['prayKey'] as String,
      version: map['version'] as String,
      registerDate: DateTime.parse(map['registerDate'] as String),
      modifiedDate: DateTime.parse(map['modifiedDate'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isFavorite': isFavorite,
      'isShow': isShow,
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
    bool? isShow,
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
      isShow: isShow ?? this.isShow,
      prayType: prayType ?? this.prayType,
      prayKey: prayKey ?? this.prayKey,
      version: version ?? this.version,
      registerDate: registerDate ?? this.registerDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
    );
  }

  @override
  String toString() {
    return 'Prayer(id: $id, title: $title, content: $content, isFavorite: $isFavorite, isShow: $isShow, prayType: $prayType, prayKey: $prayKey, version: $version, registerDate: $registerDate, modifiedDate: $modifiedDate)';
  }
}
