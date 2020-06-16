import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { useLocation, matchPath } from 'react-router-dom';
import { push } from 'connected-react-router';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import { ROUTES } from 'containers/Shared/Routes/constants';

import BrandingLinks from 'components/Branding/BrandingLinks';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const BrandingPages = Object.freeze([
  'theme',
  'home',
  'sponsors',
]);

const redirectAction = path => push(path);

const BrandingLayout = (props) => {
  const { classes, children, redirectAction, ...rest } = props;

  const location = useLocation();

  const currentPage = BrandingPages.find(page => location.pathname.includes(page));

  const [tab, setTab] = useState(currentPage || BrandingPages[0]);

  useEffect(() => {
    if (matchPath(location.pathname, { path: ROUTES.admin.system.branding.index.path(), exact: true }))
      redirectAction(ROUTES.admin.system.branding.theme.path());

    if (tab !== currentPage && currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <React.Fragment>
      <BrandingLinks
        currentTab={tab}
        {...rest}
      />
      <Fade in appear>
        <div className={classes.content}>
          {children}
        </div>
      </Fade>
    </React.Fragment>
  );
};

BrandingLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  pageTitle: PropTypes.object,
  redirectAction: PropTypes.func,
};

const mapDispatchToProps = {
  redirectAction,
};

const withConnect = connect(
  undefined,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(BrandingLayout);
