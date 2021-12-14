<?php

namespace App\Providers;
use App\Models\Session;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\ServiceProvider;

class BroadcastServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Broadcast::routes();

        Broadcast::channel('Shared-Reminders.{session}', function ($user, Session $session ) {
            if($user->id ==$session->user1_id || $user->id == $session->user2_id){
                return true;
            }
            return false;
        });


        require base_path('routes/channels.php');
    }
}
