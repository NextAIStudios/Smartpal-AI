import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _apiKey = await secureStorage.getString('ff_apiKey') ?? _apiKey;
    });
    await _safeInitAsync(() async {
      _dailyPay = await secureStorage.getString('ff_dailyPay') ?? _dailyPay;
    });
    await _safeInitAsync(() async {
      _dailyDollerPay =
          await secureStorage.getString('ff_dailyDollerPay') ?? _dailyDollerPay;
    });
    await _safeInitAsync(() async {
      _userRef = (await secureStorage.getString('ff_userRef'))?.ref ?? _userRef;
    });
    await _safeInitAsync(() async {
      _currentDateTime =
          await secureStorage.read(key: 'ff_currentDateTime') != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  (await secureStorage.getInt('ff_currentDateTime'))!)
              : _currentDateTime;
    });
    await _safeInitAsync(() async {
      _monthlyPayLink =
          await secureStorage.getString('ff_monthlyPayLink') ?? _monthlyPayLink;
    });
    await _safeInitAsync(() async {
      _monthlyDollarPayLink =
          await secureStorage.getString('ff_monthlyDollarPayLink') ??
              _monthlyDollarPayLink;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  String _apiKey = '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';
  String get apiKey => _apiKey;
  set apiKey(String _value) {
    _apiKey = _value;
    secureStorage.setString('ff_apiKey', _value);
  }

  void deleteApiKey() {
    secureStorage.delete(key: 'ff_apiKey');
  }

  List<dynamic> _currentConversation = [];
  List<dynamic> get currentConversation => _currentConversation;
  set currentConversation(List<dynamic> _value) {
    _currentConversation = _value;
  }

  void addToCurrentConversation(dynamic _value) {
    _currentConversation.add(_value);
  }

  void removeFromCurrentConversation(dynamic _value) {
    _currentConversation.remove(_value);
  }

  void removeAtIndexFromCurrentConversation(int _index) {
    _currentConversation.removeAt(_index);
  }

  void updateCurrentConversationAtIndex(
    int _index,
    dynamic Function(dynamic) updateFn,
  ) {
    _currentConversation[_index] = updateFn(_currentConversation[_index]);
  }

  String _dailyPay =
      'https://payment.intasend.com/pay/39514274-d806-47b4-bbba-cac5cf3bb0d0/';
  String get dailyPay => _dailyPay;
  set dailyPay(String _value) {
    _dailyPay = _value;
    secureStorage.setString('ff_dailyPay', _value);
  }

  void deleteDailyPay() {
    secureStorage.delete(key: 'ff_dailyPay');
  }

  String _dailyDollerPay =
      'https://payment.intasend.com/pay/377af524-a238-42d3-8dab-29af2a73eb93/';
  String get dailyDollerPay => _dailyDollerPay;
  set dailyDollerPay(String _value) {
    _dailyDollerPay = _value;
    secureStorage.setString('ff_dailyDollerPay', _value);
  }

  void deleteDailyDollerPay() {
    secureStorage.delete(key: 'ff_dailyDollerPay');
  }

  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  set userRef(DocumentReference? _value) {
    _userRef = _value;
    _value != null
        ? secureStorage.setString('ff_userRef', _value.path)
        : secureStorage.remove('ff_userRef');
  }

  void deleteUserRef() {
    secureStorage.delete(key: 'ff_userRef');
  }

  DateTime? _currentDateTime;
  DateTime? get currentDateTime => _currentDateTime;
  set currentDateTime(DateTime? _value) {
    _currentDateTime = _value;
    _value != null
        ? secureStorage.setInt(
            'ff_currentDateTime', _value.millisecondsSinceEpoch)
        : secureStorage.remove('ff_currentDateTime');
  }

  void deleteCurrentDateTime() {
    secureStorage.delete(key: 'ff_currentDateTime');
  }

  String _monthlyPayLink =
      'https://payment.intasend.com/pay/a016c114-7206-4c21-b7fe-baa9a1f7ce96/';
  String get monthlyPayLink => _monthlyPayLink;
  set monthlyPayLink(String _value) {
    _monthlyPayLink = _value;
    secureStorage.setString('ff_monthlyPayLink', _value);
  }

  void deleteMonthlyPayLink() {
    secureStorage.delete(key: 'ff_monthlyPayLink');
  }

  String _monthlyDollarPayLink =
      'https://payment.intasend.com/pay/0c3df9c8-accf-440e-bb4a-7553b5a93e32/';
  String get monthlyDollarPayLink => _monthlyDollarPayLink;
  set monthlyDollarPayLink(String _value) {
    _monthlyDollarPayLink = _value;
    secureStorage.setString('ff_monthlyDollarPayLink', _value);
  }

  void deleteMonthlyDollarPayLink() {
    secureStorage.delete(key: 'ff_monthlyDollarPayLink');
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
