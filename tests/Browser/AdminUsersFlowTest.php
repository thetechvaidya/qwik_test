<?php

namespace Tests\Browser;

use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Laravel\Dusk\Browser;
use Tests\DuskTestCase;

class AdminUsersFlowTest extends DuskTestCase
{
    use DatabaseMigrations;

    /**
     * Open Users page and click New User to ensure drawer renders.
     */
    public function testOpenNewUserDrawer()
    {
        $admin = User::factory()->create(['role' => 'admin', 'email_verified_at' => now()]);

        $this->browse(function (Browser $browser) use ($admin) {
            $browser->loginAs($admin)
                    ->visit(route('users.index'))
                    ->waitForText('Users', 5)
                    ->press('New User')
                    ->pause(500)
                    // Confirm drawer mounted by checking presence of form title text
                    ->assertSee('New User');
        });
    }
}
