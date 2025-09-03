class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int perPage;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });
}