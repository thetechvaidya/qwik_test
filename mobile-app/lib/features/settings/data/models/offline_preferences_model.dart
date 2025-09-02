import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/offline_preferences.dart';

part 'offline_preferences_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 5)
class OfflinePreferencesModel extends OfflinePreferences {
  const OfflinePreferencesModel({
    @HiveField(0) super.maxOfflineExams = 10,
    @HiveField(1) super.autoDownloadEnabled = false,
    @HiveField(2) super.wifiOnlyDownload = true,
    @HiveField(3) super.autoSyncEnabled = true,
    @HiveField(4) super.downloadQuality = DownloadQuality.medium,
    @HiveField(5) super.maxStorageUsageMB = 500,
    @HiveField(6) super.deleteAfterDays = 30,
    @HiveField(7) super.syncOnStartup = true,
    @HiveField(8) super.backgroundSyncEnabled = false,
    @HiveField(9) super.compressContent = true,
  });

  factory OfflinePreferencesModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$OfflinePreferencesModelFromJson(json);
    } catch (e) {
      // Handle malformed JSON by providing fallback values
      return OfflinePreferencesModel(
        maxOfflineExams: _parseInt(json['max_offline_exams'] ?? json['maxOfflineExams'], defaultValue: 10),
        autoDownloadEnabled: _parseBool(json['auto_download_enabled'] ?? json['autoDownloadEnabled'], defaultValue: false),
        wifiOnlyDownload: _parseBool(json['wifi_only_download'] ?? json['wifiOnlyDownload'], defaultValue: true),
        autoSyncEnabled: _parseBool(json['auto_sync_enabled'] ?? json['autoSyncEnabled'], defaultValue: true),
        downloadQuality: _parseDownloadQuality(json['download_quality'] ?? json['downloadQuality']),
        maxStorageUsageMB: _parseInt(json['max_storage_usage_mb'] ?? json['maxStorageUsageMB'], defaultValue: 500),
        deleteAfterDays: _parseInt(json['delete_after_days'] ?? json['deleteAfterDays'], defaultValue: 30),
        syncOnStartup: _parseBool(json['sync_on_startup'] ?? json['syncOnStartup'], defaultValue: true),
        backgroundSyncEnabled: _parseBool(json['background_sync_enabled'] ?? json['backgroundSyncEnabled'], defaultValue: false),
        compressContent: _parseBool(json['compress_content'] ?? json['compressContent'], defaultValue: true),
      );
    }
  }

  Map<String, dynamic> toJson() => _$OfflinePreferencesModelToJson(this);

  factory OfflinePreferencesModel.fromEntity(OfflinePreferences preferences) {
    return OfflinePreferencesModel(
      offlineModeEnabled: preferences.offlineModeEnabled,
      autoDownloadEnabled: preferences.autoDownloadEnabled,
      downloadQuality: preferences.downloadQuality,
      maxStorageLimit: preferences.maxStorageLimit,
      wifiOnlyDownloads: preferences.wifiOnlyDownloads,
      autoDeleteOldContent: preferences.autoDeleteOldContent,
      contentRetentionDays: preferences.contentRetentionDays,
      syncFrequency: preferences.syncFrequency,
      backgroundSyncEnabled: preferences.backgroundSyncEnabled,
      compressContent: preferences.compressContent,
      downloadExamContent: preferences.downloadExamContent,
      downloadVideoLectures: preferences.downloadVideoLectures,
      downloadPracticeTests: preferences.downloadPracticeTests,
      downloadStudyMaterials: preferences.downloadStudyMaterials,
      preloadUpcomingExams: preferences.preloadUpcomingExams,
    );
  }

  OfflinePreferences toEntity() {
    return OfflinePreferences(
      offlineModeEnabled: offlineModeEnabled,
      autoDownloadEnabled: autoDownloadEnabled,
      downloadQuality: downloadQuality,
      maxStorageLimit: maxStorageLimit,
      wifiOnlyDownloads: wifiOnlyDownloads,
      autoDeleteOldContent: autoDeleteOldContent,
      contentRetentionDays: contentRetentionDays,
      syncFrequency: syncFrequency,
      backgroundSyncEnabled: backgroundSyncEnabled,
      compressContent: compressContent,
      downloadExamContent: downloadExamContent,
      downloadVideoLectures: downloadVideoLectures,
      downloadPracticeTests: downloadPracticeTests,
      downloadStudyMaterials: downloadStudyMaterials,
      preloadUpcomingExams: preloadUpcomingExams,
    );
  }

  /// Helper method to parse boolean values
  static bool _parseBool(dynamic value, {bool defaultValue = true}) {
    if (value == null) return defaultValue;
    
    if (value is bool) return value;
    
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    
    if (value is int) {
      return value == 1;
    }
    
    return defaultValue;
  }

  /// Helper method to parse integer values
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    
    if (value is int) return value;
    
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    
    if (value is double) {
      return value.round();
    }
    
    return defaultValue;
  }

  /// Helper method to parse DownloadQuality
  static DownloadQuality _parseDownloadQuality(dynamic value) {
    if (value == null) return DownloadQuality.medium;
    
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'low':
          return DownloadQuality.low;
        case 'medium':
        case 'normal':
          return DownloadQuality.medium;
        case 'high':
          return DownloadQuality.high;
        case 'ultra':
        case 'ultra_high':
          return DownloadQuality.ultra;
        default:
          return DownloadQuality.medium;
      }
    }
    
    if (value is int) {
      switch (value) {
        case 0:
          return DownloadQuality.low;
        case 1:
          return DownloadQuality.medium;
        case 2:
          return DownloadQuality.high;
        case 3:
          return DownloadQuality.ultra;
        default:
          return DownloadQuality.medium;
      }
    }
    
    return DownloadQuality.medium;
  }

  /// Helper method to parse StorageLimit
  static StorageLimit _parseStorageLimit(dynamic value) {
    if (value == null) return StorageLimit.oneGB;
    
    if (value is String) {
      switch (value.toLowerCase()) {
        case '500mb':
        case '0.5gb':
          return StorageLimit.fiveHundredMB;
        case '1gb':
          return StorageLimit.oneGB;
        case '2gb':
          return StorageLimit.twoGB;
        case '5gb':
          return StorageLimit.fiveGB;
        case '10gb':
          return StorageLimit.tenGB;
        case 'unlimited':
          return StorageLimit.unlimited;
        default:
          return StorageLimit.oneGB;
      }
    }
    
    if (value is int) {
      switch (value) {
        case 500:
          return StorageLimit.fiveHundredMB;
        case 1024:
          return StorageLimit.oneGB;
        case 2048:
          return StorageLimit.twoGB;
        case 5120:
          return StorageLimit.fiveGB;
        case 10240:
          return StorageLimit.tenGB;
        case -1:
          return StorageLimit.unlimited;
        default:
          return StorageLimit.oneGB;
      }
    }
    
    return StorageLimit.oneGB;
  }

  /// Helper method to parse SyncFrequency
  static SyncFrequency _parseSyncFrequency(dynamic value) {
    if (value == null) return SyncFrequency.daily;
    
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'manual':
          return SyncFrequency.manual;
        case 'hourly':
          return SyncFrequency.hourly;
        case 'daily':
          return SyncFrequency.daily;
        case 'weekly':
          return SyncFrequency.weekly;
        default:
          return SyncFrequency.daily;
      }
    }
    
    if (value is int) {
      switch (value) {
        case 0:
          return SyncFrequency.manual;
        case 1:
          return SyncFrequency.hourly;
        case 2:
          return SyncFrequency.daily;
        case 3:
          return SyncFrequency.weekly;
        default:
          return SyncFrequency.daily;
      }
    }
    
    return SyncFrequency.daily;
  }

  /// Create preferences optimized for limited storage
  factory OfflinePreferencesModel.limitedStorage() {
    return const OfflinePreferencesModel(
      offlineModeEnabled: true,
      autoDownloadEnabled: false,
      downloadQuality: DownloadQuality.low,
      maxStorageLimit: StorageLimit.fiveHundredMB,
      wifiOnlyDownloads: true,
      autoDeleteOldContent: true,
      contentRetentionDays: 7,
      syncFrequency: SyncFrequency.weekly,
      backgroundSyncEnabled: false,
      compressContent: true,
      downloadExamContent: true,
      downloadVideoLectures: false,
      downloadPracticeTests: true,
      downloadStudyMaterials: false,
      preloadUpcomingExams: false,
    );
  }

  /// Create preferences optimized for unlimited data
  factory OfflinePreferencesModel.unlimitedData() {
    return const OfflinePreferencesModel(
      offlineModeEnabled: true,
      autoDownloadEnabled: true,
      downloadQuality: DownloadQuality.high,
      maxStorageLimit: StorageLimit.tenGB,
      wifiOnlyDownloads: false,
      autoDeleteOldContent: false,
      contentRetentionDays: 90,
      syncFrequency: SyncFrequency.hourly,
      backgroundSyncEnabled: true,
      compressContent: false,
      downloadExamContent: true,
      downloadVideoLectures: true,
      downloadPracticeTests: true,
      downloadStudyMaterials: true,
      preloadUpcomingExams: true,
    );
  }

  /// Create preferences for WiFi-only usage
  factory OfflinePreferencesModel.wifiOnly() {
    return const OfflinePreferencesModel(
      offlineModeEnabled: true,
      autoDownloadEnabled: true,
      downloadQuality: DownloadQuality.high,
      maxStorageLimit: StorageLimit.fiveGB,
      wifiOnlyDownloads: true,
      autoDeleteOldContent: true,
      contentRetentionDays: 30,
      syncFrequency: SyncFrequency.daily,
      backgroundSyncEnabled: true,
      compressContent: false,
      downloadExamContent: true,
      downloadVideoLectures: true,
      downloadPracticeTests: true,
      downloadStudyMaterials: true,
      preloadUpcomingExams: false,
    );
  }

  /// Update download settings
  OfflinePreferencesModel updateDownloadSettings({
    bool? autoDownload,
    DownloadQuality? quality,
    bool? wifiOnly,
    bool? compress,
  }) {
    return OfflinePreferencesModel.fromEntity(copyWith(
      autoDownloadEnabled: autoDownload ?? autoDownloadEnabled,
      downloadQuality: quality ?? downloadQuality,
      wifiOnlyDownloads: wifiOnly ?? wifiOnlyDownloads,
      compressContent: compress ?? compressContent,
    ));
  }

  /// Update storage settings
  OfflinePreferencesModel updateStorageSettings({
    StorageLimit? maxStorage,
    bool? autoDelete,
    int? retentionDays,
  }) {
    return OfflinePreferencesModel.fromEntity(copyWith(
      maxStorageLimit: maxStorage ?? maxStorageLimit,
      autoDeleteOldContent: autoDelete ?? autoDeleteOldContent,
      contentRetentionDays: retentionDays ?? contentRetentionDays,
    ));
  }

  /// Update sync settings
  OfflinePreferencesModel updateSyncSettings({
    SyncFrequency? frequency,
    bool? backgroundSync,
  }) {
    return OfflinePreferencesModel.fromEntity(copyWith(
      syncFrequency: frequency ?? syncFrequency,
      backgroundSyncEnabled: backgroundSync ?? backgroundSyncEnabled,
    ));
  }

  /// Update content type preferences
  OfflinePreferencesModel updateContentTypes({
    bool? examContent,
    bool? videoLectures,
    bool? practiceTests,
    bool? studyMaterials,
    bool? preloadExams,
  }) {
    return OfflinePreferencesModel.fromEntity(copyWith(
      autoDownloadEnabled: examContent ?? autoDownloadEnabled,
      compressContent: videoLectures ?? compressContent,
      backgroundSyncEnabled: practiceTests ?? backgroundSyncEnabled,
      wifiOnlyDownload: studyMaterials ?? wifiOnlyDownload,
      autoSyncEnabled: preloadExams ?? autoSyncEnabled,
    ));
  }

  /// Toggle offline mode
  OfflinePreferencesModel toggleOfflineMode() {
    return OfflinePreferencesModel.fromEntity(copyWith(
      autoDownloadEnabled: !autoDownloadEnabled,
    ));
  }

  /// Validate settings and return corrected version if needed
  OfflinePreferencesModel validateAndCorrect() {
    // Ensure retention days is reasonable
    int correctedRetentionDays = contentRetentionDays;
    if (correctedRetentionDays < 1) correctedRetentionDays = 1;
    if (correctedRetentionDays > 365) correctedRetentionDays = 365;
    
    // If offline mode is disabled, disable auto-download
    bool correctedAutoDownload = offlineModeEnabled ? autoDownloadEnabled : false;
    
    // If auto-download is disabled, disable background sync
    bool correctedBackgroundSync = correctedAutoDownload ? backgroundSyncEnabled : false;
    
    return OfflinePreferencesModel.fromEntity(copyWith(
      autoDownloadEnabled: correctedAutoDownload,
      backgroundSyncEnabled: correctedBackgroundSync,
      contentRetentionDays: correctedRetentionDays,
    ));
  }
}