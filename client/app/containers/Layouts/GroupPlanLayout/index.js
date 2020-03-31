import React, { memo, useContext, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import GroupPlanLinks from 'components/Group/GroupPlan/GroupPlanLinks';
import GroupLayout from '../GroupLayout';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { push } from 'connected-react-router';
import RouteService from 'utils/routeHelpers';
import { permission } from 'utils/permissionsHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const PlanPages = Object.freeze([
  'events',
  'kpi',
  'updates',
  'budgeting',
]);

const getPageTab = (currentPagePath) => {
  if (PlanPages[currentPagePath] !== undefined)
    return PlanPages[currentPagePath];

  return false;
};

const redirectAction = path => push(path);

const GroupPlanLayout = ({ component: Component, classes, ...rest }) => {
  const { location, defaultPage, redirectAction, showSnackbar, computedMatch, ...other } = rest;

  /* Get last element of current path, ie: '/group/:id/plan/outcomes -> outcomes */
  let currentPage = PlanPages.find(page => location.pathname.includes(page));
  if (!currentPage && location.pathname.includes('outcomes'))
    currentPage = 'events';

  const [tab, setTab] = useState(currentPage);

  useEffect(() => {
    if (rest.currentGroup && defaultPage) {
      const rs = new RouteService({ computedMatch, location });

      if (permission(rest.currentGroup, 'kpi_manage?'))
        redirectAction(ROUTES.group.plan.kpi.updates.index.path(rs.params('group_id')));
      else if (permission(rest.currentGroup, 'annual_budgets_view?')
        || permission(rest.currentGroup, 'budgets_create?')
        || permission(rest.currentGroup, 'annual_budgets_index?'))
        redirectAction(ROUTES.group.plan.budget.index.path(rs.params('group_id')));
      else if (permission(rest.currentGroup, 'events_manage?'))
        redirectAction(ROUTES.group.plan.events.index.path(rs.params('group_id')));
      else {
        showSnackbar({ message: 'You do not have permission to see this page', options: { variant: 'warning' } });
        redirectAction(ROUTES.group.home.path(rs.params('group_id')));
      }
    }

    if (tab !== currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <React.Fragment>
      <GroupLayout
        {...rest}
        component={matchProps => (
          <React.Fragment>
            <GroupPlanLinks
              currentTab={tab}
              {...rest}
              {...matchProps}
            />
            <Fade in appear>
              <div className={classes.content}>
                { Component ? <Component {...rest} {...matchProps} /> : <React.Fragment /> }
              </div>
            </Fade>
          </React.Fragment>
        )}
      />
    </React.Fragment>
  );
};

GroupPlanLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
};

const mapDispatchToProps = {
  redirectAction,
  showSnackbar,
};

const withConnect = connect(
  createStructuredSelector({}),
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(GroupPlanLayout);
