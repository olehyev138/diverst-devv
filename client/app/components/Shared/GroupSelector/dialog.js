import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import DiverstPagination from 'components/Shared/DiverstPagination';
import GroupSelectorItem from './item';
import { Divider, Box } from '@material-ui/core';

const GroupListSelector = (props) => {
  const { handleChange, values, groupField, setFieldValue, label, groups, queryScopes, ...rest } = props;
  const { getGroupsBegin, groupListUnmount, groupSelectAction, ...selectProps } = rest;

  const [params, setParams] = useState({ count: 10, page: 0, query_scopes: ['all_parents'] });
  const [searchKey, setSearchKey] = useState('');
  const [expandedGroups, setExpandedGroups] = useState({});

  /* Store a expandedGroupsHash for each group, that tracks whether or not its children are expanded */
  if (props.groups && Object.keys(props.groups).length !== 0 && Object.keys(expandedGroups).length <= 0) {
    const initialExpandedGroups = {};

    /* Setup initial hash, with each group set to false - do it like this because of how React works with state */
    /* eslint-disable-next-line no-return-assign */
    Object.keys(props.groups).map((id, i) => initialExpandedGroups[id] = false);
    setExpandedGroups(initialExpandedGroups);
  }

  const groupSearchAction = (searchKey = searchKey, params = params) => props.inputCallback(props, searchKey, params);

  return (
    <React.Fragment>
      {(groups || []).map(group => (
        <React.Fragment>
          <GroupSelectorItem
            group={group}
            expandedGroups={expandedGroups}
            setExpandedGroups={setExpandedGroups}
            {...props}
          />
        </React.Fragment>
      ))}
      <DiverstPagination
        isLoading={props.isLoading}
        rowsPerPage={params.count}
        count={props.groupTotal}
        handlePagination={(payload) => {
          const newParams = { ...params, count: payload.count, page: payload.page };

          groupSearchAction(searchKey, newParams);
          setParams(newParams);
        }}
      />
    </React.Fragment>
  );
};

GroupListSelector.propTypes = {
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
  groupTotal: PropTypes.number,

  inputCallback: PropTypes.func,
};

export default compose(
  memo,
)(GroupListSelector);
