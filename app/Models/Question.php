<?php
/**
 * File name: Question.php
 * Last modified: 16/07/21, 9:44 PM
 * Author: NearCraft - https://codecanyon.net/user/nearcraft
 * Copyright (c) 2021
 */

namespace App\Models;

use App\Filters\QueryFilter;
use App\Traits\SecureDeletes;
use App\Traits\SanitizesContent;
use App\Traits\ValidatesContent;
use App\Traits\TracksContentHistory;
use App\Traits\ValidatesMedia;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;
use Znck\Eloquent\Traits\BelongsToThrough;

class Question extends Model
{
    use HasFactory;
    use SoftDeletes;
    use SecureDeletes;
    use BelongsToThrough;
    use SanitizesContent;
    use ValidatesContent;
    use TracksContentHistory;
    use ValidatesMedia;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'question_type_id', 'skill_id', 'question', 'options', 'correct_answer',
        'default_marks', 'default_time', 'is_active', 'preferences'
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'options' => 'array',
        'preferences' => 'object',
        'is_active' => 'boolean',
    ];

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */

    /**
     * The columns that should be sanitized.
     *
     * @var array
     */
    protected $sanitized = ['question', 'options'];

    /**
     * The columns that should be validated.
     *
     * @var array
     */
    protected $validated = ['question', 'options', 'correct_answer'];

    /**
     * The columns that should be versioned.
     *
     * @var array
     */
    protected $versioned = ['question', 'options', 'correct_answer'];

    /**
     * The columns that should be checked for media.
     *
     * @var array
     */
    protected $media = ['question', 'options'];

    /**
     *  Boot the model.
     */
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($question) {
            $question->attributes['code'] = 'que_'.Str::random(11);
        });
    }

    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */

    public function questionType()
    {
        return $this->belongsTo(QuestionType::class);
    }

    public function topic()
    {
        return $this->belongsTo(Topic::class);
    }

    public function skill()
    {
        return $this->belongsTo(Skill::class);
    }

    public function section()
    {
        return $this->belongsToThrough(Section::class, Skill::class);
    }

    public function difficultyLevel()
    {
        return $this->belongsTo(DifficultyLevel::class);
    }

    public function comprehensionPassage()
    {
        return $this->belongsTo(ComprehensionPassage::class);
    }

    public function practiceSets()
    {
        return $this->belongsToMany(PracticeSet::class, 'practice_set_questions', 'question_id', 'practice_set_id');
    }

    public function practiceSessions()
    {
        return $this->belongsToMany(PracticeSession::class, 'practice_session_questions')
            ->withPivot('status', 'original_question', 'is_correct', 'time_taken', 'options', 'user_answer', 'correct_answer', 'points_earned');
    }

    public function quizzes()
    {
        return $this->belongsToMany(Quiz::class, 'quiz_questions', 'question_id', 'quiz_id');
    }

    public function quizSessions()
    {
        return $this->belongsToMany(QuizSession::class, 'quiz_session_questions')
            ->withPivot('status', 'original_question', 'options', 'is_correct', 'time_taken', 'user_answer', 'correct_answer', 'marks_earned', 'marks_deducted');
    }

    public function exams()
    {
        return $this->belongsToMany(Exam::class, 'exam_questions', 'question_id', 'exam_id');
    }

    public function examSessions()
    {
        return $this->belongsToMany(ExamSession::class, 'exam_session_questions')
            ->withPivot('status', 'exam_section_id', 'original_question', 'options', 'is_correct', 'time_taken', 'user_answer', 'correct_answer', 'marks_earned', 'marks_deducted');
    }

    public function tags()
    {
        return $this->morphToMany(Tag::class, 'taggable');
    }

    /*
    |--------------------------------------------------------------------------
    | SCOPES
    |--------------------------------------------------------------------------
    */

    public function scopeFilter($query, QueryFilter $filters)
    {
        return $filters->apply($query);
    }

    public function scopeActive($query)
    {
        $query->where('is_active', true);
    }

    /*
    |--------------------------------------------------------------------------
    | ACCESSORS
    |--------------------------------------------------------------------------
    */

    public function getCorrectAnswerAttribute($value)
    {
        return unserialize($value);
    }

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */

    public function setCorrectAnswerAttribute($value)
    {
        $this->attributes['correct_answer'] = serialize($value);
    }

}
