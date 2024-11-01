
import 'dart:async';
import 'dart:collection';

import 'api_controller.dart';
import '../../model/id_retrievable.dart';
import '../../model/push_target_type.dart';
import '../../network/client_mp.dart';

abstract class PushController<K,T extends IdRetrievable<K>> extends ApiController {

  ///Push projects collection
  HashMap<K, T> get projects;
  ///Selected active project
  T? get activeProj;
  ///Push projects count
  int get projectsCount;
  ///Contains no any projects in controller
  bool get isEmpty;
  ///Contains any projects in controller
  bool get isNotEmpty;
  ///Project push targets (device push tokens, topics' names and other) collection
  HashMap<K, HashMap<String, PushTargetType>> get projectTargets;

  ///Selected active project update events stream
  Stream<T?> get onSelectedProjectUpdate;

  ///Projects create events stream
  Stream<HashMap<K,T>> get onProjectsCreate;
  ///Projects update events stream
  Stream<HashMap<K,T>> get onProjectsUpdate;
  ///Projects delete events stream
  Stream<HashMap<K,T>> get onProjectsDelete;
  ///Whole projects collection update events stream
  Stream<HashMap<K,T>> get onProjectsCollectionUpdate;

  ///Project targets create events stream
  Stream<HashMap<K,HashMap<String, PushTargetType>>> get onTargetsCreate;
  ///Project targets update events stream
  Stream<HashMap<K,HashMap<String, PushTargetType>>> get onTargetsUpdate;
  ///Project targets delete events stream
  Stream<HashMap<K,HashMap<String, PushTargetType>>> get onTargetsDelete;
  ///Whole project targets collection update events stream
  Stream<HashMap<K,HashMap<String, PushTargetType>>> get onTargetsCollectionUpdate;

  factory PushController({required Client apiClient, Map<K, T>? initProjects, K? initSelectedProjId, Map<K, HashMap<String, PushTargetType>>? initTargets}) = PushControllerImpl;

  ///Get project by ID
  T? getProj({required K id});
  ///Search project by string query
  List<T> searchProj(String query, {bool caseSensitive = false});
  ///Get project push targets
  HashMap<String, PushTargetType> findProjectTargets({required K id});
  ///Inserts or updates project config
  void addOrUpdateProj(T proj);
  ///Removes project config and its targets
  bool removeProj({required K projId});
  ///Sets new collection value. Old collection entries will be deleted
  void setProjects(List<T> replaceProjects);

  ///Inserts project config target
  ///
  ///If project doesn't exist, no-op
  bool addOrUpdateTarget({required K projId, required String target, required PushTargetType type});
  ///Removes push target from project config
  bool removeTarget({required String target, K? projId});
  ///Get project targets
  List<MapEntry<String, PushTargetType>> getProjectTargets(K projId, {PushTargetType? targetType});
  ///Removes all push targets from project
  void removeProjectTargets({required K projId});

  ///Set project as selected from collection by ID
  bool selectProj({required K id});
  ///Deselect active project if exists
  void deselectProj();

  ///Clears project configs and all push targets
  void clearData();
  ///Clears all push targets from all projects
  void clearTargets();
}

class PushControllerImpl<K,T extends IdRetrievable<K>> extends ApiControllerImpl implements PushController<K,T> {

  final pushProjects = HashMap<K, T>();
  K? selectedProjId;
  final projTargets = HashMap<K, HashMap<String, PushTargetType>>();

  @override
  HashMap<K, T> get projects => HashMap.from(pushProjects);
  @override
  T? get activeProj => pushProjects[selectedProjId];
  @override
  int get projectsCount => pushProjects.length;
  @override
  bool get isEmpty => pushProjects.isEmpty;
  @override
  bool get isNotEmpty => pushProjects.isNotEmpty;
  @override
  HashMap<K, HashMap<String, PushTargetType>> get projectTargets => HashMap.from(projTargets);

  final StreamController<T?> selectedProjEventsController = StreamController.broadcast();
  @override
  Stream<T?> get onSelectedProjectUpdate => selectedProjEventsController.stream;

