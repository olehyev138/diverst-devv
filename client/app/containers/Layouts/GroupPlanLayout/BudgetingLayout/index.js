import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { push } from 'connected-react-router';
import { matchPath, useLocation, useParams } from 'react-router-dom';
import PropTypes from 'prop-types';

import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';
import { withStyles } from '@material-ui/core/styles';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { permission } from 'utils/permissionsHelpers';
import { renderChildrenWithProps } from 'utils/componentHelpers';

import BudgetLinks from 'components/Group/GroupPlan/BudgetLinks';

const styles = theme => ({});

const BudgetPages = Object.freeze([
  'overview',
  'annual_budget',
]);

const redirectAction = path => push(path);

const BudgetLayout = (props) => {
  const { classes, children, redirectAction, showSnackbar, ...rest } = props;

  const location = useLocation();
  const { group_id: groupId } = useParams();

  /* Get get first key that is in the path, ie: '/admin/system/settings/budgets/1/edit/ -> budgets */
  const currentPage = BudgetPages.find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(currentPage);

  useEffect(() => {
    if (matchPath(location.pathname, { path: ROUTES.group.plan.budget.index.path(), exact: true }))
      if (permission(rest.currentGroup, 'annual_budgets_view?'))
        redirectAction(ROUTES.group.plan.budget.overview.path(groupId));
      else if (permission(rest.currentGroup, 'annual_budgets_manage?'))
        redirectAction(ROUTES.group.plan.budget.editAnnualBudget.path(groupId));
      else {
        showSnackbar({ message: 'You do not have permission to manage this group\'s budget', options: { variant: 'warning' } });
        redirectAction(ROUTES.group.plan.index.path(groupId));
      }

    if (tab !== currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <React.Fragment>
      <BudgetLinks
        currentTab={tab}
      />
      <Box mb={3} />
      <Fade in appear>
        <div>
          {renderChildrenWithProps(children, { ...rest })}
        </div>
      </Fade>
    </React.Fragment>
  );
};

BudgetLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  currentGroup: PropTypes.object,
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
)(BudgetLayout);
