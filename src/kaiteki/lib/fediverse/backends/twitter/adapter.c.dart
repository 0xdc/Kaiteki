part of 'adapter.dart';

Post toPost(twitter.Tweet tweet) {
  final content = removeEntities(tweet.text, tweet.entities);

  final quotedStatus = tweet.quotedStatus;
  return Post(
    author: toUser(tweet.user),
    id: tweet.idStr,
    postedAt: tweet.createdAt,
    source: tweet,
    visibility: Visibility.public,
    content: content,
    likeCount: tweet.favoriteCount,
    repeatCount: tweet.retweetCount,
    attachments: tweet.entities.media?.map(toAttachment),
    replyToUserId: tweet.inReplyToUserIdStr,
    replyToPostId: tweet.inReplyToStatusIdStr,
    mentionedUsers: tweet.entities.userMentions?.map((e) {
      return UserReference(e.idStr);
    }).toList(),
    repeatOf: quotedStatus == null ? null : toPost(quotedStatus),
  );
}

String removeEntities(
  String text,
  twitter.Entities? entities, {
  bool removeMediaLinks = true,
  bool expandLinks = true,
}) {
  if (entities == null) {
    return text;
  }

  final totalEntities = entities.aggregated
    ..sort((a, b) => a.indices[0].compareTo(b.indices[0]));

  for (final entity in totalEntities) {
    if (entity is Media && removeMediaLinks) {
      text = text.replaceRange(
        entity.indices[0],
        entity.indices[1],
        "",
      );
    } else if (entity is Url && expandLinks) {
      text = text.replaceRange(
        entity.indices[0],
        entity.indices[1],
        entity.expandedUrl,
      );
    }
  }

  return text;
}

User toUser(twitter.User user) {
  final url = user.url;
  return User(
    displayName: user.name,
    host: null,
    id: user.idStr,
    source: user,
    username: user.screenName,
    description: user.description,
    avatarUrl: user.profileImageUrlHttps,
    bannerUrl: user.profileBannerUrl,
    postCount: user.statusesCount,
    details: UserDetails(
      location: user.location,
      website: url == null ? null : removeEntities(url, user.entities.url),
    ),
    joinDate: user.createdAt,
  );
}

Attachment toAttachment(twitter.Media media) {
  return Attachment(
    source: media,
    url: media.mediaUrlHttps,
    previewUrl: media.mediaUrlHttps,
    type: {
      "photo": AttachmentType.image,
      "video": AttachmentType.video,
      "animated_gif": AttachmentType.animated,
    }[media.type]!,
  );
}