import 'package:equatable/equatable.dart';

/// Represents a point with 2D integer coordinates (x, y) on a grid.
class Point extends Equatable {
  final int x;
  final int y;

  const Point({
    required this.x,
    required this.y,
  });

  /// Factory constructor to create a [Point] from a JSON map.
  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      x: json['x'] as int,
      y: json['y'] as int,
    );
  }

  /// Converts this [Point] instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() => '($x,$y)';
}
