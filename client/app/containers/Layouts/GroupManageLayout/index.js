import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

import GroupLayout from '../GroupLayout';
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

const GroupManageLayout = ({ component: Component, ...rest }) => {
  const { classes, data, computedMatch, location, ...other } = rest;

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPagePath = location.pathname.split('/').pop();

  const [tab, setTab] = useState(ManagePages[currentPagePath]);

  useEffect(() => {
    setTab(ManagePages[currentPagePath]);
  }, [currentPagePath]);

  return (
    <GroupLayout
      {...rest}
      component={matchProps => (
        <React.Fragment>
          <GroupManageLinks
            currentTab={tab}
            {...matchProps}
          />
          <div className={classes.content}>
            <Component currentGroup={matchProps.currentGroup} {...other} />
          </div>
        </React.Fragment>
      )}
    />
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
