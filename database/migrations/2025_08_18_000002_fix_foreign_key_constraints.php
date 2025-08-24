<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        // Drop existing foreign keys to redefine them
        Schema::table('questions', function (Blueprint $table) {
            if (Schema::hasColumn('questions', 'user_id')) {
                $table->dropForeign(['user_id']);
            }
        });

        Schema::table('payments', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
        });

        // 1. Add Missing Constraints & 2. Fix Cascade Rules & 5. Add Constraint Naming
        
        // questions table foreign keys
        Schema::table('questions', function (Blueprint $table) {
            // Constraint: user_id on questions table
            // Rule: SET NULL on delete. If a user is deleted, their questions are not deleted but the user_id is set to null.
            // Naming: questions_user_id_foreign
            if (Schema::hasColumn('questions', 'user_id')) {
                $table->foreign('user_id', 'questions_user_id_foreign')->references('id')->on('users')->onDelete('set null');
            }
        });

        // payments table foreign keys
        Schema::table('payments', function (Blueprint $table) {
            // Constraint: user_id on payments table
            // Rule: CASCADE on delete. If a user is deleted, all their payments are also deleted.
            // Naming: payments_user_id_foreign
            $table->foreign('user_id', 'payments_user_id_foreign')->references('id')->on('users')->onDelete('cascade');
        });

        // 3. Add Data Validation & 4. Add Orphan Cleanup
        
        // Cleanup orphaned questions before adding not-null constraint or stricter foreign keys.
        // This assumes we want to keep questions even if the user is gone.
        if (Schema::hasColumn('questions', 'user_id')) {
            DB::table('questions')
                ->whereNotNull('user_id')
                ->whereNotExists(function ($query) {
                    $query->select(DB::raw(1))
                          ->from('users')
                          ->whereColumn('users.id', 'questions.user_id');
                })
                ->update(['user_id' => null]);
        }

        // Cleanup orphaned payments. This is more destructive and depends on business logic.
        // Assuming payments without a user are invalid and should be deleted.
        DB::table('payments')
            ->whereNotNull('user_id')
            ->whereNotExists(function ($query) {
                $query->select(DB::raw(1))
                      ->from('users')
                      ->whereColumn('users.id', 'payments.user_id');
            })
            ->delete();
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('questions', function (Blueprint $table) {
            if (Schema::hasColumn('questions', 'user_id')) {
                $table->dropForeign('questions_user_id_foreign');
            }
        });

        Schema::table('payments', function (Blueprint $table) {
            $table->dropForeign('payments_user_id_foreign');
        });
    }
};