<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SharedReminders extends Model
{
    use HasFactory;

    // public $timestamps = false;
    // const UPDATED_AT = 'last_updated_at';

    protected $guarded= [
    ];
    
    public function reminder(){
        return $this->belongsTo(Reminder::class);
    }
}
