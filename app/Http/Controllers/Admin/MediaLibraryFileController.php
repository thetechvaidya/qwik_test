<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Services\FileManagerCompatibilityService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\View\View;
use Spatie\MediaLibrary\MediaCollections\Models\Media;
use Illuminate\Support\Facades\Validator;

class MediaLibraryFileController extends Controller
{
    protected FileManagerCompatibilityService $compatibilityService;

    public function __construct(FileManagerCompatibilityService $compatibilityService)
    {
        $this->compatibilityService = $compatibilityService;
        $this->middleware(['auth', 'role:admin']);
    }

    /**
     * Display the file manager interface
     */
    public function index(): View
    {
        return view('admin.file-manager.index');
    }

    /**
     * Upload file with Media Library integration
     */
    public function upload(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'file' => 'required|file|max:10240', // 10MB max
            'folder' => 'nullable|string|max:255',
            'model_type' => 'nullable|string',
            'model_id' => 'nullable|integer',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $folder = $request->get('folder', 'uploads');
        $model = null;

        // If model information is provided, find the model
        if ($request->has('model_type') && $request->has('model_id')) {
            $modelClass = $request->get('model_type');
            $modelId = $request->get('model_id');
            
            if (class_exists($modelClass)) {
                $model = $modelClass::find($modelId);
            }
        }

        $result = $this->compatibilityService->uploadFile(
            $request->file('file'),
            $folder,
            $model
        );

        return response()->json($result, $result['success'] ? 200 : 400);
    }

    /**
     * Delete file
     */
    public function delete(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'path' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $result = $this->compatibilityService->deleteFile($request->get('path'));

        return response()->json($result, $result['success'] ? 200 : 400);
    }

    /**
     * Create directory
     */
    public function createDirectory(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'path' => 'required|string',
            'name' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $result = $this->compatibilityService->createDirectory(
            $request->get('path'),
            $request->get('name')
        );

        return response()->json($result, $result['success'] ? 200 : 400);
    }

    /**
     * Rename file or directory
     */
    public function rename(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'old_path' => 'required|string',
            'new_name' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $result = $this->compatibilityService->renameFile(
            $request->get('old_path'),
            $request->get('new_name')
        );

        return response()->json($result, $result['success'] ? 200 : 400);
    }

    /**
     * Move file or directory
     */
    public function move(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'source_path' => 'required|string',
            'destination_path' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $result = $this->compatibilityService->moveFile(
            $request->get('source_path'),
            $request->get('destination_path')
        );

        return response()->json($result, $result['success'] ? 200 : 400);
    }

    /**
     * Copy file or directory
     */
    public function copy(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'source_path' => 'required|string',
            'destination_path' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $result = $this->compatibilityService->copyFile(
            $request->get('source_path'),
            $request->get('destination_path')
        );

        return response()->json($result, $result['success'] ? 200 : 400);
    }

    /**
     * Browse directory contents
     */
    public function browse(Request $request): JsonResponse
    {
        $path = $request->get('path', '');
        $result = $this->compatibilityService->browseDirectory($path);

        return response()->json($result, $result['success'] ? 200 : 400);
    }

    /**
     * Search files
     */
    public function search(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'query' => 'required|string|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $result = $this->compatibilityService->searchFiles($request->get('query'));

        return response()->json($result, $result['success'] ? 200 : 400);
    }

    /**
     * Get file information
     */
    public function info(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'path' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $result = $this->compatibilityService->getFileInfo($request->get('path'));

        return response()->json($result, $result['success'] ? 200 : 400);
    }

    /**
     * Compress files into archive
     */
    public function compress(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'files' => 'required|array',
            'archive_name' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // Implementation for file compression
        try {
            $files = $request->get('files');
            $archiveName = $request->get('archive_name');
            
            // Create zip archive using ZipArchive
            $zip = new \ZipArchive();
            $zipPath = storage_path('app/public/archives/' . $archiveName);
            
            // Ensure archives directory exists
            if (!file_exists(dirname($zipPath))) {
                mkdir(dirname($zipPath), 0755, true);
            }

            if ($zip->open($zipPath, \ZipArchive::CREATE) === TRUE) {
                foreach ($files as $file) {
                    // Try to find file in Media Library first
                    $media = Media::where('file_name', basename($file))->first();
                    if ($media && file_exists($media->getPath())) {
                        $zip->addFile($media->getPath(), basename($file));
                    } elseif (\Storage::disk('public')->exists($file)) {
                        $zip->addFile(\Storage::disk('public')->path($file), basename($file));
                    }
                }
                $zip->close();

                return response()->json([
                    'success' => true,
                    'archive_path' => 'archives/' . $archiveName,
                    'download_url' => asset('storage/archives/' . $archiveName),
                ]);
            }

            return response()->json([
                'success' => false,
                'error' => 'Failed to create archive'
            ], 400);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Extract archive
     */
    public function extract(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'archive_path' => 'required|string',
            'destination' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $archivePath = $request->get('archive_path');
            $destination = $request->get('destination');
            
            if (!\Storage::disk('public')->exists($archivePath)) {
                return response()->json([
                    'success' => false,
                    'error' => 'Archive not found'
                ], 404);
            }

            $zip = new \ZipArchive();
            $fullArchivePath = \Storage::disk('public')->path($archivePath);
            $destinationPath = \Storage::disk('public')->path($destination);

            if (!file_exists($destinationPath)) {
                mkdir($destinationPath, 0755, true);
            }

            if ($zip->open($fullArchivePath) === TRUE) {
                $zip->extractTo($destinationPath);
                $zip->close();

                return response()->json([
                    'success' => true,
                    'extracted_to' => $destination,
                ]);
            }

            return response()->json([
                'success' => false,
                'error' => 'Failed to extract archive'
            ], 400);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 400);
        }
    }

    /**
     * Bulk delete files
     */
    public function bulkDelete(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'files' => 'required|array',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $files = $request->get('files');
        $results = [];
        $errors = [];

        foreach ($files as $file) {
            $result = $this->compatibilityService->deleteFile($file);
            $results[] = $result;
            
            if (!$result['success']) {
                $errors[] = "Failed to delete {$file}: " . ($result['error'] ?? 'Unknown error');
            }
        }

        return response()->json([
            'success' => empty($errors),
            'results' => $results,
            'errors' => $errors,
        ]);
    }

    /**
     * CKEditor integration
     */
    public function ckeditor(Request $request): View
    {
        return view('admin.file-manager.ckeditor');
    }

    /**
     * File manager button integration
     */
    public function button(Request $request): View
    {
        return view('admin.file-manager.button');
    }
}
