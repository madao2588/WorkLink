class BadgeItem {
  const BadgeItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.earnedAt,
  });

  final String id;
  final String name;
  final String description;
  final String icon;
  final DateTime earnedAt;
}
