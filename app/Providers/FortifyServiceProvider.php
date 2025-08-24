<?php

namespace App\Providers;

use App\Actions\Fortify\CreateNewUser;
use App\Actions\Fortify\ResetUserPassword;
use App\Actions\Fortify\UpdateUserPassword;
use App\Actions\Fortify\UpdateUserProfileInformation;
use App\Models\User;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Contracts\Auth\StatefulGuard;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;
use Illuminate\Validation\ValidationException;
use Laravel\Fortify\Fortify;

class FortifyServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Fortify::createUsersUsing(CreateNewUser::class);
        Fortify::updateUserProfileInformationUsing(UpdateUserProfileInformation::class);
        Fortify::updateUserPasswordsUsing(UpdateUserPassword::class);
        Fortify::resetUserPasswordsUsing(ResetUserPassword::class);

        RateLimiter::for('login', function (Request $request) {
            // Bypass rate limiting in demo mode for testing
            if (config('qwiktest.demo_mode')) {
                return Limit::none();
            }
            return Limit::perMinute(5)->by($request->email.$request->ip());
        });

        RateLimiter::for('two-factor', function (Request $request) {
            return Limit::perMinute(5)->by($request->session()->get('login.id'));
        });

        Fortify::authenticateUsing(function (Request $request) {
            $user = User::where('email', $request->email)->orWhere('user_name', $request->email)->first();

            // Add debug logging for demo mode
            if (config('qwiktest.demo_mode')) {
                \Log::info('Demo mode authentication attempt', [
                    'email_or_username' => $request->email,
                    'user_found' => $user ? true : false,
                    'user_active' => $user ? $user->is_active : null,
                    'available_users' => User::select('email', 'user_name', 'is_active')->get()->toArray()
                ]);
            }

            //Check whether user is active, if not throw error
            if($user && !$user->is_active) {
                \Log::warning('Login attempt with inactive user', [
                    'user_id' => $user->id,
                    'email' => $user->email,
                    'user_name' => $user->user_name
                ]);
                
                throw ValidationException::withMessages([
                    Fortify::username() => ['Your account has been disabled. Please contact administrator for assistance.'],
                ]);
            }

            if ($user && Hash::check($request->password, $user->password)) {
                if(!config('qwiktest.demo_mode')) {
                    //Delete Other Browser Sessions on Login
                    $guard = app(StatefulGuard::class);
                    $guard->logoutOtherDevices($request->password);
                    if (config('session.driver') == 'database') {
                        DB::connection(config('session.connection'))->table(config('session.table', 'sessions'))
                            ->where('user_id', $user->getAuthIdentifier())
                            ->where('id', '!=', $request->session()->getId())
                            ->delete();
                    }
                }

                \Log::info('Successful authentication', [
                    'user_id' => $user->id,
                    'email' => $user->email,
                    'user_name' => $user->user_name,
                    'demo_mode' => config('qwiktest.demo_mode')
                ]);

                return $user;
            }

            // Log authentication failure details for debugging
            if ($user) {
                \Log::warning('Authentication failed: Password mismatch', [
                    'user_id' => $user->id,
                    'email' => $user->email,
                    'user_name' => $user->user_name,
                    'provided_email' => $request->email
                ]);
            } else {
                \Log::warning('Authentication failed: User not found', [
                    'provided_email' => $request->email,
                    'demo_mode' => config('qwiktest.demo_mode')
                ]);
            }
            
            return null;
        });
    }
}
