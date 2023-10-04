@TestOn('browser')

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_razorpay.dart';

void main() {
  group("Razorpay", () {
    // final List<MethodCall> log = <MethodCall>[];

    test(
      'passes options correctly',
      () async {
        var isSuccessCalled = false;
        var isCancleCalled = false;
        var isFailedCalled = false;

        late MockRazorpayWeb mockRazorpayWeb;

        tearDown(() {
          mockRazorpayWeb.clear();
        });

        setUp(() {
          mockRazorpayWeb = MockRazorpayWeb();

          when(() => mockRazorpayWeb.handleResponse(any()))
              .thenAnswer((invocation) {
            isSuccessCalled = true;
            //mockRazorpayWeb.onSuccess!(any());
          });
        });

        var options = {
          'key': 'rzp_test_1DP5mmOlF5G5aa',
          'amount': 2000,
          'name': 'Acme Corp.',
          'description': 'Fine T-Shirt',
          'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
        };

        mockRazorpayWeb.open(options);
        expect(isSuccessCalled, isTrue);
        verify(
          () => mockRazorpayWeb.onSuccess!(any()),
        ).called(1);
      },
    );
  });
}
