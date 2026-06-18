import 'package:shadcn_flutter/shadcn_flutter.dart';

/// GenLatte specific text styles. All unspecified text should use default
/// shadcn_flutter definitions.
extension GenLatteTextExtension on Text {
  /// GenLatte version of [h2] which does not have a bottom border.
  TextModifier get h2_ => WrappedText(
    style: (context, theme) => theme.typography.h2,
    child: this,
  );
}
