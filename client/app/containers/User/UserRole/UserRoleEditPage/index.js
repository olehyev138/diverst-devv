import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { ROUTES } from 'containers/Shared/Routes/constants';

import reducer from '../reducer';
import saga from '../saga';

import {
  getUserRoleBegin,
  updateUserRoleBegin, userRoleUnmount
} from '../actions';
import {
  selectFormUserRole, selectIsCommitting, selectIsFormLoading
} from '../selectors';

import UserRoleForm from 'components/User/UserRole/UserRoleForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/User/UserRole/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function UserRoleEditPage(props) {
  useInjectReducer({ key: 'roles', reducer });
  useInjectSaga({ key: 'roles', saga });

  const { role_id: roleId } = useParams();
  const links = {
    userRolesIndex: ROUTES.admin.system.users.roles.index.path(),
  };
  const { intl } = props;
  useEffect(() => {
    props.getUserRoleBegin({ id: roleId });

    return () => {
      props.userRoleUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <UserRoleForm
        edit
        userRoleAction={props.updateUserRoleBegin}
        links={links}
        userRole={props.userRole}
        buttonText={intl.formatMessage(messages.update)}
        isCommitting={props.isCommitting}
        isFormLoading={props.isFormLoading}
      />
    </React.Fragment>
  );
}

UserRoleEditPage.propTypes = {
  intl: intlShape.isRequired,
  path: PropTypes.string,
  userRole: PropTypes.object,
  getUserRoleBegin: PropTypes.func,
  updateUserRoleBegin: PropTypes.func,
  userRoleUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  userRole: selectFormUserRole(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  getUserRoleBegin,
  updateUserRoleBegin,
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
  UserRoleEditPage,
  ['userRole.permissions.update?', 'isFormLoading'],
  (props, params) => ROUTES.admin.system.users.roles.index.path(),
  permissionMessages.user.userRole.editPage
));
