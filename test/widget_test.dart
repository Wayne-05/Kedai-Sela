import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_sela/main.dart';
import 'package:kedai_sela/menu.dart';

void main() {
  testWidgets('Stok berubah pada kartu dan detail, lalu bisa dipulihkan',
      (tester) async {
    await tester.pumpWidget(const KedaiMuthuApp());
    final nama = find.text(kedaiMenu.first.name);
    await tester.longPress(nama);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final kartu = find.widgetWithText(MenuCard, kedaiMenu.first.name);
    final efek =
        find.descendant(of: kartu, matching: find.byType(AnimatedOpacity));
    expect(tester.widget<AnimatedOpacity>(efek).opacity, 0.4);

    await tester.tap(nama);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 650));
    expect(find.byType(DetailPage), findsOneWidget);
    expect(find.text('Habis'), findsOneWidget);
    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 650));
    await tester.longPress(nama);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.descendant(of: kartu, matching: find.text('Tersedia')),
        findsOneWidget);
    expect(tester.widget<AnimatedOpacity>(efek).opacity, 1);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('Pencarian, kategori, stok dan reset saling konsisten',
      (tester) async {
    await tester.pumpWidget(const KedaiMuthuApp());
    final posisiLogo = tester.getTopLeft(find.text('Kedai Muthu'));
    await tester.tap(find.text('Makanan'));
    await tester.pump();
    expect(find.text('Kopi Susu Gula Aren'), findsNothing);
    await tester.enterText(find.byType(TextField), '  ROTI  ');
    await tester.pump();
    final roti = find.text('Roti Bakar Srikaya');
    expect(find.byType(MenuCard), findsOneWidget);
    await tester.longPress(roti);
    await tester.pump();
    await tester.tap(roti);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 650));
    expect(tester.getTopLeft(find.text('Kedai Muthu')), posisiLogo);
    expect(find.text('Habis'), findsOneWidget);
    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 650));
    expect(find.byType(MenuCard), findsOneWidget);
    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();
    expect(find.text('Pisang Goreng'), findsOneWidget);
    expect(find.text('Kopi Susu Gula Aren'), findsNothing);
    await tester.enterText(find.byType(TextField), 'kopi');
    await tester.pump();
    expect(find.text('Menu tidak ditemukan'), findsOneWidget);
    await tester.tap(find.text('Reset pencarian dan filter'));
    await tester.pump();
    expect(find.text('Kopi Susu Gula Aren'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
