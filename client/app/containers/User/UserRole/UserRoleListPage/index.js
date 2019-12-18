/**
 *
 * UserRoleListPage
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
  selectPaginatedUserRoles, selectUserRoleTotal,
  selectIsFetchingUserRoles
} from '../selectors';
import {
  getUserRolesBegin, userRoleUnmount, deleteUserRoleBegin
} from '../actions';

import reducer from '../reducer';
import saga from '../saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import UserRoleList from 'components/User/UserRole/UserRoleList';

export function UserRoleListPage(props) {
  useInjectReducer({ key: 'roles', reducer });
  useInjectSaga({ key: 'roles', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  useEffect(() => {
    props.getUserRolesBegin(params);

    return () => {
      props.userRoleUnmount();
    };
  }, []);

  const rs = new RouteService(useContext);
  const links = {
    userRoleNew: ROUTES.admin.system.users.roles.new.path(),
    userRoleEdit: id => ROUTES.admin.system.users.edit.path(id),
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getUserRolesBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getUserRolesBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <UserRoleList
        userRoles={props.userRoles}
        userRoleTotal={props.userRoleTotal}
        isFetchingUserRoles={props.isFetchingUserRoles}
        deleteUserRoleBegin={props.deleteUserRoleBegin}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        handleVisitUserRoleEdit={props.handleVisitUserRoleEdit}
        links={links}
      />
    </React.Fragment>
  );
}

UserRoleListPage.propTypes = {
  getUserRolesBegin: PropTypes.func.isRequired,
  userRoles: PropTypes.object,
  userRoleTotal: PropTypes.number,
  isFetchingUserRoles: PropTypes.bool,
  deleteUserRoleBegin: PropTypes.func,
  userRoleUnmount: PropTypes.func.isRequired,
  handleVisitUserRoleEdit: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  userRoles: selectPaginatedUserRoles(),
  userRoleTotal: selectUserRoleTotal(),
  isFetchingUserRoles: selectIsFetchingUserRoles()
});

const mapDispatchToProps = dispatch => ({
  getUserRolesBegin: payload => dispatch(getUserRolesBegin(payload)),
  deleteUserRoleBegin: payload => dispatch(deleteUserRoleBegin(payload)),
  userRoleUnmount: () => dispatch(userRoleUnmount()),
  handleVisitUserRoleEdit: id => dispatch(push(ROUTES.admin.system.users.roles.edit.path(id)))
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UserRoleListPage);