/**
 *
 * UserRolePage
 *
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
  selectPaginatedUserRole, selectUserTotal,
  selectIsFetchingUserRole
} from 'containers/User/selectors';
import {
  getUserRoleBegin, userUnmount, deleteUserBegin
} from 'containers/User/actions';

import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import UserRoleList from 'components/User/UserRole/UserRoleList';

export function UserListPage(props) {
  // useInjectReducer({ key: 'users', reducer });
  // useInjectSaga({ key: 'users', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  useEffect(() => {
    props.getUserRoleBegin(params);

    return () => {
      props.userUnmount();
    };
  }, []);

  const rs = new RouteService(useContext);
  const links = {
    userNew: ROUTES.admin.system.users.new.path(),
    userEdit: id => ROUTES.admin.system.users.edit.path(id),
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getUserRoleBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getUserRoleBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <UserRoleList
        users={props.users}
        userTotal={props.userTotal}
        isFetchingUserRole={props.isFetchingUserRole}
        deleteUserBegin={props.deleteUserBegin}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        handleVisitUserEdit={props.handleVisitUserEdit}
        links={links}
      />
    </React.Fragment>
  );
}

UserListPage.propTypes = {
  getUserRoleBegin: PropTypes.func.isRequired,
  users: PropTypes.object,
  userTotal: PropTypes.number,
  isFetchingUserRole: PropTypes.bool,
  deleteUserBegin: PropTypes.func,
  userUnmount: PropTypes.func.isRequired,
  handleVisitUserEdit: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  users: selectPaginatedUserRole(),
  userTotal: selectUserTotal(),
  isFetchingUserRole: selectIsFetchingUserRole()
});

const mapDispatchToProps = dispatch => ({
  getUserRoleBegin: payload => dispatch(getUserRoleBegin(payload)),
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
)(UserListPage);