  final StreamController<HashMap<K,T>> projectsCreateEventsController = StreamController.broadcast();
  @override
  Stream<HashMap<K,T>> get onProjectsCreate => projectsCreateEventsController.stream;
  final StreamController<HashMap<K,T>> projectsUpdEventsController = StreamController.broadcast();
  @override
  Stream<HashMap<K,T>> get onProjectsUpdate => projectsUpdEventsController.stream;
  final StreamController<HashMap<K,T>> projectsDeleteEventsController = StreamController.broadcast();
  @override
  Stream<HashMap<K,T>> get onProjectsDelete => projectsDeleteEventsController.stream;
  final StreamController<HashMap<K,T>> projectsCollectionUpdEventsController = StreamController.broadcast();
  @override
  Stream<HashMap<K,T>> get onProjectsCollectionUpdate => projectsCollectionUpdEventsController.stream;

  final StreamController<HashMap<K,HashMap<String, PushTargetType>>> targetsCreateEventsController = StreamController.broadcast();
  @override
  Stream<HashMap<K,HashMap<String, PushTargetType>>> get onTargetsCreate => targetsCreateEventsController.stream;
  final StreamController<HashMap<K,HashMap<String, PushTargetType>>> targetsUpdEventsController = StreamController.broadcast();
  @override
  Stream<HashMap<K,HashMap<String, PushTargetType>>> get onTargetsUpdate => targetsUpdEventsController.stream;
  final StreamController<HashMap<K,HashMap<String, PushTargetType>>> targetsDeleteEventsController = StreamController.broadcast();
  @override
  Stream<HashMap<K,HashMap<String, PushTargetType>>> get onTargetsDelete => targetsDeleteEventsController.stream;
  final StreamController<HashMap<K,HashMap<String, PushTargetType>>> targetsCollectionUpdEventsController = StreamController.broadcast();
  @override
  Stream<HashMap<K,HashMap<String, PushTargetType>>> get onTargetsCollectionUpdate => targetsCollectionUpdEventsController.stream;

  PushControllerImpl({required super.apiClient, Map<K, T>? initProjects, K? initSelectedProjId, Map<K, HashMap<String, PushTargetType>>? initTargets}) {
    if (initProjects != null && initProjects.isNotEmpty) {
      pushProjects.addAll(initProjects);
    }
    if (initSelectedProjId != null && pushProjects.containsKey(initSelectedProjId)) {
      selectedProjId = initSelectedProjId;
    }
    if (initTargets != null && initTargets.isNotEmpty) {
      projTargets.addAll(initTargets);
    }
  }

  @override
  T? getProj({required K id}) {
    return pushProjects[id];
  }

  @override
  List<T> searchProj(String query, {bool caseSensitive = false}) {
    if (query.length < 3) {
      return pushProjects.values.toList();
    }
    final List<T> res = [];
    var validatedQuery = query;
    if (!caseSensitive) {
      validatedQuery = validatedQuery.toLowerCase();
    }
    for (final entry in pushProjects.entries) {
      var id = entry.key.toString();
      if (!caseSensitive) {
        id = id.toLowerCase();
      }
      if (id == validatedQuery || id.contains(validatedQuery)) {
        res.add(entry.value);
      }
    }
    return res;
  }

  @override
  HashMap<String, PushTargetType> findProjectTargets({required K id}) {
    return projTargets[id] ?? HashMap<String, PushTargetType>();
  }

  @override
  void addOrUpdateProj(T proj) {
    final map = HashMap<K,T>();
    final exists = pushProjects.containsKey(proj.id);
    map[proj.id] = proj;
    pushProjects[proj.id] = proj;
    if (exists) {
      projectsUpdEventsController.add(map);
    } else {
      projectsCreateEventsController.add(map);
    }
    projectsCollectionUpdEventsController.add(projects);
  }

  @override
  bool removeProj({required K projId}) {
    final proj = pushProjects[projId];
    if (proj == null) {
      return false;
    }
    pushProjects.remove(projId);
    final map = HashMap<K,T>();
    map[projId] = proj;
    removeProjectTargets(projId: projId);
    projectsDeleteEventsController.add(map);
    projectsCollectionUpdEventsController.add(projects);
    if (projId == selectedProjId) {
      if (pushProjects.isEmpty) {
        selectedProjId = null;
      } else {
        selectedProjId = pushProjects.values.first.id;
      }
      selectedProjEventsController.add(pushProjects[selectedProjId]);
    }
    return true;
  }

