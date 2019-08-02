import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/reducer';
import { selectUser } from 'containers/User/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  getUserBegin, getUsersBegin,
  updateUserBegin, userUnmount
} from 'containers/User/actions';

import saga from 'containers/User/saga';
import UserForm from 'components/User/UserForm';

export function UserEditPage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  const rs = new RouteService(useContext);
  const links = {
    usersIndex: ROUTES.admin.system.users.index.path(),
  };

  useEffect(() => {
    props.getUserBegin({ id: rs.params('user_id') });

    return () => {
      props.userUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <UserForm
        userAction={props.updateUserBegin}
        getUsersBegin={props.getUsersBegin}
        selectUsers={props.users}
        links={links}
        user={props.user}
        buttonText='Update'
      />
    </React.Fragment>
  );
}

UserEditPage.propTypes = {
  user: PropTypes.object,
  users: PropTypes.array,
  getUserBegin: PropTypes.func,
  getUsersBegin: PropTypes.func,
  updateUserBegin: PropTypes.func,
  userUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  user: selectUser(),
});

const mapDispatchToProps = {
  getUserBegin,
  getUsersBegin,
  updateUserBegin,
  userUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UserEditPage);
