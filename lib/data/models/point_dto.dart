import 'package:equatable/equatable.dart';

import '../../domain/point_entity.dart';

/// Data Transfer Object representing a 2D grid point for API serialization.
class PointDto extends Equatable {
  final int x;
  final int y;

  const PointDto({
    required this.x,
    required this.y,
  });

  /// Factory constructor to create a [PointDto] from a domain [Point] entity.
  factory PointDto.fromEntity(Point point) {
    return PointDto(
      x: point.x,
      y: point.y,
    );
  }

  /// Converts this DTO into a domain [Point] entity.
  Point toEntity() {
    return Point(
      x: x,
      y: y,
    );
  }

  /// Deserializes a [PointDto] from JSON data (handles int or string representation).
  factory PointDto.fromJson(Map<String, dynamic> json) {
    return PointDto(
      x: json['x'] is int ? json['x'] as int : int.parse(json['x'].toString()),
      y: json['y'] is int ? json['y'] as int : int.parse(json['y'].toString()),
    );
  }

  /// Serializes this [PointDto] into JSON object format `{"x": 1, "y": 2}`.
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  @override
  List<Object?> get props => [x, y];
}
