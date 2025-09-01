<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ExamSession;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ExamSessionController extends Controller
{
    /**
     * Submit answer for a question
     */
    public function submitAnswer(Request $request, ExamSession $examSession): JsonResponse
    {
        $this->validate($request, [
            'question_id' => 'required|exists:questions,id',
            'answer' => 'required',
        ]);

        // Store the answer (implementation would depend on your answer storage structure)
        $answerData = [
            'exam_session_id' => $examSession->id,
            'question_id' => $request->question_id,
            'answer' => $request->answer,
            'answered_at' => now(),
        ];

        // In a real implementation, you'd store this in an answers table
        // For now, we'll just return success

        return response()->json([
            'success' => true,
            'message' => 'Answer submitted successfully',
        ]);
    }

    /**
     * Finish an exam session
     */
    public function finish(Request $request, ExamSession $examSession)
    {
        // Ensure the session belongs to the authenticated user
        if ($examSession->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Mark session as completed
        $examSession->update([
            'status' => 'completed',
            'completed_at' => now(),
        ]);

        // Calculate final score (this would typically involve more complex logic)
        $totalQuestions = $examSession->exam->total_questions;
        $correctAnswers = $examSession->examSessionQuestions()->where('is_correct', true)->count();
        $score = ($correctAnswers / $totalQuestions) * 100;
        
        $examSession->update(['score' => $score]);

        return response()->json([
            'message' => 'Exam completed successfully',
            'score' => $score,
            'correct_answers' => $correctAnswers,
            'total_questions' => $totalQuestions
        ]);
    }

    /**
     * Mobile-optimized session status (200-byte response target)
     */
    public function mobileStatus(Request $request, ExamSession $examSession)
    {
        // Ensure the session belongs to the authenticated user
        if ($examSession->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $timeRemaining = $examSession->expires_at ? $examSession->expires_at->diffInSeconds(now(), false) : null;
        
        return response()->json([
            'id' => $examSession->id,
            'status' => $examSession->status,
            'progress' => $examSession->examSessionQuestions()->whereNotNull('selected_answer')->count(),
            'total' => $examSession->exam->total_questions,
            'time_left' => max(0, $timeRemaining ?? 0),
            'score' => $examSession->score
        ]);
    }

    /**
     * Mobile submit answer (optimized)
     */
    public function mobileSubmitAnswer(Request $request, ExamSession $examSession)
    {
        // Ensure the session belongs to the authenticated user
        if ($examSession->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Check if session is still active
        if ($examSession->status !== 'active') {
            return response()->json(['message' => 'Session not active'], 422);
        }

        $validated = $request->validate([
            'question_id' => 'required|exists:exam_questions,id',
            'answer' => 'required|string'
        ]);

        // Find or create session question
        $sessionQuestion = $examSession->examSessionQuestions()
            ->where('exam_question_id', $validated['question_id'])
            ->first();

        if (!$sessionQuestion) {
            $sessionQuestion = $examSession->examSessionQuestions()->create([
                'exam_question_id' => $validated['question_id'],
                'selected_answer' => $validated['answer']
            ]);
        } else {
            $sessionQuestion->update([
                'selected_answer' => $validated['answer']
            ]);
        }

        return response()->json([
            'saved' => true,
            'progress' => $examSession->examSessionQuestions()->whereNotNull('selected_answer')->count()
        ]);
    }

    /**
     * Mobile finish exam (optimized)
     */
    public function mobileFinish(Request $request, ExamSession $examSession)
    {
        // Ensure the session belongs to the authenticated user
        if ($examSession->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Mark session as completed
        $examSession->update([
            'status' => 'completed',
            'completed_at' => now(),
        ]);

        // Calculate score
        $totalQuestions = $examSession->exam->total_questions;
        $correctAnswers = $examSession->examSessionQuestions()->where('is_correct', true)->count();
        $score = $totalQuestions > 0 ? round(($correctAnswers / $totalQuestions) * 100, 1) : 0;
        $passed = $score >= ($examSession->exam->passing_score ?? 60);
        
        $examSession->update([
            'score' => $score,
            'is_passed' => $passed
        ]);

        return response()->json([
            'score' => $score,
            'passed' => $passed,
            'correct' => $correctAnswers,
            'total' => $totalQuestions
        ]);
    }

    /**
     * Mobile get next question (optimized)
     */
    public function mobileNextQuestion(Request $request, ExamSession $examSession)
    {
        // Ensure the session belongs to the authenticated user
        if ($examSession->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Get next unanswered question
        $answeredQuestionIds = $examSession->examSessionQuestions()
            ->whereNotNull('selected_answer')
            ->pluck('exam_question_id');

        $nextQuestion = $examSession->exam->examQuestions()
            ->whereNotIn('id', $answeredQuestionIds)
            ->select('id', 'question_text', 'options', 'question_type')
            ->first();

        if (!$nextQuestion) {
            return response()->json([
                'completed' => true,
                'message' => 'All questions answered'
            ]);
        }

        return response()->json([
            'question' => [
                'id' => $nextQuestion->id,
                'text' => $nextQuestion->question_text,
                'options' => json_decode($nextQuestion->options, true),
                'type' => $nextQuestion->question_type
            ],
            'progress' => $answeredQuestionIds->count() + 1,
            'total' => $examSession->exam->total_questions
        ]);
    }
}
