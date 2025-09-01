<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddMobilePerformanceIndexesToExams extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('exams', function (Blueprint $table) {
            // Add indexes for mobile API performance optimization
            if (!$this->indexExists('exams', 'exams_is_active_index')) {
                $table->index('is_active');
            }
            
            if (!$this->indexExists('exams', 'exams_sub_category_id_index')) {
                $table->index('sub_category_id');
            }
            
            if (!$this->indexExists('exams', 'exams_title_index')) {
                $table->index('title');
            }
            
            // Composite index for mobile queries (is_active + sub_category_id)
            if (!$this->indexExists('exams', 'exams_mobile_filter_index')) {
                $table->index(['is_active', 'sub_category_id'], 'exams_mobile_filter_index');
            }
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('exams', function (Blueprint $table) {
            $table->dropIndex(['is_active', 'sub_category_id']);
            $table->dropIndex(['title']);
            $table->dropIndex(['sub_category_id']);
            $table->dropIndex(['is_active']);
        });
    }
    
    /**
     * Check if an index exists on a table
     */
    private function indexExists($table, $index)
    {
        $connection = Schema::getConnection();
        $doctrineSchemaManager = $connection->getDoctrineSchemaManager();
        $doctrineTable = $doctrineSchemaManager->listTableDetails($table);
        
        return $doctrineTable->hasIndex($index);
    }
}