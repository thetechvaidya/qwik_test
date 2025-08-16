<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\UploadedFile;
use App\Models\User;
use App\Models\Question;
use App\Models\Exam;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class DataImportController extends Controller
{
    public function __construct()
    {
        $this->middleware(['auth', 'role:admin']);
    }

    /**
     * Import users from file
     */
    public function importUsers(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'file' => 'required|file|mimes:xlsx,xls,csv',
            'has_headers' => 'boolean',
            'handle_duplicates' => 'string|in:skip,update,fail',
            'process_in_background' => 'boolean',
            'validate_only' => 'boolean',
            'batch_size' => 'integer|min:1|max:1000',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $file = $request->file('file');
        $hasHeaders = $request->get('has_headers', true);
        $handleDuplicates = $request->get('handle_duplicates', 'skip');
        $processInBackground = $request->get('process_in_background', false);
        $validateOnly = $request->get('validate_only', false);
        $batchSize = $request->get('batch_size', 100);

        try {
            $result = $this->processUserImport($file, [
                'has_headers' => $hasHeaders,
                'handle_duplicates' => $handleDuplicates,
                'process_in_background' => $processInBackground,
                'validate_only' => $validateOnly,
                'batch_size' => $batchSize,
            ]);

            return response()->json([
                'success' => true,
                'message' => $validateOnly ? 'Validation completed' : 'Users imported successfully',
                'imported_count' => $result['imported_count'] ?? 0,
                'skipped_count' => $result['skipped_count'] ?? 0,
                'error_count' => $result['error_count'] ?? 0,
                'validation_errors' => $result['validation_errors'] ?? [],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Import questions from file
     */
    public function importQuestions(Request $request, Exam $exam = null): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'file' => 'required|file|mimes:xlsx,xls,csv',
            'exam_id' => 'nullable|exists:exams,id',
            'has_headers' => 'boolean',
            'validate_only' => 'boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $file = $request->file('file');
        $examId = $request->get('exam_id') ?? $exam?->id;
        $hasHeaders = $request->get('has_headers', true);
        $validateOnly = $request->get('validate_only', false);

        try {
            $result = $this->processQuestionImport($file, [
                'exam_id' => $examId,
                'has_headers' => $hasHeaders,
                'validate_only' => $validateOnly,
            ]);

            return response()->json([
                'success' => true,
                'message' => $validateOnly ? 'Validation completed' : 'Questions imported successfully',
                'imported_count' => $result['imported_count'] ?? 0,
                'error_count' => $result['error_count'] ?? 0,
                'validation_errors' => $result['validation_errors'] ?? [],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Process user import
     */
    private function processUserImport(UploadedFile $file, array $options): array
    {
        // Mock implementation - in real app would use Laravel Excel or CSV parser
        $data = $this->parseImportFile($file);
        
        $importedCount = 0;
        $skippedCount = 0;
        $errorCount = 0;
        $validationErrors = [];

        if ($options['validate_only']) {
            // Just validate the data without importing
            foreach ($data as $index => $row) {
                $validation = $this->validateUserRow($row);
                if (!$validation['valid']) {
                    $validationErrors[] = [
                        'row' => $index + 1,
                        'errors' => $validation['errors']
                    ];
                    $errorCount++;
                }
            }
        } else {
            // Actually import the data
            DB::transaction(function () use ($data, $options, &$importedCount, &$skippedCount, &$errorCount) {
                foreach ($data as $row) {
                    try {
                        $validation = $this->validateUserRow($row);
                        if (!$validation['valid']) {
                            $errorCount++;
                            continue;
                        }

                        $existingUser = User::where('email', $row['email'])->first();
                        
                        if ($existingUser) {
                            switch ($options['handle_duplicates']) {
                                case 'skip':
                                    $skippedCount++;
                                    continue 2;
                                case 'update':
                                    $existingUser->update($row);
                                    $importedCount++;
                                    break;
                                case 'fail':
                                    throw new \Exception("Duplicate email: {$row['email']}");
                            }
                        } else {
                            User::create($row);
                            $importedCount++;
                        }
                    } catch (\Exception $e) {
                        $errorCount++;
                    }
                }
            });
        }

        return [
            'imported_count' => $importedCount,
            'skipped_count' => $skippedCount,
            'error_count' => $errorCount,
            'validation_errors' => $validationErrors,
        ];
    }

    /**
     * Process question import
     */
    private function processQuestionImport(UploadedFile $file, array $options): array
    {
        // Mock implementation - in real app would use Laravel Excel or CSV parser
        $data = $this->parseImportFile($file);
        
        $importedCount = 0;
        $errorCount = 0;
        $validationErrors = [];

        if ($options['validate_only']) {
            // Just validate the data without importing
            foreach ($data as $index => $row) {
                $validation = $this->validateQuestionRow($row);
                if (!$validation['valid']) {
                    $validationErrors[] = [
                        'row' => $index + 1,
                        'errors' => $validation['errors']
                    ];
                    $errorCount++;
                }
            }
        } else {
            // Actually import the data
            DB::transaction(function () use ($data, $options, &$importedCount, &$errorCount) {
                foreach ($data as $row) {
                    try {
                        $validation = $this->validateQuestionRow($row);
                        if (!$validation['valid']) {
                            $errorCount++;
                            continue;
                        }

                        Question::create(array_merge($row, [
                            'exam_id' => $options['exam_id']
                        ]));
                        $importedCount++;
                    } catch (\Exception $e) {
                        $errorCount++;
                    }
                }
            });
        }

        return [
            'imported_count' => $importedCount,
            'error_count' => $errorCount,
            'validation_errors' => $validationErrors,
        ];
    }

    /**
     * Parse import file
     */
    private function parseImportFile(UploadedFile $file): array
    {
        // Mock implementation - return sample data
        return [
            ['name' => 'John Doe', 'email' => 'john@example.com', 'role' => 'user'],
            ['name' => 'Jane Smith', 'email' => 'jane@example.com', 'role' => 'user'],
        ];
    }

    /**
     * Validate user row
     */
    private function validateUserRow(array $row): array
    {
        $validator = Validator::make($row, [
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'role' => 'string|in:admin,instructor,user',
        ]);

        return [
            'valid' => !$validator->fails(),
            'errors' => $validator->errors()->toArray(),
        ];
    }

    /**
     * Validate question row
     */
    private function validateQuestionRow(array $row): array
    {
        $validator = Validator::make($row, [
            'question_text' => 'required|string',
            'question_type' => 'required|string|in:mcq,true_false,short_answer,essay',
            'marks' => 'required|numeric|min:1',
        ]);

        return [
            'valid' => !$validator->fails(),
            'errors' => $validator->errors()->toArray(),
        ];
    }
}
