import users from 'api/users/users';
import userGroups from 'api/user_groups/user_groups';
import userSegments from 'api/user_segments/user_segments';
import sessions from 'api/sessions/sessions';
import fields from 'api/fields/fields';
import fieldData from 'api/field_data/field_data';
import groups from 'api/groups/groups';
import segments from 'api/segments/segments';
import initiatives from 'api/initiatives/initiatives';
import newsFeedLinks from 'api/news_feed_links/news_feed_links';
import groupMessages from 'api/group_messages/group_messages';
import groupMessageComments from 'api/group_message_comments/group_message_comments';
import groupMembers from 'api/group_members/group_members';
import outcomes from 'api/outcomes/outcomes';

/* Metrics */
import overviewGraphs from 'api/metrics/overview_graphs';
import userGraphs from 'api/metrics/user_graphs';
import groupGraphs from 'api/metrics/group_graphs';

const Api = {
  users,
  userGroups,
  userSegments,
  sessions,
  fields,
  fieldData,
  groups,
  segments,
  initiatives,
  newsFeedLinks,
  groupMessages,
  groupMessageComments,
  groupMembers,
  outcomes,
  metrics: {
    overviewGraphs,
    userGraphs,
    groupGraphs,
  }
};

export default Api;
