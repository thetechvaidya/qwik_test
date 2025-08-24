<?php

namespace App\Traits;

use App\Models\ContentHistory;

trait TracksContentHistory
{
    /**
     * Boot the trait.
     *
     * @return void
     */
    public static function bootTracksContentHistory()
    {
        static::saved(function ($model) {
            if ($model->isDirty()) {
                ContentHistory::create([
                    'contentable_id' => $model->id,
                    'contentable_type' => get_class($model),
                    'changes' => $model->getChanges(),
                ]);
            }
        });
    }
}