import 'dart:io';

void main() {
  // Katalog toko oleh-oleh di Medan (menggunakan Map & Record)
  final Map<String, ({String nama, String kategori, int harga})> katalog = {
    'P01': (nama: 'Kopi Sidikalang 250 g', kategori: 'Kopi', harga: 45000),
    'P02': (nama: 'Kopi Gayo 250 g', kategori: 'Kopi', harga: 55000),
    'P03': (nama: 'Teh Kayu Aro 100 g', kategori: 'Teh', harga: 25000),
    'P04': (nama: 'Gula Aren 500 g', kategori: 'Pemanis', harga: 30000),
    'P05': (nama: 'Bolu Meranti', kategori: 'Makanan', harga: 80000),
  };

  // TODO 1: Menampilkan katalog sebagai tabel rapi
  print('==================================================');
  print('                 KATALOG TOKO OLEH-OLEH           ');
  print('==================================================');
  print(
    '${'Kode'.padRight(6)} | ${'Nama Produk'.padRight(22)} | ${'Kategori'.padRight(10)} | ${'Harga'.padLeft(8)}',
  );
  print('-' * 58);

  katalog.forEach((kode, produk) {
    print(
      '${kode.padRight(6)} | ${produk.nama.padRight(22)} | ${produk.kategori.padRight(10)} | Rp ${produk.harga.toString().padLeft(6)}',
    );
  });
  print('==================================================\n');

  // Menerima input pesanan dari pengguna
  stdout.write('Masukkan pesanan (contoh: P01x2, P03x1): ');
  final String input = (stdin.readLineSync() ?? '').trim();

  if (input.isEmpty) {
    print('Pesanan kosong.');
    return;
  }

  // TODO 2: Memecah input dengan split(',') lalu split('x') untuk tiap item
  final List<String> itemMentah = input.split(',');

  final List<({String kode, int jumlah})> pesananValid = [];
  final List<String> itemDitolak = [];
  final Set<String> kategoriDibeli = {};

  for (var raw in itemMentah) {
    final bagian = raw.trim().split('x');
    if (bagian.length != 2) {
      itemDitolak.add(raw.trim());
      continue;
    }

    final kode = bagian[0].trim().toUpperCase();
    final jumlah = int.tryParse(bagian[1].trim());

    // TODO 3: Cek apakah kode ada di katalog dan jumlah valid (aman dari crash)
    if (!katalog.containsKey(kode) || jumlah == null || jumlah <= 0) {
      itemDitolak.add(raw.trim());
    } else {
      pesananValid.add((kode: kode, jumlah: jumlah));
      // Menggunakan operator ! karena keberadaan kuncinya sudah dipastikan aman oleh containsKey
      kategoriDibeli.add(katalog[kode]!.kategori);
    }
  }

  // TODO 4: Hitung subtotal (map) dan total (fold), serta diskon 10% jika >= 100.000
  final List<int> subtotalList = pesananValid.map((item) {
    final harga = katalog[item.kode]!.harga;
    return harga * item.jumlah;
  }).toList();

  final int totalBelanja = subtotalList.fold<int>(0, (sum, sub) => sum + sub);

  final double diskon = totalBelanja >= 100000 ? totalBelanja * 0.10 : 0.0;
  final double totalBayar = totalBelanja - diskon;

  // TODO 5: Cetak struk, kategori produk, dan item yang ditolak
  print('\n==================================================');
  print('                   STRUK BELANJA                  ');
  print('==================================================');

  for (int i = 0; i < pesananValid.length; i++) {
    final item = pesananValid[i];
    final produkNama = katalog[item.kode]!.nama;
    final subtotal = subtotalList[i];

    print(
      '${'$produkNama (${item.jumlah}x)'.padRight(32)} : Rp ${subtotal.toString().padLeft(7)}',
    );
  }

  print('-' * 50);
  print(
    '${'Total Bayar'.padRight(32)} : Rp ${totalBayar.toStringAsFixed(0).padLeft(7)}',
  );
  print(
    '${'Diskon (10%)'.padRight(32)} : Rp ${diskon.toStringAsFixed(0).padLeft(7)}',
  );
  print(
    '${'Total Bayar'.padRight(32)} : Rp ${totalBayar.toStringAsFixed(0).padLeft(7)}',
  );
  print('==================================================');

  print('Kategori dibeli : ${kategoriDibeli.join(', ')}');

  if (itemDitolak.isNotEmpty) {
    print(
      'Item ditolak    : ${itemDitolak.join(', ')} (Format salah/Kode tidak ada)',
    );
  }
  print('==================================================');
}
