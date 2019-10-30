import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import GroupManageLinks from 'components/Group/GroupManage/GroupManageLinks';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const ManagePages = Object.freeze({
  settings: 0,
  leaders: 1
});

const GroupManageLayout = ({ component: Component, classes, ...rest }) => {
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
      <GroupManageLinks
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

GroupManageLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(GroupManageLayout);
