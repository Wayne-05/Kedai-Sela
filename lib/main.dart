import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'menu.dart';

void main() => runApp(const KedaiMuthuApp());

const tinta = Color(0xFF233B30);
const kertas = Color(0xFFFAF6EF);
const durasiHero = Duration(milliseconds: 600);
const sebelumOptimasi = bool.fromEnvironment('BASELINE');

class KedaiMuthuApp extends StatelessWidget {
  const KedaiMuthuApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Kedai Muthu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Bricolage Grotesque',
          colorScheme: ColorScheme.fromSeed(seedColor: tinta),
          scaffoldBackgroundColor: kertas,
          appBarTheme: const AppBarTheme(
              backgroundColor: kertas, foregroundColor: tinta),
        ),
        home: const KatalogPage(),
      );
}

class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});
  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage>
    with SingleTickerProviderStateMixin {
  late final putaran =
      AnimationController(vsync: this, duration: const Duration(seconds: 16));
  final stok = {
    for (final menu in kedaiMenu) menu.id: ValueNotifier(menu.isAvailable)
  };
  final _searchController = TextEditingController();
  String selectedCategory = 'Semua';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    putaran.repeat();
  }

  @override
  void dispose() {
    putaran.dispose();
    _searchController.dispose();
    for (final status in stok.values) {
      status.dispose();
    }
    super.dispose();
  }

  void _resetFilter() {
    setState(() {
      selectedCategory = 'Semua';
      searchQuery = '';
      _searchController.clear();
    });
  }

  Widget katalog(Widget cangkir) {
    final query = searchQuery.trim().toLowerCase();
    final items = kedaiMenu
        .where((menu) =>
            (selectedCategory == 'Semua' ||
                menu.category == selectedCategory) &&
            menu.name.toLowerCase().contains(query))
        .toList();
    return Scaffold(
      appBar: KedaiHeader(cangkir: cangkir),
      body: SafeArea(
          child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: 1 + (items.isEmpty ? 1 : items.length),
        itemBuilder: (context, index) {
          if (index == 0)
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Menu Kedai & Panduan
                  const Text(
                    'Menu kedai',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF233B30),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ketuk untuk detail · Tekan lama untuk ubah stok',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF757875)),
                  ),
                  const SizedBox(height: 16),

                  // Kolom Pencarian Selebar Katalog
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: const Color(0xFFE2DAD0), width: 1),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Cari nama menu…',
                        hintStyle: const TextStyle(
                            color: Color(0xFF9E9991), fontSize: 14),
                        prefixIcon: const Icon(Icons.search,
                            color: Color(0xFF757875), size: 20),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                tooltip: 'Hapus pencarian',
                                icon: const Icon(Icons.close,
                                    color: Color(0xFF757875), size: 18),
                                onPressed: () {
                                  setState(() {
                                    searchQuery = '';
                                    _searchController.clear();
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tombol Kapsul Filter Kategori
                  Wrap(
                    children: const ['Semua', 'Makanan', 'Minuman'].map((cat) {
                      final isSelected = selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () => setState(() => selectedCategory = cat),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF233B30)
                                  : const Color(0xFFFAF6EF),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF233B30)
                                    : const Color(0xFFD6CFC4),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF233B30),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ]);
          if (items.isEmpty)
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded,
                        size: 48, color: Color(0xFF9E9991)),
                    const SizedBox(height: 12),
                    const Text(
                      'Menu tidak ditemukan',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF233B30)),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: _resetFilter,
                      child: const Text(
                        'Reset pencarian dan filter',
                        style: TextStyle(
                            color: Color(0xFF8B5136),
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            );
          final menu = items[index - 1];
          final status = stok[menu.id]!;
          return ValueListenableBuilder<bool>(
            key: ValueKey(menu.id),
            valueListenable: status,
            builder: (context, tersedia, _) => MenuCard(
              menu: menu,
              tersedia: tersedia,
              onToggle: () {
                status.value = !status.value;
                final messenger = ScaffoldMessenger.of(context);
                messenger.removeCurrentSnackBar();
                messenger.showSnackBar(SnackBar(
                  backgroundColor: tinta,
                  duration: const Duration(milliseconds: 1200),
                  content: Text(
                      '${menu.name}: ${status.value ? "Tersedia" : "Habis"}'),
                ));
              },
              onDetail: () => Navigator.of(context).push(PageRouteBuilder<void>(
                transitionDuration: durasiHero,
                reverseTransitionDuration: durasiHero,
                pageBuilder: (_, animation, secondary) =>
                    DetailPage(item: menu, tersedia: tersedia),
                transitionsBuilder: (_, animation, secondary, child) =>
                    FadeTransition(opacity: animation, child: child),
              )),
            ),
          );
        },
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    const ikon = KedaiHeader.cupIcon;
    if (sebelumOptimasi) {
      // Varian pembanding: seluruh katalog dibangun kembali setiap tick.
      return AnimatedBuilder(
          animation: putaran,
          builder: (_, child) => katalog(Transform.rotate(
              angle: putaran.value * 2 * math.pi, child: ikon)));
    }
    return katalog(RepaintBoundary(
        child: AnimatedBuilder(
      animation: putaran,
      child: ikon,
      builder: (_, child) =>
          Transform.rotate(angle: putaran.value * 2 * math.pi, child: child),
    )));
  }
}

