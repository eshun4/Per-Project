<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\Reminder;
use \App\Events\ReminderEvent;
use App\Http\Resources\ReminderResource;
use App\Models\Session;

class ReminderController extends Controller
{
    //Auth middleware so authenticated user will not return null
    public function _construct(){
        $this->middleware('auth');
    }

      // get all Reminders
      public function index()
      {
        $currentuser =  auth()->user();
          return response([
              'reminders' =>  Reminder::where('user_id', '=', $currentuser->id)
             ->orderBy('created_at', 'desc')->with('user:id,firstname,lastname')->get()
          ], 200);
      }

     // create a reminder
    public function store(Request $request)
    {
        //validate fields
        $attrs = $request->validate([
            'todo' => 'required|string',
            'date'=> 'required|string',
            'time'=> 'required|string',
            'special_notes'=> 'required|string',
        ]);

        // $image = $this->saveImage($request->image, 'posts');

        $reminder = Reminder::create([
            'todo' => $attrs['todo'],
            'date' => $attrs['date'],
            'time' => $attrs['time'],
            'special_notes' => $attrs['special_notes'],
            'user_id' => auth()->user()->id,
           
        ]);


        return response([
            'status' => 'Success.',
            'message' => 'Reminder created.',
            'reminder' => new ReminderResource($reminder),
        ], 201);
    }

    public function show(Request $request, $id)
    {
        $reminder = Reminder::find($id);

        if(!$reminder)
        {
            return response([
                'status' => 'Failure.',
                'message' => 'Reminder not found.'
            ], 403);
        }

        if($reminder->user_id != auth()->user()->id)
        {
            return response([
                'status' => 'Failure.',
                'message' => 'Permission denied.',
            ], 403);
        }
        return response([
            'status' => 'Success.',
            'message' => 'Found reminder.',
            'reminder' => new ReminderResource($reminder)
        ], 200);
    }

     // update a reminder
    public function update(Request $request, $id)
    {
        $reminder = Reminder::find($id);

        if(!$reminder)
        {
            return response([
                'status' => 'Failure.',
                'message' => 'Reminder not found.'
            ], 403);
        }

        if($reminder->user_id != auth()->user()->id)
        {
            return response([
                'status' => 'Failure.',
                'message' => 'Permission denied.'
            ], 403);
        }

        //validate fields
        $attrs = $request->validate([
            'todo' => 'required|string',
            'date'=> 'required|string',
            'time'=> 'required|string',
            'special_notes'=> 'required|string',
        ]);

        $reminder->update([
            'todo' => $attrs['todo'],
            'date' => $attrs['date'],
            'time' => $attrs['time'],
            'special_notes' => $attrs['special_notes'],
        ]);


        return response([
            'status' => 'Success.',
            'message' => 'Reminder updated.',
            'reminder' => new ReminderResource($reminder)
        ], 200);
    }

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
       
         return response([
            'status' => 'Success.',
            'message' => 'Reminder Sent.',
            'reminder' => $reminder
        ], 200);
      }

      // pick and share a reminder
    public function pickAndShare(Request $request,Session $session, $id)
    {
        $reminder = Reminder::find($id);

        if(!$reminder)
        {
            return response([
                'status' => 'Failure.',
                'message' => 'Reminder not found.'
            ], 403);
        }

        if($reminder->user_id != auth()->user()->id)
        {
            return response([
                'status' => 'Failure.',
                'message' => 'Permission denied.'
            ], 403);
        }

        //validate fields
        $attrs = $request->validate([
            'todo' => 'required|string',
            'date'=> 'required|string',
            'time'=> 'required|string',
            'special_notes'=> 'required|string',
        ]);

        $reminder->$session->reminders()->update([
            'todo' => $attrs['todo'],
            'date' => $attrs['date'],
            'time' => $attrs['time'],
            'special_notes' => $attrs['special_notes'],
        ]);


        return response([
            'status' => 'Success.',
            'message' => 'Reminder Sent.',
            'reminder' => new ReminderResource($reminder)
        ], 200);
    }


      //delete reminder
    public function destroy($id)
    {
        $reminder = Reminder::find($id);

        if(!$reminder)
        {
            return response([
                'status' => 'Failure.',
                'message' => 'Reminder not found.'
            ], 403);
        }

        if($reminder->user_id != auth()->user()->id)
        {
            return response([
                'status' => 'Failure.',
                'message' => 'Permission denied.'
            ], 403);
        }

      
        $reminder->delete();

        return response([
            'status' => 'Success.',
            'message' => 'Reminder deleted.',
        ], 200);
    }
 
   
}
