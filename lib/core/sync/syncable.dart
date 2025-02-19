// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

abstract class Syncable {
  bool get synced;
  set synced(bool value);
}

abstract class HiveSyncable extends HiveObject implements Syncable {}

typedef SyncFunction<T> = Future<void> Function(T record);

class GenericSyncManager<T extends HiveSyncable> {
  final Box<T> box;
  final SyncFunction syncFunction;

  GenericSyncManager({
    required this.box,
    required this.syncFunction,
  });

  Future<void> sync() async {
    final unsyncedRecord =
        box.values.where((record) => !record.synced).toList();
    {
      for (var record in unsyncedRecord) {
        try {
          await syncFunction(record);
          record.synced = true;
          await record.save();
        } catch (e) {
          rethrow;
        }
      }
    }
  }
}
