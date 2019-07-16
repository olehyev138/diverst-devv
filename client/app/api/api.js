import users from 'api/users/users';
import sessions from 'api/sessions/sessions';
import groups from 'api/groups/groups';
import newsFeedLinks from 'api/news_feed_links/news_feed_links';
import groupMessages from 'api/group_messages/group_messages';

const Api = {
  users,
  sessions,
  groups,
  newsFeedLinks,
  groupMessages
};

export default Api;
