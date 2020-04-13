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

import { selectIsCommitting } from 'containers/User/selectors';
import {
  createUserBegin, updateFieldDataBegin,
  getUsersBegin, userUnmount
} from 'containers/User/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import UserForm from 'components/User/UserForm';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/User/messages';
import Conditional from 'components/Compositions/Conditional';
import { PolicyTemplatesPage } from 'containers/User/UserPolicy/PolicyTemplatesPage';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function UserCreatePage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  useEffect(() => () => props.userUnmount(), []);
  const { intl } = props;
  const rs = new RouteService(useContext);
  const links = {
    usersIndex: ROUTES.admin.system.users.index.path(),
  };

  return (
    <UserForm
      admin
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
  intl: intlShape,
  createUserBegin: PropTypes.func,
  updateFieldDataBegin: PropTypes.func,
  getUsersBegin: PropTypes.func,
  userUnmount: PropTypes.func,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  createUserBegin,
  updateFieldDataBegin,
  getUsersBegin,
  userUnmount
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
