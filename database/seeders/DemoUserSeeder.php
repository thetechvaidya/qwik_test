<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class DemoUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create demo users with proper roles
        $demoUsers = [
            [
                'first_name' => 'Student',
                'last_name' => 'Demo',
                'user_name' => 'student_demo',
                'email' => 'student@example.com',
                'password' => 'password123',
                'is_active' => true,
                'email_verified_at' => now(),
                'role' => 'student',
            ],
            [
                'first_name' => 'Instructor',
                'last_name' => 'Demo',
                'user_name' => 'instructor_demo',
                'email' => 'instructor@example.com',
                'password' => 'password123',
                'is_active' => true,
                'email_verified_at' => now(),
                'role' => 'instructor',
            ],
            [
                'first_name' => 'Admin',
                'last_name' => 'Demo',
                'user_name' => 'admin_demo',
                'email' => 'admin@example.com',
                'password' => 'admin123',
                'is_active' => true,
                'email_verified_at' => now(),
                'role' => 'admin',
            ],
        ];

        foreach ($demoUsers as $userData) {
            $role = $userData['role'];
            unset($userData['role']);
            
            $user = User::updateOrCreate(
                ['email' => $userData['email']],
                array_merge($userData, ['password' => Hash::make($userData['password'])])
            );
            
            // Assign proper role using Spatie Permission package
            if ($user && !$user->hasRole($role)) {
                $user->assignRole($role);
            }
        }

        $this->command->info('Demo users created successfully with proper roles!');
        $this->command->info('Demo Credentials:');
        $this->command->info('Student: student@example.com / password123');
        $this->command->info('Instructor: instructor@example.com / password123');
        $this->command->info('Admin: admin@example.com / admin123');
    }
}
