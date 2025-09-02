import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import '../../domain/usecases/get_user_stats_usecase.dart';
import '../../domain/usecases/get_subscription_info_usecase.dart';
import '../../domain/usecases/search_users_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required UploadAvatarUseCase uploadAvatarUseCase,
    required GetUserStatsUseCase getUserStatsUseCase,
    required GetSubscriptionInfoUseCase getSubscriptionInfoUseCase,
    required SearchUsersUseCase searchUsersUseCase,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _updateUserProfileUseCase = updateUserProfileUseCase,
        _uploadAvatarUseCase = uploadAvatarUseCase,
        _getUserStatsUseCase = getUserStatsUseCase,
        _getSubscriptionInfoUseCase = getSubscriptionInfoUseCase,
        _searchUsersUseCase = searchUsersUseCase,
        super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileAvatarUploadRequested>(_onProfileAvatarUploadRequested);
    on<ProfileAvatarDeleteRequested>(_onProfileAvatarDeleteRequested);
    on<ProfileStatsLoadRequested>(_onProfileStatsLoadRequested);
    on<ProfileSubscriptionLoadRequested>(_onProfileSubscriptionLoadRequested);
    on<ProfileSearchRequested>(_onProfileSearchRequested);
    on<ProfileErrorCleared>(_onProfileErrorCleared);
    on<ProfileRefreshRequested>(_onProfileRefreshRequested);
  }

  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final UploadAvatarUseCase _uploadAvatarUseCase;
  final GetUserStatsUseCase _getUserStatsUseCase;
  final GetSubscriptionInfoUseCase _getSubscriptionInfoUseCase;
  final SearchUsersUseCase _searchUsersUseCase;

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await _getUserProfileUseCase(
      GetUserProfileParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(ProfileError(message: _mapFailureToMessage(failure))),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(currentProfile: currentState.profile));
    }

    final result = await _updateUserProfileUseCase(
      UpdateUserProfileParams(
        userId: event.userId,
        updates: event.updates,
      ),
    );

    result.fold(
      (failure) => emit(ProfileError(
        message: _mapFailureToMessage(failure),
        currentProfile: currentState is ProfileLoaded ? currentState.profile : null,
      )),
      (profile) => emit(ProfileUpdateSuccess(profile: profile)),
    );
  }

  Future<void> _onProfileAvatarUploadRequested(
    ProfileAvatarUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileAvatarUploading(currentProfile: currentState.profile));
    }

    final result = await _uploadAvatarUseCase(
      UploadAvatarParams(
        userId: event.userId,
        imagePath: event.imagePath,
      ),
    );

    result.fold(
      (failure) => emit(ProfileError(
        message: _mapFailureToMessage(failure),
        currentProfile: currentState is ProfileLoaded ? currentState.profile : null,
      )),
      (avatarUrl) {
        if (currentState is ProfileLoaded) {
          final updatedProfile = currentState.profile.copyWith(avatarUrl: avatarUrl);
          emit(ProfileAvatarUploadSuccess(
            profile: updatedProfile,
            avatarUrl: avatarUrl,
          ));
        } else {
          emit(ProfileError(
            message: 'Profile not loaded',
            currentProfile: currentState is ProfileLoaded ? currentState.profile : null,
          ));
        }
      },
    );
  }

  Future<void> _onProfileAvatarDeleteRequested(
    ProfileAvatarDeleteRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(currentProfile: currentState.profile));
      
      final updatedProfile = currentState.profile.copyWith(avatarUrl: null);
      emit(ProfileUpdateSuccess(profile: updatedProfile));
    }
  }

  Future<void> _onProfileStatsLoadRequested(
    ProfileStatsLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    
    final result = await _getUserStatsUseCase(
      GetUserStatsParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(ProfileError(
        message: _mapFailureToMessage(failure),
        currentProfile: currentState is ProfileLoaded ? currentState.profile : null,
      )),
      (stats) {
        if (currentState is ProfileLoaded) {
          emit(currentState.copyWith(stats: stats));
        } else {
          emit(ProfileError(
            message: 'Profile not loaded',
            currentProfile: currentState is ProfileLoaded ? currentState.profile : null,
          ));
        }
      },
    );
  }

  Future<void> _onProfileSubscriptionLoadRequested(
    ProfileSubscriptionLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    
    final result = await _getSubscriptionInfoUseCase(
      GetSubscriptionInfoParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(ProfileError(
        message: _mapFailureToMessage(failure),
        currentProfile: currentState is ProfileLoaded ? currentState.profile : null,
      )),
      (subscriptionInfo) {
        if (currentState is ProfileLoaded) {
          emit(currentState.copyWith(subscriptionInfo: subscriptionInfo));
        } else {
          emit(ProfileError(
            message: 'Profile not loaded',
            currentProfile: currentState is ProfileLoaded ? currentState.profile : null,
          ));
        }
      },
    );
  }

  Future<void> _onProfileSearchRequested(
    ProfileSearchRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileSearchLoading());

    final result = await _searchUsersUseCase(
      SearchUsersParams(
        query: event.query,
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) => emit(ProfileError(message: _mapFailureToMessage(failure))),
      (users) => emit(ProfileSearchLoaded(
        users: users,
        query: event.query,
        hasMore: users.length >= event.limit,
      )),
    );
  }

  Future<void> _onProfileErrorCleared(
    ProfileErrorCleared event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileError && currentState.currentProfile != null) {
      emit(ProfileLoaded(profile: currentState.currentProfile!));
    } else {
      emit(const ProfileInitial());
    }
  }

  Future<void> _onProfileRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileRefreshing(currentProfile: currentState.profile));
    }

    final result = await _getUserProfileUseCase(
      GetUserProfileParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(ProfileError(
        message: _mapFailureToMessage(failure),
        currentProfile: currentState is ProfileLoaded ? currentState.profile : null,
      )),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case CacheFailure:
        return 'Local data error occurred.';
      case NetworkFailure:
        return 'Network error. Please check your connection.';
      case ValidationFailure:
        return 'Invalid data provided.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}