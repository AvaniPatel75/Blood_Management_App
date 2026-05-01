import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget destination; // Added destination screen

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.destination,
  });
}