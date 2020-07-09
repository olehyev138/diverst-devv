/**
 *
 * AdminFieldsPage
 *
 *  - lists all enterprise custom fields
 *  - renders forms for creating & editing custom fields
 *
 *  - function:
 *    - get fields from server
 *    - on edit - render respective form with field data
 *    - on new - render respective empty form
 *    - on save - create/update field
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import dig from 'object-dig';

import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  selectPaginatedFields,
  selectFieldTotal,
  selectIsLoading,
  selectIsCommitting,
  selectCommitSuccess,
  selectHasChanged,
} from 'containers/Shared/Field/selectors';
import {
  getFieldsBegin, createFieldBegin, updateFieldBegin,
  fieldUnmount, deleteFieldBegin, updateFieldPositionBegin,
} from 'containers/Shared/Field/actions';

import reducer from 'containers/Shared/Field/reducer';
import saga from 'containers/GlobalSettings/Field/saga';

import AdminFieldList from 'components/Shared/Fields/AdminFieldList';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function AdminFieldsPage(props) {
  useInjectReducer({ key: 'fields', reducer });
  useInjectSaga({ key: 'fields', saga });

  const [params, setParams] = useState(
    {
      count: 5,
      page: 0,
      order: 'asc',
      orderBy: 'position',
      fieldDefinerId: dig(props, 'currentEnterprise', 'id')
    }
  );

  useEffect(() => {
    props.getFieldsBegin(params);

    return () => {
      props.fieldUnmount();
    };
  }, []);

  useEffect(() => {
    if (props.hasChanged)
      props.getFieldsBegin(params);

    return () => {
      props.fieldUnmount();
    };
  }, [props.hasChanged]);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getFieldsBegin(newParams);
    setParams(newParams);
  };

  const positions = [];
  for (let i = 0; i < props.fields.length; i += 1)
    positions[i] = { id: props.fields[i].id, position: props.fields[i].position };

  return (
    <React.Fragment>
      <AdminFieldList
        fields={props.fields}
        fieldTotal={props.fieldTotal}
        isLoading={props.isLoading}
        createFieldBegin={payload => props.createFieldBegin({
          ...payload,
          fieldDefinerId: dig(props, 'currentEnterprise', 'id')
        })}
        updateFieldBegin={props.updateFieldBegin}
        deleteFieldBegin={props.deleteFieldBegin}
        handlePagination={handlePagination}
        isCommitting={props.isCommitting}
        commitSuccess={props.commitSuccess}
        currentEnterprise={props.currentEnterprise}

        toggles={{
          visible: true,
          editable: true,
          memberList: true,
          required: true,
        }}

        positions={positions}
        defaultParams={params}
        updateFieldPositionBegin={props.updateFieldPositionBegin}
      />
    </React.Fragment>
  );
}

AdminFieldsPage.propTypes = {
  getFieldsBegin: PropTypes.func.isRequired,
  createFieldBegin: PropTypes.func.isRequired,
  updateFieldBegin: PropTypes.func.isRequired,
  updateFieldPositionBegin: PropTypes.func.isRequired,
  fields: PropTypes.object,
  fieldTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  deleteFieldBegin: PropTypes.func,
  fieldUnmount: PropTypes.func.isRequired,
  isCommitting: PropTypes.bool,
  commitSuccess: PropTypes.bool,
  hasChanged: PropTypes.bool,
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number
  })
};

const mapStateToProps = createStructuredSelector({
  fields: selectPaginatedFields(),
  fieldTotal: selectFieldTotal(),
  isLoading: selectIsLoading(),
  isCommitting: selectIsCommitting(),
  commitSuccess: selectCommitSuccess(),
  currentEnterprise: selectEnterprise(),
  hasChanged: selectHasChanged(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getFieldsBegin,
  createFieldBegin,
  updateFieldBegin,
  deleteFieldBegin,
  updateFieldPositionBegin,
  fieldUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  AdminFieldsPage,
  ['permissions.fields_manage'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.globalSettings.field.indexPage
));
