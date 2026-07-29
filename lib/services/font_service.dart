import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontService {
  static final Map<String, TextStyle> _styleCache = {};

  static const List<String> availableKhmerFonts = [
    'Kantumruy Pro',
    'Battambang',
    'Siemreap',
    'Moul',
    'Khmer',
    'Preahvihear',
    'Dangrek',
    'Bokor',
    'Kdam Thmor Pro',
    'Hanuman',
    'Fasthand',
    'Freehand',
    'Taprom',
    'Content',
    'Chenla',
    'Nokora',
    'Suwannaphum',
    'Koulen',
    'Bayon',
    'Odor Mean Chey',
  ];

  static TextStyle getTextStyle(String fontName, TextStyle baseStyle) {
    final key = "${fontName}_${baseStyle.fontSize}_${baseStyle.fontWeight}_${baseStyle.color?.toARGB32()}";
    if (_styleCache.containsKey(key)) {
      return _styleCache[key]!;
    }

    TextStyle style;
    try {
      switch (fontName) {
        case 'Battambang':
          style = GoogleFonts.battambang(textStyle: baseStyle);
          break;
        case 'Siemreap':
          style = GoogleFonts.siemreap(textStyle: baseStyle);
          break;
        case 'Moul':
          style = GoogleFonts.moul(textStyle: baseStyle);
          break;
        case 'Khmer':
          style = GoogleFonts.khmer(textStyle: baseStyle);
          break;
        case 'Preahvihear':
          style = GoogleFonts.preahvihear(textStyle: baseStyle);
          break;
        case 'Dangrek':
          style = GoogleFonts.dangrek(textStyle: baseStyle);
          break;
        case 'Bokor':
          style = GoogleFonts.bokor(textStyle: baseStyle);
          break;
        case 'Kdam Thmor Pro':
          style = GoogleFonts.kdamThmorPro(textStyle: baseStyle);
          break;
        case 'Hanuman':
          style = GoogleFonts.hanuman(textStyle: baseStyle);
          break;
        case 'Fasthand':
          style = GoogleFonts.fasthand(textStyle: baseStyle);
          break;
        case 'Freehand':
          style = GoogleFonts.freehand(textStyle: baseStyle);
          break;
        case 'Taprom':
          style = GoogleFonts.taprom(textStyle: baseStyle);
          break;
        case 'Content':
          style = GoogleFonts.content(textStyle: baseStyle);
          break;
        case 'Chenla':
          style = GoogleFonts.chenla(textStyle: baseStyle);
          break;
        case 'Nokora':
          style = GoogleFonts.nokora(textStyle: baseStyle);
          break;
        case 'Suwannaphum':
          style = GoogleFonts.suwannaphum(textStyle: baseStyle);
          break;
        case 'Koulen':
          style = GoogleFonts.koulen(textStyle: baseStyle);
          break;
        case 'Bayon':
          style = GoogleFonts.bayon(textStyle: baseStyle);
          break;
        case 'Odor Mean Chey':
          style = GoogleFonts.odorMeanChey(textStyle: baseStyle);
          break;
        case 'Kantumruy Pro':
        default:
          style = GoogleFonts.kantumruyPro(textStyle: baseStyle);
          break;
      }
    } catch (_) {
      style = GoogleFonts.kantumruyPro(textStyle: baseStyle);
    }

    // Apply height metrics for crisp Khmer glyph rendering without clipping
    style = style.copyWith(height: baseStyle.height ?? 1.25);
    _styleCache[key] = style;
    return style;
  }
}
