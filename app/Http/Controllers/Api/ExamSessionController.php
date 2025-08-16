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
     * Finish exam session
     */
    public function finish(ExamSession $examSession): JsonResponse
    {
        $examSession->update([
            'status' => 'completed',
            'finished_at' => now(),
        ]);

        return response()->json([
            'data' => $examSession,
            'message' => 'Exam session completed successfully',
        ]);
    }
}
