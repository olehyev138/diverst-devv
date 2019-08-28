import React, { memo } from 'react';
import { compose } from 'redux';
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
      {...other}
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

export const StyledErrorLayout = withStyles(styles)(ErrorLayout);

export default compose(
  memo,
  withStyles(styles),
)(ErrorLayout);
