import 'dart:async';

import 'package:mxc_logic/internal.dart';
import 'package:mxc_logic/mxc_logic.dart';

class DatadashSetupStore extends GlobalCacheStore {
  @override
  String get zone => 'datadash-setup';

  late final Field<String?> _privateKey = field('private-key');
  late final Field<String?> _publicAddress = field('public-address');

  String? get privateKey => _privateKey.value;
  set privateKey(String? value) => _privateKey.value = value;

  String? get publicAddress => _publicAddress.value;
  set publicAddress(String? value) => _publicAddress.value = value;

  Future<void> clean() => cleanFields([
        _privateKey,
        _publicAddress,
      ]);
}
