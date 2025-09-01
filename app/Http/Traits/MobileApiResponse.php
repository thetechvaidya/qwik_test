<?php

namespace App\Http\Traits;

trait MobileApiResponse
{
    /**
     * Return a successful mobile API response
     */
    protected function mobileSuccess($data = null, string $message = 'Success', int $status = 200)
    {
        $response = [
            'success' => true,
            'message' => $message,
        ];

        if ($data !== null) {
            $response['data'] = $data;
        }

        return response()->json($response, $status);
    }

    /**
     * Return an error mobile API response
     */
    protected function mobileError(string $message = 'Error', $errors = null, int $status = 400)
    {
        $response = [
            'success' => false,
            'message' => $message,
        ];

        if ($errors !== null) {
            $response['errors'] = $errors;
        }

        return response()->json($response, $status);
    }

    /**
     * Return paginated mobile API response
     */
    protected function mobilePaginated($data, string $message = 'Success')
    {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $data->items(),
            'pagination' => [
                'current_page' => $data->currentPage(),
                'last_page' => $data->lastPage(),
                'per_page' => $data->perPage(),
                'total' => $data->total(),
                'has_more' => $data->hasMorePages(),
            ],
        ]);
    }

    /**
     * Return mobile API response with metadata
     */
    protected function mobileWithMeta($data, array $meta, string $message = 'Success')
    {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $data,
            'meta' => $meta,
        ]);
    }

    /**
     * Return validation error response for mobile
     */
    protected function mobileValidationError($validator)
    {
        return $this->mobileError(
            'Validation failed',
            $validator->errors(),
            422
        );
    }
}