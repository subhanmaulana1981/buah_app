class Buah {
  late int id;
  late String nama;
  late int harga;

  Buah({
    required this.id,
    required this.nama,
    required this.harga
  });

  factory Buah.fromMap(Map<String, dynamic> json) => Buah(
    id: json["id"],
    nama: json["nama"],
    harga: json["harga"]
  );

  Map<String, dynamic> toMap() {
    return {
      "nama": nama,
      "harga": harga
    };
  }
}