import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import GroupManageLinks from 'components/Group/GroupManage/GroupManageLinks';
import GroupLayout from 'containers/Layouts/GroupLayout';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const ManagePages = Object.freeze({
  settings: 0,
  leaders: 1
});

const GroupManageLayout = ({ component: Component, classes, ...rest }) => {
  const { currentGroup, location, computedMatch, ...other } = rest;

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPage = Object.keys(ManagePages).find(page => location.pathname.includes(page));

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPagePath = location.pathname.split('/').pop();

  const [tab, setTab] = useState(ManagePages[currentPagePath]);

  useEffect(() => {
    if (tab !== ManagePages[currentPage])
      setTab(ManagePages[currentPage]);
  }, [currentPage]);

  return (
    <React.Fragment>
      <GroupLayout
        {...rest}
        component={matchProps => (
          <React.Fragment>
            <GroupManageLinks
              currentTab={tab}
              {...rest}
              {...matchProps}
            />
            <Fade in appear>
              <div className={classes.content}>
                <Component {...rest} {...matchProps} />
              </div>
            </Fade>
          </React.Fragment>
        )}
      />
    </React.Fragment>
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
