import 'dart:ui';

import 'package:flutter/material.dart';

// For a sky-tone-inspired color theme, you can consider using various shades of blue, soft grays, and a hint of warm tones to capture the essence of the sky from dawn to dusk. Here's a palette idea:

// Dawn Light (#FFE7C6) - A soft peach tone representing the early morning light.
// Sky Blue (#87CEEB) - A clear sky blue, fresh and bright.
// Cloud Gray (#D3D3D3) - A light gray, like a fluffy cloud.
// Twilight Purple (#6A5ACD) - A soft purple to evoke the evening sky.
// Midnight Blue (#191970) - A deep blue for a night-time feel.
// You can use the lighter tones for backgrounds and the darker tones for accents or text to create a harmonious, sky-inspired theme. Would you like to see how this looks in a sample UI design?

// contrast
// Twilight Purple (#6A5ACD) or Dawn Light (#FFE7C6).
//Sunset Coral (#FF6F61):

// Cloudy Gray (#E0E0E0): A soft, neutral gray that resembles overcast skies, giving the empty state a calm and unobtrusive appearance.

// Pale Blue (#B0E0E6): A very light blue, almost like a misty sky, which conveys the idea of emptiness without feeling too stark.

// Foggy White (#F8F8FF): A nearly white tone with a hint of blue, similar to a foggy morning sky, perfect for a minimalist and clean look.
class ColorKeys {
  static Color get screenBgColor => const Color.fromARGB(255, 243, 243, 243);
  static Color get white => const Color(0xFFFFFFFF);
  static Color get black => const Color(0xFF000000);

  static Color get dawnLight2 => const Color.fromRGBO(255, 255, 204, 1);
  static Color get dawnLight => const Color(0xFFFFE7C6);
  static Color get dawnDark => const Color.fromARGB(255, 255, 190, 99);
  static Color get skyBlue => const Color(0xFF87CEEB);
  static Color get cloudGray => const Color(0xFFD3D3D3);
  static Color get twilightPurple => const Color(0xFF6A5ACD);
  static Color get midnightBlue => const Color(0xFF191970);
  static Color get primary => midnightBlue;

  static Color get sunsetCoral => const Color(0xFFFF6F61);

  static Color get cloudyGray => const Color(0xFFE0E0E0);
  static Color get paleBlue => const Color(0xFFB0E0E6);
  static Color get foggyWhite => const Color(0xFFF8F8FF);

  static Color get orangeBtn => Colors.orange;

  static Color get labelNormal => Colors.black87;
}
