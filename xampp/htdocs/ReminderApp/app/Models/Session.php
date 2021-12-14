<?php

namespace App\Models;

use App\Http\Models\Reminders;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\SharedReminders;

class Session extends Model
{
    // public $timestamps = false;
    // const UPDATED_AT = 'last_updated_at';

    use HasFactory;
    protected $guarded= [];

    public function sharedReminders(){
        return $this->hasManyThrough(SharedReminders::class, Reminder::class);
    }

    public function reminders(){
        return $this->hasMany(Reminder::class);
    }
}
