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

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { selectPaginatedUsers, selectUserTotal } from 'containers/User/selectors';
import {
  getUsersBegin, createUserBegin, updateUserBegin,
  userUnmount, deleteUserBegin
} from 'containers/User/actions';

import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';

import UserList from 'components/User/UserList';

export function UserListPage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  useEffect(() => {
    props.getUsersBegin(params);

    return () => {
      props.userUnmount();
    };
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getUsersBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <UserList
        users={props.users}
        userTotal={props.userTotal}
        createUserBegin={props.createUserBegin}
        updateUserBegin={props.updateUserBegin}
        deleteUserBegin={props.deleteUserBegin}
        handlePagination={handlePagination}
      />
    </React.Fragment>
  );
}

UserListPage.propTypes = {
  getUsersBegin: PropTypes.func.isRequired,
  createUserBegin: PropTypes.func.isRequired,
  updateUserBegin: PropTypes.func.isRequired,
  users: PropTypes.object,
  userTotal: PropTypes.number,
  deleteUserBegin: PropTypes.func,
  userUnmount: PropTypes.func.isRequired
};

const mapStateToProps = createStructuredSelector({
  users: selectPaginatedUsers(),
  userTotal: selectUserTotal(),
});

const mapDispatchToProps = {
  getUsersBegin,
  createUserBegin,
  updateUserBegin,
  deleteUserBegin,
  userUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UserListPage);
