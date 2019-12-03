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

const ManagePages = Object.freeze({
  outcomes: 0,
  kpi: 1,
  updates: 2,
  budgeting: 3,
});

const GroupPlanLayout = ({ component: Component, classes, ...rest }) => {
  const { currentGroup, location, ...other } = rest;

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPagePath = location.pathname.split('/').pop();

  const [tab, setTab] = useState(ManagePages[currentPagePath]);

  useEffect(() => {
    if (tab !== ManagePages[currentPagePath])
      setTab(ManagePages[currentPagePath]);
  }, [currentPagePath]);

  return (
    <React.Fragment>
      <GroupPlanLinks
        currentTab={tab}
        {...rest}
      />
      <Fade in appear>
        <div className={classes.content}>
          <Component currentGroup={currentGroup} {...other} />
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
