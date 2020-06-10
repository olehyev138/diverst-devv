import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { useLocation } from 'react-router-dom';

import { matchPath } from 'react-router';
import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import { ROUTES } from 'containers/Shared/Routes/constants';

import BrandingLinks from 'components/Branding/BrandingLinks';
import { renderChildrenWithProps } from 'utils/componentHelpers';

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

const BrandingLayout = (props) => {
  const { classes, children, currentGroup, ...rest } = props;

  const location = useLocation();

  let currentPage;
  if (matchPath(location.pathname, { path: ROUTES.admin.system.branding.theme.path() }))
    currentPage = 'theme';
  else if (matchPath(location.pathname, { path: ROUTES.admin.system.branding.home.path() }))
    currentPage = 'home';
  else if (matchPath(location.pathname, { path: ROUTES.admin.system.branding.sponsors.index.path() }))
    currentPage = 'sponsors';
  else if (matchPath(location.pathname, { path: ROUTES.admin.system.branding.index.path() }))
    currentPage = 'theme';

  const [tab, setTab] = useState(BrandingPages[currentPage]);

  useEffect(() => {
    if (tab !== BrandingPages[currentPage])
      setTab(BrandingPages[currentPage]);
  }, [currentPage]);

  return (
    <React.Fragment>
      <BrandingLinks
        currentTab={tab}
        {...rest}
      />
      <Fade in appear>
        <div className={classes.content}>
          {renderChildrenWithProps(children, { ...rest })}
        </div>
      </Fade>
    </React.Fragment>
  );
};

BrandingLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  currentGroup: PropTypes.object,
  pageTitle: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(BrandingLayout);
