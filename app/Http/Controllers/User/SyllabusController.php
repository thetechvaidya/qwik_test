<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;

class SyllabusController extends Controller
{
    /**
     * @deprecated The change syllabus feature has been removed.
     */
    public function __invoke(): void
    {
        abort(404);
    }
}
