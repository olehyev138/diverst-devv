import React, { memo } from 'react';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import { withStyles } from '@material-ui/core/styles';
import AdminLayout from '../AdminLayout';
import GlobalSettingsLinks from 'components/GlobalSettings/GlobalSettingsLinks';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const GlobalSettingsLayout = ({ component: Component, ...rest }) => {
  const { classes, data, ...other } = rest;

  return (
    <AdminLayout
      {...other}
      component={matchProps => (
        <React.Fragment>
          <GlobalSettingsLinks {...matchProps} />
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

GlobalSettingsLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
};

export default withStyles(styles)(GlobalSettingsLayout);
