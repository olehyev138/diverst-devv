/**
 *
 * GroupSelector
 * @Param groupType= parent,children or null(all groups)
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';

import {
  getGroupsBegin
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

const GroupSelector = ({ handleChange, values, groupField, setFieldValue, label, groupType, ...rest }) => {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const groupSelectAction = (searchKey = '') => {
    if (groupType === 'parent')
      rest.getGroupsBegin({
        count: 10, page: 0, order: 'asc',
        search: searchKey,
        query_scopes: ['all_parents']
      });
    else if (groupType === 'children')
      rest.getGroupsBegin({
        count: 10, page: 0, order: 'asc',
        search: searchKey,
        query_scopes: ['all_children']
      });
    else
      rest.getGroupsBegin({
        count: 10, page: 0, order: 'asc',
        search: searchKey,
      });
  };

  return (
    <DiverstSelect
      name={groupField}
      id={groupField}
      margin='normal'
      label={label}
      isMulti
      fullWidth
      options={rest.selectGroups}
      isLoading={rest.isLoading}
      value={values[groupField]}
      onChange={value => setFieldValue(groupField, value)}
      onInputChange={value => groupSelectAction(value)}
      hideHelperText
      {...rest}
    />
  );
};

GroupSelector.propTypes = {
  groupField: PropTypes.string.isRequired,
  label: PropTypes.node.isRequired,
  handleChange: PropTypes.func.isRequired,
  setFieldValue: PropTypes.func.isRequired,
  values: PropTypes.object.isRequired,
  groupType: PropTypes.string,
  getGroupsBegin: PropTypes.func.isRequired,
  selectGroups: PropTypes.array,
  isLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  selectGroups: selectPaginatedSelectGroups(),
  isLoading: selectGroupIsLoading(),
});

const mapDispatchToProps = {
  getGroupsBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupSelector);
