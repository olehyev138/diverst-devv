import users from 'api/users/users';
import sessions from 'api/sessions/sessions';
import groups from 'api/groups/groups';
import initiatives from 'api/initiatives/initiatives';
import newsFeedLinks from 'api/news_feed_links/news_feed_links';
import groupMessages from 'api/group_messages/group_messages';
import groupMessageComments from 'api/group_message_comments/group_message_comments';

const Api = {
  users,
  sessions,
  groups,
  initiatives,
  newsFeedLinks,
  groupMessages,
  groupMessageComments
};

export default Api;
