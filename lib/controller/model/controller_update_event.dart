import 'controller_update_event_type.dart';

///Represents general controller single data update event
class ControllerUpdateEvent<T> {
  final T item;
  final ControllerUpdateEventType type;

  ControllerUpdateEvent({required this.item, required this.type});
}