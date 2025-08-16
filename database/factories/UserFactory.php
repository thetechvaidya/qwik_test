<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class UserFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = User::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'first_name' => $this->faker->firstName,
            'last_name' => $this->faker->lastName,
            'user_name' => $this->faker->unique()->userName,
            'email' => $this->faker->unique()->safeEmail,
            'email_verified_at' => now(),
            'password' => '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', // password
            'remember_token' => Str::random(10),
            'is_active' => true,
            // Optional convenience flags for tests; columns may be absent in production
            // 'is_admin' guarded by migration that only adds if missing
        ];
    }

    /**
     * Indicate that the user should have a specific role name via Spatie roles if available.
     */
    public function role(string $role)
    {
        return $this->afterCreating(function (User $user) use ($role) {
            // If spatie/laravel-permission is installed and roles table exists, assign role
            try {
                if (\Schema::hasTable('roles')) {
                    $user->assignRole($role);
                }
            } catch (\Throwable $e) {
                // no-op in environments without roles
            }
            // Also set is_admin flag when applicable if column exists
            try {
                if (\Schema::hasColumn('users', 'is_admin') && $role === 'admin') {
                    $user->forceFill(['is_admin' => true])->save();
                }
            } catch (\Throwable $e) {
                // ignore
            }
        });
    }
}
