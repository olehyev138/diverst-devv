import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import Box from '@material-ui/core/Box';
import { withStyles } from '@material-ui/core/styles';

import AdminLayout from '../AdminLayout';
import GlobalSettingsLinks from 'components/GlobalSettings/GlobalSettingsLinks';

const styles = theme => ({});

const GlobalSettingsPages = Object.freeze({
  fields: 0,
  custom_texts: 1
});

const GlobalSettingsLayout = ({ component: Component, ...rest }) => {
  const { classes, data, location, ...other } = rest;

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPagePath = location.pathname.split('/').pop();

  const [tab, setTab] = useState(GlobalSettingsPages[currentPagePath]);

  useEffect(() => {
    setTab(GlobalSettingsPages[currentPagePath]);
  }, [currentPagePath]);

  return (
    <AdminLayout
      {...other}
      component={matchProps => (
        <React.Fragment>
          <GlobalSettingsLinks
            currentTab={tab}
            {...matchProps}
          />
          <Box mb={3} />
          <Component {...other} />
        </React.Fragment>
      )}
    />
  );
};

GlobalSettingsLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  location: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(GlobalSettingsLayout);
