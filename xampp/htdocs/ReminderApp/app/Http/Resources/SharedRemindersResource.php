<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Http\Models\SharedReminders;

class SharedRemindersResource extends JsonResource
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
            'reminder'=>$this->reminder,
            'id'=> $this->id,
            'type'=> $this->type,
            'sent_at'=>$this->created_at->diffForHumans()
        ];
    }
}