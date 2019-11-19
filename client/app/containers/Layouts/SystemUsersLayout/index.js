import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import AdminLayout from '../AdminLayout';
import SystemUsersLinks from 'components/User/SystemUsersLinks';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const SystemUsersPages = Object.freeze({
  users: 0,
  roles: 1
});

const SystemUsersLayout = ({ component: Component, classes, ...rest }) => {
  const { currentGroup, location, ...other } = rest;

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPagePath = location.pathname.split('/').pop();
  const [tab, setTab] = useState(SystemUsersPages[currentPagePath]);

  useEffect(() => {
    if (tab !== SystemUsersPages[currentPagePath])
      setTab(SystemUsersPages[currentPagePath]);
  }, [currentPagePath]);

  return (
    <AdminLayout
      {...other}
      component={matchProps => (
        <React.Fragment>
          <SystemUsersLinks
            currentTab={tab}
            {...rest}
          />
          <Fade in appear>
            <div className={classes.content}>
              <Component {...other} />
            </div>
          </Fade>
        </React.Fragment>
      )}
    />
  );
};

SystemUsersLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(SystemUsersLayout);
