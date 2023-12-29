// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Add new`
  String get push_ctrl_panel_project_add_new {
    return Intl.message(
      'Add new',
      name: 'push_ctrl_panel_project_add_new',
      desc: '',
      args: [],
    );
  }

  /// `Project not selected`
  String get push_ctrl_panel_project_not_selected_err {
    return Intl.message(
      'Project not selected',
      name: 'push_ctrl_panel_project_not_selected_err',
      desc: '',
      args: [],
    );
  }

  /// `Push message data`
  String get push_ctrl_panel_msg_payload {
    return Intl.message(
      'Push message data',
      name: 'push_ctrl_panel_msg_payload',
      desc: '',
      args: [],
    );
  }

  /// `Push message payload parse fail`
  String get push_ctrl_panel_msg_payload_parse_err {
    return Intl.message(
      'Push message payload parse fail',
      name: 'push_ctrl_panel_msg_payload_parse_err',
      desc: '',
      args: [],
    );
  }

  /// `Message target`
  String get push_ctrl_panel_msg_target {
    return Intl.message(
      'Message target',
      name: 'push_ctrl_panel_msg_target',
      desc: '',
      args: [],
    );
  }

  /// `Topic or device token not stated`
  String get push_ctrl_panel_msg_target_not_stated_err {
    return Intl.message(
      'Topic or device token not stated',
      name: 'push_ctrl_panel_msg_target_not_stated_err',
      desc: '',
      args: [],
    );
  }

  /// `Firebase project`
  String get push_ctrl_panel_gms_project {
    return Intl.message(
      'Firebase project',
      name: 'push_ctrl_panel_gms_project',
      desc: '',
      args: [],
    );
  }

  /// `Validate push notification through API without sending to devices (validate_only)`
  String get push_ctrl_panel_gms_validate_only_hint {
    return Intl.message(
      'Validate push notification through API without sending to devices (validate_only)',
      name: 'push_ctrl_panel_gms_validate_only_hint',
      desc: '',
      args: [],
    );
  }

  /// `HMS project or app`
  String get push_ctrl_panel_hms_project {
    return Intl.message(
      'HMS project or app',
      name: 'push_ctrl_panel_hms_project',
      desc: '',
      args: [],
    );
  }

  /// `Validate push notification through API without sending to devices (validate_only)`
  String get push_ctrl_panel_hms_validate_only_hint {
    return Intl.message(
      'Validate push notification through API without sending to devices (validate_only)',
      name: 'push_ctrl_panel_hms_validate_only_hint',
      desc: '',
      args: [],
    );
  }

  /// `Push notifications send log`
  String get push_ctrl_panel_send_log_hint {
    return Intl.message(
      'Push notifications send log',
      name: 'push_ctrl_panel_send_log_hint',
      desc: '',
      args: [],
    );
  }

  /// `Topic`
  String get push_target_type_topic {
    return Intl.message(
      'Topic',
      name: 'push_target_type_topic',
      desc: '',
      args: [],
    );
  }

  /// `Device token`
  String get push_target_type_token {
    return Intl.message(
      'Device token',
      name: 'push_target_type_token',
      desc: '',
      args: [],
    );
  }

  /// `Pick previously saved push target`
  String get push_target_history {
    return Intl.message(
      'Pick previously saved push target',
      name: 'push_target_history',
      desc: '',
      args: [],
    );
  }

  /// `New project`
  String get proj_ctor_new_title {
    return Intl.message(
      'New project',
      name: 'proj_ctor_new_title',
      desc: '',
      args: [],
    );
  }

  /// `Project update`
  String get proj_ctor_upd_title {
    return Intl.message(
      'Project update',
      name: 'proj_ctor_upd_title',
      desc: '',
      args: [],
    );
  }

  /// `Firebase project ID`
  String get proj_ctor_gms_id_hint {
    return Intl.message(
      'Firebase project ID',
      name: 'proj_ctor_gms_id_hint',
      desc: '',
      args: [],
    );
  }

  /// `Firebase account credentials json`
  String get proj_ctor_gms_cred_json_hint {
    return Intl.message(
      'Firebase account credentials json',
      name: 'proj_ctor_gms_cred_json_hint',
      desc: '',
      args: [],
    );
  }

  /// `Firebase project ID not stated`
  String get proj_ctor_gms_id_empty_err {
    return Intl.message(
      'Firebase project ID not stated',
      name: 'proj_ctor_gms_id_empty_err',
      desc: '',
      args: [],
    );
  }

  /// `Firebase project credential not stated`
  String get proj_ctor_gms_cred_empty_err {
    return Intl.message(
      'Firebase project credential not stated',
      name: 'proj_ctor_gms_cred_empty_err',
      desc: '',
      args: [],
    );
  }

  /// `Firebase project credential invalid JSON`
  String get proj_ctor_gms_cred_invalid_err {
    return Intl.message(
      'Firebase project credential invalid JSON',
      name: 'proj_ctor_gms_cred_invalid_err',
      desc: '',
      args: [],
    );
  }

  /// `Huawei project or app ID`
  String get proj_ctor_hms_id_hint {
    return Intl.message(
      'Huawei project or app ID',
      name: 'proj_ctor_hms_id_hint',
      desc: '',
      args: [],
    );
  }

  /// `Huawei app OAuth 2.0 client ID`
  String get proj_ctor_hms_cl_id_hint {
    return Intl.message(
      'Huawei app OAuth 2.0 client ID',
      name: 'proj_ctor_hms_cl_id_hint',
      desc: '',
      args: [],
    );
  }

  /// `Huawei app OAuth 2.0 client secret`
  String get proj_ctor_hms_cl_secret_hint {
    return Intl.message(
      'Huawei app OAuth 2.0 client secret',
      name: 'proj_ctor_hms_cl_secret_hint',
      desc: '',
      args: [],
    );
  }

  /// `Huawei project or app ID not stated`
  String get proj_ctor_hms_id_empty_err {
    return Intl.message(
      'Huawei project or app ID not stated',
      name: 'proj_ctor_hms_id_empty_err',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Huawei project or app ID`
  String get proj_ctor_hms_id_invalid_err {
    return Intl.message(
      'Invalid Huawei project or app ID',
      name: 'proj_ctor_hms_id_invalid_err',
      desc: '',
      args: [],
    );
  }

  /// `Huawei app OAuth 2.0 client ID not stated`
  String get proj_ctor_hms_cl_id_empty_err {
    return Intl.message(
      'Huawei app OAuth 2.0 client ID not stated',
      name: 'proj_ctor_hms_cl_id_empty_err',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Huawei app OAuth 2.0 client ID`
  String get proj_ctor_hms_cl_id_invalid_err {
    return Intl.message(
      'Invalid Huawei app OAuth 2.0 client ID',
      name: 'proj_ctor_hms_cl_id_invalid_err',
      desc: '',
      args: [],
    );
  }

  /// `Huawei app OAuth 2.0 client secret not stated`
  String get proj_ctor_hms_cl_secret_empty_err {
    return Intl.message(
      'Huawei app OAuth 2.0 client secret not stated',
      name: 'proj_ctor_hms_cl_secret_empty_err',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get general_accept {
    return Intl.message(
      'Accept',
      name: 'general_accept',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get general_add {
    return Intl.message(
      'Add',
      name: 'general_add',
      desc: '',
      args: [],
    );
  }

  /// `Deleted`
  String get general_deleted {
    return Intl.message(
      'Deleted',
      name: 'general_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get general_send {
    return Intl.message(
      'Send',
      name: 'general_send',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get general_search {
    return Intl.message(
      'Search',
      name: 'general_search',
      desc: '',
      args: [],
    );
  }

  /// `Topic`
  String get general_topic {
    return Intl.message(
      'Topic',
      name: 'general_topic',
      desc: '',
      args: [],
    );
  }

  /// `Device token`
  String get general_device_token {
    return Intl.message(
      'Device token',
      name: 'general_device_token',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
