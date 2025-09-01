import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/entities/search_history.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

/// Search bar widget with suggestions and history
class ExamSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final VoidCallback? onClear;
  final String? hintText;
  final bool autofocus;

  const ExamSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.onClear,
    this.hintText,
    this.autofocus = true,
  });

  @override
  State<ExamSearchBar> createState() => _ExamSearchBarState();
}

class _ExamSearchBarState extends State<ExamSearchBar> {
  late FocusNode _focusNode;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    widget.controller.addListener(_onTextChanged);
    
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showSuggestionsOverlay();
    } else {
      _hideSuggestionsOverlay();
    }
  }

  void _onTextChanged() {
    final query = widget.controller.text;
    if (query.isNotEmpty) {
      context.read<SearchBloc>().add(GetSearchSuggestionsEvent(query: query));
    }
    
    if (_focusNode.hasFocus) {
      _showSuggestionsOverlay();
    }
  }

  void _showSuggestionsOverlay() {
    if (_overlayEntry != null) return;
    
    setState(() {
      _showSuggestions = true;
    });
    
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSuggestionsOverlay() {
    setState(() {
      _showSuggestions = false;
    });
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: BlocProvider.value(
              value: context.read<SearchBloc>(),
              child: _buildSuggestionsContent(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchBloc>()
        ..add(const LoadSearchHistoryEvent()),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Search exams...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      widget.controller.clear();
                      widget.onClear?.call();
                      _hideSuggestionsOverlay();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              widget.onSearch(value.trim());
              _hideSuggestionsOverlay();
              _focusNode.unfocus();
            }
          },
          textInputAction: TextInputAction.search,
        ),
      ),
    );
  }

  Widget _buildSuggestionsContent() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return _buildLoadingContent();
        }
        
        if (state is SearchLoaded) {
          return _buildSuggestionsLoaded(state);
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingContent() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSuggestionsLoaded(SearchLoaded state) {
    final query = widget.controller.text.trim();
    final suggestions = state.suggestions;
    final history = state.searchHistory;
    
    // Show suggestions if there's a query, otherwise show history
    if (query.isNotEmpty && suggestions.isNotEmpty) {
      return _buildSuggestionsList(suggestions);
    } else if (query.isEmpty && history.isNotEmpty) {
      return _buildHistoryList(history);
    } else if (query.isNotEmpty) {
      return _buildNoSuggestions();
    }
    
    return _buildEmptyState();
  }

  Widget _buildSuggestionsList(List<SearchSuggestion> suggestions) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Suggestions',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return _buildSuggestionItem(suggestion);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<SearchHistory> history) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<SearchBloc>().add(const ClearSearchHistoryEvent());
                  },
                  child: Text(
                    'Clear All',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: history.length,
              itemBuilder: (context, index) {
                final historyItem = history[index];
                return _buildHistoryItem(historyItem);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(SearchSuggestion suggestion) {
    return ListTile(
      dense: true,
      leading: Icon(
        suggestion.getIconName(),
        size: 20,
        color: AppColors.textSecondary,
      ),
      title: Text(
        suggestion.getDisplayText(),
        style: AppTextStyles.bodyMedium,
      ),
      subtitle: suggestion.getSubtitle() != null
          ? Text(
              suggestion.getSubtitle()!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : null,
      onTap: () {
        widget.controller.text = suggestion.text;
        widget.onSearch(suggestion.text);
        _hideSuggestionsOverlay();
        _focusNode.unfocus();
      },
    );
  }

  Widget _buildHistoryItem(SearchHistory history) {
    return ListTile(
      dense: true,
      leading: const Icon(
        Icons.history,
        size: 20,
        color: AppColors.textSecondary,
      ),
      title: Text(
        history.query,
        style: AppTextStyles.bodyMedium,
      ),
      subtitle: Text(
        history.getDisplayText(),
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.close,
          size: 16,
        ),
        onPressed: () {
          context.read<SearchBloc>().add(RemoveSearchHistoryEvent(
            historyId: history.id,
          ));
        },
      ),
      onTap: () {
        widget.controller.text = history.query;
        widget.onSearch(history.query);
        _hideSuggestionsOverlay();
        _focusNode.unfocus();
      },
    );
  }

  Widget _buildNoSuggestions() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              color: AppColors.textSecondary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'No suggestions found',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Start typing to search for exams',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}