import React, { memo, useEffect } from 'react';
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

import { ROUTES } from 'containers/Shared/Routes/constants';

import UserRoleForm from 'components/User/UserRole/UserRoleForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/User/UserRole/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';
import { selectPermissions } from 'containers/Shared/App/selectors';

export function UserRoleCreatePage(props) {
  useInjectReducer({ key: 'roles', reducer });
  useInjectSaga({ key: 'roles', saga });

  useEffect(() => () => props.userRoleUnmount(), []);

  const { intl } = props;

  const links = {
    userRolesIndex: ROUTES.admin.system.users.roles.index.path(),
  };

  return (
    <UserRoleForm
      admin
      userRoleAction={props.createUserRoleBegin}
      buttonText={intl.formatMessage(messages.create)}
      getUserRolesBegin={props.getUserRolesBegin}
      selectUserRoles={props.userRoles}
      links={links}
      isCommitting={props.isCommitting}
    />
  );
}

UserRoleCreatePage.propTypes = {
  intl: intlShape,
  createUserRoleBegin: PropTypes.func,
  getUserRolesBegin: PropTypes.func,
  userRoleUnmount: PropTypes.func,
  userRoles: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  permissions: selectPermissions(),
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  UserRoleCreatePage,
  ['permissions.policy_templates_create'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.user.userRole.createPage
));
