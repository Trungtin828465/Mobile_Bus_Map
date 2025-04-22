class Article {
  final int idBaiViet;
  final String tieuDe;
  final String tacGia;
  final DateTime ngayDang;
  final List<ArticleImage> anhBaiViets;
  final List<ArticleContent> noiDungBaiViets;

  Article({
    required this.idBaiViet,
    required this.tieuDe,
    required this.tacGia,
    required this.ngayDang,
    required this.anhBaiViets,
    required this.noiDungBaiViets,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      idBaiViet: json['iD_BaiViet'] ?? 0, // Khớp với iD_BaiViet
      tieuDe: json['tieuDe'] ?? '',
      tacGia: json['tacGia'] ?? '',
      ngayDang: DateTime.parse(json['ngayDang'] ?? DateTime.now().toString()),
      anhBaiViets: (json['anhBaiViets'] as List<dynamic>?)
          ?.map((e) => ArticleImage.fromJson(e))
          .toList() ??
          [],
      noiDungBaiViets: (json['noiDungBaiViets'] as List<dynamic>?)
          ?.map((e) => ArticleContent.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class ArticleImage {
  final int idAnh;
  final int idBaiViet;
  final String duongDan; // Sửa urlAnh thành duongDan
  final String moTa; // Sửa description thành moTa

  ArticleImage({
    required this.idAnh,
    required this.idBaiViet,
    required this.duongDan,
    required this.moTa,
  });

  factory ArticleImage.fromJson(Map<String, dynamic> json) {
    return ArticleImage(
      idAnh: json['iD_Anh'] ?? 0, // Khớp với iD_Anh
      idBaiViet: json['iD_BaiViet'] ?? 0, // Khớp với iD_BaiViet
      duongDan: json['duongDan'] ?? '', // Khớp với duongDan
      moTa: json['moTa'] ?? '', // Khớp với moTa
    );
  }
}

class ArticleContent {
  final int idNoiDung;
  final int idBaiViet;
  final String noiDung;
  final int thuTu; // Sửa order thành thuTu

  ArticleContent({
    required this.idNoiDung,
    required this.idBaiViet,
    required this.noiDung,
    required this.thuTu,
  });

  factory ArticleContent.fromJson(Map<String, dynamic> json) {
    return ArticleContent(
      idNoiDung: json['iD_NoiDung'] ?? 0, // Khớp với iD_NoiDung
      idBaiViet: json['iD_BaiViet'] ?? 0, // Khớp với iD_BaiViet
      noiDung: json['noiDung'] ?? '',
      thuTu: json['thuTu'] ?? 0, // Khớp với thuTu
    );
  }
}