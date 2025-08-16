<?php

namespace Tests\Browser;

use Illuminate\Foundation\Testing\DatabaseMigrations;
use Laravel\Dusk\Browser;
use Tests\DuskTestCase;

class PrimeVue4InteractionTest extends DuskTestCase
{
    use DatabaseMigrations;

    /**
     * Test Drawer component interaction (open/close visibility)
     */
    public function testDrawerInteraction()
    {
        $this->browse(function (Browser $browser) {
            $browser->visit('/admin/users')
                    ->assertMissing('.p-drawer') // Drawer should be hidden initially
                    ->click('button:contains("New User")') // Click button to open drawer
                    ->waitFor('.p-drawer', 5) // Wait for drawer to appear
                    ->assertVisible('.p-drawer.p-drawer-md') // Assert drawer is visible with correct class
                    ->click('.p-drawer-close') // Close drawer
                    ->waitUntilMissing('.p-drawer', 5) // Wait for drawer to disappear
                    ->assertMissing('.p-drawer'); // Assert drawer is hidden
        });
    }

    /**
     * Test Select component value change (formerly Dropdown)
     */
    public function testSelectValueChange()
    {
        $this->browse(function (Browser $browser) {
            $browser->visit('/admin/categories')
                    ->click('button:contains("New Category")') // Open form
                    ->waitFor('.p-drawer', 5)
                    ->within('.p-drawer', function (Browser $browser) {
                        // Test Select component (if present in CategoryForm)
                        if ($browser->element('.p-select')) {
                            $browser->click('.p-select')
                                    ->waitFor('.p-select-overlay')
                                    ->click('.p-select-option:first-child')
                                    ->assertMissing('.p-select-overlay'); // Dropdown should close
                        }
                    });
        });
    }

    /**
     * Test ToggleSwitch component (formerly InputSwitch)
     */
    public function testToggleSwitchInteraction()
    {
        $this->browse(function (Browser $browser) {
            $browser->visit('/admin/users')
                    ->click('button:contains("New User")')
                    ->waitFor('.p-drawer', 5)
                    ->within('.p-drawer', function (Browser $browser) {
                        // Test ToggleSwitch component (if present in UserForm)
                        if ($browser->element('.p-toggleswitch')) {
                            $initialState = $browser->attribute('.p-toggleswitch', 'class');
                            $browser->click('.p-toggleswitch')
                                    ->pause(500); // Wait for animation
                            
                            $newState = $browser->attribute('.p-toggleswitch', 'class');
                            $this->assertNotEquals($initialState, $newState, 'ToggleSwitch state should change');
                        }
                    });
        });
    }

    /**
     * Test DatePicker component interaction
     */
    public function testDatePickerInteraction()
    {
        $this->browse(function (Browser $browser) {
            $browser->visit('/admin/users')
                    ->click('button:contains("New User")')
                    ->waitFor('.p-drawer', 5)
                    ->within('.p-drawer', function (Browser $browser) {
                        // Test DatePicker component (if present in UserForm)
                        if ($browser->element('.p-datepicker')) {
                            $browser->click('.p-datepicker input')
                                    ->waitFor('.p-datepicker-panel', 2)
                                    ->assertVisible('.p-datepicker-panel')
                                    ->click('.p-datepicker-today') // Click today's date
                                    ->waitUntilMissing('.p-datepicker-panel', 2)
                                    ->assertMissing('.p-datepicker-panel'); // Panel should close
                        }
                    });
        });
    }

    /**
     * Test Toast notifications appear properly (global instance)
     */
    public function testToastNotifications()
    {
        $this->browse(function (Browser $browser) {
            $browser->visit('/admin/categories')
                    ->click('button:contains("New Category")')
                    ->waitFor('.p-drawer', 5)
                    ->within('.p-drawer', function (Browser $browser) {
                        // Fill form and submit to trigger toast
                        $browser->type('input[name="name"]', 'Test Category')
                                ->press('Save')
                                ->waitFor('.p-toast', 5) // Toast should appear
                                ->assertSee('saved') // Assert success message appears
                                ->waitUntilMissing('.p-toast', 10); // Toast should disappear after timeout
                    });
        });
    }

    /**
     * Test Tag copy functionality with clipboard
     */
    public function testTagCopyFunctionality()
    {
        $this->browse(function (Browser $browser) {
            $browser->visit('/admin/users')
                    ->waitFor('table') // Wait for data table to load
                    ->click('.p-tag:first-child') // Click first Tag with code and copy icon
                    ->waitFor('.p-toast', 5) // Wait for copy success toast
                    ->assertSee('Copied') // Assert copy success message
                    ->waitUntilMissing('.p-toast', 10); // Toast should disappear
        });
    }

    /**
     * Test responsive Drawer sizing classes
     */
    public function testDrawerSizing()
    {
        $this->browse(function (Browser $browser) {
            // Test medium drawer width
            $browser->visit('/admin/users')
                    ->click('button:contains("New User")')
                    ->waitFor('.p-drawer', 5)
                    ->assertHasClass('.p-drawer', 'p-drawer-md')
                    ->script('return window.getComputedStyle(document.querySelector(".p-drawer")).width');
            
            // On large screens, drawer should have 32rem (512px) width
            $width = $browser->script('return window.getComputedStyle(document.querySelector(".p-drawer")).width')[0];
            $this->assertContains('512px', $width, 'Drawer should have correct width for p-drawer-md class');
        });
    }
}
