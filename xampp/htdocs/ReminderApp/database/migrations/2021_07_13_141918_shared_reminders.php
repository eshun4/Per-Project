<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class SharedReminders extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('shared_reminders', function (Blueprint $table) {
            $table->increments('id')->nullable();
            $table->unsignedInteger('reminder_id')->references('id')->on('reminders')->onDelete('cascade')->nullable();
            $table->unsignedInteger('session_id')->references('id')->on('sessions')->onDelete('cascade')->nullable();
            $table->unsignedInteger('user_id')->references('id')->on('users')->onDelete('cascade')->nullable();
            $table->boolean('type')->nullable(); // 0 is for send and 1 is for receive
            $table->timestamp('created_at')->nullable();
            $table->timestamp('updated_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('shared_reminders');
    }
}
