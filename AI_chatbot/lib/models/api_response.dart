// lib/models/api_response.dart

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;
  final List<ValidationError>? validationErrors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    this.validationErrors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['error'] == null,
      message: json['message'] ?? json['error'] ?? 'Unknown response',
      data: json['error'] == null && fromJsonT != null ? fromJsonT(json) : null,
      error: json['error'],
      validationErrors: json['details'] != null
          ? (json['details'] as List)
              .map((e) => ValidationError.fromJson(e))
              .toList()
          : null,
    );
  }

  factory ApiResponse.success(T data, String message) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
    );
  }

  factory ApiResponse.error(String error,
      {List<ValidationError>? validationErrors}) {
    return ApiResponse<T>(
      success: false,
      message: error,
      error: error,
      validationErrors: validationErrors,
    );
  }
}

class ValidationError {
  final String field;
  final String message;
  final dynamic value;

  ValidationError({
    required this.field,
    required this.message,
    this.value,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      field: json['field'] ?? '',
      message: json['message'] ?? '',
      value: json['value'],
    );
  }
}
