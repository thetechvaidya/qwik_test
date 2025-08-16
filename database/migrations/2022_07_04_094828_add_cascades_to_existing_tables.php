<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddCascadesToExistingTables extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        // SQLite does not support dropping foreign keys by name via Schema builder.
        // In test env (SQLite), skip altering constraints as it's not critical for tests.
        if (Schema::getConnection()->getDriverName() === 'sqlite') {
            return;
        }

        Schema::table('questions', function (Blueprint $table) {
            $table->dropForeign('questions_topic_id_foreign');
            $table->foreign('topic_id')->references('id')->on('topics')->onDelete('set null');
        });


        Schema::table('lessons', function (Blueprint $table) {
            $table->dropForeign('lessons_topic_id_foreign');
            $table->foreign('topic_id')->references('id')->on('topics')->onDelete('set null');
        });

        Schema::table('videos', function (Blueprint $table) {
            $table->dropForeign('videos_topic_id_foreign');
            $table->foreign('topic_id')->references('id')->on('topics')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
}
