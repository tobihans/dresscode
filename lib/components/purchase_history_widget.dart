import 'package:dresscode/api/services/payment_service.dart';
import 'package:dresscode/components/payment_item.dart';
import 'package:dresscode/models/payment.dart';
import 'package:dresscode/models/page.dart' as page;
import 'package:dresscode/requests/page_request.dart';
import 'package:dresscode/utils/token_storage.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryWidget extends StatefulWidget {
  const PurchaseHistoryWidget({Key? key}) : super(key: key);

  @override
  State<PurchaseHistoryWidget> createState() => _PurchaseHistoryWidgetState();
}

class _PurchaseHistoryWidgetState extends State<PurchaseHistoryWidget> {
  late Future<PurchaseHistoryViewModel> _viewModelFuture;

  @override
  void initState() {
    super.initState();
    _viewModelFuture = PurchaseHistoryViewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<PurchaseHistoryViewModel>(
        future: _viewModelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final payments = snapshot.data!.payments;
            if (payments.isEmpty) {
              return const Center(
                child: Text(
                  'Aucun achat effectué',
                  style: TextStyle(fontSize: 17),
                ),
              );
            }

            return ListView.builder(
              itemCount: payments.length,
              itemBuilder: (ctx, index) {
                return PaymentItem(
                  payment: payments[index],
                );
              },
            );
          } else {
            return Center(
              child: TextButton(
                child: const Text(
                  'Une erreur s\'est produite. Cliquez ici pour rééssayer',
                ),
                onPressed: initState,
              ),
            );
          }
        },
      ),
    );
  }
}

class PurchaseHistoryViewModel {
  final List<Payment> payments;

  const PurchaseHistoryViewModel({
    required this.payments,
  });

  /// Here we are going to get all the purchases at once
  static Future<PurchaseHistoryViewModel> init() async {
    final pageRequest = PageRequest(pageNumber: 0, pageSize: 10);
    final token = await TokenStorage.getToken();
    final paymentService = PaymentService(token);
    final List<Payment> payments = [];
    var result = page.emptyPage<Payment>();
    do {
      result = await paymentService.getPayments(pageRequest);
      payments.addAll(result.content);
      pageRequest.pageNumber++;
    } while (payments.length < result.totalElements);
    return PurchaseHistoryViewModel(payments: payments);
  }
}
