import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class PaymobManager {
  // PayMob API keys - Should be moved to a more secure storage in production
  static const String _payMobApiKey =
      "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TlRnM09Td2libUZ0WlNJNklqRTNNelk0TVRnMk5Ua3VNVEl3TmpJekluMC41allFTnRyNFk1T0RBeElaZ3ZRVmIwWEl1TzNBaktpODE0dHVpZjd4MDVKMTh1cUNMUnlfZXN2UjloYW9sTGJDOU5tQ2hMV2hXbm12X2Q3MlBkRTJvZw==";
  static const String _integrationId =
      "8101"; // Integration ID for payment gateway
  static const String _paymobBaseUrl = "https://ksa.paymob.com/api";
  static const String _iframeUrl = "$_paymobBaseUrl/acceptance/iframes/6357";

  // Get PayMob iframe URL with token
  static String getPaymentUrl(String paymentToken) {
    return "$_iframeUrl?payment_token=$paymentToken";
  }

  // Step 1: Get authentication token
  static Future<String> getAuthToken() async {
    final url = Uri.parse('$_paymobBaseUrl/auth/tokens');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({"api_key": _payMobApiKey});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['token'];
      } else {
        log('Failed to load token: ${response.statusCode}');
        log('Response body: ${response.body}');
        throw Exception('Failed to get authentication token');
      }
    } catch (e) {
      log('Error getting auth token: $e');
      rethrow;
    }
  }

  // Step 2: Create order
  static Future<int> createOrder({
    required String token,
    required String amount,
    Map<String, dynamic>? productData,
  }) async {
    final url = Uri.parse('$_paymobBaseUrl/ecommerce/orders');
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

    // Create items array with product data if available
    List<Map<String, dynamic>> items = [];
    if (productData != null && productData.containsKey('name')) {
      String name = productData['name'] is String
          ? productData['name']
          : productData['name'] is List
              ? productData['name'][0]
              : 'Product';

      items.add({
        "name": name,
        "amount_cents": amount,
        "description": productData['description'] ?? "",
        "quantity": productData['quantity'] ?? 1,
        "is_organic": productData['is_organic'] ?? false,
        "is_refrigerated": productData['is_frezed'] ?? false,
      });
    }

    final body = json.encode({
      "auth_token": token,
      "delivery_needed":
          productData?['shipping_type'] == 'refrigerated' ? "true" : "false",
      "amount_cents": amount,
      "currency": "SAR",
      "items": items.isEmpty ? [] : items,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final orderId = responseData['id'];

        if (orderId != null) {
          return orderId;
        } else {
          throw Exception('Order ID not found in the response');
        }
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      log('Error creating order: $e');
      rethrow;
    }
  }

  // Step 3: Get payment key
  static Future<String> getPaymentKey({
    required String token,
    required String orderId,
    required String amount,
    required Map<String, dynamic> billingData,
    Map<String, dynamic>? shippingData,
  }) async {
    final url = Uri.parse('$_paymobBaseUrl/acceptance/payment_keys');
    final headers = {'Content-Type': 'application/json'};

    // Add shipping info if this product requires refrigerated shipping
    Map<String, dynamic> finalBillingData = Map.from(billingData);
    if (shippingData != null &&
        shippingData['shipping_type'] == 'refrigerated') {
      finalBillingData['shipping_details'] = {
        'shipping_method': 'refrigerated',
        'shipping_capacity': shippingData['shipping_capacity'] ?? 1,
        'minimum_delivery_limit': shippingData['minimum_delivery_limit'] ?? 1,
      };
    }

    final body = json.encode({
      "auth_token": token,
      "amount_cents": amount,
      "expiration": 3600,
      "currency": "SAR",
      "order_id": orderId,
      "lock_order_when_paid": "false",
      "integration_id": _integrationId,
      "billing_data": finalBillingData,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final paymentKey = responseData['token'];

        if (paymentKey != null) {
          return paymentKey;
        } else {
          throw Exception('Payment key not found in the response');
        }
      } else {
        throw Exception(
            'Failed to generate payment key: ${response.statusCode}');
      }
    } catch (e) {
      log('Error getting payment key: $e');
      rethrow;
    }
  }

  // Create billing data for PayMob
  static Map<String, String> createBillingData({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) {
    return {
      "apartment": "NA",
      "email": email,
      "floor": "NA",
      "first_name": firstName,
      "street": "NA",
      "building": "NA",
      "phone_number": phone,
      "shipping_method": "NA",
      "postal_code": "NA",
      "city": "NA",
      "country": "SA",
      "last_name": lastName,
      "state": "NA"
    };
  }
}
