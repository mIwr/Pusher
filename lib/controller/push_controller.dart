
import 'dart:async';
import 'dart:collection';

import 'package:pusher/controller/model/controller_update_event.dart';
import 'package:pusher/controller/model/controller_update_event_type.dart';
import 'package:pusher/model/id_retrievable.dart';
import 'package:pusher/model/push_target_type.dart';

abstract class PushController<K,T extends IdRetrievable<K>> {

  ///Push projects collection
  HashMap<K, T> get projects;
  ///Selected project
  T? get selected;
  ///Push project update event stream
  Stream<ControllerUpdateEvent<T>> get onProjectUpdate;
  ///Project selection update event stream
  Stream<T?> get onSelectedProjUpdate;
  ///Firebase projects collection update event stream
  Stream<HashMap<K, T>> get onProjectsCollectionUpdate;

  ///Saved push targets (device push tokens or topics' names) collection for Firebase project FCM
  HashMap<K, HashMap<String, PushTargetType>> get savedProjectTargets;
  ///Push target update event stream
  Stream<ControllerUpdateEvent<MapEntry<String, PushTargetType>>> get onTargetUpdate;
  ///Project targets collection update event stream
  Stream<MapEntry<T, HashMap<String, PushTargetType>>> get onProjectTargetsCollectionUpdate;

  factory PushController({Map<K, T>? initProjects, K? initSelectedProjId, Map<K, HashMap<String, PushTargetType>>? initTargets}) = PushControllerImpl;

  ///Returns ordered by ID projects collection
  List<T> generateOrderedList();

  ///Search GMS projects by string [query]
  List<T> search(String query);
  ///Set project as selected from collection by ID
  bool selectProj({required K id});
  ///Deselect active project if exists
  void deselectProj();
  ///Inserts or updates Firebase project config
  void updateProj(T proj);
  ///Removes Firebase project config and its targets
  bool removeProj({required K projId});
  ///Sets new collection value. Old collection entries will be deleted
  void setProjects(List<T> replaceProjects);
  ///Inserts or updates Firebase project configs
  void updateProjects(List<T> updProjects);
  ///Clears the project configs with its targets
  void clearProjects();

  ///Inserts project config target
  ///
  ///If project doesn't exist, no-op
  bool addTarget({required K projId, required String target, required PushTargetType type});
  ///Removes push target from Firebase project config
  bool removeTarget({required String target, K? projId});
  ///Get project targets
  List<MapEntry<String, PushTargetType>> getProjectTargets(K projId, {PushTargetType? targetType});
  ///Removes all push targets from project
  void removeProjectTargets({required K projId});
  ///Clears all push targets from each project
  void clearTargets();

}

class PushControllerImpl<K,T extends IdRetrievable<K>> implements PushController<K,T> {
  final pushProjects = HashMap<K, T>();
  final projTargets = HashMap<K, HashMap<String, PushTargetType>>();
  K? selectedId;

  @override
  HashMap<K, T> get projects => HashMap.from(pushProjects);
  @override
  HashMap<K, HashMap<String, PushTargetType>> get savedProjectTargets => HashMap.from(projTargets);
  @override
  T? get selected => pushProjects[selectedId];

  final StreamController<ControllerUpdateEvent<T>> projectEventsController = StreamController.broadcast();
  @override
  Stream<ControllerUpdateEvent<T>> get onProjectUpdate => projectEventsController.stream;

  final StreamController<HashMap<K, T>> projectCollectionEventsController = StreamController.broadcast();
  @override
  Stream<HashMap<K, T>> get onProjectsCollectionUpdate => projectCollectionEventsController.stream;

  final StreamController<T?> selectedProjEventsController = StreamController.broadcast();
  @override
  Stream<T?> get onSelectedProjUpdate => selectedProjEventsController.stream;

  final StreamController<ControllerUpdateEvent<MapEntry<String, PushTargetType>>> targetEventsController = StreamController.broadcast();
  Stream<ControllerUpdateEvent<MapEntry<String, PushTargetType>>> get onTargetUpdate => targetEventsController.stream;

