<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use App\Models\SharedReminders;

class Reminder extends Model
{
    use HasApiTokens, HasFactory, Notifiable;
    
    // public $timestamps = false;
    // const UPDATED_AT = 'last_updated_at';
    protected $guarded =[];
    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */

    protected $fillable = [
        'todo',
        'date',
        'time',
        'special_notes',
        'user_id'
    ];

   public function sharedReminders(){
       return $this->hasMany(SharedReminders::class);
   }
   
   public function user()
   {
       return $this->belongsTo(User::class);
   }
}
