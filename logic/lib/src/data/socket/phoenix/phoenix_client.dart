import 'dart:async';

import 'package:mxc_logic/src/data/socket/phoenix/phoenix_exception.dart';
import 'package:mxc_logic/src/data/socket/mxc_socket_client.dart';
import 'package:phoenix_socket/phoenix_socket.dart';

import '../../../domain/const/const.dart';

class PhoenixClient implements IMXCSocketClient {
  PhoenixClient._internal();

  /// Singleton Phoenix Client, Use connect for initializing the connection and unlock features otherwise you will get PhoenixSocketNotConnected Error.
  /// with a Phoenix backend using WebSockets.
  factory PhoenixClient() {
    return _singleton;
  }
  static final PhoenixClient _singleton = PhoenixClient._internal();

  PhoenixSocket? _socketInstance;

  @override
  bool isConnected() => _socketInstance?.isConnected ?? false;

  /// Connects and initializes the socket instance if was not initialized before.
  @override
  Future<Stream<dynamic>> connect(String url) async {
    final newSocket = await PhoenixSocket(
      url,
      socketOptions:
          const PhoenixSocketOptions(timeout: Config.httpClientTimeOut),
    ).connect();
    if (newSocket != null) {
      _socketInstance == null;
      _socketInstance = newSocket;
      return _socketInstance!.openStream;
    } else {
      throw 'Unable to connect to Websocket';
    }
  }

  /// Empty string If not connected at all
  @override
  String get endpoint => _socketInstance?.endpoint ?? '';

  @override
  void disconnect() async {
    if (_socketInstance != null && isConnected()) {
      _socketInstance!.close();
    }
  }

  @override
  Stream<PhoenixSocketOpenEvent> getOpenStream() {
    if (_socketInstance != null) {
      return _socketInstance!.openStream;
    } else {
      throw 'Unable to connect to Websocket';
    }
  }

  @override
  Stream<PhoenixSocketCloseEvent> getCloseStream() {
    if (_socketInstance != null && isConnected()) {
      return _socketInstance!.closeStream;
    }
    throw 'Trying to access connection while not connected!';
  }

  @override
  Stream<PhoenixSocketErrorEvent> getErrorStream() {
    if (_socketInstance != null && isConnected()) {
      return _socketInstance!.errorStream;
    }
    throw 'Trying to access connection while not connected!';
  }

  @override
  Future<Stream<Message>> subscribeToEvent(
    String event,
  ) async {
    if (_socketInstance == null) {
      throw PhoenixSocketNotInitialized(null, 'subscribeToEvent');
    }

    if (!isConnected()) {
      throw PhoenixSocketNotConnected(
        Uri.parse(_socketInstance!.endpoint),
        'subscribeToEvent',
      );
    }

    final doesChannelExists = _socketInstance!.channels.values
        .any((element) => element.topic == event);

    if (doesChannelExists) {
      final channel = _socketInstance!.channels.values
          .firstWhere((element) => element.topic == event);
      return channel.messages;
    } else {
      // Leave all other channels
      final channels = _socketInstance!.channels.values.toList();
      for (PhoenixChannel channel in channels) {
        // _socketInstance.
        _socketInstance!.removeChannel(channel);
      }
      return await joinChannel(event);
    }
  }

  Future<Stream<Message>> joinChannel(
    String event, {
    PhoenixChannel? subscription,
  }) async {
    subscription = subscription ??
        _socketInstance!.addChannel(
          topic: event,
        );

    final subscriptionResponse = await subscription.join().future;

    if (subscriptionResponse.isOk) {
      return subscription.messages;
    } else {
      throw PhoenixSocketJoinChannelError(
        Uri.parse(_socketInstance!.endpoint),
        'joinChannel',
        event,
      );
    }
  }
}
