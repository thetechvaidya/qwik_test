<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;

class TestRunnerController extends Controller
{
    public function runTests()
    {
        try {
            Artisan::call('test', ['--testsuite' => 'Feature']);
            $output = Artisan::output();
            return response()->json(['output' => $output]);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}