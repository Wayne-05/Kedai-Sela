class MenuItem {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final String description;
  final String category; // 'Makanan' atau 'Minuman'
  final bool isAvailable;

  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    this.isAvailable = true,
  });
}

const List<MenuItem> kedaiMenu = [
  // --- KATEGORI MINUMAN ---
  MenuItem(
    id: 'kopi-susu-aren',
    name: 'Kopi Susu Gula Aren',
    price: 24000,
    imageUrl: 'assets/images/kopi_susu_aren.png',
    description:
        'Espresso house blend berpadu susu segar dingin dan lelehan gula aren murni.',
    category: 'Minuman',
    isAvailable: true,
  ),
  MenuItem(
    id: 'cappuccino',
    name: 'Cappuccino',
    price: 26000,
    imageUrl: 'assets/images/cappuccino.png',
    description:
        'Espresso seimbang dengan steamed milk dan foam lembut bermotif latte art daun.',
    category: 'Minuman',
    isAvailable: true,
  ),
  MenuItem(
    id: 'matcha-latte',
    name: 'Matcha Latte',
    price: 28000,
    imageUrl: 'assets/images/matcha_latte.png',
    description: 'Teh hijau matcha murni Uji berpadu dengan susu segar dingin.',
    category: 'Minuman',
    isAvailable: false, // Status Habis
  ),
  MenuItem(
    id: 'teh-melati',
    name: 'Teh Melati',
    price: 15000,
    imageUrl: 'assets/images/teh_melati.png',
    description:
        'Seduhan daun teh melati harum khas Jawa dengan aroma bunga yang menenangkan.',
    category: 'Minuman',
    isAvailable: true,
  ),
  MenuItem(
    id: 'es-jeruk',
    name: 'Es Jeruk',
    price: 18000,
    imageUrl: 'assets/images/es_jeruk.png',
    description:
        'Perasan jeruk segar asli dengan bulir citrus dan es batu sejuk.',
    category: 'Minuman',
    isAvailable: true,
  ),

  // --- KATEGORI MAKANAN ---
  MenuItem(
    id: 'roti-bakar-srikaya',
    name: 'Roti Bakar Srikaya',
    price: 22000,
    imageUrl: 'assets/images/roti_srikaya.png',
    description:
        'Dua potong roti panggang segitiga keemasan dengan lelehan selai srikaya hijau pandan legit.',
    category: 'Makanan',
    isAvailable: true,
  ),
  MenuItem(
    id: 'pisang-goreng',
    name: 'Pisang Goreng',
    price: 17000,
    imageUrl: 'assets/images/pisang_goreng.png',
    description:
        'Tiga potong pisang kepok krispi berbentuk kipas renyah di atas alas daun pisang.',
    category: 'Makanan',
    isAvailable: true,
  ),
  MenuItem(
    id: 'nasi-ayam-kemangi',
    name: 'Nasi Ayam Kemangi',
    price: 32000,
    imageUrl: 'assets/images/nasi_ayam_kemangi.png',
    description:
        'Nasi putih hangat disajikan berdampingan dengan ayam suwir rempah dan daun kemangi segar.',
    category: 'Makanan',
    isAvailable: true,
  ),
  MenuItem(
    id: 'mi-goreng-jawa',
    name: 'Mi Goreng Jawa',
    price: 29000,
    imageUrl: 'assets/images/mi_goreng_jawa.png',
    description:
        'Mi kenyal bumbu manis gurih dengan irisan telur rebus dan taburan daun bawang segar.',
    category: 'Makanan',
    isAvailable: true,
  ),
  MenuItem(
    id: 'puding-cokelat',
    name: 'Puding Cokelat',
    price: 16000,
    imageUrl: 'assets/images/puding_cokelat.png',
    description:
        'Puding cokelat pekat fluted bundt disiram vla vanila lembut yang meleleh di satu sisi.',
    category: 'Makanan',
    isAvailable: true,
  ),
];

String rupiah(int harga) =>
    'Rp ${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
const saranPenyajian = {
  'kopi-susu-aren': 'Aduk perlahan agar espresso, susu, dan gula aren menyatu.',
  'cappuccino': 'Nikmati selagi hangat saat busa susu masih lembut.',
  'matcha-latte': 'Aduk lapisan matcha dan susu sebelum dinikmati.',
  'teh-melati': 'Nikmati hangat untuk merasakan aroma melatinya.',
  'es-jeruk': 'Nikmati dingin dengan irisan jeruk segar.',
  'roti-bakar-srikaya': 'Sajikan hangat agar roti tetap renyah.',
  'pisang-goreng': 'Nikmati selagi hangat saat lapisan luarnya masih renyah.',
  'nasi-ayam-kemangi': 'Santap nasi hangat bersama ayam dan daun kemangi.',
  'mi-goreng-jawa': 'Nikmati mi hangat bersama irisan telur dan daun bawang.',
  'puding-cokelat':
      'Sajikan dingin, lalu tuangkan vla sesaat sebelum disantap.',
};
