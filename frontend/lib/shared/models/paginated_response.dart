class PaginatedResponse<T> {
  final List<T> items;
  final int count;

  const PaginatedResponse({required this.items, required this.count});

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      items: (json['items'] as List).map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      count: json['count'] as int,
    );
  }
}
