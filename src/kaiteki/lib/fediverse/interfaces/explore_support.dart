import "package:kaiteki/fediverse/model/model.dart";

abstract class ExploreSupport {
  ExploreCapabilities get capabilities;

  Future<List<Post>> getTrendingPosts();
  Future<List<Embed>> getTrendingLinks();
  Future<List<String>> getTrendingHashtags();
}

abstract class ExploreCapabilities {
  bool get supportsTrendingLinks;
}
