import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectReducer } from 'utils/injectReducer';
import { useInjectSaga } from 'utils/injectSaga';

import reducer from 'containers/Analyze/reducer';
import groupReducer from 'containers/Group/reducer';
import groupSaga from 'containers/Group/saga';

import { metricsUnmount } from 'containers/Analyze/actions';
import { getGroupsBegin } from 'containers/Group/actions';
import { selectPaginatedSelectGroups } from 'containers/Group/selectors';

import { Grid, Card, CardContent } from '@material-ui/core';

import GroupDashboardLinks from 'components/Analyze/Dashboards/GroupDashboard/GroupDashboardLinks';
import GroupScopeSelect from 'components/Analyze/Shared/GroupScopeSelect';

// Sub dashboards
import OverviewDashboard from 'components/Analyze/Dashboards/GroupDashboard/OverviewDashboard';
import SocialMediaDashboard from 'components/Analyze/Dashboards/GroupDashboard/SocialMediaDashboard';
import ResourcesDashboard from 'components/Analyze/Dashboards/GroupDashboard/ResourcesDashboard';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

const Dashboards = Object.freeze({
  overview: 0,
  events: 1,
  social: 2,
  resources: 3,
});

export function GroupDashboardPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });

  /**
   * GroupDashboard supports group filtering/scoping as a `dashboard filter`
   *  - Renders a `group scope select`, builds a `filter object` & passes it down to the
   *    graphs for filtering.
   *
   *  - See metricsHelpers for details on filtering
   */

  const [currentDashboard, setCurrentDashboard] = useState(Dashboards.overview);

  /* Filter by default on only parent groups */
  const [dashboardFilters, setDashboardFilters] = useState({
    parent_scope: { value: null, key: 'parent_id', op: '==' },
    group_scope: null
  });

  /* Callback function for GroupScopeSelect
   *   - builds single filter object out of selected group names
   */
  const updateScope = (scope) => {
    /* If scope groups is set & not 0, apply new filters */
    if (scope.groups && scope.groups.length !== 0)
      /* If scope groups is == 1, filter groups with scoped group as parent */
      if (scope.groups.length === 1)
        setDashboardFilters({
          parent_scope: { value: scope.groups[0].value, key: 'parent_id', op: '==' }
        });
      else
      /* If scope groups is > 1, filter on selected groups */
        setDashboardFilters({
          group_scope: { value: scope.groups.map(g => g.label), key: 'name', op: 'in' }
        });
    /* If scope groups is not set, set filters back to default */
    else
      setDashboardFilters({
        parent_scope: { value: null, key: 'parent_id', op: '==' },
        group_scope: null
      });
  };

  const handleDashboardChange = (_, newDashboard) => {
    setCurrentDashboard(newDashboard);
  };

  useEffect(() => () => () => metricsUnmount(), []);

  const dashboards = [
    <OverviewDashboard dashboardFilters={Object.values(dashboardFilters)} />,
    <SocialMediaDashboard dashboardFilters={Object.values(dashboardFilters)} />,
    <ResourcesDashboard dashboardFilters={Object.values(dashboardFilters)} />
  ];

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item xs={12}>
          <GroupDashboardLinks
            currentDashboard={currentDashboard}
            handleDashboardChange={handleDashboardChange}
          />
        </Grid>
        <Grid item xs={12}>
          <GroupScopeSelect
            groups={props.groups}
            getGroupsBegin={props.getGroupsBegin}
            updateScope={updateScope}
          />
        </Grid>
      </Grid>
      { dashboards[currentDashboard] }
    </React.Fragment>
  );
}

GroupDashboardPage.propTypes = {
  groups: PropTypes.array,
  getGroupsBegin: PropTypes.func,
  metricsUnmount: PropTypes.func,
  permissions: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getGroupsBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  GroupDashboardPage,
  ['permissions.metrics_overview'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.analyze.dashboards.groupPage
));
