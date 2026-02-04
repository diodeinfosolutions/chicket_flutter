import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': _enUS,
        'ar': _arSA,
      };

  static const Map<String, String> _enUS = {
    // Homepage
    'order_here': 'ORDER HERE',
    'to_skip_queue': 'TO SKIP THE QUEUE',
    'dine_in': 'DINE IN',
    'takeaway': 'TAKEAWAY',
    'english': 'ENGLISH',
    'arabic': 'عربي',

    // Menu
    'all': 'All',
    'add_to_cart': 'ADD TO CART',

    // Cart
    'your_cart': 'YOUR CART',
    'recommended_for_you': 'RECOMMENDED FOR YOU',
    'items_added_to_cart': 'ITEMS ADDED TO YOUR CART',
    'total': 'TOTAL:',
    'cancel_order': 'CANCEL ORDER',
    'proceed': 'PROCEED',
    'items_added': 'Items has been added to the cart',

    // Clear cart dialog
    'clear_cart_question': 'WOULD YOU LIKE TO CLEAR THE ITEMS\nIN THE CART?',
    'no': 'NO',
    'delete': 'DELETE',

    // Mobile/Receipt screen
    'receive_e_receipt': 'RECEIVE E-RECEIPT',
    'e_receipt_sent_via': 'YOUR E-RECEIPT WILL BE SENT VIA WHATSAPP/SMS',
    'thanks_paperless': 'THANKS FOR HELPING US GO PAPERLESS',
    'continue_to_payment': 'CONTINUE TO PAYMENT',
    'return_to_cart': 'RETURN TO CART',

    // Payment screen
    'select_payment_options': 'SELECT PAYMENT OPTIONS',
    'scan_qr_to_pay': 'PLEASE SCAN THE QR CODE TO MAKE PAYMENT',
    'others': 'OTHERS',
    'credit_debit_card': 'CREDIT/DEBIT CARD',
    'wafaa_voucher': 'WAFAA+ VOUCHER',
    'gift_voucher': 'GIFT VOUCHER',
    'pay_cash': 'PAY CASH AT COUNTER',
    'continue_btn': 'CONTINUE',
    'no_payment_methods': 'No payment methods available',

    // Order confirmed
    'yay_order_confirmed': 'YAY!\nYOUR ORDER IS CONFIRMED',
    'saved_on_order': 'GREAT! YOU SAVED BHD @amount ON THIS ORDER',
    'order_number': 'ORDER NUMBER',
    'scan_for': 'SCAN FOR ',
    'e_receipt': 'E-RECEIPT',
    'sent_to_number': 'SENT TO YOUR NUMBER',
    'collect_order': 'COLLECT YOUR ORDER\nAT THE COUNTER WHEN IT\'S READY',
    'thank_you': 'THANK YOU !',
  };

  static const Map<String, String> _arSA = {
    // Homepage
    'order_here': 'اطلب هنا',
    'to_skip_queue': 'لتخطي الطابور',
    'dine_in': 'تناول بالمطعم',
    'takeaway': 'سفري',
    'english': 'ENGLISH',
    'arabic': 'عربي',

    // Menu
    'all': 'الكل',
    'add_to_cart': 'أضف للسلة',

    // Cart
    'your_cart': 'سلة التسوق',
    'recommended_for_you': 'موصى به لك',
    'items_added_to_cart': 'تمت إضافة المنتجات إلى سلتك',
    'total': 'المجموع:',
    'cancel_order': 'إلغاء الطلب',
    'proceed': 'متابعة',
    'items_added': 'تمت إضافة المنتجات إلى السلة',

    // Clear cart dialog
    'clear_cart_question': 'هل تريد مسح المنتجات\nمن السلة؟',
    'no': 'لا',
    'delete': 'حذف',

    // Mobile/Receipt screen
    'receive_e_receipt': 'استلام الإيصال الإلكتروني',
    'e_receipt_sent_via': 'سيتم إرسال إيصالك عبر واتساب/رسالة نصية',
    'thanks_paperless': 'شكراً لمساعدتنا في التحول الرقمي',
    'continue_to_payment': 'المتابعة للدفع',
    'return_to_cart': 'العودة للسلة',

    // Payment screen
    'select_payment_options': 'اختر طريقة الدفع',
    'scan_qr_to_pay': 'يرجى مسح رمز QR لإتمام الدفع',
    'others': 'أخرى',
    'credit_debit_card': 'بطاقة ائتمان/خصم',
    'wafaa_voucher': 'قسيمة وفاء+',
    'gift_voucher': 'قسيمة هدية',
    'pay_cash': 'الدفع نقداً عند الكاونتر',
    'continue_btn': 'متابعة',
    'no_payment_methods': 'لا توجد طرق دفع متاحة',

    // Order confirmed
    'yay_order_confirmed': 'رائع!\nتم تأكيد طلبك',
    'saved_on_order': 'ممتاز! وفرت @amount دينار بحريني في هذا الطلب',
    'order_number': 'رقم الطلب',
    'scan_for': 'امسح للحصول على ',
    'e_receipt': 'الإيصال الإلكتروني',
    'sent_to_number': 'تم الإرسال إلى رقمك',
    'collect_order': 'استلم طلبك\nمن الكاونتر عندما يكون جاهزاً',
    'thank_you': 'شكراً لك!',
  };
}
