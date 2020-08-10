import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { push } from 'connected-react-router';
import { matchPath, useLocation, useParams } from 'react-router-dom';
import PropTypes from 'prop-types';

import Fade from '@material-ui/core/Fade';
import { withStyles } from '@material-ui/core/styles';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { permission } from 'utils/permissionsHelpers';
import { renderChildrenWithProps } from 'utils/componentHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import GroupManageLinks from 'components/Group/GroupManage/GroupManageLinks';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const ManagePages = Object.freeze([
  'settings',
  'leaders',
  'sponsors'
]);

const redirectAction = path => push(path);

const GroupManageLayout = (props) => {
  const { classes, children, currentGroup, redirectAction, showSnackbar, ...rest } = props;

  const location = useLocation();
  const { group_id: groupId } = useParams();

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPage = ManagePages.find(page => location.pathname.includes(page));

  const [tab, setTab] = useState(currentPage || ManagePages[0]);

  useEffect(() => {
    if (matchPath(location.pathname, { path: ROUTES.group.manage.index.path(), exact: true }))
      if (permission(currentGroup, 'update?'))
        redirectAction(ROUTES.group.manage.settings.index.path(groupId));
      else if (permission(currentGroup, 'leaders_view?'))
        redirectAction(ROUTES.group.manage.leaders.index.path(groupId));
      else {
        showSnackbar({ message: 'You do not have permission to manage this group', options: { variant: 'warning' } });
        redirectAction(ROUTES.group.home.path(groupId));
      }

    if (tab !== currentPage && currentPage)
      setTab(currentPage);
  }, [currentPage, currentGroup]);

  return (
    <React.Fragment>
      <GroupManageLinks
        currentTab={tab}
        currentGroup={currentGroup}
        {...rest}
      />
      <Fade in appear>
        <div className={classes.content}>
          {renderChildrenWithProps(children, { currentGroup, ...rest })}
        </div>
      </Fade>
    </React.Fragment>
  );
};

GroupManageLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  currentGroup: PropTypes.object,
  redirectAction: PropTypes.func,
  showSnackbar: PropTypes.func,
};

const mapDispatchToProps = {
  redirectAction,
  showSnackbar,
};

const withConnect = connect(
  createStructuredSelector({}),
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(GroupManageLayout);
