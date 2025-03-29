part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class GetUserDataSuccessState extends PaymentState {}

class GetUserDataFailureState extends PaymentState {
  final String error;

  const GetUserDataFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class GetUserDataLoadingState extends PaymentState {}

class PayWithPayMobLoading extends PaymentState {}

class PayWithPayMobSuccess extends PaymentState {}

class PayWithPayMobFailure extends PaymentState {
  final String error;

  PayWithPayMobFailure({required this.error}) {
    log('Payment Failure: $error');
  }

  @override
  List<Object> get props => [error];
}

class CreateTransactionLoading extends PaymentState {}

class CreateTransactionSuccess extends PaymentState {}

class CreateTransactionFailure extends PaymentState {
  final String error;

  CreateTransactionFailure({required this.error}) {
    log('Transaction Failure: $error');
  }

  @override
  List<Object> get props => [error];
}

class AddAmountToOwnerWalletLoadign extends PaymentState {}

class AddAmountToOwnerWalletSuccess extends PaymentState {}

class AddAmountToOwnerWalletFailure extends PaymentState {
  final String error;
  AddAmountToOwnerWalletFailure({required this.error}) {
    log(name: "Add Amount To Owner Wallet Failure : ", error);
  }
}
