import enterprises from 'api/enterprises/enterprises';
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
import policyGroups from 'api/policy_groups/policy_groups';
import groupMessages from 'api/group_messages/group_messages';
import groupMessageComments from 'api/group_message_comments/group_message_comments';
import groupMembers from 'api/group_members/group_members';
import outcomes from 'api/outcomes/outcomes';

/* Metrics */
import overviewGraphs from 'api/metrics/overview_graphs';
import userGraphs from 'api/metrics/user_graphs';
import groupGraphs from 'api/metrics/group_graphs';
import metricsDashboards from 'api/metrics/metrics_dashboards';
import customGraphs from 'api/metrics/custom_graphs';

const Api = {
  enterprises,
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
  policyGroups,
  outcomes,
  metrics: {
    overviewGraphs,
    userGraphs,
    groupGraphs,
    metricsDashboards,
    customGraphs
  }
};

export default Api;
