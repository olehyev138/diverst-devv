import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from '../reducer';
import saga from '../saga';
import { selectIsCommitting } from '../selectors';

import {
  createUserRoleBegin,
  getUserRolesBegin, userRoleUnmount
} from '../actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import UserRoleForm from 'components/User/UserRole/UserRoleForm';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/User/UserRole/messages';

export function UserRoleCreatePage(props) {
  useInjectReducer({ key: 'roles', reducer });
  useInjectSaga({ key: 'roles', saga });

  useEffect(() => () => props.userRoleUnmount(), []);

  const rs = new RouteService(useContext);
  const links = {
    userRolesIndex: ROUTES.admin.system.users.roles.index.path(),
  };

  return (
    <UserRoleForm
      admin
      userRoleAction={props.createUserRoleBegin}
      buttonText={<DiverstFormattedMessage {...messages.create} />}
      getUserRolesBegin={props.getUserRolesBegin}
      selectUserRoles={props.userRoles}
      links={links}
      isCommitting={props.isCommitting}
    />
  );
}

UserRoleCreatePage.propTypes = {
  createUserRoleBegin: PropTypes.func,
  getUserRolesBegin: PropTypes.func,
  userRoleUnmount: PropTypes.func,
  userRoles: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createUserRoleBegin,
  getUserRolesBegin,
  userRoleUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UserRoleCreatePage);
