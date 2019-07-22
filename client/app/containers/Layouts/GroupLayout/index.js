import React, { memo } from 'react';
import { Route } from 'react-router';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import { withStyles } from '@material-ui/core/styles';

import GroupPage from 'containers/Group/GroupPage';
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

  /* Wraps a child component in GroupPage
   *   - GroupPage will be wrapped around every container in the group section
   *   - Connects to store & handles general current group state, such as current group object, layout
   *   - Doesnt cause problems like AuthenticatedLayout for whatever reason. Likely because the layouts use 'render props'
   */

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
              <GroupPage {...other}>
                <Component {...other} />
              </GroupPage>
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
