<?php

namespace App\Http\Resources;

use Carbon\Carbon;
use Illuminate\Http\Resources\Json\JsonResource;

class ReminderResource extends JsonResource
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
            'todo' => $this->todo,
            'date' => $this->date,
            'time' => $this->time,
            'special_notes' => $this->special_notes,
            'user_id' => $this->user_id,
            'session_id' =>$this->session_id,
            'created_at' =>Carbon::parse($this->created_at)->format('Y-m-d H:i:s A'),
            'updated_at' =>Carbon::parse($this->updated_at)->format('Y-m-d H:i:s A'),
        ];
    }
}
