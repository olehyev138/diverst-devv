import React from 'react';
import { Switch } from 'react-router';
import PropTypes from 'prop-types';

// Layouts
import UserLayout from 'containers/Layouts/UserLayout/index';
import GroupLayout from 'containers/Layouts/GroupLayout/index';
import AdminLayout from 'containers/Layouts/AdminLayout/index';
import SessionLayout from 'containers/Layouts/SessionLayout/index';
import ErrorLayout from 'containers/Layouts/ErrorLayout/index';

// Pages
import {
  HomePage, LoginPage, NotFoundPage, PlaceholderPage
} from 'containers/Shared/Routes/templates';

/* Admin - Manage - Group */
import UserGroupListPage from 'containers/Group/UserGroupListPage';
import AdminGroupListPage from 'containers/Group/AdminGroupListPage';
import GroupCreatePage from 'containers/Group/GroupCreatePage';
import GroupEditPage from 'containers/Group/GroupEditPage';

/* Group */
import GroupHomePage from 'containers/Group/GroupHomePage';
import EventsPage from 'containers/Event/EventsPage';
import NewsFeedPage from 'containers/News/NewsFeedPage';
import OutcomesPage from 'containers/Group/Outcome/OutcomesPage';

/* Group - Events */
import EventPage from 'containers/Event/EventPage';
import EventCreatePage from 'containers/Event/EventCreatePage';
import EventEditPage from 'containers/Event/EventEditPage';

/* Group - News Feed */
import GroupMessagePage from 'containers/News/GroupMessage/GroupMessagePage';
import GroupMessageCreatePage from 'containers/News/GroupMessage/GroupMessageCreatePage';
import GroupMessageEditPage from 'containers/News/GroupMessage/GroupMessageEditPage';

/* Group - Outcomes */
import OutcomeCreatePage from 'containers/Group/Outcome/OutcomeCreatePage';
import OutcomeEditPage from 'containers/Group/Outcome/OutcomeEditPage';

// Paths
import { ROUTES } from 'containers/Shared/Routes/constants';

export default function Routes(props) {
  const expandRoute = route => ({ path: route.path(), data: route.data || {} });

  return (
    <Switch>
      <SessionLayout {...expandRoute(ROUTES.session.login)} component={LoginPage} />

      { /* Admin */ }
      { /* Admin - Analyze */ }
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.overview)} component={PlaceholderPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.users)} component={PlaceholderPage} />

      { /* Admin - Manage */ }
      { /* Admin - Manage - Groups */ }
      <AdminLayout exact {...expandRoute(ROUTES.admin.manage.groups.index)} component={AdminGroupListPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.groups.new)} component={GroupCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.groups.edit)} component={GroupEditPage} />

      <UserLayout exact {...expandRoute(ROUTES.user.home)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.innovate)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.news)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.events)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.groups)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.downloads)} component={PlaceholderPage} />
      <UserLayout {...expandRoute(ROUTES.user.mentorship)} component={PlaceholderPage} />

      { /* Group */ }
      <GroupLayout exact {...expandRoute(ROUTES.group.home)} component={GroupHomePage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.events.index)} component={EventsPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.news.index)} component={NewsFeedPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.outcomes.index)} component={OutcomesPage} />

      { /* Group Events */ }
      <GroupLayout {...expandRoute(ROUTES.group.events.new)} component={EventCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.events.edit)} component={EventEditPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.events.show)} component={EventPage} />

      { /* Group News Feed */ }
      <GroupLayout {...expandRoute(ROUTES.group.news.messages.new)} component={GroupMessageCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.messages.edit)} component={GroupMessageEditPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.news.messages.index)} component={GroupMessagePage} />

      { /* Group Outcomes */ }
      <GroupLayout {...expandRoute(ROUTES.group.outcomes.new)} component={OutcomeCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.outcomes.edit)} component={OutcomeEditPage} />

      <ErrorLayout path='' component={NotFoundPage} />
    </Switch>
  );
}
