import React, { memo, useContext, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import GroupPlanLinks from 'components/Group/GroupPlan/GroupPlanLinks';
import GroupLayout from '../GroupLayout';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const PlanPages = Object.freeze({
  events: 0,
  kpi: 1,
  updates: 2,
  budgeting: 3,
});

const getPageTab = (currentPagePath) => {
  if (PlanPages[currentPagePath] !== undefined)
    return PlanPages[currentPagePath];

  return false;
};

const GroupPlanLayout = ({ component: Component, classes, ...rest }) => {
  const { location, ...other } = rest;

  /* Get last element of current path, ie: '/group/:id/plan/outcomes -> outcomes */
  let currentPage = Object.keys(PlanPages).find(page => location.pathname.includes(page));
  if (!currentPage && location.pathname.includes('outcomes'))
    currentPage = 'events';

  const [tab, setTab] = useState(PlanPages[currentPage]);

  useEffect(() => {
    if (tab !== PlanPages[currentPage])
      setTab(PlanPages[currentPage]);
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
                <Component {...rest} {...matchProps} />
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

export default compose(
  memo,
  withStyles(styles),
)(GroupPlanLayout);
