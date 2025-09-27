<?php

namespace App\Actions\ReferenceData;

use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Schema;

class SyncReferenceData
{
    /**
     * Ensure critical reference data tables contain the expected baseline rows.
     */
    public function handle(): void
    {
        if (!method_exists(Schema::class, 'hasTable')) {
            return;
        }

        $this->syncQuestionTypes();
        $this->syncDifficultyLevels();
        $this->syncQuizTypes();
        $this->syncSubCategoryTypes();
    }

    private function syncQuestionTypes(): void
    {
        $this->syncTable('question_types', 'code', $this->questionTypes());
    }

    private function syncDifficultyLevels(): void
    {
        $this->syncTable('difficulty_levels', 'code', $this->difficultyLevels());
    }

    private function syncQuizTypes(): void
    {
        $this->syncTable('quiz_types', 'code', $this->quizTypes());
    }

    private function syncSubCategoryTypes(): void
    {
        $this->syncTable('sub_category_types', 'code', $this->subCategoryTypes());
    }

    private function syncTable(string $table, string $uniqueKey, array $rows): void
    {
        if (empty($rows) || !Schema::hasTable($table)) {
            return;
        }

        try {
            $columns = Schema::getColumnListing($table);
            $hasCreatedAt = in_array('created_at', $columns, true);
            $hasUpdatedAt = in_array('updated_at', $columns, true);
            $hasDeletedAt = in_array('deleted_at', $columns, true);
            $timestamp = Carbon::now();

            foreach ($rows as $row) {
                if (!array_key_exists($uniqueKey, $row)) {
                    continue;
                }

                $keyValue = $row[$uniqueKey];
                $existing = DB::table($table)->where($uniqueKey, $keyValue)->first();

                $payload = $row;
                if ($hasUpdatedAt) {
                    $payload['updated_at'] = $timestamp;
                }
                if ($hasDeletedAt) {
                    $payload['deleted_at'] = null;
                }

                if ($existing) {
                    if ($hasCreatedAt) {
                        unset($payload['created_at']);
                    }

                    DB::table($table)
                        ->where($uniqueKey, $keyValue)
                        ->update($payload);
                } else {
                    if ($hasCreatedAt && !isset($payload['created_at'])) {
                        $payload['created_at'] = $timestamp;
                    }

                    DB::table($table)->insert($payload);
                }
            }
        } catch (\Throwable $e) {
            Log::error('Failed bootstrapping reference data', [
                'table' => $table,
                'error' => $e->getMessage(),
            ]);
        }
    }

    private function questionTypes(): array
    {
        return [
            [
                'name' => 'Multiple Choice Single Answer',
                'code' => 'MSA',
                'type' => 'objective',
                'icon_path' => 'msa.png',
                'short_description' => 'This question type allows a single correct answer from a list of options.',
                'is_active' => 1,
            ],
            [
                'name' => 'Multiple Choice Multiple Answers',
                'code' => 'MMA',
                'type' => 'objective',
                'icon_path' => 'mma.png',
                'short_description' => 'Multiple correct answers can be selected for this question type.',
                'is_active' => 1,
            ],
            [
                'name' => 'True or False',
                'code' => 'TOF',
                'type' => 'objective',
                'icon_path' => 'tof.png',
                'short_description' => 'Binary true/false style question.',
                'is_active' => 1,
            ],
            [
                'name' => 'Short Answer',
                'code' => 'SAQ',
                'type' => 'objective',
                'icon_path' => 'saq.png',
                'short_description' => 'Users provide short text or numeric answers.',
                'is_active' => 1,
            ],
            [
                'name' => 'Match the Following',
                'code' => 'MTF',
                'type' => 'objective',
                'icon_path' => 'mtf.png',
                'short_description' => 'Match related items across two lists.',
                'is_active' => 1,
            ],
            [
                'name' => 'Ordering/Sequence',
                'code' => 'ORD',
                'type' => 'objective',
                'icon_path' => 'ord.png',
                'short_description' => 'Arrange items in the correct order.',
                'is_active' => 1,
            ],
            [
                'name' => 'Fill in the Blanks',
                'code' => 'FIB',
                'type' => 'objective',
                'icon_path' => 'fib.png',
                'short_description' => 'Learners provide the missing words in a statement.',
                'is_active' => 1,
            ],
            [
                'name' => 'Long Answer/Paragraph',
                'code' => 'LAQ',
                'type' => 'subjective',
                'icon_path' => 'laq.png',
                'short_description' => 'Extended text responses comparable to essay questions.',
                'is_active' => 0,
            ],
        ];
    }

    private function difficultyLevels(): array
    {
        return [
            ['name' => 'Very Easy', 'code' => 'VERYEASY', 'is_active' => 1],
            ['name' => 'Easy', 'code' => 'EASY', 'is_active' => 1],
            ['name' => 'Medium', 'code' => 'MEDIUM', 'is_active' => 1],
            ['name' => 'High', 'code' => 'HIGH', 'is_active' => 1],
            ['name' => 'Very High', 'code' => 'VERYHIGH', 'is_active' => 1],
        ];
    }

    private function quizTypes(): array
    {
        return [
            ['name' => 'Quiz', 'code' => 'qtp_lLvoMjFoKRf', 'slug' => 'quiz', 'is_active' => 1],
            ['name' => 'Contest', 'code' => 'qtp_uqQvsmXRube', 'slug' => 'contest', 'is_active' => 1],
            ['name' => 'Daily Challenge', 'code' => 'qtp_xJnjmbmgV5E', 'slug' => 'daily-challenge', 'is_active' => 1],
            ['name' => 'Daily Task', 'code' => 'qtp_dJ7t7b2onxc', 'slug' => 'daily-task', 'is_active' => 1],
            ['name' => 'Hackathon', 'code' => 'qtp_pALr8tBpML7', 'slug' => 'hackathon', 'is_active' => 1],
            ['name' => 'Assignment', 'code' => 'qtp_ok3cIEqIHg4', 'slug' => 'assignment', 'is_active' => 1],
        ];
    }

    private function subCategoryTypes(): array
    {
        return [
            ['name' => 'Course', 'code' => 'course', 'is_active' => 1],
            ['name' => 'Certification', 'code' => 'certification', 'is_active' => 1],
            ['name' => 'Class', 'code' => 'class', 'is_active' => 1],
            ['name' => 'Exam', 'code' => 'exam', 'is_active' => 1],
            ['name' => 'Grade', 'code' => 'grade', 'is_active' => 1],
            ['name' => 'Standard', 'code' => 'standard', 'is_active' => 1],
            ['name' => 'Stream', 'code' => 'stream', 'is_active' => 1],
            ['name' => 'Level', 'code' => 'level', 'is_active' => 1],
            ['name' => 'Skill', 'code' => 'skill', 'is_active' => 1],
            ['name' => 'Branch', 'code' => 'branch', 'is_active' => 1],
        ];
    }
}
