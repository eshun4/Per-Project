<?php

namespace App\Http\Controllers;
use App\Models\Session;
use App\Http\Resources\SessionResource;
use Illuminate\Http\Request;
use App\Events\SessionEvent;

class SessionController extends Controller
{
    public function create($contact_id){
       $session = Session::firstOrCreate(['user1_id'=>auth()->id(), 'user2_id' =>$contact_id]);
       $modifiedSession = new SessionResource($session);
       broadcast(new SessionEvent($modifiedSession , auth()->id()));
        return response([
            'session' => $modifiedSession ,
            'status' => 'Success',
            'message' => 'Your Session.'
        ], 200);
    }

    public function getSessions(){
        $session = Session::where('user1_id', '=',auth()->user()->id )->orWhere('user2_id','=',auth()->user()->id)->get();
        $modifiedSession = SessionResource::collection($session);
         return response([
             'sessions' => $modifiedSession ,
             'status' => 'Success',
             'message' => 'Opened Sessions.'
         ], 200);
     }
}
