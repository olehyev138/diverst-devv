import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';

import GroupPlanLayout from '..';
import BudgetLinks from 'components/Group/GroupPlan/BudgetLinks';

const styles = theme => ({});

const BudgetPages = Object.freeze([
  'overview',
  'annual_budget',
]);

const BudgetLayout = ({ component: Component, ...rest }) => {
  const { classes, data, location, ...other } = rest;

  /* Get get first key that is in the path, ie: '/admin/system/settings/budgets/1/edit/ -> budgets */
  const currentPage = BudgetPages.find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(currentPage);

  useEffect(() => {
    if (tab !== currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <GroupPlanLayout
      {...rest}
      component={matchProps => (
        <React.Fragment>
          <BudgetLinks
            currentTab={tab}
            {...matchProps}
          />
          <Box mb={3} />
          <Fade in appear>
            <div>
              <Component {...other} />
            </div>
          </Fade>
        </React.Fragment>
      )}
    />
  );
};

BudgetLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  location: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(BudgetLayout);
