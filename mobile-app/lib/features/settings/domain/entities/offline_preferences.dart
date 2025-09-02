import 'package:equatable/equatable.dart';

enum DownloadQuality {
  low,
  medium,
  high,
}

class OfflinePreferences extends Equatable {
  const OfflinePreferences({
    this.maxOfflineExams = 10,
    this.autoDownloadEnabled = false,
    this.wifiOnlyDownload = true,
    this.autoSyncEnabled = true,
    this.downloadQuality = DownloadQuality.medium,
    this.maxStorageUsageMB = 500,
    this.deleteAfterDays = 30,
    this.syncOnStartup = true,
    this.backgroundSyncEnabled = false,
    this.compressContent = true,
  });

  final int maxOfflineExams;
  final bool autoDownloadEnabled;
  final bool wifiOnlyDownload;
  final bool autoSyncEnabled;
  final DownloadQuality downloadQuality;
  final int maxStorageUsageMB;
  final int deleteAfterDays;
  final bool syncOnStartup;
  final bool backgroundSyncEnabled;
  final bool compressContent;

  @override
  List<Object?> get props => [
        maxOfflineExams,
        autoDownloadEnabled,
        wifiOnlyDownload,
        autoSyncEnabled,
        downloadQuality,
        maxStorageUsageMB,
        deleteAfterDays,
        syncOnStartup,
        backgroundSyncEnabled,
        compressContent,
      ];

  /// Gets download quality as string
  String getDownloadQualityString() {
    switch (downloadQuality) {
      case DownloadQuality.low:
        return 'Low';
      case DownloadQuality.medium:
        return 'Medium';
      case DownloadQuality.high:
        return 'High';
    }
  }

  /// Gets estimated storage per exam in MB based on quality
  double getEstimatedStoragePerExamMB() {
    switch (downloadQuality) {
      case DownloadQuality.low:
        return compressContent ? 2.0 : 3.0;
      case DownloadQuality.medium:
        return compressContent ? 5.0 : 7.0;
      case DownloadQuality.high:
        return compressContent ? 10.0 : 15.0;
    }
  }

  /// Calculates total estimated storage usage in MB
  double getEstimatedTotalStorageMB() {
    return maxOfflineExams * getEstimatedStoragePerExamMB();
  }

  /// Checks if storage limit would be exceeded
  bool wouldExceedStorageLimit() {
    return getEstimatedTotalStorageMB() > maxStorageUsageMB;
  }

  /// Gets maximum number of exams that can fit in storage limit
  int getMaxExamsForStorageLimit() {
    final storagePerExam = getEstimatedStoragePerExamMB();
    if (storagePerExam <= 0) return maxOfflineExams;
    return (maxStorageUsageMB / storagePerExam).floor();
  }

  /// Validates offline preferences settings
  List<String> validateSettings() {
    final errors = <String>[];
    
    if (maxOfflineExams <= 0) {
      errors.add('Maximum offline exams must be greater than 0');
    }
    
    if (maxStorageUsageMB <= 0) {
      errors.add('Maximum storage usage must be greater than 0');
    }
    
    if (deleteAfterDays <= 0) {
      errors.add('Delete after days must be greater than 0');
    }
    
    if (wouldExceedStorageLimit()) {
      errors.add('Current settings would exceed storage limit');
    }
    
    return errors;
  }

  /// Gets storage usage as percentage
  double getStorageUsagePercentage() {
    if (maxStorageUsageMB <= 0) return 0.0;
    return (getEstimatedTotalStorageMB() / maxStorageUsageMB).clamp(0.0, 1.0);
  }

  /// Gets available download quality options
  static List<DownloadQuality> getQualityOptions() {
    return DownloadQuality.values;
  }

  /// Gets storage limit options in MB
  static List<int> getStorageLimitOptions() {
    return [100, 250, 500, 1000, 2000, 5000];
  }

  /// Gets delete after days options
  static List<int> getDeleteAfterDaysOptions() {
    return [7, 14, 30, 60, 90, 180];
  }

  OfflinePreferences copyWith({
    int? maxOfflineExams,
    bool? autoDownloadEnabled,
    bool? wifiOnlyDownload,
    bool? autoSyncEnabled,
    DownloadQuality? downloadQuality,
    int? maxStorageUsageMB,
    int? deleteAfterDays,
    bool? syncOnStartup,
    bool? backgroundSyncEnabled,
    bool? compressContent,
  }) {
    return OfflinePreferences(
      maxOfflineExams: maxOfflineExams ?? this.maxOfflineExams,
      autoDownloadEnabled: autoDownloadEnabled ?? this.autoDownloadEnabled,
      wifiOnlyDownload: wifiOnlyDownload ?? this.wifiOnlyDownload,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      downloadQuality: downloadQuality ?? this.downloadQuality,
      maxStorageUsageMB: maxStorageUsageMB ?? this.maxStorageUsageMB,
      deleteAfterDays: deleteAfterDays ?? this.deleteAfterDays,
      syncOnStartup: syncOnStartup ?? this.syncOnStartup,
      backgroundSyncEnabled: backgroundSyncEnabled ?? this.backgroundSyncEnabled,
      compressContent: compressContent ?? this.compressContent,
    );
  }

  @override
  String toString() {
    return 'OfflinePreferences(maxOfflineExams: $maxOfflineExams, autoDownloadEnabled: $autoDownloadEnabled, wifiOnlyDownload: $wifiOnlyDownload, autoSyncEnabled: $autoSyncEnabled, downloadQuality: $downloadQuality, maxStorageUsageMB: $maxStorageUsageMB, deleteAfterDays: $deleteAfterDays, syncOnStartup: $syncOnStartup, backgroundSyncEnabled: $backgroundSyncEnabled, compressContent: $compressContent)';
  }
}