import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/backends/mastodon/client.dart";
import "package:kaiteki/fediverse/backends/mastodon/shared_adapter.dart";
import "package:kaiteki/fediverse/interfaces/explore_support.dart";
import "package:kaiteki/fediverse/model/embed.dart";
import "package:kaiteki/fediverse/model/instance.dart";
import "package:kaiteki/fediverse/model/notification.dart";
import "package:kaiteki/fediverse/model/post/post.dart";

class MastodonAdapter extends SharedMastodonAdapter<MastodonClient>
    implements ExploreSupport {
  @override
  final String instance;

  static Future<MastodonAdapter> create(ApiType type, String instance) async {
    return MastodonAdapter.custom(type, instance, MastodonClient(instance));
  }

  MastodonAdapter.custom(super.type, this.instance, super.client);

  @override
  Future<Instance?> probeInstance() async {
    final instance = await client.getInstance();

    if (instance.version.contains("Pleroma") ||
        instance.version.contains("+glitch")) {
      return null;
    }

    return toInstance(instance, this.instance);
  }

  @override
  Future<Instance> getInstance() async {
    return toInstance(await client.getInstance(), instance);
  }

  @override
  Future<void> deleteAccount(String password) {
    // TODO(Craftplacer): implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    // HACK(Craftplacer): refetching latest notifcation will mark previously unfetched notifications as read as well
    final latest = await client.getNotifications(limit: 1);
    if (latest.isEmpty) return;
    await client.setMarkerPosition(notifications: latest.first.id);
  }

  @override
  Future<void> markNotificationAsRead(Notification notification) {
    throw UnsupportedError(
      "Mastodon does not support marking individual notifications as read",
    );
  }

  @override
  Future<List<Post>> getTrendingPosts() async {
    final statuses = await client.getTrendingStatuses();
    return statuses.map((s) => toPost(s, instance)).toList();
  }

  @override
  Future<List<Embed>> getTrendingLinks() async {
    final links = await client.getTrendingLinks();
    return links.map(toEmbed).toList();
  }

  @override
  Future<List<String>> getTrendingHashtags() async {
    final tags = await client.getTrendingTags();
    return tags.map((t) => t.name).toList();
  }
}
