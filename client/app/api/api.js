import enterprises from 'api/enterprises/enterprises';
import users from 'api/users/users';
import userGroups from 'api/user_groups/user_groups';
import sessions from 'api/sessions/sessions';
import fields from 'api/fields/fields';
import fieldData from 'api/field_data/field_data';
import groups from 'api/groups/groups';
import newsFeedLinks from 'api/news_feed_links/news_feed_links';
import policyGroups from 'api/policy_groups/policy_groups';
import groupMessages from 'api/group_messages/group_messages';
import groupMessageComments from 'api/group_message_comments/group_message_comments';
import groupMembers from 'api/group_members/group_members';

const Api = {
  enterprises,
  users,
  userGroups,
  sessions,
  fields,
  fieldData,
  groups,
  newsFeedLinks,
  groupMessages,
  groupMessageComments,
  groupMembers,
  policyGroups
};

export default Api;
