<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use App\Models\WebhookEvent;
use App\Repositories\PaymentRepository;
use App\Repositories\RazorpayRepository;
use App\Settings\StripeSettings;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Validator;
use Stripe\Exception\SignatureVerificationException;
use Stripe\Webhook;

class WebHookController extends Controller
{
    /**
     * Razorpay payments webhook
     *
     * @param Request $request
     * @param RazorpayRepository $repository
     * @return \Illuminate\Http\JsonResponse
     */
    public function razorpay(Request $request, RazorpayRepository $repository)
    {
        // Add Rate Limiting
        $eventId = $request->input('payload.payment.entity.id');
        $key = 'webhook:razorpay:'.$eventId;
        if (RateLimiter::tooManyAttempts($key, 10)) {
            Log::warning('Razorpay webhook rate limit exceeded.', ['ip' => $request->ip()]);
            return response()->json(['error' => 'Too many requests.'], 429);
        }
        RateLimiter::hit($key);

        // Add Webhook Signature Verification
        if (! $repository->verifyWebhook($request->getContent(), $request->header('X-Razorpay-Signature'))) {
            Log::error('Razorpay webhook signature verification failed.', ['ip' => $request->ip()]);
            return response()->json(['error' => 'Invalid signature.'], 400);
        }

        // Add Input Validation
        $validator = Validator::make($request->all(), [
            'event' => 'required|string',
            'payload.payment.entity.id' => 'required|string',
        ]);

        if ($validator->fails()) {
            Log::error('Invalid Razorpay webhook payload.', ['errors' => $validator->errors(), 'ip' => $request->ip()]);
            return response()->json(['error' => 'Invalid payload.'], 400);
        }

        // Enhance Error Handling
        try {
            $payload = $request->input('payload');
            $event = $request->input('event');

            // Add Logging
            Log::info('Razorpay webhook received.', ['event' => $event, 'payment_id' => $payload['payment']['entity']['id']]);

            if (WebhookEvent::where('event_id', $eventId)->exists()) {
                return response()->json(['status' => 'duplicate']);
            }

            WebhookEvent::create([
                'event_id' => $eventId,
                'payload' => $request->getContent(),
                'source' => 'razorpay',
            ]);

            $payment = Payment::where('transaction_id', $payload['payment']['entity']['id'])->first();

            if ($payment) {
                switch ($event) {
                    case 'payment.captured':
                        $payment->status = 'completed';
                        break;
                    case 'payment.failed':
                        $payment->status = 'failed';
                        break;
                }
                $payment->update();
            } else {
                Log::warning('Payment not found for Razorpay webhook.', ['transaction_id' => $payload['payment']['entity']['id']]);
            }

            return response()->json(['status' => 'success']);
        } catch (\Exception $e) {
            Log::error('Error processing Razorpay webhook.', ['message' => $e->getMessage()]);
            return response()->json(['error' => 'An internal error occurred.'], 500);
        }
    }

    /**
     * Stripe payment webhook to fulfil the order
     *
     * @param Request $request
     * @param PaymentRepository $paymentRepository
     * @param StripeSettings $settings
     * @return \Illuminate\Http\JsonResponse
     */
    public function stripe(Request $request, PaymentRepository $paymentRepository, StripeSettings $settings)
    {
        // Add Rate Limiting
        $eventId = $event->id;
        $key = 'webhook:stripe:'.$eventId;
        if (RateLimiter::tooManyAttempts($key, 10)) {
            Log::warning('Stripe webhook rate limit exceeded.', ['ip' => $request->ip()]);
            return response()->json(['error' => 'Too many requests.'], 429);
        }
        RateLimiter::hit($key);

        $payload = $request->getContent();
        $sigHeader = $request->header('Stripe-Signature');

        // Add Webhook Signature Verification
        try {
            $event = Webhook::constructEvent($payload, $sigHeader, $settings->webhook_secret);
        } catch (\UnexpectedValueException $e) {
            Log::error('Invalid Stripe webhook payload.', ['ip' => $request->ip()]);
            return response()->json(['error' => 'Invalid payload.'], 400);
        } catch (SignatureVerificationException $e) {
            Log::error('Stripe webhook signature verification failed.', ['ip' => $request->ip()]);
            return response()->json(['error' => 'Invalid signature.'], 400);
        }

        // Add Input Validation
        $validator = Validator::make($event->data->object->toArray(), [
            'id' => 'required|string',
            'object' => 'required|string',
        ]);

        if ($validator->fails()) {
            Log::error('Invalid Stripe webhook event object.', ['errors' => $validator->errors(), 'ip' => $request->ip()]);
            return response()->json(['error' => 'Invalid event object.'], 400);
        }

        // Enhance Error Handling
        try {
            // Add Logging
            Log::info('Stripe webhook received.', ['event_type' => $event->type]);

            if (WebhookEvent::where('event_id', $eventId)->exists()) {
                return response()->json(['status' => 'duplicate']);
            }

            WebhookEvent::create([
                'event_id' => $eventId,
                'payload' => $request->getContent(),
                'source' => 'stripe',
            ]);

            switch ($event->type) {
                case 'checkout.session.completed':
                case 'invoice.paid':
                case 'payment_intent.succeeded':
                    $session = $event->data->object;
                    $payment = Payment::where('payment_id', $session->client_reference_id)->first();
                    if ($payment && $payment->status !== 'completed') {
                        $payment->status = 'completed';
                        $payment->transaction_id = $session->payment_intent;
                        $payment->payment_date = Carbon::now();
                        $payment->update();
                    }
                    break;
                case 'payment_intent.payment_failed':
                    $session = $event->data->object;
                    $payment = Payment::where('payment_id', $session->client_reference_id)->first();
                    if ($payment) {
                        $payment->status = 'failed';
                        $payment->update();
                    }
                    break;
            }

            return response()->json(['status' => 'success']);
        } catch (\Exception $e) {
            Log::error('Error processing Stripe webhook.', ['message' => $e->getMessage()]);
            return response()->json(['error' => 'An internal error occurred.'], 500);
        }
    }
}
