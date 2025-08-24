<?php

namespace App\Models;

use App\Filters\QueryFilter;
use App\Settings\LocalizationSettings;
use App\Traits\SecureDeletes;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class Subscription extends Model
{
    use HasFactory;
    use SoftDeletes;
    use SecureDeletes;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */

    protected $table = 'subscriptions';

    protected $fillable = [
        'user_id',
        'plan_id',
        'payment_id',
        'category_type',
        'category_id',
        'status',
        'starts_at',
        'expires_at',
        'duration'
    ];

    protected $casts = [
        'starts_at' => 'datetime',
        'expires_at' => 'datetime',
    ];

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */

    protected static function booted()
    {
        static::creating(function ($subscription) {
            $subscription->attributes['code'] = 'subscription_'.Str::random(11);
        });

        static::saving(function ($subscription) {
            $subscription->validateSubscription();
            $subscription->checkForSuspiciousActivity();
        });
    }

    public function isActive()
    {
        return $this->status === 'active' && $this->expires_at && Carbon::parse($this->expires_at)->isFuture();
    }

    public function validateSubscription()
    {
        if ($this->starts_at && $this->expires_at && $this->starts_at->gte($this->expires_at)) {
            throw ValidationException::withMessages([
                'expires_at' => 'The expiration date must be after the start date.',
            ]);
        }

        if ($this->isDirty('status') && $this->getOriginal('status') === 'expired' && $this->status !== 'expired') {
            throw ValidationException::withMessages([
                'status' => 'Cannot change the status of an expired subscription.',
            ]);
        }
    }

    public function checkForSuspiciousActivity()
    {
        // Monitor for rapid status changes or unusual subscription patterns
        if ($this->isDirty('status') && $this->getOriginal('status')) {
            $originalStatus = $this->getOriginal('status');
            Log::channel('fraud')->info("Subscription status changed for user {$this->user_id} from {$originalStatus} to {$this->status}.");
        }
    }


    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */

    public function category()
    {
        return $this->morphTo();
    }

    public function plan()
    {
        return $this->belongsTo(Plan::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function payment()
    {
        return $this->belongsTo(Payment::class);
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

    public function scopeForUser($query, User $user)
    {
        return $query->where('user_id', $user->id);
    }

    public function scopeExpired($query)
    {
        return $query->where('expires_at', '<=', Carbon::now());
    }

    /*
    |--------------------------------------------------------------------------
    | ACCESSORS
    |--------------------------------------------------------------------------
    */

    public function getStartsAttribute($value)
    {
        $localization = app(LocalizationSettings::class);
        return Carbon::parse($value)->timezone($localization->default_timezone)->toFormattedDateString();
    }

    public function getExpiresAttribute($value)
    {
        $localization = app(LocalizationSettings::class);
        return Carbon::parse($value)->timezone($localization->default_timezone)->toFormattedDateString();
    }

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */
}
