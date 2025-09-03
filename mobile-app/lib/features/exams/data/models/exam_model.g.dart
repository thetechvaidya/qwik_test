// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamModelAdapter extends TypeAdapter<ExamModel> {
  @override
  final int typeId = 10;

  @override
  ExamModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      imageUrl: fields[3] as String?,
      duration: fields[4] as int,
      totalQuestions: fields[5] as int,
      totalMarks: fields[6] as int,
      passingScore: fields[7] as double,
      difficulty: fields[8] as String,
      category: fields[9] as String,
      subcategory: fields[10] as String?,
      tags: (fields[11] as List).cast<String>(),
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
      scheduledAt: fields[14] as DateTime?,
      expiresAt: fields[15] as DateTime?,
      isActive: fields[16] as bool,
      isPaid: fields[17] as bool,
      price: fields[18] as double?,
      currency: fields[19] as String?,
      status: fields[20] as String,
      type: fields[21] as String,
      stats: fields[22] as ExamStatsModel?,
    );
  }

  @override
  void write(BinaryWriter writer, ExamModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.totalQuestions)
      ..writeByte(6)
      ..write(obj.totalMarks)
      ..writeByte(7)
      ..write(obj.passingScore)
      ..writeByte(8)
      ..write(obj.difficulty)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.subcategory)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.scheduledAt)
      ..writeByte(15)
      ..write(obj.expiresAt)
      ..writeByte(16)
      ..write(obj.isActive)
      ..writeByte(17)
      ..write(obj.isPaid)
      ..writeByte(18)
      ..write(obj.price)
      ..writeByte(19)
      ..write(obj.currency)
      ..writeByte(20)
      ..write(obj.status)
      ..writeByte(21)
      ..write(obj.type)
      ..writeByte(22)
      ..write(obj.stats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExamStatsModelAdapter extends TypeAdapter<ExamStatsModel> {
  @override
  final int typeId = 12;

  @override
  ExamStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamStatsModel(
      totalAttempts: fields[0] as int,
      averageScore: fields[1] as double,
      highestScore: fields[2] as double,
      lowestScore: fields[3] as double,
      passCount: fields[4] as int,
      failCount: fields[5] as int,
      passRate: fields[6] as double,
      averageCompletionTimeMinutes: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ExamStatsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.totalAttempts)
      ..writeByte(1)
      ..write(obj.averageScore)
      ..writeByte(2)
      ..write(obj.highestScore)
      ..writeByte(3)
      ..write(obj.lowestScore)
      ..writeByte(4)
      ..write(obj.passCount)
      ..writeByte(5)
      ..write(obj.failCount)
      ..writeByte(6)
      ..write(obj.passRate)
      ..writeByte(7)
      ..write(obj.averageCompletionTimeMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamStatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamModel _$ExamModelFromJson(Map<String, dynamic> json) => ExamModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      duration: (json['duration'] as num).toInt(),
      totalQuestions: (json['total_questions'] as num).toInt(),
      totalMarks: (json['total_marks'] as num).toInt(),
      passingScore: (json['passing_score'] as num).toDouble(),
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      scheduledAt: json['scheduled_at'] == null
          ? null
          : DateTime.parse(json['scheduled_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      isPaid: json['is_paid'] as bool? ?? false,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      status: json['status'] as String? ?? 'draft',
      type: json['type'] as String? ?? 'practice',
      stats: json['stats'] == null
          ? null
          : ExamStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExamModelToJson(ExamModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'duration': instance.duration,
      'total_questions': instance.totalQuestions,
      'total_marks': instance.totalMarks,
      'passing_score': instance.passingScore,
      'difficulty': instance.difficulty,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'tags': instance.tags,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'scheduled_at': instance.scheduledAt?.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
      'is_active': instance.isActive,
      'is_paid': instance.isPaid,
      'price': instance.price,
      'currency': instance.currency,
      'status': instance.status,
      'type': instance.type,
      'stats': instance.stats,
    };

ExamStatsModel _$ExamStatsModelFromJson(Map<String, dynamic> json) =>
    ExamStatsModel(
      totalAttempts: (json['total_attempts'] as num).toInt(),
      averageScore: (json['average_score'] as num).toDouble(),
      highestScore: (json['highest_score'] as num).toDouble(),
      lowestScore: (json['lowest_score'] as num).toDouble(),
      passCount: (json['pass_count'] as num).toInt(),
      failCount: (json['fail_count'] as num).toInt(),
      passRate: (json['pass_rate'] as num).toDouble(),
      averageCompletionTimeMinutes:
          (json['average_completion_time_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$ExamStatsModelToJson(ExamStatsModel instance) =>
    <String, dynamic>{
      'total_attempts': instance.totalAttempts,
      'average_score': instance.averageScore,
      'highest_score': instance.highestScore,
      'lowest_score': instance.lowestScore,
      'pass_count': instance.passCount,
      'fail_count': instance.failCount,
      'pass_rate': instance.passRate,
      'average_completion_time_minutes': instance.averageCompletionTimeMinutes,
    };
