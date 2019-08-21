/* Layouts */
import UserLayout from 'containers/Layouts/UserLayout/Loadable';
import GroupLayout from 'containers/Layouts/GroupLayout/Loadable';
import AdminLayout from 'containers/Layouts/AdminLayout/Loadable';
import SessionLayout from 'containers/Layouts/SessionLayout/Loadable';
import ErrorLayout from 'containers/Layouts/ErrorLayout/Loadable';
import GlobalSettingsLayout from 'containers/Layouts/GlobalSettingsLayout/Loadable';


/* Session */
import LoginPage from 'containers/Session/LoginPage/Loadable';


/* User */
import HomePage from 'containers/User/HomePage/Loadable';
import UserGroupListPage from 'containers/Group/UserGroupListPage/Loadable';


/* Admin - Manage - Group */
import AdminGroupListPage from 'containers/Group/AdminGroupListPage/Loadable';
import GroupCreatePage from 'containers/Group/GroupCreatePage/Loadable';
import GroupEditPage from 'containers/Group/GroupEditPage/Loadable';

/* Admin - System - Global Settings */
import FieldsPage from 'containers/GlobalSettings/Field/FieldsPage/Loadable';

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


/* Global */
import NotFoundPage from 'containers/Shared/NotFoundPage/Loadable';
import PlaceholderPage from 'components/Shared/PlaceholderPage/Loadable';


export {
  UserLayout, GroupLayout, AdminLayout, SessionLayout, ErrorLayout, GlobalSettingsLayout, LoginPage, HomePage,
  UserGroupListPage, AdminGroupListPage, GroupCreatePage, GroupEditPage, FieldsPage, UsersPage, UserCreatePage,
  UserEditPage, GroupHomePage, EventsPage, NewsFeedPage, OutcomesPage, EventPage, EventCreatePage, EventEditPage,
  GroupMessagePage, GroupMessageCreatePage, GroupMessageEditPage, OutcomeCreatePage, OutcomeEditPage,
  GroupMemberListPage, GroupMemberCreatePage, NotFoundPage, PlaceholderPage
};
