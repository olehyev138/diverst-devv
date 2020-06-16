import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import DiverstPagination from 'components/Shared/DiverstPagination';
import GroupSelectorItem from './item';
import { Divider, Box, Fade } from '@material-ui/core';
import DiverstLoader from 'components/Shared/DiverstLoader';
import messages from 'containers/Group/messages';

const GroupListSelector = (props) => {
  const { groups, ...rest } = props;
  const { getGroupsBegin, groupListUnmount } = rest;

  const [params, setParams] = useState({ count: 10, page: 0, query_scopes: ['all_parents'] });
  const [searchKey, setSearchKey] = useState('');
  const [expandedGroups, setExpandedGroups] = useState({});

  /* Store a expandedGroupsHash for each group, that tracks whether or not its children are expanded */
  if (props.groups && props.groups.length !== 0 && Object.keys(expandedGroups).length <= 0) {
    const initialExpandedGroups = {};

    /* Setup initial hash, with each group set to false - do it like this because of how React works with state */
    /* eslint-disable-next-line no-return-assign */
    props.groups.map((id, i) => initialExpandedGroups[id] = false);
    setExpandedGroups(initialExpandedGroups);
  }

  const groupSearchAction = (searchKey = searchKey, params = params) => props.inputCallback(props, searchKey, params);

  useEffect(() => {
    if (props.open)
      groupSearchAction(searchKey, params);
    return () => null;
  }, [props.open]);

  return (
    <React.Fragment>
      <DiverstLoader isLoading={props.isLoading} transition={Fade}>
        {(groups || []).map(group => (
          <GroupSelectorItem
            {...rest}
            group={group}
            expandedGroups={expandedGroups}
            setExpandedGroups={setExpandedGroups}
          />
        ))}
      </DiverstLoader>
      <DiverstPagination
        rowsPerPage={params.count}
        rowsPerPageOptions={[10]}
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
  isLoading: PropTypes.bool,

  groups: PropTypes.array,
  groupTotal: PropTypes.number,

  inputCallback: PropTypes.func,

  open: PropTypes.bool,
  addGroup: PropTypes.func.isRequired,
  removeGroup: PropTypes.func.isRequired,
  isSelected: PropTypes.func.isRequired,
  selected: PropTypes.oneOfType([
    PropTypes.arrayOf(PropTypes.object),
    PropTypes.object
  ]),
};

export default compose(
  memo,
)(GroupListSelector);
