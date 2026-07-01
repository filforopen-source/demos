import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay/pay.dart';
import '../view_models/cart_view_model.dart';
import '../utils/formatters.dart';

class CheckoutScreen extends StatefulWidget {
  final CartViewModel cartViewModel;

  const CheckoutScreen({super.key, required this.cartViewModel});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  int _currentStep = 0; // 0: Shipping, 1: Payment, 2: Review

  // Controllers for section completion tracking
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();

  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  // Focus nodes
  final _nameFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _cityFocus = FocusNode();
  final _stateFocus = FocusNode();
  final _zipFocus = FocusNode();
  final _phoneFocus = FocusNode();

  final _cardNumberFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _cvvFocus = FocusNode();
  
  late final Future<Pay> _payClientFuture;

  @override
  void initState() {
    super.initState();
    // Add listeners to controllers to update step progress
    final shippingControllers = [
      _nameController,
      _addressController,
      _cityController,
      _stateController,
      _zipController,
      _phoneController,
    ];
    for (var controller in shippingControllers) {
      controller.addListener(_checkShippingCompletion);
    }

    final paymentControllers = [
      _cardNumberController,
      _expiryController,
      _cvvController,
    ];
    for (var controller in paymentControllers) {
      controller.addListener(_checkPaymentCompletion);
    }

    _payClientFuture = _initPay();
  }

  Future<Pay> _initPay() async {
    final googlePayConfig = await PaymentConfiguration.fromAsset(
      'payment_configurations/google_pay_config.json',
    );
    final applePayConfig = await PaymentConfiguration.fromAsset(
      'payment_configurations/apple_pay_config.json',
    );
    return Pay({
      PayProvider.google_pay: googlePayConfig,
      PayProvider.apple_pay: applePayConfig,
    });
  }

  void _checkShippingCompletion() {
    final isShippingValid =
        _nameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _stateController.text.isNotEmpty &&
        _zipController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;

    if (isShippingValid && _currentStep == 0) {
      setState(() => _currentStep = 1);
    } else if (!isShippingValid && _currentStep == 1) {
      setState(() => _currentStep = 0);
    }
  }

  void _checkPaymentCompletion() {
    final isPaymentValid =
        _cardNumberController.text.isNotEmpty &&
        _expiryController.text.isNotEmpty &&
        _cvvController.text.isNotEmpty;

    if (isPaymentValid && _currentStep <= 1) {
      setState(() => _currentStep = 2);
    } else if (!isPaymentValid && _currentStep == 2) {
      _checkShippingCompletion(); // Fallback to check if still at payment or shipping
      if (_currentStep != 0) {
        setState(() => _currentStep = 1);
      }
    }
  }

  List<PaymentItem> get _paymentItems {
    final subtotal = widget.cartViewModel.subtotal;
    const shipping = 5.0;
    final total = subtotal + shipping;

    return [
      PaymentItem(
        label: 'Subtotal',
        amount: subtotal.toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      ),
      const PaymentItem(
        label: 'Shipping',
        amount: '5.00',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        label: 'Total',
        amount: total.toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      ),
    ];
  }

  void _onApplePayResult(Map<String, dynamic> result) {
    debugPrint('Apple Pay result: $result');
    _handlePaymentSuccess();
  }

  void _onGooglePayResult(Map<String, dynamic> result) {
    debugPrint('Google Pay result: $result');
    _handlePaymentSuccess();
  }

  void _onPaymentPressed(Pay provider, PayProvider providerType) async {
    try {
      final result = await provider.showPaymentSelector(
        providerType,
        _paymentItems,
      );
      if (providerType == PayProvider.google_pay) {
        _onGooglePayResult(result);
      } else {
        _onApplePayResult(result);
      }
    } catch (e) {
      debugPrint('Error during payment: $e');
    }
  }

  void _handlePaymentSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    widget.cartViewModel.clear();
    context.go('/');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();

