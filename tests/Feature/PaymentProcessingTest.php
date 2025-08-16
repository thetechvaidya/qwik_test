<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Subscription;
use App\Models\Payment;
use App\Models\Wallet;
use App\Models\Transaction;
use Bavix\Wallet\Models\Wallet as WalletModel;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Config;
use Tests\TestCase;

class PaymentProcessingTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $user;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::factory()->create();
        
        // Mock payment gateway configurations
        Config::set('services.razorpay.key', 'test_key');
        Config::set('services.razorpay.secret', 'test_secret');
        Config::set('services.razorpay.webhook_secret', 'webhook_secret');
        Config::set('services.stripe.key', 'pk_test_key');
        Config::set('services.stripe.secret', 'sk_test_secret');
    }

    /** @test */
    public function user_can_create_wallet()
    {
        $this->actingAs($this->user);

        // Laravel Wallet automatically creates wallets when accessed
        $wallet = $this->user->wallet;

        $this->assertInstanceOf(WalletModel::class, $wallet);
        $this->assertEquals(0, $wallet->balance);
        // Currency field is not part of Laravel Wallet's default schema
        // Remove currency assertion or implement a custom getCurrency() accessor
    }

    /** @test */
    public function user_can_deposit_money_to_wallet()
    {
        $this->actingAs($this->user);

        $depositAmount = 100;
        $this->user->deposit($depositAmount);

        $this->assertEquals($depositAmount, $this->user->balance);
        $this->assertDatabaseHas('transactions', [
            'payable_id' => $this->user->id,
            'payable_type' => get_class($this->user),
            'type' => 'deposit',
            'amount' => $depositAmount,
        ]);
    }

    /** @test */
    public function user_can_withdraw_money_from_wallet()
    {
        $this->actingAs($this->user);

        // First deposit money
        $this->user->deposit(200);

        // Then withdraw
        $withdrawAmount = 50;
        $this->user->withdraw($withdrawAmount);

        $this->assertEquals(150, $this->user->balance);
        $this->assertDatabaseHas('transactions', [
            'payable_id' => $this->user->id,
            'payable_type' => get_class($this->user),
            'type' => 'withdraw',
            'amount' => $withdrawAmount,
        ]);
    }

    /** @test */
    public function user_cannot_withdraw_more_than_balance()
    {
        $this->actingAs($this->user);

        $this->user->deposit(50);

        $this->expectException(\Bavix\Wallet\Exceptions\InsufficientFunds::class);
        $this->user->withdraw(100);
    }

    /** @test */
    public function user_can_transfer_money_between_wallets()
    {
        $this->actingAs($this->user);
        $recipient = User::factory()->create();

        $this->user->deposit(200);
        $transferAmount = 75;

        $this->user->transfer($recipient, $transferAmount);

        $this->assertEquals(125, $this->user->balance);
        $this->assertEquals(75, $recipient->balance);
    }

    /** @test */
    public function user_can_initiate_razorpay_payment()
    {
        $this->actingAs($this->user);

        Http::fake([
            'api.razorpay.com/*' => Http::response([
                'id' => 'order_test123',
                'entity' => 'order',
                'amount' => 50000, // Amount in paise (500 INR)
                'currency' => 'INR',
                'status' => 'created',
            ], 200)
        ]);

        $paymentData = [
            'amount' => 500,
            'currency' => 'INR',
            'description' => 'Test payment',
        ];

        $response = $this->post('/payments/razorpay/create', $paymentData);

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'order_id',
            'amount',
            'currency',
            'key',
        ]);
    }

    /** @test */
    public function razorpay_payment_webhook_processes_successfully()
    {
        Http::fake([
            'api.razorpay.com/*' => Http::response([
                'id' => 'pay_test123',
                'status' => 'captured',
                'amount' => 50000,
                'currency' => 'INR',
                'order_id' => 'order_test123',
            ], 200)
        ]);

        $webhookPayload = [
            'event' => 'payment.captured',
            'payload' => [
                'payment' => [
                    'entity' => [
                        'id' => 'pay_test123',
                        'amount' => 50000,
                        'currency' => 'INR',
                        'status' => 'captured',
                        'order_id' => 'order_test123',
                    ]
                ]
            ]
        ];

        $response = $this->postJson('/webhooks/razorpay', $webhookPayload);

        $response->assertStatus(200);
        $this->assertDatabaseHas('payments', [
            'payment_id' => 'pay_test123',
            'status' => 'completed',
            'amount' => 500,
        ]);
    }

    /** @test */
    public function user_can_initiate_stripe_payment()
    {
        $this->actingAs($this->user);

        Http::fake([
            'api.stripe.com/*' => Http::response([
                'id' => 'pi_test123',
                'object' => 'payment_intent',
                'amount' => 5000, // Amount in cents ($50.00)
                'currency' => 'usd',
                'status' => 'requires_payment_method',
                'client_secret' => 'pi_test123_secret',
            ], 200)
        ]);

        $paymentData = [
            'amount' => 50,
            'currency' => 'USD',
            'description' => 'Test Stripe payment',
        ];

        $response = $this->post('/payments/stripe/create', $paymentData);

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'payment_intent_id',
            'client_secret',
            'amount',
            'currency',
        ]);
    }

    /** @test */
    public function stripe_webhook_processes_payment_successfully()
    {
        $webhookPayload = [
            'type' => 'payment_intent.succeeded',
            'data' => [
                'object' => [
                    'id' => 'pi_test123',
                    'amount' => 5000,
                    'currency' => 'usd',
                    'status' => 'succeeded',
                    'metadata' => [
                        'user_id' => $this->user->id,
                    ]
                ]
            ]
        ];

        $response = $this->postJson('/webhooks/stripe', $webhookPayload);

        $response->assertStatus(200);
        $this->assertDatabaseHas('payments', [
            'payment_id' => 'pi_test123',
            'status' => 'completed',
            'amount' => 50,
        ]);
    }

    /** @test */
    public function user_can_create_subscription()
    {
        $this->actingAs($this->user);
        $this->user->deposit(1000);

        $subscriptionData = [
            'plan_type' => 'monthly',
            'amount' => 299,
            'currency' => 'USD',
        ];

        $response = $this->post('/subscriptions', $subscriptionData);

        $response->assertRedirect();
        $this->assertDatabaseHas('subscriptions', [
            'user_id' => $this->user->id,
            'plan_type' => 'monthly',
            'amount' => 299,
            'status' => 'active',
        ]);
    }

    /** @test */
    public function subscription_can_be_renewed_automatically()
    {
        $this->actingAs($this->user);
        $this->user->deposit(1000);

        $subscription = Subscription::factory()->create([
            'user_id' => $this->user->id,
            'expires_at' => now()->subDay(),
            'status' => 'active',
            'amount' => 299,
        ]);

        // Simulate subscription renewal
        $response = $this->post("/subscriptions/{$subscription->id}/renew");

        $response->assertStatus(200);
        $this->assertDatabaseHas('subscriptions', [
            'id' => $subscription->id,
            'status' => 'active',
        ]);

        // Check that payment was deducted from wallet
        $this->assertEquals(701, $this->user->fresh()->balance);
    }

    /** @test */
    public function subscription_fails_with_insufficient_funds()
    {
        $this->actingAs($this->user);
        $this->user->deposit(100); // Not enough for subscription

        $subscriptionData = [
            'plan_type' => 'monthly',
            'amount' => 299,
            'currency' => 'USD',
        ];

        $response = $this->post('/subscriptions', $subscriptionData);

        $response->assertSessionHasErrors();
        $this->assertDatabaseMissing('subscriptions', [
            'user_id' => $this->user->id,
            'status' => 'active',
        ]);
    }

    /** @test */
    public function user_can_cancel_subscription()
    {
        $this->actingAs($this->user);

        $subscription = Subscription::factory()->create([
            'user_id' => $this->user->id,
            'status' => 'active',
        ]);

        $response = $this->delete("/subscriptions/{$subscription->id}");

        $response->assertRedirect();
        $this->assertDatabaseHas('subscriptions', [
            'id' => $subscription->id,
            'status' => 'cancelled',
        ]);
    }

    /** @test */
    public function payment_can_be_refunded()
    {
        $this->actingAs($this->user);

        $payment = Payment::factory()->create([
            'user_id' => $this->user->id,
            'amount' => 500,
            'status' => 'completed',
            'payment_gateway' => 'razorpay',
            'payment_id' => 'pay_test123',
        ]);

        Http::fake([
            'api.razorpay.com/*' => Http::response([
                'id' => 'rfnd_test123',
                'payment_id' => 'pay_test123',
                'amount' => 50000,
                'status' => 'processed',
            ], 200)
        ]);

        $response = $this->post("/payments/{$payment->id}/refund", [
            'reason' => 'Customer request',
        ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('payments', [
            'id' => $payment->id,
            'status' => 'refunded',
        ]);

        // Check that amount was credited back to wallet
        $this->assertEquals(500, $this->user->fresh()->balance);
    }

    /** @test */
    public function partial_refund_works_correctly()
    {
        $this->actingAs($this->user);

        $payment = Payment::factory()->create([
            'user_id' => $this->user->id,
            'amount' => 500,
            'status' => 'completed',
        ]);

        Http::fake([
            'api.razorpay.com/*' => Http::response([
                'id' => 'rfnd_test123',
                'payment_id' => 'pay_test123',
                'amount' => 25000, // Half refund
                'status' => 'processed',
            ], 200)
        ]);

        $response = $this->post("/payments/{$payment->id}/refund", [
            'amount' => 250,
            'reason' => 'Partial refund',
        ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('payments', [
            'id' => $payment->id,
            'status' => 'partially_refunded',
        ]);

        $this->assertEquals(250, $this->user->fresh()->balance);
    }

    /** @test */
    public function payment_history_is_recorded_correctly()
    {
        $this->actingAs($this->user);

        // Make deposit
        $this->user->deposit(100);

        // Make withdrawal
        $this->user->withdraw(25);

        // Transfer to another user
        $recipient = User::factory()->create();
        $this->user->transfer($recipient, 30);

        $response = $this->get('/payments/history');

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('User/PaymentHistory')
                ->has('transactions')
                ->where('transactions.data', function ($transactions) {
                    return count($transactions) === 3;
                })
        );
    }

    /** @test */
    public function currency_conversion_works_correctly()
    {
        $this->actingAs($this->user);

        // Mock currency conversion API
        Http::fake([
            'api.exchangerate-api.com/*' => Http::response([
                'result' => 'success',
                'conversion_rate' => 0.85, // USD to EUR
                'conversion_result' => 85,
            ], 200)
        ]);

        $response = $this->post('/payments/convert', [
            'amount' => 100,
            'from_currency' => 'USD',
            'to_currency' => 'EUR',
        ]);

        $response->assertStatus(200);
        $response->assertJson([
            'converted_amount' => 85,
            'conversion_rate' => 0.85,
        ]);
    }

    /** @test */
    public function payment_validation_prevents_invalid_amounts()
    {
        $this->actingAs($this->user);

        $invalidPaymentData = [
            'amount' => -50, // Negative amount
            'currency' => 'USD',
        ];

        $response = $this->post('/payments/razorpay/create', $invalidPaymentData);

        $response->assertSessionHasErrors(['amount']);
    }

    /** @test */
    public function payment_security_measures_work()
    {
        $this->actingAs($this->user);

        // Test rate limiting by making multiple requests
        for ($i = 0; $i < 10; $i++) {
            $response = $this->post('/payments/razorpay/create', [
                'amount' => 100,
                'currency' => 'USD',
            ]);
        }

        // Should be rate limited after too many requests
        $response->assertStatus(429);
    }

    /** @test */
    public function webhook_signature_verification_works()
    {
        $payload = json_encode(['test' => 'data']);
        $secret = 'webhook_secret';
        $signature = hash_hmac('sha256', $payload, $secret);

        $response = $this->withHeaders([
            'X-Razorpay-Signature' => $signature,
        ])->postJson('/webhooks/razorpay', json_decode($payload, true));

        // Should verify signature and process webhook
        $response->assertStatus(200);
    }

    /** @test */
    public function invalid_webhook_signature_is_rejected()
    {
        $payload = json_encode(['test' => 'data']);
        $invalidSignature = 'invalid_signature';

        $response = $this->withHeaders([
            'X-Razorpay-Signature' => $invalidSignature,
        ])->postJson('/webhooks/razorpay', json_decode($payload, true));

        $response->assertStatus(400);
    }

    /** @test */
    public function transaction_logs_are_created_for_all_operations()
    {
        $this->actingAs($this->user);

        $this->user->deposit(100);
        $this->user->withdraw(25);

        $transactions = $this->user->transactions;

        $this->assertCount(2, $transactions);
        $this->assertEquals('deposit', $transactions->first()->type);
        $this->assertEquals('withdraw', $transactions->last()->type);
    }

    /** @test */
    public function payment_gateway_failover_works()
    {
        $this->actingAs($this->user);

        // Mock Razorpay failure
        Http::fake([
            'api.razorpay.com/*' => Http::response([], 500),
            'api.stripe.com/*' => Http::response([
                'id' => 'pi_test123',
                'client_secret' => 'pi_test123_secret',
            ], 200)
        ]);

        $paymentData = [
            'amount' => 100,
            'currency' => 'USD',
            'fallback_gateway' => 'stripe',
        ];

        $response = $this->post('/payments/create-with-fallback', $paymentData);

        $response->assertStatus(200);
        // Should have fallen back to Stripe
        $response->assertJsonPath('gateway', 'stripe');
    }

    /** @test */
    public function subscription_analytics_are_tracked()
    {
        $this->actingAs($this->user);

        Subscription::factory(5)->create(['status' => 'active']);
        Subscription::factory(3)->create(['status' => 'cancelled']);
        Subscription::factory(2)->create(['status' => 'expired']);

        $response = $this->get('/admin/subscriptions/analytics');

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Subscriptions/Analytics')
                ->has('analytics')
                ->where('analytics.active_count', 5)
                ->where('analytics.cancelled_count', 3)
                ->where('analytics.expired_count', 2)
        );
    }
}
