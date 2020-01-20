/**
 *
 * FieldsPage
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
  fieldUnmount, deleteFieldBegin
} from 'containers/Shared/Field/actions';

import reducer from 'containers/Shared/Field/reducer';
import saga from '../fieldsSaga';

import FieldList from 'components/Shared/Fields/FieldList';
import { selectGroup } from 'containers/Group/selectors';

export function FieldListPage(props) {
  useInjectReducer({ key: 'fields', reducer });
  useInjectSaga({ key: 'fields', saga });

  const [params, setParams] = useState(
    {
      count: 5,
      page: 0,
      order: 'asc',
      orderBy: 'fields.id',
      fieldDefinerId: dig(props, 'currentGroup', 'id')
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

  return (
    <React.Fragment>
      <FieldList
        fields={props.fields}
        fieldTotal={props.fieldTotal}
        isLoading={props.isLoading}
        createFieldBegin={payload => props.createFieldBegin({
          ...payload,
          fieldDefinerId: dig(props, 'currentGroup', 'id'),
        })}
        updateFieldBegin={props.updateFieldBegin}
        deleteFieldBegin={props.deleteFieldBegin}
        handlePagination={handlePagination}
        isCommitting={props.isCommitting}
        commitSuccess={props.commitSuccess}
        currentGroup={props.currentGroup}

        numberField
      />
    </React.Fragment>
  );
}

FieldListPage.propTypes = {
  getFieldsBegin: PropTypes.func.isRequired,
  createFieldBegin: PropTypes.func.isRequired,
  updateFieldBegin: PropTypes.func.isRequired,
  fields: PropTypes.object,
  fieldTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  deleteFieldBegin: PropTypes.func,
  fieldUnmount: PropTypes.func.isRequired,
  isCommitting: PropTypes.bool,
  commitSuccess: PropTypes.bool,
  hasChanged: PropTypes.bool,
  currentGroup: PropTypes.shape({
    id: PropTypes.number
  })
};

const mapStateToProps = createStructuredSelector({
  fields: selectPaginatedFields(),
  fieldTotal: selectFieldTotal(),
  isLoading: selectIsLoading(),
  isCommitting: selectIsCommitting(),
  commitSuccess: selectCommitSuccess(),
  currentGroup: selectGroup(),
  hasChanged: selectHasChanged(),
});

const mapDispatchToProps = {
  getFieldsBegin,
  createFieldBegin,
  updateFieldBegin,
  deleteFieldBegin,
  fieldUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(FieldListPage);
