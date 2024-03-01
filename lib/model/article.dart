class Article {
  late final int? id;
  late final String? imgURL;
  late final String? titre;
  late final String? text;

  Article({
    this.id,
    this.imgURL,
    this.titre,
    this.text,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      imgURL: json['img_url'],
      titre: json['tire'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img_url': imgURL,
      'tire': titre,
      'text': text,
    };
  }

  @override
  String toString() {
    return 'Article: {id: $id, imgURL: $imgURL, tire: $titre, text: $text}';
  }
}
