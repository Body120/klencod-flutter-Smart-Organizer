import 'dart:convert';
import 'package:flutter/widgets.dart';

class InstalledApp {
  const InstalledApp({
    required this.name,
    required this.packageName,
    required this.iconBase64,
  });

  final String name;
  final String packageName;
  final String iconBase64;

  factory InstalledApp.fromMap(Map<dynamic, dynamic> map) {
    return InstalledApp(
      name: map['name']?.toString() ?? 'Unknown',
      packageName: map['packageName']?.toString() ?? '',
      iconBase64: map['icon']?.toString() ?? '',
    );
  }

  ImageProvider? get iconProvider {
    try {
      if (iconBase64.isEmpty) return null;
      return MemoryImage(base64Decode(iconBase64));
    } catch (_) {
      return null;
    }
  }
}
