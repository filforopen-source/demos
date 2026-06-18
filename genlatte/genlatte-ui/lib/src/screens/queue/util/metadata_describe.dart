import 'package:genlatte_data/models.dart';

extension MetadataDescribe on LatteOrderMetadata {
  String describe() {
    final buf = StringBuffer('<')..write(id);
    if (completionTime != null) {
      buf.write('-completed');
    }
    buf.write('>');
    return buf.toString();
  }
}
