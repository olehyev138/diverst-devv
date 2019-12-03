import React, { memo, useEffect } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import UserLinks from 'components/User/UserLinks';
import { withStyles } from '@material-ui/core/styles';
import AuthenticatedLayout from '../AuthenticatedLayout';

import Scrollbar from 'components/Shared/Scrollbar';
import UserLayout from '../UserLayout';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Mentorship/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Mentorship/saga';
import RouteService from 'utils/routeHelpers';
import dig from 'object-dig';

import { getUserBegin, userUnmount } from 'containers/Mentorship/actions';

import { selectMentoringInterests, selectUser as selectGlobalUser } from 'containers/Shared/App/selectors';
import { selectFormUser, selectUser } from 'containers/Mentorship/selectors';
import { createStructuredSelector } from 'reselect';
import { connect } from 'react-redux';
import { CardContent, Grid } from '@material-ui/core';
import MentorshipMenu from 'components/Mentorship/MentorshipMenu';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const MentorshipLayout = ({ component: Component, ...rest }) => {
  useInjectReducer({ key: 'mentorship', reducer });
  useInjectSaga({ key: 'mentorship', saga });

  const {
    classes, data, computedMatch, user, location, disableBreadcrumbs, ...other
  } = rest;

  /* - currentGroup will be wrapped around every container in the group section
   * - Connects to store & handles general current group state, such as current group object, layout
   */

  const rs = new RouteService({ computedMatch, location });

  useEffect(() => {
    const [userId1] = rs.params('user_id');
    const userId2 = dig(rest, 'globalUser', 'id');

    // const userId = userId1;
    const userId = userId1 || userId2;

    if (userId && dig(rest, 'user', 'id') !== userId)
      other.getUserBegin({ id: userId });

    return () => {
      other.userUnmount();
    };
  }, [dig(rest, 'globalUser', 'id')]);

  return (
    <UserLayout
      disableBreadcrumbs={disableBreadcrumbs}
      data={data}
      user={rest.user}
      {...other}
      component={matchProps => (
        <React.Fragment>
          {user && (
            <Grid container>
              <Grid item xs={3}>
                <CardContent>
                  {user && (
                    <MentorshipMenu
                      user={user}
                      globalUser={dig(rest, 'globalUser')}
                    />
                  )}
                </CardContent>
              </Grid>
              <Grid item xs={9}>
                {user && (
                  <CardContent>
                    <Component user={user} formUser={rest.formUser} pageTitle={data.titleMessage} {...rest} />
                  </CardContent>
                )}
              </Grid>
            </Grid>
          )}
        </React.Fragment>
      )}
    />
  );
};

MentorshipLayout.propTypes = {
  globalUser: PropTypes.object,
  user: PropTypes.object,
  formUser: PropTypes.object,
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  globalUser: selectGlobalUser(),
  user: selectUser(),
  formUser: selectFormUser(),
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
)(MentorshipLayout);
