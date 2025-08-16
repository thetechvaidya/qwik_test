<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;
use App\Models\ExamSession;
use App\Models\QuizSession;
use App\Models\PracticeSession;
use App\Models\User;
use App\Models\Question;
use App\Models\Exam;
use Maatwebsite\Excel\Facades\Excel;
use Barryvdh\DomPDF\Facade\Pdf;

class DataExportController extends Controller
{
    public function __construct()
    {
        $this->middleware(['auth', 'role:admin']);
    }

    /**
     * Export exam sessions
     */
    public function exportExamSessions(Request $request): Response
    {
        $format = $request->get('format', 'excel');
        $examId = $request->get('exam_id');
        $categoryId = $request->get('category_id');
        $dateFrom = $request->get('date_from');
        $dateTo = $request->get('date_to');
        $columns = $request->get('columns', []);

        $query = ExamSession::with(['user', 'exam']);

        if ($examId) {
            $query->where('exam_id', $examId);
        }

        if ($categoryId) {
            $query->whereHas('exam', function ($q) use ($categoryId) {
                $q->where('category_id', $categoryId);
            });
        }

        if ($dateFrom) {
            $query->where('created_at', '>=', $dateFrom);
        }

        if ($dateTo) {
            $query->where('created_at', '<=', $dateTo);
        }

        $sessions = $query->get();

        if ($format === 'csv') {
            return $this->exportToCsv($sessions, 'exam-sessions.csv');
        }

        return $this->exportToExcel($sessions, 'exam-sessions.xlsx');
    }

    /**
     * Export quiz sessions
     */
    public function exportQuizSessions(Request $request): Response
    {
        $format = $request->get('format', 'excel');
        $dateFrom = $request->get('date_from');
        $dateTo = $request->get('date_to');

        $query = QuizSession::with(['user', 'quiz']);

        if ($dateFrom) {
            $query->where('created_at', '>=', $dateFrom);
        }

        if ($dateTo) {
            $query->where('created_at', '<=', $dateTo);
        }

        $sessions = $query->get();

        if ($format === 'csv') {
            return $this->exportToCsv($sessions, 'quiz-sessions.csv');
        }

        return $this->exportToExcel($sessions, 'quiz-sessions.xlsx');
    }

    /**
     * Export practice sessions
     */
    public function exportPracticeSessions(Request $request): Response
    {
        $format = $request->get('format', 'excel');
        $sessions = PracticeSession::with(['user', 'topic'])->get();

        if ($format === 'csv') {
            return $this->exportToCsv($sessions, 'practice-sessions.csv');
        }

        return $this->exportToExcel($sessions, 'practice-sessions.xlsx');
    }

    /**
     * Export users
     */
    public function exportUsers(Request $request): Response
    {
        $format = $request->get('format', 'excel');
        $includeExamStats = $request->get('include_exam_stats', false);

        $query = User::query();

        if ($includeExamStats) {
            $query->withCount(['examSessions', 'quizSessions']);
        }

        $users = $query->get();

        if ($format === 'csv') {
            return $this->exportToCsv($users, 'users.csv');
        }

        return $this->exportToExcel($users, 'users.xlsx');
    }

    /**
     * Export questions
     */
    public function exportQuestions(Request $request): Response
    {
        $format = $request->get('format', 'excel');
        $examId = $request->get('exam_id');

        $query = Question::with(['exam', 'topic', 'difficultyLevel']);

        if ($examId) {
            $query->where('exam_id', $examId);
        }

        $questions = $query->get();

        if ($format === 'csv') {
            return $this->exportToCsv($questions, 'questions.csv');
        }

        return $this->exportToExcel($questions, 'questions.xlsx');
    }

    /**
     * Export exam report as PDF
     */
    public function exportExamReportPdf(Exam $exam): Response
    {
        $data = [
            'exam' => $exam,
            'sessions' => $exam->examSessions()->with('user')->get(),
            'statistics' => [
                'total_sessions' => $exam->examSessions()->count(),
                'average_score' => $exam->examSessions()->avg('score'),
                'pass_rate' => $exam->examSessions()->where('status', 'pass')->count(),
            ]
        ];

        $pdf = Pdf::loadView('admin.exports.exam-report', $data);
        
        return $pdf->download("exam-{$exam->id}-report.pdf");
    }

    /**
     * Export exam session PDF
     */
    public function exportExamSessionPdf(ExamSession $examSession): Response
    {
        $data = [
            'session' => $examSession,
            'user' => $examSession->user,
            'exam' => $examSession->exam,
        ];

        $pdf = Pdf::loadView('admin.exports.exam-session', $data);
        
        return $pdf->download("exam-session-{$examSession->id}.pdf");
    }

    /**
     * Schedule export
     */
    public function scheduleExport(Request $request): JsonResponse
    {
        $exportType = $request->get('export_type');
        $frequency = $request->get('frequency');

        // Implementation for scheduling exports would go here
        // This could use Laravel's job queue system

        return response()->json([
            'success' => true,
            'message' => 'Export scheduled successfully',
            'export_type' => $exportType,
            'frequency' => $frequency,
        ]);
    }

    /**
     * Get export status
     */
    public function getExportStatus(string $exportId): JsonResponse
    {
        // Mock implementation - in real app would check actual export status
        return response()->json([
            'id' => $exportId,
            'status' => 'completed',
            'progress' => 100,
            'download_url' => "/admin/exports/{$exportId}/download",
        ]);
    }

    /**
     * Get export template
     */
    public function getExportTemplate(string $type): Response
    {
        $templates = [
            'users' => [
                ['name', 'email', 'role', 'created_at'],
            ],
            'questions' => [
                ['question_text', 'question_type', 'marks', 'category', 'difficulty'],
            ],
        ];

        $template = $templates[$type] ?? [];

        return $this->exportToExcel($template, "{$type}-template.xlsx");
    }

    /**
     * Export comprehensive report
     */
    public function exportComprehensiveReport(Request $request): Response
    {
        $format = $request->get('format', 'excel');
        $includeSheets = $request->get('include_sheets', []);

        $data = [];

        if (in_array('exam_sessions', $includeSheets)) {
            $data['exam_sessions'] = ExamSession::with(['user', 'exam'])->get();
        }

        if (in_array('quiz_sessions', $includeSheets)) {
            $data['quiz_sessions'] = QuizSession::with(['user', 'quiz'])->get();
        }

        if (in_array('summary', $includeSheets)) {
            $data['summary'] = [
                'total_users' => User::count(),
                'total_exams' => Exam::count(),
                'total_sessions' => ExamSession::count(),
            ];
        }

        return $this->exportToExcel($data, 'comprehensive-report.xlsx');
    }

    /**
     * Helper method to export to Excel
     */
    private function exportToExcel($data, string $filename): Response
    {
        // Mock implementation - in real app would use Laravel Excel
        return response()->download(storage_path('app/exports/' . $filename));
    }

    /**
     * Helper method to export to CSV
     */
    private function exportToCsv($data, string $filename): Response
    {
        // Mock implementation - in real app would generate actual CSV
        return response()->download(storage_path('app/exports/' . $filename));
    }
}
