import React, {memo, useEffect, useState} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import { withStyles } from '@material-ui/core/styles';
import RouteService from 'utils/routeHelpers';

import GroupLayout from '../GroupLayout';
import GroupManageLinks from 'components/Group/GroupManage/GroupManageLinks';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const ManagePages = Object.freeze({
  settings: 0,
  leaders: 1
});

const GroupManageLayout = ({ component: Component, ...rest }) => {
  const { classes, data, computedMatch, location, ...other } = rest;
  const [tab, setTab] = useState(ManagePages.settings);

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPagePath = location.pathname.split('/').pop();

  useEffect(() => {
    setTab(ManagePages[currentPagePath]);
  }, [currentPagePath]);

  return (
    <GroupLayout
      {...rest}
      component={matchProps => (
        <React.Fragment>
          <GroupManageLinks
            currentTab={tab}
            {...matchProps}
          />
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

GroupManageLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(GroupManageLayout);
