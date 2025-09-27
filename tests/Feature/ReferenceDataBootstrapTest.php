<?php

namespace Tests\Feature;

use App\Actions\ReferenceData\SyncReferenceData;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class ReferenceDataBootstrapTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function it_bootstraps_core_reference_tables_when_missing(): void
    {
        $tables = [
            'question_types',
            'difficulty_levels',
            'quiz_types',
            'sub_category_types',
        ];

        foreach ($tables as $table) {
            DB::table($table)->delete();
        }

        app(SyncReferenceData::class)->handle();

        $this->assertSame(8, DB::table('question_types')->count());
        $this->assertSame(5, DB::table('difficulty_levels')->count());
        $this->assertSame(6, DB::table('quiz_types')->count());
        $this->assertSame(10, DB::table('sub_category_types')->count());
    }
}
