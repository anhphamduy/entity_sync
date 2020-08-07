An entity sync library for Dart developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'package:entity_sync/entity_sync.dart';

class TestEntity with SerializableMixin {
  int id;
  String name;
  DateTime created;

  TestEntity(this.id, this.name, this.created);
}
class TestEntitySerializer extends Serializer {
  final fields = <SerializableField>[
    IntegerField('id'),
    StringField('name'),
    DateTimeField('created'),
  ];

  TestEntitySerializer({Map<String, dynamic>data, SerializableMixin instance})
      : super(data: data, instance: instance);
}


main() {
  final instance = TestEntity(0, 'TestName', DateTime.now());
  final serializer = TestEntitySerializer(instance: instance);

  /// validate that the instance provided is valid
  final valid = serializer.isValid();
  /// get a json representation of the instance
  final json = serializer.toRepresentation();
}
```
