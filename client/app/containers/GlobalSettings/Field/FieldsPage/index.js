/**
 *
 * AdminFieldListPage
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedFields, selectFieldTotal } from 'containers/GlobalSettings/Field/selectors';
import { getFieldsBegin, fieldUnmount, deleteFieldBegin } from 'containers/GlobalSettings/Field/actions';
import reducer from 'containers/GlobalSettings/Field/reducer';

import saga from 'containers/GlobalSettings/Field/saga';

// import FieldList from 'components/GlobalSettings/Field/AdminFieldList';

export function AdminFieldListPage(props) {
  useInjectReducer({ key: 'fields', reducer });
  useInjectSaga({ key: 'fields', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  useEffect(() => {
    // props.getFieldsBegin(params);

//    return () => {
//      props.fieldListUnmount();
//    };
  }, []);

  /*
   * - get fields from server
   * - on edit - render respective form with field data
   * - on new - render respective empty form
   * - on save - create/update field
   */

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getFieldsBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
    </React.Fragment>
  );
}

AdminFieldListPage.propTypes = {
  getFieldsBegin: PropTypes.func.isRequired,
  // fieldListUnmount: PropTypes.func.isRequired,
  fields: PropTypes.object,
  fieldTotal: PropTypes.number,
  deleteFieldBegin: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  fields: selectPaginatedFields(),
  fieldTotal: selectFieldTotal(),
});

function mapDispatchToProps(dispatch) {
  return {
    getFieldsBegin: payload => dispatch(getFieldsBegin(payload)),
    // fieldListUnmount: () => dispatch(fieldListUnmount()),
    deleteFieldBegin: payload => dispatch(deleteFieldBegin(payload))
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(AdminFieldListPage);
