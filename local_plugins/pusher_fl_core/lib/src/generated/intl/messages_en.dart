// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "general_accept": MessageLookupByLibrary.simpleMessage("Accept"),
        "general_add": MessageLookupByLibrary.simpleMessage("Add"),
        "general_deleted": MessageLookupByLibrary.simpleMessage("Deleted"),
        "general_device_token":
            MessageLookupByLibrary.simpleMessage("Device token"),
        "general_search": MessageLookupByLibrary.simpleMessage("Search"),
        "general_send": MessageLookupByLibrary.simpleMessage("Send"),
        "general_topic": MessageLookupByLibrary.simpleMessage("Topic"),
        "proj_ctor_gms_cred_empty_err": MessageLookupByLibrary.simpleMessage(
            "Firebase project credential not stated"),
        "proj_ctor_gms_cred_invalid_err": MessageLookupByLibrary.simpleMessage(
            "Firebase project credential invalid JSON"),
        "proj_ctor_gms_cred_json_hint": MessageLookupByLibrary.simpleMessage(
            "Firebase account credentials json"),
        "proj_ctor_gms_id_empty_err": MessageLookupByLibrary.simpleMessage(
            "Firebase project ID not stated"),
        "proj_ctor_gms_id_hint":
            MessageLookupByLibrary.simpleMessage("Firebase project ID"),
        "proj_ctor_hms_cl_id_empty_err": MessageLookupByLibrary.simpleMessage(
            "Huawei app OAuth 2.0 client ID not stated"),
        "proj_ctor_hms_cl_id_hint": MessageLookupByLibrary.simpleMessage(
            "Huawei app OAuth 2.0 client ID"),
        "proj_ctor_hms_cl_id_invalid_err": MessageLookupByLibrary.simpleMessage(
            "Invalid Huawei app OAuth 2.0 client ID"),
        "proj_ctor_hms_cl_secret_empty_err":
            MessageLookupByLibrary.simpleMessage(
                "Huawei app OAuth 2.0 client secret not stated"),
        "proj_ctor_hms_cl_secret_hint": MessageLookupByLibrary.simpleMessage(
            "Huawei app OAuth 2.0 client secret"),
        "proj_ctor_hms_id_empty_err": MessageLookupByLibrary.simpleMessage(
            "Huawei project or app ID not stated"),
        "proj_ctor_hms_id_hint":
            MessageLookupByLibrary.simpleMessage("Huawei project or app ID"),
        "proj_ctor_hms_id_invalid_err": MessageLookupByLibrary.simpleMessage(
            "Invalid Huawei project or app ID"),
        "proj_ctor_new_title":
            MessageLookupByLibrary.simpleMessage("New project"),
        "proj_ctor_upd_title":
            MessageLookupByLibrary.simpleMessage("Project update"),
        "push_ctrl_panel_gms_project":
            MessageLookupByLibrary.simpleMessage("Firebase project"),
        "push_ctrl_panel_gms_validate_only_hint":
            MessageLookupByLibrary.simpleMessage(
                "Validate push notification through API without sending to devices (validate_only)"),
        "push_ctrl_panel_hms_project":
            MessageLookupByLibrary.simpleMessage("HMS project or app"),
        "push_ctrl_panel_hms_validate_only_hint":
            MessageLookupByLibrary.simpleMessage(
                "Validate push notification through API without sending to devices (validate_only)"),
        "push_ctrl_panel_msg_payload":
            MessageLookupByLibrary.simpleMessage("Push message data"),
        "push_ctrl_panel_msg_payload_parse_err":
            MessageLookupByLibrary.simpleMessage(
                "Push message payload parse fail"),
        "push_ctrl_panel_msg_target":
            MessageLookupByLibrary.simpleMessage("Message target"),
        "push_ctrl_panel_msg_target_not_stated_err":
            MessageLookupByLibrary.simpleMessage(
                "Topic or device token not stated"),
        "push_ctrl_panel_project_add_new":
            MessageLookupByLibrary.simpleMessage("Add new"),
        "push_ctrl_panel_project_not_selected_err":
            MessageLookupByLibrary.simpleMessage("Project not selected"),
        "push_ctrl_panel_send_log_hint":
            MessageLookupByLibrary.simpleMessage("Push notifications send log"),
        "push_target_history": MessageLookupByLibrary.simpleMessage(
            "Pick previously saved push target"),
        "push_target_type_token":
            MessageLookupByLibrary.simpleMessage("Device token"),
        "push_target_type_topic": MessageLookupByLibrary.simpleMessage("Topic")
      };
}
