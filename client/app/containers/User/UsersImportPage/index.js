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
  selectPaginatedFields,
  selectIsLoading
} from 'containers/Shared/Field/selectors';
import { selectEnterprise } from 'containers/Shared/App/selectors';
import {
  getFieldsBegin, fieldUnmount
} from 'containers/Shared/Field/actions';

import reducer from 'containers/Shared/Field/reducer';
import saga from 'containers/GlobalSettings/Field/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import UserList from 'components/User/UserList';
import UserImport from 'components/User/UserImport';

export function UserListPage(props) {
  useInjectReducer({ key: 'fields', reducer });
  useInjectSaga({ key: 'fields', saga });

  const [params, setParams] = useState({ count: -1, page: 0, order: 'asc' });

  const getUsers = (params = params) => {
    const newParams = {
      ...params,
      fieldDefinerId: props.currentEnterprise.id
    };
    props.getFieldsBegin(newParams);
    setParams(newParams);
  };

  useEffect(() => {
    getUsers();

    return () => {
      props.fieldUnmount();
    };
  }, []);

  const rs = new RouteService(useContext);

  const links = {
    userNew: ROUTES.admin.system.users.new.path(),
    userEdit: id => ROUTES.admin.system.users.edit.path(id),
  };

  return (
    <React.Fragment>
      <UserImport
        fields={[
          ...['First Name*', 'Last Name*', 'Email*', 'Biography', 'Active'],
          ...Object.values(props.fields).map(field => `${field.title}${field.required ? '*' : ''}`)
        ]}
        isFetchingFields={props.isFetchingFields}
        links={links}
      />
    </React.Fragment>
  );
}

UserListPage.propTypes = {
  currentEnterprise: PropTypes.object.isRequired,
  getFieldsBegin: PropTypes.func.isRequired,
  fields: PropTypes.object,
  isFetchingFields: PropTypes.bool,
  fieldUnmount: PropTypes.func.isRequired,
};

const mapStateToProps = createStructuredSelector({
  fields: selectPaginatedFields(),
  isFetchingFields: selectIsLoading(),
  currentEnterprise: selectEnterprise(),
});

const mapDispatchToProps = {
  getFieldsBegin,
  fieldUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UserListPage);
