<?php

namespace App\Http\Resources;
use App\Models\Session;
use App\Http\Resources\SessionResource;
use Carbon\Carbon;

use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'firstname' => $this->firstname,
            'lastname' => $this->lastname,
            'email' => $this->email,
            'phone' => $this->phone,
            'image' => $this->image,
            'email_verified_at' =>$this->email_verified_at,
            'created_at' =>Carbon::parse($this->created_at)->format('Y-m-d H:i:s A'),
            'updated_at' =>Carbon::parse($this->updated_at)->format('Y-m-d H:i:s A'),
            'session' => $this->session_details($this->id),
            
        ];
    }

    private function session_details($id){

       $session = Session::whereIn('user1_d', [auth()->id(), $id])->whereIn('user2_id', [auth()->id(),$id])->first();
       return new SessionResource($session);
    }
}
