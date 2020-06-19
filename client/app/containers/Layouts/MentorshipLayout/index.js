import React, { memo, useEffect } from 'react';
import { compose } from 'redux';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import { createStructuredSelector } from 'reselect';
import dig from 'object-dig';
import { useLocation, useParams } from 'react-router-dom';

import { CardContent, Grid } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Mentorship/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Mentorship/saga';

import { getUserBegin, userUnmount } from 'containers/Mentorship/actions';

import {
  selectEnterprise,
  selectUser as selectUserSession
} from 'containers/Shared/App/selectors';

import { selectFormUser, selectUser } from 'containers/Mentorship/selectors';

import MentorshipMenu from 'components/Mentorship/MentorshipMenu/Loadable';
import Conditional from 'components/Compositions/Conditional';

import permissionMessages from 'containers/Shared/Permissions/messages';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { customTexts } from 'utils/customTextHelpers';
import { renderChildrenWithProps } from 'utils/componentHelpers';
import { findTitleForPath } from 'utils/routeHelpers';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const MentorshipLayout = (props) => {
  const { classes, user, formUser, ...rest } = props;

  useInjectReducer({ key: 'mentorship', reducer });
  useInjectSaga({ key: 'mentorship', saga });

  /* - currentGroup will be wrapped around every container in the group section
   * - Connects to store & handles general current group state, such as current group object, layout
   */

  const location = useLocation();
  const { user_id: userId } = useParams();

  // eslint-disable-next-line comma-spacing
  const [pageTitle,] = findTitleForPath({
    path: location.pathname,
    textArguments: customTexts(),
  });

  useEffect(() => {
    const userId1 = userId || null;
    const userId2 = dig(rest, 'userSession', 'user_id');

    // const userId = userId1;
    const userId = userId1 || userId2;

    if (userId && dig(rest, 'user', 'id') !== userId)
      rest.getUserBegin({ id: userId });

    return () => {
      rest.userUnmount();
    };
  }, [dig(rest, 'userSession', 'user_id')]);

  return (
    <React.Fragment>
      {user && (
        <Grid container>
          <Grid item xs={3}>
            <CardContent>
              {user && (
                <MentorshipMenu
                  user={user}
                  userSession={dig(rest, 'userSession')}
                />
              )}
            </CardContent>
          </Grid>
          <Grid item xs={9}>
            {user && (
              <CardContent>
                {renderChildrenWithProps(props.children, { user, formUser, pageTitle, ...rest })}
              </CardContent>
            )}
          </Grid>
        </Grid>
      )}
    </React.Fragment>
  );
};

MentorshipLayout.propTypes = {
  children: PropTypes.any,
  userSession: PropTypes.object,
  user: PropTypes.object,
  formUser: PropTypes.object,
  classes: PropTypes.object,
  pageTitle: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  userSession: selectUserSession(),
  user: selectUser(),
  formUser: selectFormUser(),
  enterprise: selectEnterprise(),
});

const mapDispatchToProps = {
  getUserBegin,
  userUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export const StyledUserLayout = withStyles(styles)(MentorshipLayout);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(Conditional(
  MentorshipLayout,
  ['enterprise.mentorship_module_enabled', '!enterprise'],
  (props, params) => ROUTES.user.root.path(),
  permissionMessages.layouts.mentorship,
));
