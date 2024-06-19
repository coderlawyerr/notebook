class NoteModel {
  late final String id; // id
  late final String title; // başlık
  late String content; // içerik
  late DateTime updatedTime; // güncel tarih
  
  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updatedTime': updatedTime.toIso8601String(),
    };
  }

  static NoteModel fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map["id"] ?? "",
      title: map["title"] ?? "",
      content: map["content"] ?? "",
      updatedTime: DateTime.parse(map["updatedTime"] ?? ""),
    );
  }
}