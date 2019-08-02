import React, {memo, useContext, useEffect, useState} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';

import { selectUserTotal } from 'containers/User/selectors';
import { createUserBegin, getUsersBegin, userUnmount } from 'containers/User/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import UserForm from 'components/User/UserForm';

export function UserCreatePage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  useEffect(() => () => props.userUnmount(), []);

  const rs = new RouteService(useContext);
  const links = {
    usersIndex: ROUTES.admin.system.users.index.path(),
  };

  return (
    <UserForm
      userAction={props.createUserBegin}
      buttonText='Create'
      getUsersBegin={props.getUsersBegin}
      selectUsers={props.users}
      links={links}
    />
  );
}

UserCreatePage.propTypes = {
  createUserBegin: PropTypes.func,
  getUsersBegin: PropTypes.func,
  userUnmount: PropTypes.func,
  users: PropTypes.array
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
  createUserBegin,
  getUsersBegin,
  userUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UserCreatePage);
