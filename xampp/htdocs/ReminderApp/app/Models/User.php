<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use App\Notifications\ResetPasswordNotification;

class User extends Authenticatable implements MustVerifyEmail
{
    use HasApiTokens, HasFactory, Notifiable;
    
    // public $timestamps =true;
    // const UPDATED_AT = 'email_verified_at';
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'firstname',
        'lastname',
        'email',
        'phone',
        'image',
        'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'date:Y-m-d',
    ];
    

    public function reminders()
    {
        return $this->hasMany(Reminder::class);
    }

    public function sendPasswordResetNotification($token)
    {

        $url =  $token;

        $this->notify(new ResetPasswordNotification($url));
    }

    public function contacts()
    {
        return $this->belongsToMany(User::class, 'user_contact', 'user_id', 'contact_id');
    }
    

}
