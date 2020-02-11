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
import { selectIsCommitting } from 'containers/Shared/CsvFile/selectors';
import {
  getFieldsBegin, fieldUnmount
} from 'containers/Shared/Field/actions';
import {
  createCsvFileBegin
} from 'containers/Shared/CsvFile/actions';

import reducer from 'containers/Shared/CsvFile/reducer';
import saga from 'containers/Shared/CsvFile/saga';
import fieldReducer from 'containers/Shared/Field/reducer';
import fieldSaga from 'containers/GlobalSettings/Field/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import UserList from 'components/User/UserList';
import UserImport from 'components/User/UserImport';

export function UserListPage(props) {
  useInjectReducer({ key: 'csv_files', reducer });
  useInjectSaga({ key: 'csv_files', saga });
  useInjectReducer({ key: 'fields', reducer: fieldReducer });
  useInjectSaga({ key: 'fields', saga: fieldSaga });

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
        importAction={props.createCsvFileBegin}
        isCommitting={props.isCommitting}
        links={links}
      />
    </React.Fragment>
  );
}

UserListPage.propTypes = {
  currentEnterprise: PropTypes.object.isRequired,
  getFieldsBegin: PropTypes.func.isRequired,
  createCsvFileBegin: PropTypes.func.isRequired,
  fields: PropTypes.object,
  isFetchingFields: PropTypes.bool,
  fieldUnmount: PropTypes.func.isRequired,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  fields: selectPaginatedFields(),
  isFetchingFields: selectIsLoading(),
  currentEnterprise: selectEnterprise(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  getFieldsBegin,
  fieldUnmount,
  createCsvFileBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UserListPage);
