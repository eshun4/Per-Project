<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class SessionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('sessions', function (Blueprint $table) {
            $table->increments('id')->nullable();
            $table->unsignedInteger('user1_id')->references('id')->on('users')->onDelete('cascade');
            $table->unsignedInteger('user2_id')->references('id')->on('users')->onDelete('cascade');
            $table->unique(['user1_id','user2_id']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('sessions');
    }
}