    _nameFocus.dispose();
    _addressFocus.dispose();
    _cityFocus.dispose();
    _stateFocus.dispose();
    _zipFocus.dispose();
    _phoneFocus.dispose();
    _cardNumberFocus.dispose();
    _expiryFocus.dispose();
    _cvvFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('checkoutScaffold'),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => context.pop(),
              ),
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsetsDirectional.only(
                  start: 56,
                  bottom: 12,
                ),
                title: Text(
                  'Checkout',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Interactive Stepper
            SliverPersistentHeader(
              pinned: true,
              delegate: _StepperHeaderDelegate(currentStep: _currentStep),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SectionHeader(
                    title: 'Shipping Address',
                    icon: Icons.local_shipping_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildShippingForm(),

                  const SizedBox(height: 32),
                  _SectionHeader(
                    title: 'Payment Information',
                    icon: Icons.payment_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentForm(),

                  const SizedBox(height: 32),
                  _SectionHeader(
                    title: 'Review Order',
                    icon: Icons.receipt_long_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildOrderReview(),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const Key('placeOrderButton'),
                      onPressed: _handlePlaceOrder,
                      child: const Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingForm() {
    return Column(
      children: [
        TextFormField(
          key: const Key('fullNameField'),
          controller: _nameController,
          focusNode: _nameFocus,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_addressFocus),
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('addressField'),
          controller: _addressController,
          focusNode: _addressFocus,
          decoration: const InputDecoration(
            labelText: 'Address Line 1',
            prefixIcon: Icon(Icons.home_outlined),
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_cityFocus),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                key: const Key('cityField'),
                controller: _cityController,
                focusNode: _cityFocus,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_stateFocus),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                key: const Key('stateField'),
                controller: _stateController,
                focusNode: _stateFocus,
                decoration: const InputDecoration(labelText: 'State'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_zipFocus),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                key: const Key('zipField'),
                controller: _zipController,
                focusNode: _zipFocus,
                decoration: const InputDecoration(labelText: 'ZIP Code'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_phoneFocus),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                key: const Key('phoneField'),
                controller: _phoneController,
                focusNode: _phoneFocus,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                keyboardType: TextInputType.phone,
                inputFormatters: [PhoneNumberFormatter()],
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_cardNumberFocus),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return FutureBuilder<Pay>(
      future: _payClientFuture,
      builder: (context, paySnapshot) {
        if (!paySnapshot.hasData) return const SizedBox.shrink();
        final payClient = paySnapshot.data!;

        return Column(
          children: [
            FutureBuilder<bool>(
              future: payClient.userCanPay(PayProvider.google_pay),
              builder: (context, snapshot) => snapshot.data == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              _onPaymentPressed(payClient, PayProvider.google_pay),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Pay with Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            FutureBuilder<bool>(
              future: payClient.userCanPay(PayProvider.apple_pay),
              builder: (context, snapshot) => snapshot.data == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              _onPaymentPressed(payClient, PayProvider.apple_pay),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey.shade300),
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Pay with Apple',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 32),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 32),
            TextFormField(
              key: const Key('cardNumberField'),
              controller: _cardNumberController,
              focusNode: _cardNumberFocus,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                prefixIcon: Icon(Icons.credit_card),
                hintText: '**** **** **** ****',
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              keyboardType: TextInputType.number,
              inputFormatters: [CardNumberFormatter()],
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_expiryFocus),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: const Key('expiryField'),
                    controller: _expiryController,
                    focusNode: _expiryFocus,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [ExpirationDateFormatter()],
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_cvvFocus),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: const Key('cvvField'),
                    controller: _cvvController,
                    focusNode: _cvvFocus,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '***',
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CVVFormatter(maxLength: 3)],
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderReview() {
    final subtotal = widget.cartViewModel.subtotal;
    const shipping = 5.00;
    final total = subtotal + shipping;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...widget.cartViewModel.items.values.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.quantity}x ${item.product.name}'),
                    Text(
                      '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('\$${subtotal.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Shipping'), Text('\$5.00')],
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handlePlaceOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      widget.cartViewModel.clear();
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _StepperHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int currentStep;

  _StepperHeaderDelegate({required this.currentStep});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7FF),
              border: Border(
                bottom: BorderSide(color: Colors.blue.withValues(alpha: 0.1)),
              ),
            ),
            child: Row(
              children: [
                _StepIndicator(
                  label: 'Shipping',
                  isCompleted: currentStep > 0,
                  isActive: currentStep == 0,
                ),
                Expanded(
                  child: _AnimatedDivider(
                    isActive: currentStep > 0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                _StepIndicator(
                  label: 'Payment',
                  isCompleted: currentStep > 1,
                  isActive: currentStep == 1,
                ),
                Expanded(
                  child: _AnimatedDivider(
                    isActive: currentStep > 1,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                _StepIndicator(label: 'Review', isActive: currentStep == 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant _StepperHeaderDelegate oldDelegate) =>
      oldDelegate.currentStep != currentStep;
}

class _AnimatedDivider extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _AnimatedDivider({required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(height: 2, color: Colors.grey.shade300),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: 2,
          width: isActive
              ? 500
              : 0, // Should be roughly enough to fill the Expanded space
          color: color,
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isActive;

  const _StepIndicator({
    required this.label,
    this.isCompleted = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCompleted || isActive
        ? Theme.of(context).primaryColor
        : Colors.grey;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? color : Colors.white,
            border: Border.all(color: color, width: 2),
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: isActive || isCompleted
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
