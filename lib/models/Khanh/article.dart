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
      idBaiViet: json['ID_BaiViet'] ?? 0, // Khớp với iD_BaiViet
      tieuDe: json['TieuDe'] ?? '',
      tacGia: json['TacGia'] ?? '',
      ngayDang: DateTime.parse(json['NgayDang'] ?? DateTime.now().toString()),
      anhBaiViets: (json['AnhBaiViets'] as List<dynamic>?)
          ?.map((e) => ArticleImage.fromJson(e))
          .toList() ??
          [],
      noiDungBaiViets: (json['NoiDungBaiViets'] as List<dynamic>?)
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
      idAnh: json['ID_Anh'] ?? 0, // Khớp với iD_Anh
      idBaiViet: json['ID_BaiViet'] ?? 0, // Khớp với iD_BaiViet
      duongDan: json['DuongDan'] ?? '', // Khớp với duongDan
      moTa: json['MoTa'] ?? '', // Khớp với moTa
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
      idNoiDung: json['ID_NoiDung'] ?? 0, // Khớp với iD_NoiDung
      idBaiViet: json['ID_BaiViet'] ?? 0, // Khớp với iD_BaiViet
      noiDung: json['NoiDung'] ?? '',
      thuTu: json['ThuTu'] ?? 0, // Khớp với thuTu
    );
  }
}