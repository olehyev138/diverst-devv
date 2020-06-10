/**
 *
 * GroupSelector
 *
 */

import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';

import {
  getGroupsBegin, groupListUnmount
} from 'containers/Group/actions';

import { compose } from 'redux';
import { connect } from 'react-redux';

import DiverstSelect from '../DiverstSelect';
import { createStructuredSelector } from 'reselect';
import { selectPaginatedSelectGroups, selectGroupIsLoading } from 'containers/Group/selectors';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Group/saga';

const GroupSelector = ({ handleChange, values, groupField, setFieldValue, label, queryScopes, ...rest }) => {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const { getGroupsBegin, groupListUnmount, ...selectProps } = rest;

  const groupSelectAction = (searchKey = '') => {
    rest.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      query_scopes: queryScopes || []
    });
  };

  useEffect(() => {
    groupSelectAction();

    return () => groupListUnmount();
  }, []);

  return (
    <DiverstSelect
      name={groupField}
      id={groupField}
      margin='normal'
      label={label}
      fullWidth
      options={rest.groups}
      value={values[groupField]}
      onChange={value => setFieldValue(groupField, value || (selectProps.isMulti ? [] : null))}
      onInputChange={groupSelectAction}
      hideHelperText
      {...selectProps}
    />
  );
};

GroupSelector.propTypes = {
  groupField: PropTypes.string.isRequired,
  label: PropTypes.node.isRequired,
  handleChange: PropTypes.func.isRequired,
  setFieldValue: PropTypes.func.isRequired,
  values: PropTypes.object.isRequired,
  queryScopes: PropTypes.arrayOf(PropTypes.string),
  isLoading: PropTypes.bool,

  getGroupsBegin: PropTypes.func.isRequired,
  groupListUnmount: PropTypes.func.isRequired,
  groups: PropTypes.array,
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups(),
  isLoading: selectGroupIsLoading(),
});

const mapDispatchToProps = {
  getGroupsBegin,
  groupListUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupSelector);
