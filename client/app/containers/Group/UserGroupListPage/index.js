/**
 *
 * UserGroupListPage
 *
 */

import React, { memo, useEffect, useState, useMemo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { Button, Grid } from '@material-ui/core';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedGroups, selectGroupTotal, selectGroupIsLoading } from 'containers/Group/selectors';
import { getGroupsBegin, groupAllUnmount, deleteGroupBegin } from 'containers/Group/actions';
import reducer from 'containers/Group/reducer';

import saga from 'containers/Group/saga';

import GroupList from 'components/Group/UserGroupList';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectPermissions, selectUser } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from '../messages';

const defaultAllGroupsParams = Object.freeze({
  count: 5,
  page: 0,
  orderBy: 'position',
  order: 'asc',
  query_scopes: ['all_parents'],
  with_children: true
});

export function UserGroupListPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const [params, setParams] = useState({ count: 5, page: 0, orderBy: 'position', order: 'asc', query_scopes: ['all_parents'], with_children: true });
  const [displayMyGroups, setDisplayMyGroups] = useState(false);

  const defaultJoinedGroupsParams = useMemo(() => Object.freeze({
    count: 5,
    page: 0,
    orderBy: 'position',
    order: 'asc',
    query_scopes: [['joined_groups', props.user?.user_id]],
  }), [props.user?.user_id]);

  useEffect(() => {
    props.getGroupsBegin(params);

    return () => props.groupAllUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getGroupsBegin(newParams);
    setParams(newParams);
  };

  const getJoinedGroups = () => {
    const newParams = { ...defaultJoinedGroupsParams, order: params.order, orderBy: params.orderBy };

    setParams(newParams);
    props.getGroupsBegin(newParams);
    setDisplayMyGroups(true);
  };

  const getAllGroups = () => {
    const newParams = { ...defaultAllGroupsParams, order: params.order, orderBy: params.orderBy };

    setParams(newParams);
    props.getGroupsBegin(newParams);
    setDisplayMyGroups(false);
  };

  return (
    <React.Fragment>
      <Grid container justify='space-between' spacing={3}>
        <Grid item>
        </Grid>
        <Grid item>
          {displayMyGroups ? (
            <Button
              size='small'
              color='primary'
              variant='contained'
              onClick={getAllGroups}
            >
              <DiverstFormattedMessage {...messages.allGroups} />
            </Button>
          ) : (
            <Button
              size='small'
              color='primary'
              variant='contained'
              onClick={getJoinedGroups}
            >
              <DiverstFormattedMessage {...messages.myGroups} />
            </Button>
          )}
        </Grid>
        <Grid item xs={12}>
          <GroupList
            isLoading={props.isLoading}
            groups={props.groups}
            groupTotal={props.groupTotal}
            defaultParams={params}
            deleteGroupBegin={props.deleteGroupBegin}
            handlePagination={handlePagination}
            viewChildren={!displayMyGroups}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

UserGroupListPage.propTypes = {
  getGroupsBegin: PropTypes.func.isRequired,
  groupAllUnmount: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  groups: PropTypes.array,
  user: PropTypes.object,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
  isLoading: selectGroupIsLoading(),
  permissions: selectPermissions(),
  user: selectUser(),
});

function mapDispatchToProps(dispatch) {
  return {
    getGroupsBegin: payload => dispatch(getGroupsBegin(payload)),
    groupAllUnmount: () => dispatch(groupAllUnmount()),
    deleteGroupBegin: payload => dispatch(deleteGroupBegin(payload))
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  UserGroupListPage,
  ['permissions.groups_view'],
  (props, rs) => ROUTES.user.home.path(),
  permissionMessages.group.userListPage
));
