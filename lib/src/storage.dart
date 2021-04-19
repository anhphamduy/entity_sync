import 'package:entity_sync/moor_sync.dart';
import 'package:moor/moor.dart';

import 'sync.dart';

class StorageResult<TSyncable extends SyncableMixin> {
  bool successful;

  StorageResult(this.successful);
}

/// Responsible for local storage of syncable entities
abstract class Storage<TSyncable extends SyncableMixin> {
  /// Gets the instances to sync
  Future<Iterable<TSyncable>> getInstancesToSync();

  /// Gets an instance matching the remote key, or null
  Future<TSyncable?> get({dynamic remoteKey, dynamic localKey});

  /// Upserts an instance using an optional local key
  Future<StorageResult<TSyncable>> insert(TSyncable instance);

  /// Upserts an instance using an optional local key
  Future<StorageResult<TSyncable>> update(
    TSyncable instance, {
    dynamic remoteKey,
    dynamic localKey,
  });
}

abstract class Relation<TSyncable extends SyncableMixin> {
  Future<String?> needToSyncInstance(TSyncable instance);
}

class MoorRelation<TProxy extends ProxyMixin<DataClass>>
    implements Relation<TProxy> {
  final GeneratedDatabase database;
  final String fkColumn;
  final SyncableTable fkTable;

  MoorRelation(this.database, this.fkColumn, this.fkTable);

  @override
  Future<String?> needToSyncInstance(TProxy instance) async {
    final remoteKey = instance.toMap()[fkColumn];
    final fkInstance = await (database.select(
      fkTable.actualTable() as TableInfo,
    )..where(
            (t) => fkTable.remoteKeyColumn().equals(remoteKey),
          ))
        .getSingleOrNull();

    if (fkInstance == null) {
      return remoteKey;
    }

    return null;
  }
}
