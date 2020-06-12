import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';

import { selectFormUser, selectIsCommitting, selectIsFormLoading } from 'containers/User/selectors';
import {
  createUserBegin, updateFieldDataBegin,
  getUsersBegin, userUnmount, getUserPrototypeBegin
} from 'containers/User/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/User/messages';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';
import InviteForm from 'components/User/InviteForm';

export function UserCreatePage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  useEffect(() => {
    props.getUserPrototypeBegin();

    return () => {
      props.userUnmount();
    };
  }, []);
  const { intl } = props;
  const rs = new RouteService(useContext);
  const links = {
    usersIndex: ROUTES.admin.system.users.index.path(),
  };

  return (
    <InviteForm
      admin
      user={props.user}
      isFormLoading={props.isFormLoading}
      userAction={props.createUserBegin}
      updateFieldDataBegin={props.updateFieldDataBegin}
      buttonText={intl.formatMessage(messages.create)}
      getUsersBegin={props.getUsersBegin}
      selectUsers={props.users}
      links={links}
      isCommitting={props.isCommitting}
    />
  );
}

UserCreatePage.propTypes = {
  intl: intlShape.isRequired,
  createUserBegin: PropTypes.func,
  updateFieldDataBegin: PropTypes.func,
  getUsersBegin: PropTypes.func,
  getUserPrototypeBegin: PropTypes.func,
  userUnmount: PropTypes.func,
  user: PropTypes.object,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
  user: selectFormUser(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  createUserBegin,
  updateFieldDataBegin,
  getUsersBegin,
  userUnmount,
  getUserPrototypeBegin,
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
  UserCreatePage,
  ['permissions.users_create'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.user.createPage
));
