import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import DiverstPagination from 'components/Shared/DiverstPagination';
import GroupSelectorItem from './item';
import { Divider, Box, Fade, Grid } from '@material-ui/core';
import DiverstLoader from 'components/Shared/DiverstLoader';
import messages from 'containers/Group/messages';
import { DiverstCSSCell, DiverstCSSGrid } from 'components/Shared/DiverstCSSGrid';

const styles = {
  bottom: {
    minHeight: '100%',
  },
  container: {
    flex: 1,
    alignItems: 'center'
  },
  list: {
    flex: 1,
    overflow: 'auto',
  }
};

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

  const list = (
    <DiverstLoader isLoading={props.isLoading} transition={Fade}>
      {(groups || []).map(group => (
        <GroupSelectorItem
          key={group.value}
          {...rest}
          group={group}
          expandedGroups={expandedGroups}
          setExpandedGroups={setExpandedGroups}
        />
      ))}
    </DiverstLoader>
  );

  const paginator = (
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
  );

  const toReturn = (
    <DiverstCSSGrid
      columns={1}
      rows='1fr auto'
      areas={[
        'list',
        'paginator',
      ]}
      rowGap='16px'
      columnGap='24px'
    >
      <DiverstCSSCell area='list'>{list}</DiverstCSSCell>
      <DiverstCSSCell area='paginator'>{paginator}</DiverstCSSCell>
    </DiverstCSSGrid>
  );

  return (
    <React.Fragment>
      <div style={styles.list}>
        {list}
      </div>
      <div style={styles.bottom}>
        {paginator}
      </div>
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
