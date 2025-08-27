<?php
/**
 * File name: User.php
 * Last modified: 19/07/21, 10:54 PM
 * Author: NearCraft - https://codecanyon.net/user/nearcraft
 * Copyright (c) 2021
 */

namespace App\Models;

use App\Traits\SecureDeletes;
use App\Traits\SubscriptionTrait;
use App\Traits\SyllabusTrait;
use Bavix\Wallet\Interfaces\Wallet;
use Bavix\Wallet\Traits\HasWallet;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Fortify\TwoFactorAuthenticatable;
use Laravel\Jetstream\HasProfilePhoto;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;
use App\Filters\QueryFilter;
use Spatie\SchemalessAttributes\SchemalessAttributesTrait;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Str;

class User extends Authenticatable implements Wallet, MustVerifyEmail
{
    use HasApiTokens;
    use HasFactory;
    use HasProfilePhoto;
    use Notifiable;
    use TwoFactorAuthenticatable;
    use SchemalessAttributesTrait;
    use HasRoles;
    use HasWallet;
    use SoftDeletes;
    use SecureDeletes;
    use SubscriptionTrait;
    use SyllabusTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */

    protected $fillable = [
        'first_name',
        'last_name',
        'user_name',
        'mobile',
        'email',
        'password',
        'is_active',
        'preferences',
        'email_verified_at',
        'role',
        'is_admin',
        'failed_login_attempts',
        'last_failed_login_at',
    ];

    protected $hidden = [
        'password',
        'remember_token',
        'two_factor_recovery_codes',
        'two_factor_secret',
        'verification_code',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'mobile_verified_at' => 'datetime',
        'is_active' => 'boolean',
    ];

    protected $appends = [
        'profile_photo_url',
        'role_id',
    ];

    protected $schemalessAttributes = [
        'preferences',
    ];

    /**
     * Get the default profile photo URL if no profile photo has been uploaded.
     *
     * @return string
     */
    protected function defaultProfilePhotoUrl()
    {
        return asset('images/placeholders/default-profile.svg');
    }

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */


    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */

    public function passwordHistories()
    {
        return $this->hasMany(PasswordHistory::class);
    }

    public function userGroups()
    {
        return $this->belongsToMany(UserGroup::class, 'user_group_users', 'user_id', 'user_group_id')
            ->withPivot('joined_at');
    }

    public function practiceSessions()
    {
        return $this->hasMany(PracticeSession::class);
    }

    public function quizSessions()
    {
        return $this->hasMany(QuizSession::class);
    }

    public function examSessions()
    {
        return $this->hasMany(ExamSession::class);
    }

    public function payments()
    {
        return $this->hasMany(Payment::class);
    }

    public function subscriptions()
    {
        return $this->hasMany(Subscription::class);
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

    public function scopeWithPreferencesAttributes(): Builder
    {
        return $this->preferences->modelScope();
    }

    /*
    |--------------------------------------------------------------------------
    | ACCESSORS
    |--------------------------------------------------------------------------
    */

    public function getFullNameAttribute()
    {
        return "{$this->first_name} {$this->last_name}";
    }

    public function getWalletBalanceAttribute()
    {
        return $this->wallet()->sum('balance');
    }

    public function getRoleIdAttribute()
    {
        return $this->roles->count() > 0 ? $this->roles->first()->name : null;
    }

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */

    public function setFirstNameAttribute($value)
    {
        $this->attributes['first_name'] = strip_tags($value);
    }

    public function setLastNameAttribute($value)
    {
        $this->attributes['last_name'] = strip_tags($value);
    }

    /*
    |--------------------------------------------------------------------------
    | PERFORMANCE OPTIMIZATIONS
    |--------------------------------------------------------------------------
    */

    /**
     * Get the user's active subscription with caching for performance.
     * This method implements query result caching as recommended in the audit.
     */
    public function getActiveSubscriptionCached()
    {
        return \Cache::remember(
            "user.{$this->id}.active_subscription",
            3600, // 1 hour cache
            fn() => $this->subscriptions()->where('status', 'active')->first()
        );
    }

    /**
     * Get user's exam sessions with eager loading optimization.
     * This method demonstrates the recommended eager loading approach.
     */
    public function getExamSessionsOptimized()
    {
        return $this->examSessions()
            ->with(['exam', 'examAnswers'])
            ->latest()
            ->get();
    }

    /**
     * Invalidate all of the user's sessions.
     */
    public function invalidateAllSessions()
    {
        if (config('session.driver') !== 'database') {
            return;
        }

        \DB::table(config('session.table', 'sessions'))
            ->where('user_id', $this->id)
            ->delete();
    }

    /**
     * Export user data for GDPR compliance.
     *
     * @return array
     */
    public function exportData(): array
    {
        return [
            'profile' => $this->toArray(),
            'subscriptions' => $this->subscriptions,
            'payments' => $this->payments,
            'exam_sessions' => $this->examSessions,
        ];
    }

    /**
     * Anonymize user data for GDPR compliance.
     */
    public function anonymize()
    {
        $this->update([
            'first_name' => 'Anonymous',
            'last_name' => 'User',
            'user_name' => 'anonymous_' . $this->id,
            'email' => 'anonymous_' . $this->id . '@example.com',
            'mobile' => null,
            'password' => \Hash::make(Str::random(32)),
            'is_active' => false,
        ]);
    }
}
