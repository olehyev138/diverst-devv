import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { matchPath, useLocation, useParams } from 'react-router-dom';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { push } from 'connected-react-router';
import { permission } from 'utils/permissionsHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import GroupPlanLinks from 'components/Group/GroupPlan/GroupPlanLinks';

import { renderChildrenWithProps } from 'utils/componentHelpers';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const PlanPages = Object.freeze([
  'events',
  'kpi',
  'budgeting',
]);

const redirectAction = path => push(path);

const GroupPlanLayout = (props) => {
  const { classes, children, redirectAction, showSnackbar, ...rest } = props;

  const location = useLocation();
  const { group_id: groupId } = useParams();

  /* Get last element of current path, ie: '/group/:id/plan/outcomes -> outcomes */
  let currentPage = PlanPages.find(page => location.pathname.includes(page));
  if (!currentPage && location.pathname.includes('outcomes'))
    currentPage = 'events';

  const [tab, setTab] = useState(currentPage || PlanPages[0]);

  useEffect(() => {
    if (rest.currentGroup && matchPath(location.pathname, { path: ROUTES.group.plan.index.path(), exact: true }))
      if (permission(rest.currentGroup, 'kpi_manage?'))
        redirectAction(ROUTES.group.plan.kpi.updates.index.path(groupId));
      else if (permission(rest.currentGroup, 'annual_budgets_view?')
        || permission(rest.currentGroup, 'budgets_create?')
        || permission(rest.currentGroup, 'annual_budgets_index?'))
        redirectAction(ROUTES.group.plan.budget.index.path(groupId));
      else if (permission(rest.currentGroup, 'events_manage?'))
        redirectAction(ROUTES.group.plan.events.index.path(groupId));
      else {
        showSnackbar({ message: 'You do not have permission to see this page', options: { variant: 'warning' } });
        redirectAction(ROUTES.group.home.path(groupId));
      }

    if (tab !== currentPage && currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <React.Fragment>
      <GroupPlanLinks
        currentTab={tab}
        {...rest}
      />
      <Fade in appear>
        <div className={classes.content}>
          {renderChildrenWithProps(children, { ...rest })}
        </div>
      </Fade>
    </React.Fragment>
  );
};

GroupPlanLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  pageTitle: PropTypes.object,
  redirectAction: PropTypes.func,
  showSnackbar: PropTypes.func,
};

const mapDispatchToProps = {
  redirectAction,
  showSnackbar,
};

const withConnect = connect(
  undefined,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(GroupPlanLayout);
