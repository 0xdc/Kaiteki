import "package:kaiteki/fediverse/backends/mastodon/capabilities.dart";
import "package:kaiteki/fediverse/interfaces/reaction_support.dart";
import "package:kaiteki/fediverse/model/formatting.dart";

class GlitchCapabilities extends MastodonCapabilities
    implements ReactionSupportCapabilities {
  final bool supportsReactions;

  const GlitchCapabilities(this.supportsReactions);

  // TODO(erincandescent): Take from
  // api/v1/instance:configuration.statuses.supported_media_types
  @override
  Set<Formatting> get supportedFormattings {
    return const {
      Formatting.plainText,
      Formatting.markdown,
    };
  }

  @override
  bool get supportsCustomEmojiReactions => supportsReactions;
  @override
  bool get supportsUnicodeEmojiReactions => supportsReactions;
  @override
  bool get supportsMultipleReactions => supportsReactions;
}
