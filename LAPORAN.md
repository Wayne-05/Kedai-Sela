# Laporan performa Kedai Muthu

**Status pengukuran:** belum diukur pada perangkat. Isi tabel dengan data dari DevTools setelah menjalankan kedua varian.

## Pertanyaan uji

Apakah membatasi rebuild animasi cangkir pada header mengurangi waktu UI dan jumlah frame lambat? Pada baseline, setiap tick membangun ulang katalog. Pada versi akhir, builder hanya membangun transformasi, menggunakan kembali ikon child dan mengisolasi repaint. Isi katalog, ukuran kartu, durasi animasi, serta perilaku sentuhan sama pada kedua varian.

## Prosedur

1. Catat model ponsel, versi Android, refresh rate, dan keluaran `flutter --version`. Gunakan perangkat dan orientasi yang sama untuk seluruh uji.
2. Jalankan `flutter run --profile -d ID_PERANGKAT --dart-define=BASELINE=true`. Buka tautan DevTools dari terminal dan pilih Performance.
3. Gulir daftar serta buka dan tutup detail sekali untuk pemanasan. Kembali ke atas, dengan Matcha Latte habis dan sembilan menu lainnya tersedia. Bersihkan rekaman sebelumnya.
4. Rekam header berputar selama 10 detik. Gulir katalog sampai bawah lalu kembali ke atas. Tekan lama menu pertama dua kali dengan jeda satu detik. Ketuk menu pertama, tunggu satu detik, lalu kembali. Hentikan rekaman. Ekspor snapshot.
5. Catat jumlah frame yang terekam dan frame lambat pada interval tersebut. Untuk timing yang dapat dibandingkan, pilih frame header dengan waktu UI tertinggi selama 10 detik pertama dan catat waktu UI serta raster pada frame itu.
6. Ulangi tiga kali. Hentikan aplikasi dan ulangi langkah 2–5 dengan `flutter run --profile -d ID_PERANGKAT --dart-define=BASELINE=false`. Gunakan median dari tiga nilai tiap metrik untuk ringkasan. Simpan kedua snapshot beserta tangkapan layar.
7. Bila ingin menjelaskan penyebab perbedaan, buat rekaman terpisah dengan Track Widget Builds saat katalog diam dan cangkir berputar. Catat widget yang dibangun setiap tick. Matikan pelacakan tambahan pada pengukuran waktu.

Perangkat / Android / Flutter / refresh rate: …

| Varian dan ulangan | Jumlah frame | Frame lambat | UI pada frame header terpilih (ms) | Raster pada frame yang sama (ms) |
|---|---:|---:|---:|---:|
| Sebelum 1 | | | | |
| Sebelum 2 | | | | |
| Sebelum 3 | | | | |
| Sesudah 1 | | | | |
| Sesudah 2 | | | | |
| Sesudah 3 | | | | |

**Kesimpulan untuk diisi sesudah uji.** Median waktu UI berubah dari … ms menjadi … ms. Median persentase frame lambat (100 × frame lambat / jumlah frame per rekaman) berubah dari …% menjadi …%. Pada rekaman build, widget yang terlihat dibangun kembali saat cangkir berputar adalah …. Jelaskan jika selisih kecil, berubah arah, atau bervariasi antarulangan. Waktu raster dan UI perlu dibaca terpisah.

Panduan membaca grafik, waktu UI/raster, frame lambat dan snapshot tersedia di [dokumentasi Flutter DevTools](https://docs.flutter.dev/tools/devtools/performance).
