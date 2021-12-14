<?php

namespace App\Http\Controllers;

use App\Models\Http\SharedReminders;
use Illuminate\Http\Request;
use App\Models\Session;
use App\Http\Resources\SharedRemindersResource;
use App\Events\PrivateSharedReminderEvent;

class SharedRemindersController extends Controller
{
    //Send Reminder
    public function send(Session $session, Request $request){
       
        $attrs = $request->validate([
           'todo' => 'required|string',
           'date'=> 'required|string',
           'time'=> 'required|string',
           'special_notes'=> 'required|string',
       ]);
       $reminder = $session->reminders()->create([
           'todo' => $attrs['todo'],
           'date' => $attrs['date'],
           'time' => $attrs['time'],
           'special_notes' => $attrs['special_notes'],
           'user_id' => auth()->user()->id,
       ]);

    $rem = $reminder -> sharedReminders()->create([
        'session_id' => $session->id,
        'type' => 0,
        'user_id' => auth()->user()->id,
     ]);

     $reminder -> sharedReminders()->create([
         'session_id' => $session->id,
         'type' => 1,
         'user_id' => $request->user_to,
    ]);

    broadcast(new PrivateSharedReminderEvent($reminder, $rem ));

        return response([
           'status' => 'Success.',
           'message' => 'Reminder Sent.',
           'reminder' => $reminder
       ], 200);
     }

     public function shared(Session $session){
        return SharedRemindersResource::collection($session->sharedReminders->where('user_id', auth()->user()->id));
        
     }
}
