import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/reducer';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  getUserBegin, getUsersBegin, updateFieldDataBegin,
  updateUserBegin, userUnmount
} from 'containers/User/actions';

import { selectUser, selectFieldData } from 'containers/User/selectors';

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
        updateFieldDataBegin={props.updateFieldDataBegin}
        links={links}
        user={props.user}
        fieldData={props.fieldData}
        buttonText='Update'
      />
    </React.Fragment>
  );
}

UserEditPage.propTypes = {
  user: PropTypes.object,
  fieldData: PropTypes.array,
  getUserBegin: PropTypes.func,
  updateUserBegin: PropTypes.func,
  updateFieldDataBegin: PropTypes.func,
  userUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  user: selectUser(),
  fieldData: selectFieldData()
});

const mapDispatchToProps = {
  getUserBegin,
  updateUserBegin,
  updateFieldDataBegin,
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