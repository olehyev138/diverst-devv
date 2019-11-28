import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { matchPath } from 'react-router';
import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import { ROUTES } from 'containers/Shared/Routes/constants';

import AdminLayout from '../AdminLayout';
import BrandingLinks from 'components/Branding/BrandingLinks';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const BrandingPages = Object.freeze({
  theme: 0,
  home: 1,
  sponsors: 2
});

const BrandingLayout = ({ component: Component, classes, ...rest }) => {
  const { currentGroup, location, ...other } = rest;

  let currentPage;
  if (matchPath(location.pathname, { path: ROUTES.admin.system.branding.theme.path() }))
    currentPage = 'theme';
  else if (matchPath(location.pathname, { path: ROUTES.admin.system.branding.home.path() }))
    currentPage = 'home';
  else if (matchPath(location.pathname, { path: ROUTES.admin.system.branding.sponsors.index.path() }))
    currentPage = 'sponsors';

  const [tab, setTab] = useState(BrandingPages[currentPage]);

  useEffect(() => {
    if (tab !== BrandingPages[currentPage])
      setTab(BrandingPages[currentPage]);
  }, [currentPage]);

  return (
    <AdminLayout
      {...other}
      component={matchProps => (
        <React.Fragment>
          <BrandingLinks
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

BrandingLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(BrandingLayout);
