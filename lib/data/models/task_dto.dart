import 'package:equatable/equatable.dart';

import 'point_dto.dart';

/// Data Transfer Object representing an individual pathfinding task received from GET API response.
class TaskDto extends Equatable {
  final String id;
  final List<String> field;
  final PointDto start;
  final PointDto end;

  const TaskDto({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  /// Factory constructor to parse [TaskDto] from JSON response.
  factory TaskDto.fromJson(Map<String, dynamic> json) {
    final rawField = json['field'] as List<dynamic>;
    final fieldList = rawField.map((e) => e.toString()).toList();

    return TaskDto(
      id: json['id'].toString(),
      field: fieldList,
      start: PointDto.fromJson(json['start'] as Map<String, dynamic>),
      end: PointDto.fromJson(json['end'] as Map<String, dynamic>),
    );
  }

  /// Serializes [TaskDto] to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field': field,
      'start': start.toJson(),
      'end': end.toJson(),
    };
  }

  /// Converts 1D field list of string rows into a 2D matrix (`List<List<String>>`) for PathfinderService.
  List<List<String>> toGrid() {
    return field.map((row) => row.split('')).toList();
  }

  @override
  List<Object?> get props => [id, field, start, end];
}
