import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import reducer from '../reducer';
import saga from '../saga';

import {
  getUserRoleBegin, getUserRolesBegin,
  updateUserRoleBegin, userRoleUnmount
} from '../actions';
import {
  selectFormUserRole, selectIsCommitting, selectIsFormLoading
} from '../selectors';

import UserRoleForm from 'components/User/UserRole/UserRoleForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/User/UserRole/messages';
import Conditional from 'components/Compositions/Conditional';
import { UserRoleListPage } from 'containers/User/UserRole/UserRoleListPage';

export function UserRoleEditPage(props) {
  useInjectReducer({ key: 'roles', reducer });
  useInjectSaga({ key: 'roles', saga });

  const rs = new RouteService(useContext);
  const links = {
    userRolesIndex: ROUTES.admin.system.users.roles.index.path(),
  };
  const { intl } = props;
  useEffect(() => {
    props.getUserRoleBegin({ id: rs.params('role_id') });

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
  intl: intlShape,
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
  (props, rs) => ROUTES.admin.system.users.roles.index.path(),
  'user.userRole.editPage'
));
