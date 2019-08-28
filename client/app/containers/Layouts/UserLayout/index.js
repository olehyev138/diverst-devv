import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import UserLinks from 'components/User/UserLinks';
import { withStyles } from '@material-ui/core/styles';
import AuthenticatedLayout from '../AuthenticatedLayout';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const UserLayout = ({ component: Component, ...rest }) => {
  const { classes, data, ...other } = rest;

  return (
    <AuthenticatedLayout
      position='absolute'
      data={data}
      {...other}
      component={matchProps => (
        <React.Fragment>
          <div className={classes.toolbar} />
          <UserLinks pageTitle={data.titleMessage} {...matchProps} />
          <Container>
            <div className={classes.content}>
              <Component pageTitle={data.titleMessage} {...other} />
            </div>
          </Container>
        </React.Fragment>
      )}
    />
  );
};

UserLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
};

export const StyledUserLayout = withStyles(styles)(UserLayout);

export default compose(
  memo,
  withStyles(styles),
)(UserLayout);
