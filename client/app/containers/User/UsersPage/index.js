/**
 *
 * UsersPage
 *
 *  - lists all enterprise custom users
 *  - renders forms for creating & editing custom users
 *
 *  - function:
 *    - get users from server
 *    - on edit - render respective form with user data
 *    - on new - render respective empty form
 *    - on save - create/update user
 */

import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { push } from 'connected-react-router';

import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  selectPaginatedUsers, selectUserTotal,
  selectIsFetchingUsers
} from 'containers/User/selectors';
import {
  getUsersBegin, userUnmount, deleteUserBegin, exportUsersBegin
} from 'containers/User/actions';

import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import UserList from 'components/User/UserList';
import Conditional from 'components/Compositions/Conditional';
import { UserEditPage } from 'containers/User/UserEditPage';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

const UserTypes = Object.freeze([
  'all',
  'inactive',
  'invitation_sent',
  'saml',
]);

export function UserListPage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });
  const [type, setType] = React.useState('all');

  const getUsers = (scope, params = params) => {
    const newParams = {
      ...params,
      query_scopes: [scope]
    };
    props.getUsersBegin(newParams);
    setParams(newParams);
  };

  const exportUsers = () => {
    props.exportUsersBegin(params);
  };

  useEffect(() => {
    getUsers('all');

    return () => {
      props.userUnmount();
    };
  }, []);

  const handleChangeScope = (newScope) => {
    if (UserTypes.includes(newScope)) {
      setType(newScope);
      getUsers(newScope, params);
    }
  };

  const rs = new RouteService(useContext);
  const links = {
    userNew: ROUTES.admin.system.users.new.path(),
    userEdit: id => ROUTES.admin.system.users.edit.path(id),
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getUsersBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getUsersBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <UserList
        users={props.users}
        userTotal={props.userTotal}
        isFetchingUsers={props.isFetchingUsers}
        deleteUserBegin={props.deleteUserBegin}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        handleVisitUserEdit={props.handleVisitUserEdit}
        handleChangeScope={handleChangeScope}
        exportUsers={exportUsers}
        links={links}
        userType={type}
        UserTypes={UserTypes}
      />
    </React.Fragment>
  );
}

UserListPage.propTypes = {
  getUsersBegin: PropTypes.func.isRequired,
  users: PropTypes.object,
  userTotal: PropTypes.number,
  isFetchingUsers: PropTypes.bool,
  deleteUserBegin: PropTypes.func,
  exportUsersBegin: PropTypes.func,
  userUnmount: PropTypes.func.isRequired,
  handleVisitUserEdit: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  users: selectPaginatedUsers(),
  userTotal: selectUserTotal(),
  isFetchingUsers: selectIsFetchingUsers(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = dispatch => ({
  getUsersBegin: payload => dispatch(getUsersBegin(payload)),
  exportUsersBegin: payload => dispatch(exportUsersBegin(payload)),
  deleteUserBegin: payload => dispatch(deleteUserBegin(payload)),
  userUnmount: () => dispatch(userUnmount()),
  handleVisitUserEdit: id => dispatch(push(ROUTES.admin.system.users.edit.path(id)))
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  UserListPage,
  ['permissions.users_create'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.user.indexPage
));
