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
  static Color get white => const Color(0xFFFFFFFF);
  static Color get black => const Color(0xFF000000);

  static Color secondary = Colors.grey;
  static Color primary = Colors.black;
  static Color accent = Colors.orange;
  static Color brightness = Colors.white;

  static Color defaultSecondary = Colors.grey;
  static Color defaultPrimary = const Color(0xFF000000);
  static Color defaultAccent = Colors.orange;
  static Color defaultBrightness = Colors.white;

  static Color text = Colors.black;
}
