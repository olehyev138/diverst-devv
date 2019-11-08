/* Layouts */
import UserLayout from 'containers/Layouts/UserLayout/Loadable';
import GroupLayout from 'containers/Layouts/GroupLayout/Loadable';
import AdminLayout from 'containers/Layouts/AdminLayout/Loadable';
import SessionLayout from 'containers/Layouts/SessionLayout/Loadable';
import ErrorLayout from 'containers/Layouts/ErrorLayout/Loadable';
import GlobalSettingsLayout from 'containers/Layouts/GlobalSettingsLayout/Loadable';
import GroupManageLayout from 'containers/Layouts/GroupManageLayout/Loadable';
import MentorshipLayout from 'containers/Layouts/MentorshipLayout/Loadable';
import InnovateLayout from 'containers/Layouts/InnovateLayout/Loadable';

/* Session */
import LoginPage from 'containers/Session/LoginPage/Loadable';


/* User */
import HomePage from 'containers/User/HomePage/Loadable';
import UserGroupListPage from 'containers/Group/UserGroupListPage/Loadable';
import UserProfilePage from 'containers/User/UserProfilePage/Loadable';
import UserNewsLinkPage from 'containers/User/UserNewsFeedPage/Loadable';
import UserEventsPage from 'containers/User/UserEventsPage/Loadable';

/* User - Mentorship */
import MentorshipProfilePage from 'containers/Mentorship/MentorshipProfilePage/Loadable';
import MentorshipEditProfilePage from 'containers/Mentorship/MentorshipEditProfilePage/Loadable';
import MentorsPage from 'containers/Mentorship/Mentoring/MentorsPage/Loadable';

/* Admin - Analyze */
import GroupDashboardPage from 'containers/Analyze/Dashboards/GroupDashboardPage/Loadable';
import UserDashboardPage from 'containers/Analyze/Dashboards/UserDashboardPage/Loadable';

/* Admin - Analyze - Custom */
import MetricsDashboardListPage from 'containers/Analyze/Dashboards/MetricsDashboard/MetricsDashboardListPage/Loadable';
import MetricsDashboardCreatePage from 'containers/Analyze/Dashboards/MetricsDashboard/MetricsDashboardCreatePage/Loadable';
import MetricsDashboardEditPage from 'containers/Analyze/Dashboards/MetricsDashboard/MetricsDashboardEditPage/Loadable';
import MetricsDashboardPage from 'containers/Analyze/Dashboards/MetricsDashboard/MetricsDashboardPage/Loadable';
import CustomGraphCreatePage from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphCreatePage/Loadable';
import CustomGraphEditPage from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphEditPage/Loadable';

/* Admin - Manage - Group */
import AdminGroupListPage from 'containers/Group/AdminGroupListPage/Loadable';
import GroupCreatePage from 'containers/Group/GroupCreatePage/Loadable';
import GroupEditPage from 'containers/Group/GroupEditPage/Loadable';

/* Admin - Manage - Segment */
import SegmentListPage from 'containers/Segment/SegmentListPage/Loadable';
import SegmentPage from 'containers/Segment/SegmentPage/Loadable';

/* Admin - System - Global Settings */
import FieldsPage from 'containers/GlobalSettings/Field/FieldsPage/Loadable';
import CustomTextEditPage from 'containers/GlobalSettings/CustomText/CustomTextEditPage/Loadable';
import EnterpriseConfigurationPage from 'containers/GlobalSettings/EnterpriseConfiguration/EnterpriseConfigurationPage/Loadable';

/* Admin - System - User */
import UsersPage from 'containers/User/UsersPage/Loadable';
import UserCreatePage from 'containers/User/UserCreatePage/Loadable';
import UserEditPage from 'containers/User/UserEditPage/Loadable';


/* Group */
import GroupHomePage from 'containers/Group/GroupHomePage/Loadable';
import EventsPage from 'containers/Event/EventsPage/Loadable';
import NewsFeedPage from 'containers/News/NewsFeedPage/Loadable';
import OutcomesPage from 'containers/Group/Outcome/OutcomesPage/Loadable';

/* Group - Events */
import EventPage from 'containers/Event/EventPage/Loadable';
import EventCreatePage from 'containers/Event/EventCreatePage/Loadable';
import EventEditPage from 'containers/Event/EventEditPage/Loadable';

/* Group - News Feed */
import GroupMessagePage from 'containers/News/GroupMessage/GroupMessagePage/Loadable';
import GroupMessageCreatePage from 'containers/News/GroupMessage/GroupMessageCreatePage/Loadable';
import GroupMessageEditPage from 'containers/News/GroupMessage/GroupMessageEditPage/Loadable';

/* Group - Outcomes */
import OutcomeCreatePage from 'containers/Group/Outcome/OutcomeCreatePage/Loadable';
import OutcomeEditPage from 'containers/Group/Outcome/OutcomeEditPage/Loadable';

/* Group - Members */
import GroupMemberListPage from 'containers/Group/GroupMembers/GroupMemberListPage/Loadable';
import GroupMemberCreatePage from 'containers/Group/GroupMembers/GroupMemberCreatePage/Loadable';

/* Group - Manage */
import GroupSettingsPage from 'containers/Group/GroupManage/GroupSettingsPage/Loadable';

/* Group/Admin - Resource */
import FoldersPage from 'containers/Resource/Folder/FoldersPage/Loadable';
import FolderCreatePage from 'containers/Resource/Folder/FolderCreatePage/Loadable';
import FolderEditPage from 'containers/Resource/Folder/FolderEditPage/Loadable';
import FolderPage from 'containers/Resource/Folder/FolderPage/Loadable';
import ResourceCreatePage from 'containers/Resource/Resource/ResourceCreatePage/Loadable';
import ResourceEditPage from 'containers/Resource/Resource/ResourceEditPage/Loadable';

/* Admin Innovate */

/* Global */
import NotFoundPage from 'containers/Shared/NotFoundPage/Loadable';
import PlaceholderPage from 'components/Shared/PlaceholderPage/Loadable';


export {
  UserLayout, GroupLayout, AdminLayout, SessionLayout, ErrorLayout, GlobalSettingsLayout, LoginPage, HomePage,
  UserGroupListPage, AdminGroupListPage, GroupCreatePage, GroupEditPage, SegmentListPage, SegmentPage, FieldsPage,
  UsersPage, UserCreatePage, UserEditPage, GroupHomePage, EventsPage, NewsFeedPage, OutcomesPage, EventPage,
  EventCreatePage, EventEditPage, GroupMessagePage, GroupMessageCreatePage, GroupMessageEditPage, OutcomeCreatePage,
  OutcomeEditPage, GroupMemberListPage, GroupMemberCreatePage, NotFoundPage, PlaceholderPage, GroupDashboardPage,
  UserDashboardPage, MetricsDashboardListPage, MetricsDashboardCreatePage, MetricsDashboardEditPage, MetricsDashboardPage,
  CustomGraphCreatePage, CustomGraphEditPage, GroupManageLayout, GroupSettingsPage, CustomTextEditPage,
  UserNewsLinkPage, UserEventsPage, FoldersPage, FolderCreatePage, FolderEditPage, FolderPage, ResourceCreatePage,
  ResourceEditPage, UserProfilePage, InnovateLayout, EnterpriseConfigurationPage,
  MentorshipProfilePage, MentorshipEditProfilePage, MentorshipLayout, MentorsPage,
};
