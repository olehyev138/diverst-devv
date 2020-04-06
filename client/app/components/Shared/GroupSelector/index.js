/**
 *
 * GroupSelector
 *
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
import { selectPaginatedSelectGroups, selectAllSubgroups } from 'containers/Group/selectors';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Segment/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Group/saga';

const GroupSelector = ({ handleChange, values, groupField, setFieldValue, label, groupType, ...rest }) => {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const groupSelectAction = (searchKey = '') => {
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
      // options={(groupType === 'parent') ? rest.parentgroups : ((groupType === 'children') ? rest.subgroups : rest.allgroups)}
      options={(groupType === 'parent') ? rest.parentgroups : ((groupType === 'children') ? rest.subgroups : rest.parentgroups.concat(rest.subgroups))}
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
  allgroups: PropTypes.array,
  parentgroups: PropTypes.array,
  subgroups: PropTypes.array,
};

const mapStateToProps = createStructuredSelector({
  subgroups: selectAllSubgroups(),
  parentgroups: selectPaginatedSelectGroups(),
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
