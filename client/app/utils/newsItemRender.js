import GroupMessageListItem from 'components/News/GroupMessage/GroupMessageListItem';
import NewsLinkListItem from 'components/News/NewsLink/NewsLinkListItem';
import SocialLinkListItem from 'components/News/SocialLink/SocialLinkListItem';
import React from 'react';

export default function renderNewsItem(item, props, small = false) {
  if (item.group_message)
    return (
      <GroupMessageListItem
        links={props.links}
        newsItem={item}
        readonly={props.readonly}
        groupId={item.news_feed.group_id}
        deleteGroupMessageBegin={props.deleteGroupMessageBegin}
        updateNewsItemBegin={props.updateNewsItemBegin}
        archiveNewsItemBegin={props.archiveNewsItemBegin}
        pinNewsItemBegin={props.pinNewsItemBegin}
        unpinNewsItemBegin={props.unpinNewsItemBegin}
        likeNewsItemBegin={props.likeNewsItemBegin}
        unlikeNewsItemBegin={props.unlikeNewsItemBegin}
        small={small}
        currentGroup={props.currentGroup}
      />
    );
  else if (item.news_link) // eslint-disable-line no-else-return
    return (
      <NewsLinkListItem
        links={props.links}
        newsLink={item.news_link}
        newsItem={item}
        groupId={item.news_feed.group_id}
        readonly={props.readonly}
        deleteNewsLinkBegin={props.deleteNewsLinkBegin}
        updateNewsItemBegin={props.updateNewsItemBegin}
        archiveNewsItemBegin={props.archiveNewsItemBegin}
        pinNewsItemBegin={props.pinNewsItemBegin}
        unpinNewsItemBegin={props.unpinNewsItemBegin}
        likeNewsItemBegin={props.likeNewsItemBegin}
        unlikeNewsItemBegin={props.unlikeNewsItemBegin}
        small={small}
        currentGroup={props.currentGroup}
      />
    );
  else if (item.social_link)
    return (
      <SocialLinkListItem
        socialLink={item.social_link}
        links={props.links}
        newsItem={item}
        groupId={item.news_feed.group_id}
        readonly={props.readonly}
        deleteSocialLinkBegin={props.deleteSocialLinkBegin}
        updateNewsItemBegin={props.updateNewsItemBegin}
        archiveNewsItemBegin={props.archiveNewsItemBegin}
        pinNewsItemBegin={props.pinNewsItemBegin}
        unpinNewsItemBegin={props.unpinNewsItemBegin}
        likeNewsItemBegin={props.likeNewsItemBegin}
        unlikeNewsItemBegin={props.unlikeNewsItemBegin}
        small={small}
        currentGroup={props.currentGroup}
      />
    );

  return undefined;
}
