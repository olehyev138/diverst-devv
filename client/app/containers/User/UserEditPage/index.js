import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { injectIntl, intlShape } from 'react-intl';
import { useParams, useLocation } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/User/saga';
import reducer from 'containers/User/reducer';
import fieldDataReducer from 'containers/Shared/FieldData/reducer';
import fieldDataSaga from 'containers/Shared/FieldData/saga';

import {
  getUserBegin, updateFieldDataBegin,
  updateUserBegin, userUnmount
} from 'containers/User/actions';

import { selectFormUser, selectFieldData, selectIsCommitting, selectIsFormLoading } from 'containers/User/selectors';
import { selectPermissions } from 'containers/Shared/App/selectors';

import messages from 'containers/User/messages';
import permissionMessages from 'containers/Shared/Permissions/messages';

import { ROUTES } from 'containers/Shared/Routes/constants';

import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';
import Conditional from 'components/Compositions/Conditional';

import UserForm from 'components/User/UserForm';

export function UserEditPage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });
  useInjectReducer({ key: 'field_data', reducer: fieldDataReducer });
  useInjectSaga({ key: 'field_data', saga: fieldDataSaga });

  const { intl } = props;

  const { user_id: userId } = useParams();
  const location = useLocation();

  const links = {
    usersIndex: ROUTES.admin.system.users.index.path(),
    usersPath: id => ROUTES.user.show.path(id),
  };

  useEffect(() => {
    props.getUserBegin({ id: userId });

    return () => {
      props.userUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <DiverstBreadcrumbs />
      <UserForm
        edit
        userAction={props.updateUserBegin}
        updateFieldDataBegin={props.updateFieldDataBegin}
        links={links}
        user={props.user}
        fieldData={props.fieldData}
        buttonText={intl.formatMessage(messages.update)}
        admin={location.pathname.startsWith('/admin')}
        isCommitting={props.isCommitting}
        isFormLoading={props.isFormLoading}
      />
    </React.Fragment>
  );
}

UserEditPage.propTypes = {
  intl: intlShape.isRequired,
  user: PropTypes.object,
  fieldData: PropTypes.array,
  getUserBegin: PropTypes.func,
  updateUserBegin: PropTypes.func,
  updateFieldDataBegin: PropTypes.func,
  userUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  user: selectFormUser(),
  fieldData: selectFieldData(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
  permissions: selectPermissions(),
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  UserEditPage,
  ['user.permissions.update?', 'isFormLoading'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.user.editPage
));