class KedaiHeader extends StatelessWidget implements PreferredSizeWidget {
  const KedaiHeader(
      {super.key, this.showBackButton = false, this.cangkir = cupIcon});
  final bool showBackButton;
  final Widget cangkir;
  static const cupIcon =
      Icon(Icons.local_cafe_outlined, color: tinta, size: 19);

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) => AppBar(
        toolbarHeight: 68,
        backgroundColor: const Color(0xFFE4EDDF),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: showBackButton
            ? const BackButton(color: tinta)
            : const SizedBox.shrink(),
        leadingWidth: 48,
        titleSpacing: 0,
        title: Row(children: [
          Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x14233B30),
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ]),
              child: cangkir),
          const SizedBox(width: 12),
          const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                Text('Kedai Muthu',
                    style: TextStyle(
                        color: tinta,
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
                Text('Bistro & Roastery',
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8B5136),
                        fontWeight: FontWeight.w600)),
              ])),
        ]),
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                  radius: 17,
                  backgroundColor: tinta,
                  child: Icon(Icons.person_outline,
                      color: Colors.white, size: 19)))
        ],
      );
}

class MenuCard extends StatelessWidget {
  const MenuCard(
      {super.key,
      required this.menu,
      required this.tersedia,
      required this.onToggle,
      required this.onDetail});
  final MenuItem menu;
  String get nama => menu.name;
  int get harga => menu.price;
  final bool tersedia;
  final VoidCallback onToggle;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Semantics(
          button: true,
          value: tersedia ? 'Tersedia' : 'Habis',
          child: GestureDetector(
            onLongPress: onToggle,
            onTap: onDetail,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: tersedia ? 1 : 0.4,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    menu.category == 'Minuman'
                        ? const Color(0xFFF3F3E9)
                        : const Color(0xFFFBEEE2),
                  ]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFDDD8CB)),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x132C3125),
                        blurRadius: 8,
                        offset: Offset(0, 3))
                  ],
                ),
                child: Row(children: [
                  IkonMenu(menu: menu),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(nama,
                            style: const TextStyle(
                                color: tinta,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(rupiah(harga),
                                  style: const TextStyle(
                                      color: Color(0xFF8B5136),
                                      fontWeight: FontWeight.w600)),
                              Text(tersedia ? 'Tersedia' : 'Habis',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: tersedia
                                          ? const Color(0xFF527259)
                                          : const Color(0xFFA83C31))),
                            ]),
                      ])),
                  const Icon(Icons.chevron_right, color: tinta),
                ]),
              ),
            ),
          ),
        ),
      );
}

class IkonMenu extends StatelessWidget {
  const IkonMenu({super.key, required this.menu, this.besar = false});
  final MenuItem menu;
  final bool besar;

  @override
  Widget build(BuildContext context) {
    final sisi = besar ? 232.0 : 56.0;
    final simbol = Image.asset(menu.imageUrl,
        fit: BoxFit.cover, excludeFromSemantics: true);
    return Hero(
      tag: menu.id,
      createRectTween: (awal, akhir) =>
          MaterialRectCenterArcTween(begin: awal, end: akhir),
      flightShuttleBuilder: (_, animasi, arah, asal, tujuan) => AnimatedBuilder(
        animation: animasi,
        child: simbol,
        builder: (_, child) => ClipRRect(
          borderRadius: BorderRadius.circular(28 * (1 - animasi.value)),
          child: child,
        ),
      ),
      child: Container(
        width: sisi,
        height: sisi,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: kertas, shape: besar ? BoxShape.rectangle : BoxShape.circle),
        child: simbol,
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final MenuItem item;
  final bool tersedia;

  const DetailPage({super.key, required this.item, required this.tersedia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EF),
      appBar: const KedaiHeader(showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Kanvas Persegi 232 × 232 px (Warna Gula Aren / Latar Artisanal)
            Center(child: IkonMenu(menu: item, besar: true)),
            const SizedBox(height: 24),

            // Badge Khas Muthu & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RACIKAN KHAS MUTHU',
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: Color(0xD98B5136),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tersedia
                        ? const Color(0xFF527259).withAlpha(31)
                        : const Color(0xFFC04738).withAlpha(31),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 3.5,
                        backgroundColor: tersedia
                            ? const Color(0xFF527259)
                            : const Color(0xFFC04738),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        tersedia ? 'Tersedia' : 'Habis',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: tersedia
                              ? const Color(0xFF527259)
                              : const Color(0xFFC04738),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Nama Menu & Harga
            Text(
              item.name,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF233B30),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              rupiah(item.price),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8B5136),
              ),
            ),
            const SizedBox(height: 20),

            const Divider(color: Color(0xFFE5DDD0)),
            const SizedBox(height: 14),

            // Deskripsi Seduhan / Hidangan
            Text(
              item.category == 'Minuman'
                  ? 'DESKRIPSI SEDUHAN'
                  : 'DESKRIPSI HIDANGAN',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: Color(0xFF757875),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF233B30),
              ),
            ),
            const SizedBox(height: 20),

            // Saran Penyajian
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F2E7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8E2D5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.tips_and_updates_outlined,
                      size: 18, color: Color(0xFF8B5136)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      saranPenyajian[item.id]!,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF233B30),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
