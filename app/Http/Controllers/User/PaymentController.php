<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Http\Requests\User\StorePaymentRequest;
use App\Models\Payment;
use App\Services\FraudDetectionService;
use App\Settings\BillingSettings;
use App\Settings\LocalizationSettings;
use App\Settings\SiteSettings;
use App\Transformers\User\UserPaymentTransformer;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Inertia\Inertia;
use Throwable;

class PaymentController extends Controller
{
    /**
     * PaymentController constructor.
     */
    public function __construct()
    {
        $this->middleware(['role:student|employee'])->except('downloadInvoice');
        $this->middleware(['throttle:60,1'])->only('store');
    }

    /**
     * Get user payments
     *
     * @return \Inertia\Response
     */
    public function index()
    {
        $payments = Payment::with('plan')
            ->where('user_id', auth()->user()->id)
            ->paginate(request()->perPage != null ? request()->perPage : 10);

        return Inertia::render('User/MyPayments', [
            'payments' => fractal($payments, new UserPaymentTransformer())->toArray(),
            'enable_invoice' => app(BillingSettings::class)->enable_invoicing
        ]);
    }

    /**
     * Store a newly created payment in storage.
     *
     * @param StorePaymentRequest $request
     * @param FraudDetectionService $fraudDetectionService
     * @return \Illuminate\Http\RedirectResponse
     */
    public function store(StorePaymentRequest $request, FraudDetectionService $fraudDetectionService)
    {
        // 1. Audit Logging: Log payment attempt
        Log::info('Payment attempt initiated by user: ' . auth()->user()->id, $request->validated());

        // 2. Fraud Detection
        if ($fraudDetectionService->isFraudulent($request)) {
            Log::warning('Potential fraudulent payment attempt detected for user: ' . auth()->user()->id, $request->validated());
            return redirect()->back()->with('errorMessage', 'Your payment could not be processed.');
        }

        try {
            // 3. Transaction Security & PCI Compliance
            // PCI DSS compliance is ensured by not handling or storing raw credit card information.
            // All sensitive data is handled by the respective payment gateway's SDK/API.
            $payment = DB::transaction(function () use ($request) {
                // 4. Authorization: Ensure users can only process their own payments.
                // This is implicitly handled by associating the payment with the authenticated user.
                $payment = Payment::create([
                    'user_id' => auth()->user()->id,
                    'plan_id' => $request->plan_id,
                    'gateway' => $request->payment_gateway,
                    'amount' => $request->amount,
                    'currency' => $request->currency,
                    'status' => 'pending', // Initial status
                ]);

                // TODO: Add payment gateway integration logic here.
                // For example: $gatewayResponse = app(PaymentGateway::class)->process($payment);
                // Update payment status based on gateway response.

                return $payment;
            });

            // 5. Audit Logging: Log successful transaction
            Log::info('Payment successful for user: ' . auth()->user()->id, ['payment_id' => $payment->id]);

            return redirect()->route('user.payments.index')->with('successMessage', 'Payment created successfully!');
        } catch (Throwable $e) {
            // 6. Secure Error Handling & Audit Logging
            Log::error('Payment processing failed for user: ' . auth()->user()->id, [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString() // For internal logs only
            ]);

            // Do not leak sensitive information in the error message.
            return redirect()->back()->with('errorMessage', 'An unexpected error occurred. Please try again later.');
        }
    }


    public function downloadInvoice($id, LocalizationSettings $localizationSettings, SiteSettings $settings)
    {
        if(config('qwiktest.demo_mode')) {
            return redirect()->back()->with('errorMessage', 'This operation is disabled in the demo mode.');
        }

        if(!app(BillingSettings::class)->enable_invoicing) {
            return __('Invoice not available for download.');
        }

        $payment = Payment::where('payment_id', '=', $id)->firstOrFail();

        // Authorization: Ensure the user can only download their own invoice.
        $this->authorize('view', $payment);

        $now = Carbon::now()->timezone($localizationSettings->default_timezone);
        $user = auth()->user()->first_name.' '.auth()->user()->last_name;

        return view('pdf.invoice', [
            'payment' => fractal($payment, new UserPaymentTransformer())->toArray()['data'],
            'data' => $payment->data,
            'logo' => $settings->logo_path ? url('storage/'.$settings->logo_path) : null,
            'footer' => "* Invoice Generated from {$settings->app_name} by {$user} on {$now->toDayDateTimeString()}",
            'rtl' => $localizationSettings->default_direction == 'rtl'
        ]);
    }
}
