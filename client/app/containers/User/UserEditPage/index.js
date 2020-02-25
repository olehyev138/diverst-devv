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

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/User/messages';

export function UserEditPage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });
  useInjectReducer({ key: 'field_data', reducer: fieldDataReducer });
  useInjectSaga({ key: 'field_data', saga: fieldDataSaga });

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
        buttonText={<DiverstFormattedMessage {...messages.update} />}
        admin={props.path.startsWith('/admin')}
        isCommitting={props.isCommitting}
        isFormLoading={props.isFormLoading}
      />
    </React.Fragment>
  );
}

UserEditPage.propTypes = {
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
