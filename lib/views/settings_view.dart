import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clock_settings.dart';
import '../services/weather_service.dart';
import '../services/font_service.dart';
import 'weather_forecast_dialog.dart';

class SettingsDialog extends StatelessWidget {
  final Color textColor;
  final Color bgColor;

  const SettingsDialog({
    super.key,
    required this.textColor,
    required this.bgColor,
  });

  static Future<void> show(BuildContext context, Color textColor, Color bgColor) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SettingsDialog(textColor: textColor, bgColor: bgColor),
    );
  }

  String _getThemeDisplayName(ThemePreset preset) {
    switch (preset) {
      case ThemePreset.battambang:
        return "🍌 ខេត្តបាត់ដំបង (Battambang)";
      case ThemePreset.siemReap:
        return "🏛️ ខេត្តសៀមរាប (Siem Reap)";
      case ThemePreset.phnomPenh:
        return "👑 រាជធានីភ្នំពេញ (Phnom Penh)";
      case ThemePreset.kep:
        return "🦀 ខេត្តកែប (Kep)";
      case ThemePreset.sihanoukville:
        return "🏖️ ខេត្តព្រះសីហនុ (Sihanoukville)";
      case ThemePreset.kampot:
        return "🌶️ ខេត្តកំពត (Kampot)";
      case ThemePreset.mondulkiri:
        return "🐘 ខេត្តមណ្ឌលគិរី (Mondulkiri)";
      case ThemePreset.ratanakiri:
        return "💎 ខេត្តរតនគិរី (Ratanakiri)";
      case ThemePreset.preahVihear:
        return "🏔️ ខេត្តព្រះវិហារ (Preah Vihear)";
      case ThemePreset.kampongChhnang:
        return "🏺 ខេត្តកំពង់ឆ្នាំង (Kampong Chhnang)";
      case ThemePreset.kampongSpeu:
        return "🌴 ខេត្តកំពង់ស្ពឺ (Kampong Speu)";
      case ThemePreset.kampongThom:
        return "🐟 ខេត្តកំពង់ធំ (Kampong Thom)";
      case ThemePreset.kampongCham:
        return "🛥️ ខេត្តកំពង់ចាម (Kampong Cham)";
      case ThemePreset.kratie:
        return "🎋 ខេត្តក្រចេះ (Kratie)";
      case ThemePreset.stungTreng:
        return "🌿 ខេត្តស្ទឹងត្រែង (Stung Treng)";
      case ThemePreset.preyVeng:
        return "🌾 ខេត្តព្រៃវែង (Prey Veng)";
      case ThemePreset.svayRieng:
        return "🚣 ខេត្តស្វាយរៀង (Svay Rieng)";
      case ThemePreset.takeo:
        return "🏺 ខេត្តតាកែវ (Takeo)";
      case ThemePreset.pursat:
        return "⛰️ ខេត្តពោធិ៍សាត់ (Pursat)";
      case ThemePreset.banteayMeanchey:
        return "🌾 ខេត្តបន្ទាយមានជ័យ (Banteay Meanchey)";
      case ThemePreset.oddarMeanchey:
        return "🍃 ខេត្តឧត្តរមានជ័យ (Oddar Meanchey)";
      case ThemePreset.pailin:
        return "🌳 ខេត្តប៉ៃលិន (Pailin)";
      case ThemePreset.kohKong:
        return "🌄 ខេត្តកោះកុង (Koh Kong)";
      case ThemePreset.tboungKhmum:
        return "🌾 ខេត្តត្បូងឃ្មុំ (Tboung Khmum)";
      case ThemePreset.kandal:
        return "🏛️ ខេត្តកណ្តាល (Kandal)";
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ClockSettings>(context);
    final isKhmer = settings.useKhmerDigits;

    return Dialog(
      backgroundColor: const Color(0xFF111111),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF1F1F1F), width: 1.0),
      ),
      child: Container(
        width: 540,
        height: 680,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Settings Dialog Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.tune_rounded, color: textColor, size: 26),
                    const SizedBox(width: 10),
                    Text(
                      isKhmer ? '⚙️ ការកំណត់' : '⚙️ Settings',
                      style: FontService.getTextStyle(
                        settings.fontFamily,
                        TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: textColor),
                  tooltip: isKhmer ? 'បិទ' : 'Close',
                ),
              ],
            ),
            Divider(color: textColor.withOpacity(0.2), height: 24),

            // Settings Content Body (Scrollable)
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // Section 1: Language Switcher
                  _buildSectionTitle(isKhmer ? '🌐 ភាសា' : '🌐 Language'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildChoiceChip(
                          label: isKhmer ? '🇰🇭 ភាសាខ្មែរ' : '🇰🇭 Khmer',
                          selected: settings.useKhmerDigits,
                          onSelected: () => settings.toggleKhmerDigits(true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildChoiceChip(
                          label: isKhmer ? '🇬🇧 ភាសាអង់គ្លេស' : '🇬🇧 English',
                          selected: !settings.useKhmerDigits,
                          onSelected: () => settings.toggleKhmerDigits(false),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // Section 2: Themes (Dropdown Selector)
                  _buildSectionTitle(isKhmer ? '🎨 ប្រធានបទខេត្ត/ក្រុង' : '🎨 Province Themes'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ThemePreset>(
                        value: settings.themePreset,
                        isExpanded: true,
                        dropdownColor: bgColor,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: textColor),
                        items: ThemePreset.values.map((preset) {
                          return DropdownMenuItem<ThemePreset>(
                            value: preset,
                            child: Text(
                              _getThemeDisplayName(preset),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newPreset) {
                          if (newPreset != null) {
                            settings.setTheme(newPreset);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Section 3: Google Khmer Fonts Dropdown
                  _buildSectionTitle(isKhmer ? '🔤 ពុម្ពអក្សរខ្មែរ' : '🔤 Google Khmer Fonts'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: FontService.availableKhmerFonts.contains(settings.fontFamily) ? settings.fontFamily : 'Kantumruy Pro',
                        isExpanded: true,
                        dropdownColor: bgColor,
                        icon: Icon(Icons.font_download_outlined, color: textColor),
                        items: FontService.availableKhmerFonts.map((font) {
                          return DropdownMenuItem<String>(
                            value: font,
                            child: Text(
                              font,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: font == settings.fontFamily ? FontWeight.bold : FontWeight.normal,
                                color: textColor,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newFont) {
                          if (newFont != null) {
                            settings.setFontFamily(newFont);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Section 4: Time Format
                  _buildSectionTitle(isKhmer ? '⏰ ទម្រង់ម៉ោង' : '⏰ Time Format'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildChoiceChip(
                          label: isKhmer ? '១២ ម៉ោង (AM / PM)' : '12-Hour (AM / PM)',
                          selected: settings.timeFormat == TimeFormat.h12,
                          onSelected: () => settings.setTimeFormat(TimeFormat.h12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildChoiceChip(
                          label: isKhmer ? '២៤ ម៉ោង' : '24-Hour',
                          selected: settings.timeFormat == TimeFormat.h24,
                          onSelected: () => settings.setTimeFormat(TimeFormat.h24),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // Section 5: Display Mode (Clock / Calendar)
                  _buildSectionTitle(isKhmer ? '📱 របៀបបង្ហាញ' : '📱 Display Mode'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildChoiceChip(
                          label: isKhmer ? '🕒 នាឡិកា' : '🕒 Clock',
                          selected: settings.displayMode == DisplayMode.clock,
                          onSelected: () => settings.setDisplayMode(DisplayMode.clock),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildChoiceChip(
                          label: isKhmer ? '📅 ប្រតិទិន' : '📅 Calendar',
                          selected: settings.displayMode == DisplayMode.calendar,
                          onSelected: () => settings.setDisplayMode(DisplayMode.calendar),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // Section 5.5: Live Wallpaper Selection
                  _buildSectionTitle(isKhmer ? '🖼️ រូបភាពរស់រវើក (Live Wallpaper)' : '🖼️ Live Wallpaper'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChoiceChip(
                        label: isKhmer ? '🚫 បិទ (AMOLED)' : '🚫 Off (AMOLED)',
                        selected: settings.liveWallpaperMode == LiveWallpaperMode.off,
                        onSelected: () => settings.setLiveWallpaperMode(LiveWallpaperMode.off),
                      ),
                      _buildChoiceChip(
                        label: isKhmer ? '✨ ពន្លឺអូរ៉ា' : '✨ Aura Pulse',
                        selected: settings.liveWallpaperMode == LiveWallpaperMode.auraPulse,
                        onSelected: () => settings.setLiveWallpaperMode(LiveWallpaperMode.auraPulse),
                      ),
                      _buildChoiceChip(
                        label: isKhmer ? '🌌 ផ្កាយអវកាស' : '🌌 Cosmic Stars',
                        selected: settings.liveWallpaperMode == LiveWallpaperMode.cosmicStars,
                        onSelected: () => settings.setLiveWallpaperMode(LiveWallpaperMode.cosmicStars),
                      ),
                      _buildChoiceChip(
                        label: isKhmer ? '🌧️ ទឹកភ្លៀង Zen' : '🌧️ Gentle Rain',
                        selected: settings.liveWallpaperMode == LiveWallpaperMode.gentleRain,
                        onSelected: () => settings.setLiveWallpaperMode(LiveWallpaperMode.gentleRain),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // Section 6: Display Toggles
                  _buildSectionTitle(isKhmer ? '👁️ ជម្រើសបង្ហាញ' : '👁️ Display Options'),
                  const SizedBox(height: 8),
                  _buildSwitchTile(
                    title: isKhmer ? 'ប្រើប្រាស់លេខខ្មែរ' : 'Khmer Digits',
                    value: settings.useKhmerDigits,
                    onChanged: (val) => settings.toggleKhmerDigits(val),
                  ),
                  _buildSwitchTile(
                    title: isKhmer ? 'បង្ហាញវិនាទី' : 'Show Seconds',
                    value: settings.showSeconds,
                    onChanged: (val) => settings.toggleShowSeconds(val),
                  ),
                  _buildSwitchTile(
                    title: isKhmer ? 'បង្ហាញកាលបរិច្ឆេទ' : 'Show Date',
                    value: settings.showDate,
                    onChanged: (val) => settings.toggleShowDate(val),
                  ),
                  _buildSwitchTile(
                    title: isKhmer ? 'បង្ហាញអាកាសធាតុ' : 'Show Weather',
                    value: settings.showWeather,
                    onChanged: (val) => settings.toggleShowWeather(val),
                  ),
                  _buildSwitchTile(
                    title: 'បង្ហាញសុភាសិតខ្មែរ (Daily Proverb)',
                    value: settings.showProverb,
                    onChanged: (val) => settings.toggleShowProverb(val),
                  ),
                  _buildSwitchTile(
                    title: 'បង្ហាញឆ្នាំរាសី និងស័កខ្មែរ (Khmer Zodiac & Era)',
                    value: settings.showKhmerZodiac,
                    onChanged: (val) => settings.toggleShowKhmerZodiac(val),
                  ),
                  _buildSwitchTile(
                    title: 'បង្ហាញរាប់ថយក្រោយថ្ងៃបុណ្យជាតិ (Khmer Holidays)',
                    value: settings.showKhmerHolidays,
                    onChanged: (val) => settings.toggleShowKhmerHolidays(val),
                  ),
                  _buildSwitchTile(
                    title: 'បង្ហាញសញ្ញា ថ្ងៃសីល (Khmer Holy Days)',
                    value: settings.showKhmerHolyDays,
                    onChanged: (val) => settings.toggleShowKhmerHolyDays(val),
                  ),

                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final weather = await WeatherService.fetchLiveWeatherForTheme(settings.themePreset);
                      if (context.mounted) {
                        WeatherForecastDialog.show(context, weather, textColor, bgColor);
                      }
                    },
                    icon: Icon(Icons.cloud_sync_outlined, color: textColor),
                    label: Text(
                      'មើលការព្យាករណ៍ & ប្រវត្តិកំណត់ត្រា (៥ ថ្ងៃមុន - ៥ ថ្ងៃបន្ទាប់)',
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: textColor.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Section 4: System Options
                  _buildSectionTitle('⚙️ ការកំណត់ប្រព័ន្ធ (System Options)'),
                  const SizedBox(height: 8),
                  _buildSwitchTile(
                    title: 'ស្ថិតនៅលើគេជានិច្ច (Always On Top)',
                    value: settings.alwaysOnTop,
                    onChanged: (val) => settings.toggleAlwaysOnTop(val),
                  ),
                  _buildSwitchTile(
                    title: isKhmer ? 'ស្វ័យប្រវត្តទៅ Screen ទី២ (Auto 2nd Screen)' : 'Auto Move to 2nd Screen',
                    value: settings.autoSecondaryDisplay,
                    onChanged: (val) => settings.toggleAutoSecondaryDisplay(val),
                  ),
                  _buildSwitchTile(
                    title: isKhmer ? 'បង្វិលភីកសែល OLED (ការពារដិត)' : 'OLED Pixel Shift',
                    value: settings.oledPixelShift,
                    onChanged: (val) => settings.toggleOledPixelShift(val),
                  ),

                  const SizedBox(height: 24),
                  // Section 7: User Guide & Shortcuts
                  _buildSectionTitle(isKhmer ? '⌨️ គ្រាប់ចុចកាត់ (Keyboard Shortcuts)' : '⌨️ Keyboard Shortcuts Guide'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _buildShortcutRow('N', isKhmer ? 'ប្តូរប្រធានបទលឿន (Cycle 25 Themes)' : 'Cycle Themes (N)'),
                        const SizedBox(height: 6),
                        _buildShortcutRow('C', isKhmer ? 'ប្តូររវាង នាឡិកា និង ប្រតិទិន' : 'Toggle Clock / Calendar (C)'),
                        const SizedBox(height: 6),
                        _buildShortcutRow('T', isKhmer ? 'ថ្ងៃនេះ (Today) / នាឡិការាប់ថយក្រោយ' : 'Jump to Today / Focus Timer (T)'),
                        const SizedBox(height: 6),
                        _buildShortcutRow('1', isKhmer ? 'ប្តូររវាង លេខខ្មែរ និង លេខអារ៉ាប់' : 'Toggle Khmer / Arabic Digits (1)'),
                        const SizedBox(height: 6),
                        _buildShortcutRow('S  /  ,', isKhmer ? 'បើកផ្ទាំងការកំណត់ (Settings)' : 'Open Settings (S)'),
                        const SizedBox(height: 6),
                        _buildShortcutRow('F  /  F11', isKhmer ? 'បើក/បិទ អេក្រង់ពេញ (Fullscreen)' : 'Toggle Fullscreen (F)'),
                        const SizedBox(height: 6),
                        _buildShortcutRow('←  /  →', isKhmer ? 'រំកិលខែមុន / ខែបន្ទាប់ (Calendar Mode)' : 'Previous / Next Month (← / →)'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Section 8: About Developer
                  _buildSectionTitle(isKhmer ? '👨‍💻 អំពីអ្នកអភិវឌ្ឍន៍ (About Developer)' : '👨‍💻 About Developer'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: textColor.withOpacity(0.12), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: textColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.code_rounded, color: textColor, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isKhmer ? 'វ៉ាត សត្យា (Vath Sathya)' : 'Vath Sathya',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Software Engineer & Creator of Zen Clock',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: textColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: textColor.withOpacity(0.12), height: 1),
                        const SizedBox(height: 12),
                        Text(
                          isKhmer
                              ? 'Zen Clock ត្រូវបានបង្កើតឡើងយ៉ាងសម្រិតសម្រាំងបំផុត ដើម្បីរួមចំណែកលើកស្ទួយវប្បធម៌ខ្មែរ ប្រទិន្នទិនចន្ទគតិ ថ្ងៃសីល សុភាសិត ព្រមទាំងប្រធានបទ ២៥ ខេត្តក្រុង នៃព្រះរាជាណាចក្រកម្ពុជា ជាមួយស្ថាបត្យកម្ម AMOLED ល្បឿនលឿន & ស្រាលបំផុត។'
                              : 'Zen Clock is crafted with passion for Khmer culture, lunar calendar, holy days, and 25 Cambodian province themes with ultra-lightweight AMOLED performance for Linux, Windows, and Android.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: textColor.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'GitHub Repository',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textColor.withOpacity(0.7),
                              ),
                            ),
                            SelectableText(
                              'github.com/vathsathya/zen-clock',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textColor.withOpacity(0.9),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  // Reset Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      await settings.resetToDefaults();
                    },
                    icon: Icon(Icons.refresh_rounded, color: textColor),
                    label: Text(
                      isKhmer ? 'កំណត់ឡើងវិញ (Reset)' : 'Reset to Defaults',
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: textColor.withOpacity(0.12),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildShortcutRow(String key, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: textColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            key,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: textColor.withOpacity(0.9),
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? textColor.withOpacity(0.22) : textColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor.withOpacity(0.9),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: textColor,
            activeTrackColor: textColor.withOpacity(0.3),
            inactiveThumbColor: textColor.withOpacity(0.5),
            inactiveTrackColor: textColor.withOpacity(0.1),
          ),
        ],
      ),
    );
  }
}
