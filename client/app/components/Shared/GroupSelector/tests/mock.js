// mock store for group selector
import React from 'react';
import GroupSelector from '../index';
import PropTypes from 'prop-types';

function MockGroupSelector(props) {
  return (
    <div>
      <GroupSelector {...props} />
    </div>
  );
}

MockGroupSelector.propTypes = {
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

export default MockGroupSelector;
