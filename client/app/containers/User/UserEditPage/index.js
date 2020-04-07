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

import { selectFormUser, selectFieldData, selectIsCommitting, selectIsFormLoading } from 'containers/User/selectors';

import saga from 'containers/User/saga';
import UserForm from 'components/User/UserForm';
import fieldDataReducer from 'containers/Shared/FieldData/reducer';
import fieldDataSaga from 'containers/Shared/FieldData/saga';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/User/messages';
import Conditional from 'components/Compositions/Conditional';
import { UserCreatePage } from 'containers/User/UserCreatePage';
import { selectPermissions } from 'containers/Shared/App/selectors';

export function UserEditPage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });
  useInjectReducer({ key: 'field_data', reducer: fieldDataReducer });
  useInjectSaga({ key: 'field_data', saga: fieldDataSaga });
  const { intl } = props;
  const rs = new RouteService(useContext);
  const links = {
    usersIndex: ROUTES.admin.system.users.index.path(),
    usersPath: id => ROUTES.user.show.path(id),
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
        edit
        userAction={props.updateUserBegin}
        updateFieldDataBegin={props.updateFieldDataBegin}
        links={links}
        user={props.user}
        fieldData={props.fieldData}
        buttonText={intl.formatMessage(messages.update)}
        admin={props.path.startsWith('/admin')}
        isCommitting={props.isCommitting}
        isFormLoading={props.isFormLoading}
      />
    </React.Fragment>
  );
}

UserEditPage.propTypes = {
  intl: intlShape,
  path: PropTypes.string,
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
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  'user.editPage'
));
