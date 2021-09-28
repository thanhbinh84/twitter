import 'package:equatable/equatable.dart';
import 'package:mms/data/models/message.dart';

abstract class MessageState extends Equatable {
  final List<Object?>? objProps;
  const MessageState([this.objProps]);

  List<Object?> get props => objProps ?? [];
}

class MessageInitial extends MessageState {
  @override
  String toString() => 'MessageInitial';
}

class MessageLoadInProgress extends MessageState {
  @override
  String toString() => 'MessageLoadInProgress';
}

class MessageLoadSuccess extends MessageState {
  final List<Message> messages;

  MessageLoadSuccess({required this.messages}) : super([messages]);

  @override
  String toString() => 'MessageLoadSuccess';
}

class MessageFailure extends MessageState {
  final String error;
  MessageFailure(this.error) : super([error]);

  @override
  String toString() => 'MessageFailure $error';
}

