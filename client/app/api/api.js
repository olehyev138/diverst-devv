import enterprises from 'api/enterprises/enterprises';
import users from 'api/users/users';
import userRoles from 'api/user_roles/user_roles';
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
import groupLeaders from 'api/group_leaders/group_leaders';
import groupMessages from 'api/group_messages/group_messages';
import groupMessageComments from 'api/group_message_comments/group_message_comments';
import groupMembers from 'api/group_members/group_members';
import outcomes from 'api/outcomes/outcomes';
import customText from 'api/custom_text/custom_text';
import user from 'api/user/user';
import folders from 'api/folders/folders';
import resources from 'api/resources/resources';
import campaigns from 'api/campaigns/campaigns';
import mentorings from 'api/mentorings/mentorings';
import mentoringRequests from 'api/mentoring_requests/mentoring_requests';
import questions from 'api/campaign_questions/questions';
import mentorshipSessions from 'api/mentorship_sessions/mentorship_sessions';
import mentoringSessions from 'api/mentoring_sessions/mentoring_sessions';
import answers from 'api/answers/answers';
import comments from 'api/comments/comments';
import emails from 'api/emails/emails';
import emailEvents from 'api/clockwork_database_events/clockwork_database_events';
import newsLinks from 'api/newslinks/newslinks';
import newsLinkComments from 'api/news_link_comments/news_link_comments';
import socialLinks from 'api/sociallinks/sociallinks';

/* Metrics */
import overviewGraphs from 'api/metrics/overview_graphs';
import userGraphs from 'api/metrics/user_graphs';
import groupGraphs from 'api/metrics/group_graphs';
import metricsDashboards from 'api/metrics/metrics_dashboards';
import customGraphs from 'api/metrics/custom_graphs';

const Api = {
  enterprises,
  users,
  user,
  userGroups,
  userSegments,
  userRoles,
  sessions,
  fields,
  fieldData,
  groups,
  segments,
  initiatives,
  newsFeedLinks,
  newsLinks,
  newsLinkComments,
  socialLinks,
  groupLeaders,
  groupMessages,
  groupMessageComments,
  groupMembers,
  policyGroups,
  outcomes,
  customText,
  folders,
  resources,
  campaigns,
  questions,
  answers,
  comments,
  mentorings,
  mentoringRequests,
  mentorshipSessions,
  mentoringSessions,
  emails,
  emailEvents,
  metrics: {
    overviewGraphs,
    userGraphs,
    groupGraphs,
    metricsDashboards,
    customGraphs
  }
};

export default Api;
