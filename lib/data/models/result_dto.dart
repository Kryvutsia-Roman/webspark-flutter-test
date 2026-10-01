import 'package:equatable/equatable.dart';

import '../../domain/point_entity.dart';
import 'point_dto.dart';

/// Data Transfer Object representing the result payload sent in POST API request.
class ResultDto extends Equatable {
  final String id;
  final ResultDataDto result;

  const ResultDto({
    required this.id,
    required this.result,
  });

  /// Factory constructor to construct a [ResultDto] from task [id] and domain [path] points.
  factory ResultDto.fromPath({
    required String id,
    required List<Point> path,
  }) {
    final steps = path.map((p) => PointDto.fromEntity(p)).toList();
    final pathString = path.map((p) => '(${p.x},${p.y})').join('->');
    return ResultDto(
      id: id,
      result: ResultDataDto(
        steps: steps,
        path: pathString,
      ),
    );
  }

  /// Deserializes a [ResultDto] from JSON data.
  factory ResultDto.fromJson(Map<String, dynamic> json) {
    return ResultDto(
      id: json['id'].toString(),
      result: ResultDataDto.fromJson(json['result'] as Map<String, dynamic>),
    );
  }

  /// Serializes [ResultDto] to JSON format for POST payload.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'result': result.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, result];
}

/// Holds steps and path string representation inside [ResultDto].
class ResultDataDto extends Equatable {
  final List<PointDto> steps;
  final String path;

  const ResultDataDto({
    required this.steps,
    required this.path,
  });

  /// Deserializes [ResultDataDto] from JSON map.
  factory ResultDataDto.fromJson(Map<String, dynamic> json) {
    final stepsList = json['steps'] as List<dynamic>;
    return ResultDataDto(
      steps: stepsList
          .map((e) => PointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      path: json['path'] as String,
    );
  }

  /// Serializes [ResultDataDto] into JSON object format with steps array `[{"x": 1, "y": 2}, ...]`.
  Map<String, dynamic> toJson() {
    return {
      'steps': steps.map((e) => e.toJson()).toList(),
      'path': path,
    };
  }

  @override
  List<Object?> get props => [steps, path];
}