  final StreamController<MapEntry<T, HashMap<String, PushTargetType>>> projectTargetsCollectionEventsController = StreamController.broadcast();
  @override
  Stream<MapEntry<T, HashMap<String, PushTargetType>>> get onProjectTargetsCollectionUpdate => projectTargetsCollectionEventsController.stream;

  PushControllerImpl({Map<K, T>? initProjects, K? initSelectedProjId, Map<K, HashMap<String, PushTargetType>>? initTargets}) {
    if (initProjects != null && initProjects.isNotEmpty) {
      pushProjects.addAll(initProjects);
    }
    if (pushProjects.containsKey(initSelectedProjId)) {
      selectedId = initSelectedProjId;
    }
    if (initTargets != null && initTargets.isNotEmpty) {
      projTargets.addAll(initTargets);
    }
  }

  @override
  List<T> generateOrderedList() {
    throw UnimplementedError();
  }

  @override
  List<T> search(String query) {
    throw UnimplementedError();
  }

  @override
  bool selectProj({required K id}) {
    if (pushProjects.containsKey(id)) {
      selectedId = id;
      selectedProjEventsController.add(pushProjects[id]);
      return true;
    }
    return false;
  }

  @override
  void deselectProj() {
    selectedId = null;
    selectedProjEventsController.add(null);
  }

  @override
  void updateProj(T proj) {
    var eventType = ControllerUpdateEventType.created;
    final stock = pushProjects[proj.id];
    if (stock != null) {
      eventType = ControllerUpdateEventType.updated;
    }
    final empty = pushProjects.isEmpty;
    pushProjects[proj.id] = proj;
    projectEventsController.add(ControllerUpdateEvent(item: proj, type: eventType));
    if (eventType == ControllerUpdateEventType.created) {
      projectCollectionEventsController.add(projects);
    }
    if (empty) {
      selectedId = proj.id;
      selectedProjEventsController.add(proj);
    }
  }

  @override
  bool removeProj({required K projId}) {
    final proj = pushProjects[projId];
    if (proj == null) {
      return false;
    }
    pushProjects.remove(projId);
    projectEventsController.add(ControllerUpdateEvent(item: proj, type: ControllerUpdateEventType.deleted));
    projectCollectionEventsController.add(projects);
    if (projId == selectedId) {
      if (pushProjects.isEmpty) {
        selectedId = null;
      } else {
        selectedId = pushProjects.values.first.id;
      }
      selectedProjEventsController.add(selected);
    }
    removeProjectTargets(projId: projId);

    return true;
  }

  @override
  void setProjects(List<T> replaceProjects) {
    final replaceKeys = HashSet<K>.from(replaceProjects.map((e) => e.id));
    final projectDeletionKeys = HashSet<K>();
    var countUpd = false;
    for (final proj in replaceProjects) {
      var eventType = ControllerUpdateEventType.updated;
      if (!pushProjects.containsKey(proj.id)) {
        eventType = ControllerUpdateEventType.created;
        countUpd = true;
      }
      pushProjects[proj.id] = proj;
      projectEventsController.add(ControllerUpdateEvent(item: proj, type: eventType));
    }
    for (final entry in pushProjects.entries) {
      if (replaceKeys.contains(entry.key)) {
        continue;
      }
      projectDeletionKeys.add(entry.key);
      countUpd = true;
    }
    if (projectDeletionKeys.isEmpty) {
      if (countUpd) {
        projectCollectionEventsController.add(projects);
      }
      return;
    }
    for (final key in projectDeletionKeys) {
      final item = pushProjects[key];
      if (item == null) {
        continue;
      }
      pushProjects.remove(item.id);
      projectEventsController.add(ControllerUpdateEvent(item: item, type: ControllerUpdateEventType.deleted));
      removeProjectTargets(projId: item.id);
    }
    if (countUpd) {
      projectCollectionEventsController.add(projects);
    }
  }

