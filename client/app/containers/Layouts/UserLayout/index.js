import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import Fade from '@material-ui/core/Fade';
import UserLinks from 'components/User/UserLinks';
import { withStyles } from '@material-ui/core/styles';
import AuthenticatedLayout from '../AuthenticatedLayout';

import Scrollbar from 'components/Shared/Scrollbar';
import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const UserLayout = ({ component: Component, ...rest }) => {
  const { classes, data, disableBreadcrumbs, ...other } = rest;

  return (
    <AuthenticatedLayout
      position='relative'
      data={data}
      {...other}
      component={matchProps => (
        <React.Fragment>
          <UserLinks pageTitle={data.titleMessage} {...matchProps} />
          <Scrollbar>
            <Fade in appear>
              <Container>
                <div className={classes.content}>
                  {disableBreadcrumbs !== true ? (
                    <DiverstBreadcrumbs />
                  ) : (
                    <React.Fragment />
                  )}
                  <Component pageTitle={data.titleMessage} {...other} />
                </div>
              </Container>
            </Fade>
          </Scrollbar>
        </React.Fragment>
      )}
    />
  );
};

UserLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  disableBreadcrumbs: PropTypes.bool,
};

export const StyledUserLayout = withStyles(styles)(UserLayout);

export default compose(
  memo,
  withStyles(styles),
)(UserLayout);
