<?php

namespace App\Models;

use App\Filters\QueryFilter;
use App\Settings\LocalizationSettings;
use App\Traits\SecureDeletes;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\Log;
use InvalidArgumentException;
use Spatie\SchemalessAttributes\SchemalessAttributesTrait;

class Payment extends Model
{
    use HasFactory;
    use SoftDeletes;
    use SecureDeletes;
    use SchemalessAttributesTrait;

    protected $fillable = ['user_id', 'plan_id', 'payment_id', 'transaction_id', 'amount', 'currency', 'status', 'payment_date', 'gateway', 'data'];

    protected $schemalessAttributes = [
        'data',
    ];

    public const VALID_STATUSES = ['pending', 'completed', 'failed', 'refunded'];

    /*
    |--------------------------------------------------------------------------
    | BOOTED
    |--------------------------------------------------------------------------
    */
    protected static function booted()
    {
        static::updating(function ($payment) {
            if ($payment->isDirty('status')) {
                Log::channel('payment')->info('Payment status changed', [
                    'payment_id' => $payment->id,
                    'old_status' => $payment->getOriginal('status'),
                    'new_status' => $payment->status,
                ]);
            }
        });
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

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function plan()
    {
        return $this->belongsTo(Plan::class);
    }

    public function subscription()
    {
        return $this->hasOne(Subscription::class);
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

    public function scopeWithDataAttributes(): Builder
    {
        return $this->data->modelScope();
    }

    /*
    |--------------------------------------------------------------------------
    | ACCESSORS
    |--------------------------------------------------------------------------
    */

    public function getPaymentDateAttribute($value)
    {
        $localization = app(LocalizationSettings::class);
        return Carbon::parse($value)->timezone($localization->default_timezone);
    }

    public function getDataAttribute($value)
    {
        try {
            return json_decode(Crypt::decryptString($value), true);
        } catch (\Exception $e) {
            return null;
        }
    }

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */

    public function setStatusAttribute($value)
    {
        if (!in_array($value, self::VALID_STATUSES)) {
            throw new InvalidArgumentException("Invalid status: {$value}");
        }

        if (!is_numeric($this->attributes['amount']) || $this->attributes['amount'] <= 0) {
            throw new InvalidArgumentException('Invalid payment amount.');
        }

        if (!in_array($this->attributes['currency'], config('billing.allowed_currencies', ['USD', 'EUR', 'GBP', 'INR']))) {
            throw new InvalidArgumentException('Invalid currency.');
        }

        $this->attributes['status'] = $value;
    }

    public function setDataAttribute($value)
    {
        $this->attributes['data'] = Crypt::encryptString(json_encode($value));
    }
}
