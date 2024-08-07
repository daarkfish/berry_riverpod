class Berry {
  final int id;
  final String name;
  final int growthTime;
  final int maxHarvest;
  final int size;

  Berry({
    required this.id,
    required this.name,
    required this.growthTime,
    required this.maxHarvest,
    required this.size,
  });

  factory Berry.fromJson(Map<String, dynamic> json) {
    return Berry(
      id: json['id'],
      name: json['name'],
      growthTime: json['growth_time'],
      maxHarvest: json['max_harvest'],
      size: json['size'],
    );
  }
}
