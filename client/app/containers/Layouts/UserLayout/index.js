import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import UserLinks from 'components/User/UserLinks';
import { withStyles } from '@material-ui/core/styles';
import AuthenticatedLayout from '../AuthenticatedLayout';

import Scrollbar from 'components/Shared/Scrollbar';

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
      position='relative'
      data={data}
      {...other}
      component={matchProps => (
        <div>
          <UserLinks pageTitle={data.titleMessage} {...matchProps} />
          <Scrollbar>
            <Container>
              <div className={classes.content}>
                <Component pageTitle={data.titleMessage} {...other} />
              </div>
            </Container>
          </Scrollbar>
        </div>
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
