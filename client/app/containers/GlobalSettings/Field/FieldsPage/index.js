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

import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { getFieldsBegin, fieldUnmount, deleteFieldBegin } from 'containers/GlobalSettings/Field/actions';
import { selectPaginatedFields, selectFieldTotal } from 'containers/GlobalSettings/Field/selectors';

import reducer from 'containers/GlobalSettings/Field/reducer';
import saga from 'containers/GlobalSettings/Field/saga';

import FieldList from 'components/GlobalSettings/Field/FieldList';

export function FieldListPage(props) {
  useInjectReducer({ key: 'fields', reducer });
  useInjectSaga({ key: 'fields', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  useEffect(() => {
    props.getFieldsBegin(params);

    return () => {
      props.fieldUnmount();
    };
  }, []);

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
        deleteFieldBegin={props.deleteFieldBegin}
        handlePagination={handlePagination}
      />
    </React.Fragment>
  );
}

FieldListPage.propTypes = {
  getFieldsBegin: PropTypes.func.isRequired,
  fields: PropTypes.object,
  fieldTotal: PropTypes.number,
  deleteFieldBegin: PropTypes.func,
  fieldUnmount: PropTypes.func.isRequired
};

const mapStateToProps = createStructuredSelector({
  fields: selectPaginatedFields(),
  fieldTotal: selectFieldTotal(),
});

const mapDispatchToProps = {
  getFieldsBegin,
  deleteFieldBegin,
  fieldUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(FieldListPage);
