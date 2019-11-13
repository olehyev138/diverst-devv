import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import Box from '@material-ui/core/Box';
import { withStyles } from '@material-ui/core/styles';

import AdminLayout from '../AdminLayout';
import InnovateLinks from 'components/Innovate/InnovateLinks';

const styles = theme => ({});

const InnovatePages = Object.freeze({
  campaigns: 0,
  financials: 1
});

const InnovateLayout = ({ component: Component, ...rest }) => {
  const { classes, data, location, ...other } = rest;

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPagePath = location.pathname.split('/').pop();

  const [tab, setTab] = useState(InnovatePages[currentPagePath]);

  useEffect(() => {
    setTab(InnovatePages[currentPagePath]);
  }, [currentPagePath]);

  return (
    <AdminLayout
      {...other}
      component={matchProps => (
        <React.Fragment>
          <InnovateLinks
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

InnovateLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  location: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(InnovateLayout);
