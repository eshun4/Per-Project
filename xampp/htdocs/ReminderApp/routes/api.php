<?php


use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ReminderController;
use App\Http\Controllers\SessionController;
use App\Http\Controllers\EmailVerificationController;
use App\Http\Controllers\SharedRemindersController;
use App\Http\Controllers\NewPasswordController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

//Public Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

//Email verification
Route::post('email/verification-notification', [EmailVerificationController::class, 'sendVerificationEmail'])->middleware('auth:sanctum');
Route::get('verify-email/{id}/{hash}', [EmailVerificationController::class, 'verify'])->name('verification.verify')->middleware('auth:sanctum');

// Forgot Password 
Route::post('forgot-password', [NewPasswordController::class, 'forgotPassword']);
Route::post('reset-password', [NewPasswordController::class, 'reset']);

//Protected Routes
Route::group(['middleware' => ['auth:sanctum'], 'middleware' => ['web']], function(){
    

    Route::get('/token', function (Request $request) {
        $token = $request->session()->token();
    
        $token = csrf_token();
        return response([
            'csrf_token' => $token
        ], 201);
     
    });
    //User
    Route::get('/users', [AuthController::class, 'users']);//get all users
    Route::get('/user', [AuthController::class, 'user']);
    Route::put('/user', [AuthController::class, 'update']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/search/{string}', [AuthController::class, 'search']);
    Route::get('/toggleContact/{id}', [AuthController::class, 'toggleContact']);
    Route::get('/getContacts', [AuthController::class, 'getContacts']);
   
    //Create Session
    //Visit this later
    Route::post('/session/create/{id}', [SessionController::class, 'create']);
    Route::get('/sessions', [SessionController::class, 'getSessions']);

     // Reminder
     Route::get('/reminders', [ReminderController::class, 'index']); // all reminders
     Route::post('/reminders', [ReminderController::class, 'store']); // create reminder
     Route::get('/reminders/{id}', [ReminderController::class, 'show']); // get single reminder
     Route::put('/reminders/{id}', [ReminderController::class, 'update']); // update reminders
     Route::put('/reminders/{id}', [ReminderController::class, 'pickAndSend']); // pick reminders
     Route::delete('/reminders/{id}', [ReminderController::class, 'destroy']); // delete reminders

     //Shared Reminders
     Route::post('send/{session}/{user_to}', [SharedRemindersController::class, 'send']);
     Route::post('session/sharedReminders/{session}', [SharedRemindersController::class, 'shared']);
});
