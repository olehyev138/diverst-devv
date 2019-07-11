import React, { memo } from 'react';
import { Route } from 'react-router';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import { withStyles } from '@material-ui/core/styles';

import GroupLinks from 'components/Group/GroupLinks';
import AuthenticatedLayout from '../AuthenticatedLayout';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const GroupLayout = ({ component: Component, ...rest }) => {
  const { classes, ...other } = rest;

  return (
    <AuthenticatedLayout
      position='absolute'
      {...other}
      component={matchProps => (
        <React.Fragment>
          <div className={classes.toolbar} />
          <GroupLinks {...matchProps} />

          <Container>
            <div className={classes.content}>
              <Component {...other} />
            </div>
          </Container>
        </React.Fragment>
      )}
    />
  );
};

GroupLayout.propTypes = {
  component: PropTypes.elementType,
  classes: PropTypes.object,
};

export default withStyles(styles)(GroupLayout);
