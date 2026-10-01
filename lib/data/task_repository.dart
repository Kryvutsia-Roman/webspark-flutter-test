import 'api_client.dart';
import 'models/result_dto.dart';
import 'models/task_dto.dart';

/// Repository for fetching pathfinding tasks and sending results.
class TaskRepository {
  final ApiClient _apiClient;

  TaskRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Fetches the list of pathfinding tasks from [baseUrl].
  Future<List<TaskDto>> fetchTasks(String baseUrl) async {
    final response = await _apiClient.get(baseUrl);

    final data = response.data;
    if (data == null) {
      throw Exception('Empty response from server');
    }

    List<dynamic> tasksJson;
    if (data is List) {
      tasksJson = data;
    } else if (data is Map<String, dynamic> && data.containsKey('data')) {
      tasksJson = data['data'] as List<dynamic>;
    } else {
      throw Exception('Invalid data format received from server');
    }

    return tasksJson
        .map((item) => TaskDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Sends array of solved task [results] to [baseUrl].
  Future<bool> sendResults(String baseUrl, List<ResultDto> results) async {
    final payload = results.map((result) => result.toJson()).toList();
    final response = await _apiClient.post(baseUrl, payload);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to send results. Status code: ${response.statusCode}');
    }
  }
}
