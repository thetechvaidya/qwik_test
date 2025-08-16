<?php

namespace App\Services;

use App\Models\Exam;
use App\Models\ExamSchedule;
use Carbon\Carbon;

class ExamSchedulerService
{
    /**
     * Schedule an exam
     */
    public function scheduleExam(Exam $exam, array $scheduleData): ExamSchedule
    {
        return ExamSchedule::create([
            'exam_id' => $exam->id,
            'start_date' => $scheduleData['start_date'],
            'end_date' => $scheduleData['end_date'],
            'max_attempts' => $scheduleData['max_attempts'] ?? 1,
            'is_active' => $scheduleData['is_active'] ?? true,
        ]);
    }

    /**
     * Check if exam is currently active
     */
    public function isExamActive(Exam $exam): bool
    {
        $now = now();
        
        return $exam->schedules()
            ->where('is_active', true)
            ->where('start_date', '<=', $now)
            ->where('end_date', '>=', $now)
            ->exists();
    }

    /**
     * Get upcoming exams
     */
    public function getUpcomingExams(int $days = 7): \Illuminate\Database\Eloquent\Collection
    {
        $startDate = now();
        $endDate = now()->addDays($days);

        return Exam::whereHas('schedules', function ($query) use ($startDate, $endDate) {
            $query->where('is_active', true)
                  ->whereBetween('start_date', [$startDate, $endDate]);
        })->get();
    }

    /**
     * Expire old exam schedules
     */
    public function expireOldSchedules(): int
    {
        return ExamSchedule::where('end_date', '<', now())
            ->where('is_active', true)
            ->update(['is_active' => false]);
    }
}