  @override
  void updateProjects(List<T> updProjects) {
    var countUpd = false;
    for (final proj in updProjects) {
      var eventType = ControllerUpdateEventType.updated;
      if (!pushProjects.containsKey(proj.id)) {
        eventType = ControllerUpdateEventType.created;
        countUpd = true;
      }
      pushProjects[proj.id] = proj;
      projectEventsController.add(ControllerUpdateEvent(item: proj, type: eventType));
    }
    if (countUpd) {
      projectCollectionEventsController.add(projects);
    }
  }

  @override
  void clearProjects() {
    for (final entry in pushProjects.entries) {
      projectEventsController.add(ControllerUpdateEvent(item: entry.value, type: ControllerUpdateEventType.deleted));
    }
    pushProjects.clear();
    projectCollectionEventsController.add(projects);
    clearTargets();
  }

  @override
  bool addTarget({required K projId, required String target, required PushTargetType type}) {
    final proj = pushProjects[projId];
    if (proj == null) {
      return false;
    }
    var eventType = ControllerUpdateEventType.created;
    var targets = projTargets[projId];
    if (targets == null) {
      targets = HashMap<String, PushTargetType>();
      projTargets[projId] = targets;
    }
    final replaceItem = targets[target];
    if (replaceItem != null) {
      eventType = ControllerUpdateEventType.updated;
    }
    projTargets[projId]?[target] = type;
    targetEventsController.add(ControllerUpdateEvent(item: MapEntry(target, type), type: eventType));
    if (eventType == ControllerUpdateEventType.created) {
      projectTargetsCollectionEventsController.add(MapEntry(proj, HashMap.from(targets)));
    }
    return true;
  }

  @override
  bool removeTarget({required String target, K? projId}) {
    T? proj;
    HashMap<String, PushTargetType>? targets;
    if (projId != null) {
      proj = pushProjects[projId];
      targets = projTargets[projId];
      if (targets == null || targets.isEmpty) {
        return false;
      }
      final targetType = targets[target];
      if (targetType != null) {
        targets.remove(target);
        targetEventsController.add(ControllerUpdateEvent(item: MapEntry(target, targetType), type: ControllerUpdateEventType.deleted));
        if (proj != null) {
          projectTargetsCollectionEventsController.add(MapEntry(proj, HashMap.from(targets)));
        }

        return true;
      }
    }
    HashMap<String, PushTargetType>? targetsCollection;
    PushTargetType? targetType;
    for (final projEntry in projTargets.entries) {
      for (final targetEntry in projEntry.value.entries) {
        if (targetEntry.key != target) {
          continue;
        }
        targetType = targetEntry.value;
        targetsCollection = projEntry.value;
        proj = pushProjects[projEntry.key];
        break;
      }
    }
    if (targetsCollection == null || targetType == null) {
      return false;
    }
    targetsCollection.remove(target);
    targetEventsController.add(ControllerUpdateEvent(item: MapEntry(target, targetType), type: ControllerUpdateEventType.deleted));
    if (proj != null) {
      projectTargetsCollectionEventsController.add(MapEntry(proj, HashMap.from(targetsCollection)));
    }

    return true;
  }

  @override
  List<MapEntry<String, PushTargetType>> getProjectTargets(K projId, {PushTargetType? targetType}) {
    final allProjTargets = projTargets[projId];
    if (allProjTargets == null || allProjTargets.isEmpty) {
      return [];
    }
    final List<MapEntry<String, PushTargetType>> res = [];
    for (final entry in allProjTargets.entries) {
      if (targetType != null && targetType != entry.value) {
        continue;
      }
      res.add(MapEntry<String, PushTargetType>(entry.key, entry.value));
    }
    return res;
  }

  @override
  void removeProjectTargets({required K projId}) {
    final targets = projTargets[projId];
    if (targets == null) {
      return;
    }
    for (final targetEntry in targets.entries) {
      targetEventsController.add(ControllerUpdateEvent(item: targetEntry, type: ControllerUpdateEventType.deleted));
    }
    projTargets.remove(projId);
  }

  @override
  void clearTargets() {
    for (final entry in projTargets.entries) {
      for (final targetEntry in entry.value.entries) {
        targetEventsController.add(ControllerUpdateEvent(item: targetEntry, type: ControllerUpdateEventType.deleted));
      }
    }
    projTargets.clear();
  }
}