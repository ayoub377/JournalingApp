class JournalEntry {
  final String title;
  final List<dynamic> content;
  final String emotion;
  final DateTime? createdAt;
  final String? imageUrl;

  JournalEntry({this.imageUrl,required this.content, required this.emotion,this.createdAt, required this.title});

// to json and from json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'emotion': emotion,
      'created_at': createdAt!.millisecondsSinceEpoch,
      'imageUrl' : imageUrl
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      title: json['title'] ?? '',
      content: json['content'] as List<dynamic>,
      emotion: json['emotion'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
      imageUrl : json['imageUrl'] ?? ''
    );
  }

  JournalEntry copyWith({
    String? title,
    List<dynamic>? content,
    String? emotion,
    DateTime? createdAt,
    String? imageUrl
  }) {
    return JournalEntry(
      title: title ?? this.title,
      content: content ?? this.content,
      emotion: emotion ?? this.emotion,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl
    );
  }

}

