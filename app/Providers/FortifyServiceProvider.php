<?php

namespace App\Providers;

use App\Actions\Fortify\CreateNewUser;
use App\Actions\Fortify\ResetUserPassword;
use App\Actions\Fortify\UpdateUserPassword;
use App\Actions\Fortify\UpdateUserProfileInformation;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Contracts\Auth\StatefulGuard;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Laravel\Fortify\Fortify;
use Spatie\Permission\Models\Role;

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
        $this->ensureDemoUsers();

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

    /**
     * Ensure demo users exist with the documented credentials when running locally or in demo mode.
     */
    protected function ensureDemoUsers(): void
    {
        if (app()->runningInConsole() && app()->environment('production') && !config('qwiktest.demo_mode')) {
            // Avoid mutating production data when not in demo mode.
            return;
        }

        if (!app()->environment(['local', 'development', 'staging', 'testing']) && !config('qwiktest.demo_mode')) {
            return;
        }

        $demoProfiles = [
            [
                'email' => 'admin@qwiktest.com',
                'first_name' => 'QwikTest',
                'last_name' => 'Admin',
                'user_name' => 'admin',
                'role' => 'admin',
                'legacy_emails' => ['admin@example.com'],
            ],
            [
                'email' => 'instructor@qwiktest.com',
                'first_name' => 'John',
                'last_name' => 'Instructor',
                'user_name' => 'instructor',
                'role' => 'instructor',
                'legacy_emails' => ['john@example.com'],
            ],
            [
                'email' => 'student@qwiktest.com',
                'first_name' => 'Jane',
                'last_name' => 'Student',
                'user_name' => 'student',
                'role' => 'student',
                'legacy_emails' => ['student@example.com', 'jane@example.com'],
            ],
        ];

        foreach ($demoProfiles as $profile) {
            $user = User::where('email', $profile['email'])->first();

            if (! $user && ! empty($profile['legacy_emails'])) {
                $user = User::whereIn('email', $profile['legacy_emails'])->first();
                if ($user && $user->email !== $profile['email']) {
                    $user->email = $profile['email'];
                }
            }

            if (! $user) {
                $userName = $this->generateUniqueUsername($profile['user_name']);

                $user = User::create([
                    'first_name' => $profile['first_name'],
                    'last_name' => $profile['last_name'],
                    'user_name' => $userName,
                    'email' => $profile['email'],
                    'password' => Hash::make('password'),
                    'email_verified_at' => Carbon::now(),
                    'is_active' => true,
                ]);

                Log::info('Demo user created', [
                    'email' => $profile['email'],
                    'user_name' => $userName,
                ]);
            } else {
                $updates = [];

                foreach (['first_name', 'last_name'] as $field) {
                    if ($profile[$field] !== null && $user->{$field} !== $profile[$field]) {
                        $updates[$field] = $profile[$field];
                    }
                }

                if (! empty($profile['user_name']) && $user->user_name !== $profile['user_name']) {
                    $updates['user_name'] = $this->generateUniqueUsername($profile['user_name'], $user->id);
                }

                if (! $user->is_active) {
                    $updates['is_active'] = true;
                }

                if (! $user->email_verified_at) {
                    $updates['email_verified_at'] = Carbon::now();
                }

                if (! Hash::check('password', $user->password)) {
                    $updates['password'] = Hash::make('password');
                }

                if (! empty($updates)) {
                    $user->forceFill($updates)->save();

                    Log::info('Demo user updated', [
                        'email' => $profile['email'],
                        'changes' => array_keys($updates),
                    ]);
                }
            }

            $roleName = $profile['role'] ?? null;

            if ($roleName) {
                if (! Role::where('name', $roleName)->exists()) {
                    Role::create(['name' => $roleName]);
                }

                if (! $user->hasRole($roleName) || $user->roles()->count() !== 1) {
                    $user->syncRoles([$roleName]);
                }
            }
        }
    }

    /**
     * Generate a unique username based on the desired base value.
     */
    protected function generateUniqueUsername(string $base, ?int $ignoreId = null): string
    {
        $slug = Str::slug($base, '_') ?: 'user';
        $candidate = $slug;
        $suffix = 1;

        while (User::where('user_name', $candidate)
            ->when($ignoreId, fn ($query) => $query->where('id', '!=', $ignoreId))
            ->exists()) {
            $candidate = $slug.$suffix;
            $suffix++;
        }

        return $candidate;
    }
}
