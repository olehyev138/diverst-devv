import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import GroupPlanLinks from 'components/Group/GroupPlan/GroupPlanLinks';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const PlanPages = Object.freeze({
  events: 0,
  outcomes: 1,
  kpi: 2,
  updates: 3,
  budgeting: 4,
});

const GroupPlanLayout = ({ component: Component, classes, ...rest }) => {
  const { location, ...other } = rest;

  /* Get last element of current path, ie: '/group/:id/plan/outcomes -> outcomes */
  const currentPagePath = location.pathname.split('/').pop();

  const [tab, setTab] = useState(PlanPages[currentPagePath]);

  useEffect(() => {
    if (tab !== PlanPages[currentPagePath])
      setTab(PlanPages[currentPagePath]);
  }, [currentPagePath]);

  return (
    <React.Fragment>
      <GroupPlanLinks
        currentTab={tab}
        {...rest}
      />
      <Fade in appear>
        <div className={classes.content}>
          <Component {...other} />
        </div>
      </Fade>
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
