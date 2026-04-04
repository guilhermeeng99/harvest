import 'package:flutter/material.dart';
import 'package:harvest_site/pages/help_center/widgets/faq_section.dart';

const ordersFaq = [
  FaqItem(
    question: 'How do I place an order?',
    answer:
        'Browse products on the Home or Search screen, add items to your '
        'cart, then go to Cart and tap "Checkout". Enter your delivery '
        "address and confirm — it's that simple!",
  ),
  FaqItem(
    question: 'Can I track my order in real time?',
    answer:
        'Yes! Open the Orders section in the app to see the live status '
        'of your delivery: Pending → Confirmed → Harvesting → '
        'Delivering → Delivered.',
  ),
  FaqItem(
    question: 'Can I cancel or modify my order?',
    answer:
        'Orders can be cancelled or modified while they are still in '
        '"Pending" status. Once a farmer starts harvesting, changes are '
        'no longer possible. Contact our support via Help Center if you '
        'need urgent assistance.',
  ),
  FaqItem(
    question: 'What is the minimum order value?',
    answer:
        'There is no minimum order value. Order as little or as much as '
        'you like. Delivery fees may apply depending on your location.',
  ),
];

const deliveryFaq = [
  FaqItem(
    question: 'What are the delivery times?',
    answer:
        'Standard delivery is within 24–48 hours after order confirmation. '
        'For same-day delivery, orders must be placed before 10 AM on '
        'available days.',
  ),
  FaqItem(
    question: 'Do you deliver to my area?',
    answer:
        'Coverage is expanding constantly. Enter your address at checkout '
        '— the app will confirm if your area is currently served.',
  ),
  FaqItem(
    question: 'Can I schedule delivery for a specific date?',
    answer:
        'Scheduled delivery windows are available for select areas. If '
        'available in your region, a calendar selector will appear at '
        'checkout.',
  ),
];

const productsFaq = [
  FaqItem(
    question: 'Are the products really organic?',
    answer:
        'Products marked with the organic badge are certified by our '
        'partner farmers. Each product page shows the farm name, '
        'certifications, and harvest practices.',
  ),
  FaqItem(
    question: 'What if a product is out of stock?',
    answer:
        'Stock is updated in real time. If a product runs out, it will be '
        'shown as unavailable. You can add it to your watchlist and be '
        "notified when it's back.",
  ),
  FaqItem(
    question: 'What do the units mean (kg, unit, bunch)?',
    answer:
        'Each product shows its unit of measure on the detail page. For '
        "example, \"1 kg\" means you'll receive approximately 1 kilogram, "
        'and "1 bunch" means a standard bunch as picked by the farmer.',
  ),
];

const paymentsFaq = [
  FaqItem(
    question: 'What payment methods are accepted?',
    answer:
        'Harvest currently supports credit card, debit card, and digital '
        'wallets. Payment is processed securely at checkout.',
  ),
  FaqItem(
    question: 'Is my payment information safe?',
    answer:
        'All payment data is encrypted end-to-end. We never store your '
        'full card number. Transactions are protected by industry-standard '
        'PCI DSS compliance.',
  ),
  FaqItem(
    question: 'How do refunds work?',
    answer:
        'Refunds for cancelled orders are processed within 3–5 business '
        'days back to your original payment method. For quality issues, '
        'contact us within 24 hours of delivery.',
  ),
];

const accountFaq = [
  FaqItem(
    question: 'How do I create an account?',
    answer:
        'Download the Harvest app, tap "Sign Up", enter your name, email, '
        "and a secure password. You'll receive a verification email to "
        'activate your account.',
  ),
  FaqItem(
    question: 'I forgot my password. How do I reset it?',
    answer:
        'On the Sign In screen, tap "Forgot password?" and enter your '
        "email. You'll receive a reset link within a few minutes.",
  ),
  FaqItem(
    question: 'How do I update my delivery address?',
    answer:
        'Go to Profile → Delivery Addresses to add, edit, or remove '
        'addresses. You can also set a default address for faster '
        'checkout.',
  ),
];

const faqSections = <({String title, IconData icon, List<FaqItem> items})>[
  (title: 'Orders', icon: Icons.receipt_long_rounded, items: ordersFaq),
  (title: 'Delivery', icon: Icons.local_shipping_rounded, items: deliveryFaq),
  (title: 'Products', icon: Icons.eco_rounded, items: productsFaq),
  (title: 'Payments', icon: Icons.payment_rounded, items: paymentsFaq),
  (title: 'Account', icon: Icons.person_rounded, items: accountFaq),
];
