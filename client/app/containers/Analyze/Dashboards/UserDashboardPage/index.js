import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectReducer } from 'utils/injectReducer';
import { useInjectSaga } from 'utils/injectSaga';

import reducer from 'containers/Analyze/reducer';
import { metricsUnmount } from 'containers/Analyze/actions';

import { Grid, Card, CardContent } from '@material-ui/core';

import UserDashboard from 'components/Analyze/Dashboards/UserDashboard';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function UserDashboardPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useEffect(() => () => () => metricsUnmount(), []);

  return (
    <React.Fragment>
      <UserDashboard />
    </React.Fragment>
  );
}

UserDashboardPage.propTypes = {
  Users: PropTypes.array,
  getUsersBegin: PropTypes.func,
  metricsUnmount: PropTypes.func,
  permissions: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  UserDashboardPage,
  ['permissions.metrics_overview'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.analyze.dashboards.userPage
));
