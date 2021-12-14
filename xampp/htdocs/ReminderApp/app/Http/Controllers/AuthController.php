<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Http\Resources\UserResource;


class AuthController extends Controller
{
    //User Registration
    public function register(Request $request)
    {
        //validate fields
        $attrs = $request->validate([
            'firstname' => 'required|string',
            'lastname'=> 'required|string',
            'phone'=> 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6|confirmed'
        ]);

        //create user
        $user = User::create([
            'firstname' => $attrs['firstname'],
            'lastname' => $attrs['lastname'],
            'phone' => $attrs['phone'],
            'email' => $attrs['email'],
            'password' => bcrypt($attrs['password'])
        ]);
        
       

        //return user & token in response
        return response([
            'status' => 'Success',
            'message' => 'Account Created Successfully.',
            'user' => new UserResource($user),
            'token' => $user->createToken('secret')->plainTextToken
        ], 201);


    }

    // login user
    public function login(Request $request)
    {
        //validate fields
        $attrs = $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6'
        ]);

        // attempt login
        if(!Auth::attempt($attrs))
        {
            return response([
                'message' => 'Invalid credentials.'
            ], 403);
        }

        //return user & token in response
        return response([
            'status' => 'Success',
            'message' => 'Login Successful',
            'user' => new UserResource(auth()->user()), 
            'token' => auth()->user()->createToken('secret')->plainTextToken
        ], 201);
    }

    // // logout user
    // public function logout()
    // {
    //     auth()->user()->tokens()->delete();
    //     return response([
    //         'message' => 'Logout success.'
    //     ], 201);
    // }

     // logout user
     public function logout(Request $request)
     {
         $request ->user()->currentAccessToken()->delete();
         return response([
             'status' => 'Success',
             'message' => 'Logout success.'
         ], 201);
     }
     

    //search from users as contacts
    public function search(Request $request, $string){

        // $data = $request->get('data');
        $user_info = User::where('firstname','like', "%{$string}%")
        ->orWhere('lastname', 'like', "%{$string}%")
        ->orWhere('email', 'like', "%{$string}%")
        ->orWhere('phone', 'like', "%{$string}%")
                 ->first();

        if(!$user_info) {
            return Response()->json([
                'status' => 'Failure',
                'message' => 'User does not exist'
            ], 409);
        }
    
        return Response()->json([
            'status' => 'Success',
            'user' => new $user_info
        ], 201);
    }
//Remember to create an empty array in flutter app for contact list.
    // get user details
    public function user()
    {
         $currentuser =  auth()->user();
        return Response()->json([
            'status' => 'Success',
            'user' => new UserResource($currentuser)
        ], 201);
    }
// Get all users
    public function users()
    {
        $user = User::all();
        return Response()->json([
            'status' => 'Success',
            'users' => UserResource::collection($user),
        ], 201);
    }

    // update user
    public function update(Request $request)
    {
        $attrs = $request->validate([
            'firstname' => 'required|string',
            'lastname' => 'required|string',
            'phone' => 'required|string'
        ]);

      $image = $this->saveImage($request->image, 'profileImages');
      

        auth()->user()->update([
            'firstname' => $attrs['firstname'],
            'lastname' => $attrs['lastname'],
            'image' => $image,
        ]);

        return response([
            'message' => 'User updated.',
            'user' => auth()->user()
        ], 200);
    }

    public function toggleContact($id)
    {
        $userContacts = auth()->user()->contacts();

        if ($userContacts ->find($id)) {
            $userContacts ->detach([$id]);
            return response([
                'status' => 'Success',
                'message' => 'Contact Removed.',
            ], 200);
        }

        $userContacts ->attach($id);
        return response([
            'status' => 'Success',
            'message' => 'Contact Added.',
        ], 200);
    }

    public function getContacts()
    {
        $userContacts = auth()->user()->contacts()->get();
        return response([
            'status' => 'Success',
            'message' => 'All Friends',
            'Contacts' => UserResource::collection($userContacts)
        ], 200);
    }

    
}