  @override
  void setProjects(List<T> replaceProjects) {
    final deleted = HashMap<K,T>();
    final created = HashMap<K,T>();
    final updated = HashMap<K,T>();
    final replaceProjectKeys = HashSet<K>.from(replaceProjects.map((e) => e.id));
    for (final entry in pushProjects.entries.toList(growable: false)) {
      if (replaceProjectKeys.contains(entry.key)) {
        continue;
      }
      deleted[entry.key] = entry.value;
      pushProjects.remove(entry.key);
    }
    for (final proj in replaceProjects) {
      if (pushProjects.containsKey(proj.id)) {
        updated[proj.id] = proj;
      } else {
        created[proj.id] = proj;
      }
      pushProjects[proj.id] = proj;
    }
    if (deleted.isEmpty && updated.isEmpty && created.isEmpty) {
      return;
    }
    if (deleted.isNotEmpty) {
      projectsDeleteEventsController.add(deleted);
      if (selectedProjId != null && deleted.containsKey(selectedProjId)) {
        if (pushProjects.isEmpty) {
          selectedProjId = null;
        } else {
          selectedProjId = pushProjects.values.first.id;
        }
        selectedProjEventsController.add(pushProjects[selectedProjId]);
      }
    }
    if (created.isNotEmpty) {
      projectsCreateEventsController.add(created);
    }
    if (updated.isNotEmpty) {
      projectsUpdEventsController.add(updated);
    }
    projectsCollectionUpdEventsController.add(projects);
  }

  @override
  bool addOrUpdateTarget({required K projId, required String target, required PushTargetType type}) {
    final proj = pushProjects[projId];
    if (proj == null) {
      return false;
    }
    if (!projTargets.containsKey(projId)) {
      projTargets[projId] = HashMap<String,PushTargetType>();
    }
    final exists = projTargets[projId]?.containsKey(target) == true;
    final map = HashMap<K,HashMap<String, PushTargetType>>();
    map[projId] = HashMap<String, PushTargetType>.fromEntries([MapEntry(target, type)]);
    projTargets[projId]?[target] = type;
    if (exists) {
      targetsUpdEventsController.add(map);
    } else {
      targetsCreateEventsController.add(map);
    }
    targetsCollectionUpdEventsController.add(projectTargets);
    return true;
  }

  @override
  bool removeTarget({required String target, K? projId}) {
    final map = HashMap<K,HashMap<String, PushTargetType>>();
    K? safeProjId = projId;
    if (safeProjId == null) {
      for (final projEntry in projTargets.entries) {
        for (final targetEntry in projEntry.value.entries) {
          if (targetEntry.key != target) {
            continue;
          }
          safeProjId = projEntry.key;
          break;
        }
      }
      if (safeProjId == null) {
        return false;
      }
    }
    final targets = projTargets[safeProjId];
    if (targets == null || targets.isEmpty) {
      return false;
    }
    final targetType = projTargets[safeProjId]?.remove(target);
    if (targetType == null) {
      return false;
    }
    map[safeProjId] = HashMap<String, PushTargetType>.fromEntries([MapEntry(target, targetType)]);
    targetsDeleteEventsController.add(map);
    targetsCollectionUpdEventsController.add(projectTargets);
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
    final map = HashMap<K, HashMap<String, PushTargetType>>();
    map[projId] = HashMap<String, PushTargetType>.from(targets);
    if (!pushProjects.containsKey(projId)) {
      projectTargets.remove(projId);
    } else {
      projTargets[projId]?.clear();
    }
    targetsDeleteEventsController.add(map);
    targetsCollectionUpdEventsController.add(projectTargets);
  }

  @override
  bool selectProj({required K id}) {
    if (!pushProjects.containsKey(id)) {
      return false;
    }
    selectedProjId = id;
    selectedProjEventsController.add(pushProjects[id]);
    return true;
  }

  @override
  void deselectProj() {
    selectedProjId = null;
    selectedProjEventsController.add(null);
  }

  @override
  void clearData() {
    clearTargets();
    final deleted = projects;
    selectedProjId = null;
    pushProjects.clear();
    projectsDeleteEventsController.add(deleted);
    projectsCollectionUpdEventsController.add(projects);
    selectedProjEventsController.add(null);
  }

  @override
  void clearTargets() {
    final deleted = projectTargets;
    projTargets.clear();
    targetsDeleteEventsController.add(deleted);
    targetsCollectionUpdEventsController.add(projectTargets);
  }
}