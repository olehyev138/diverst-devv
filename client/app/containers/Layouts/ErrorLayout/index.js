import React, { memo } from 'react';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import ApplicationLayout from '../ApplicationLayout';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  container: {
    height: '100%',
  },
  content: {
    height: '100%',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
  },
});

const ErrorLayout = ({ component: Component, ...rest }) => {
  const { classes, ...other } = rest;

  return (
    <ApplicationLayout
      component={matchProps => (
        <Container maxWidth='sm' className={classes.container}>
          <div className={classes.content}>
            <Component {...other} />
          </div>
        </Container>
      )}
    />
  );
};

ErrorLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
};

export default withStyles(styles)(ErrorLayout);
