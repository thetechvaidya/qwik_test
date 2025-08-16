<?php

namespace Tests\Browser;

use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Laravel\Dusk\Browser;
use Tests\DuskTestCase;

class AdminTableE2ETest extends DuskTestCase
{
    use DatabaseMigrations;

    /**
     * Ensure global search triggers on Enter and filters Users table (server-side).
     */
    public function testUsersGlobalSearchEnter()
    {
        // Seed users
        $admin = User::factory()->create(['role' => 'admin', 'email' => 'admin@example.com']);
        $john = User::factory()->create(['first_name' => 'John', 'last_name' => 'Alpha', 'user_name' => 'john.alpha']);
        $jane = User::factory()->create(['first_name' => 'Jane', 'last_name' => 'Beta', 'user_name' => 'jane.beta']);

        $this->browse(function (Browser $browser) use ($admin, $john, $jane) {
            $browser->loginAs($admin)
                    ->visit(route('users.index'))
                    ->waitFor('table', 5)
                    // Type search term and hit Enter (trigger: 'enter')
                    ->type('input[placeholder*="Search"]', 'Alpha')
                    ->keys('input[placeholder*="Search"]', '{enter}')
                    ->pause(800)
                    // Expect to see John Alpha but not Jane Beta
                    ->assertSee('Alpha')
                    ->assertDontSee('Beta');
        });
    }
}
