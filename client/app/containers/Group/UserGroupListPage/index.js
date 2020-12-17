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
import { withStyles } from '@material-ui/core/styles';
import { Button, Grid, Typography, Fade } from '@material-ui/core';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedGroups, selectGroupTotal, selectGroupIsLoading } from 'containers/Group/selectors';
import { getGroupsBegin, groupAllUnmount, deleteGroupBegin } from 'containers/Group/actions';
import reducer from 'containers/Group/reducer';

import saga from 'containers/Group/saga';

import GroupList from 'components/Group/UserGroupList';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectPermissions, selectUser, selectCustomText } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from '../messages';

const styles = theme => ({
  headerText: {
    fontWeight: 'bold',
  },
});

const defaultAllGroupsParams = Object.freeze({
  count: 5,
  page: 0,
  orderBy: 'position',
  order: 'asc',
  query_scopes: ['all_parents'],
  with_children: false
});

export function UserGroupListPage({ classes, ...props }) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const [parentData, setParentData] = useState(undefined);

  const [params, setParams] = useState(defaultAllGroupsParams);
  const [displayMyGroups, setDisplayMyGroups] = useState(false);

  const defaultJoinedGroupsParams = useMemo(() => Object.freeze({
    count: 5,
    page: 0,
    orderBy: 'position',
    order: 'asc',
    query_scopes: [['joined_groups', props.user?.user_id]],
    with_children: false,
  }), [props.user?.user_id]);

  useEffect(() => {
    props.getGroupsBegin(params);

    return () => props.groupAllUnmount();
  }, []);

  useEffect(() => {
    if (parentData === undefined || !parentData?.id) return;

    const newParams = { ...defaultAllGroupsParams, query_scopes: [['children_of', parentData?.id]] };

    props.getGroupsBegin(newParams);
    setParams(newParams);
  }, [parentData?.id]);

  const handleParentExpand = (id, name) => setParentData({ id, name });

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getGroupsBegin(newParams);
    setParams(newParams);
  };

  const getJoinedGroups = () => {
    const newParams = { ...defaultJoinedGroupsParams, order: params.order, orderBy: params.orderBy };

    setParentData({ name: parentData?.name });
    setParams(newParams);
    props.getGroupsBegin(newParams);
    setDisplayMyGroups(true);
  };

  const getAllGroups = () => {
    const newParams = { ...defaultAllGroupsParams, order: params.order, orderBy: params.orderBy };

    setParentData({ name: parentData?.name });
    setParams(newParams);
    props.getGroupsBegin(newParams);
    setDisplayMyGroups(false);
  };

  return (
    <React.Fragment>
      <Grid container justify='space-between' spacing={3}>
        <Grid item>
          <Fade
            in={!!parentData?.id}
            onExited={() => {
              setParentData(null);
              setDisplayMyGroups(false);
            }}
          >
            <Button
              size='small'
              color='primary'
              variant='contained'
              onClick={() => {
                setParentData({ name: parentData?.name });
                getAllGroups();
              }}
            >
              <DiverstFormattedMessage {...messages.back} />
            </Button>
          </Fade>
        </Grid>
        <Fade in={!!parentData?.id}>
          <Grid item>
            <Typography component='span' color='primary' variant='h5' className={classes.headerText}>
              {parentData?.name}
            </Typography>
            &nbsp;
            &nbsp;
            <Typography component='span' color='textSecondary' variant='h5' className={classes.headerText}>
              <DiverstFormattedMessage {...messages.childList} />
            </Typography>
          </Grid>
        </Fade>
        <Grid item>
          <Fade in={!parentData?.name}>
            <span>
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
            </span>
          </Fade>
        </Grid>
        <Grid item xs={12}>
          <GroupList
            isLoading={props.isLoading}
            groups={props.groups}
            groupTotal={props.groupTotal}
            defaultParams={params}
            deleteGroupBegin={props.deleteGroupBegin}
            handleParentExpand={handleParentExpand}
            handlePagination={handlePagination}
            viewChildren={!displayMyGroups}
            customTexts={props.customTexts}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

UserGroupListPage.propTypes = {
  classes: PropTypes.object,
  getGroupsBegin: PropTypes.func.isRequired,
  groupAllUnmount: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  groups: PropTypes.array,
  user: PropTypes.object,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
  isLoading: selectGroupIsLoading(),
  permissions: selectPermissions(),
  user: selectUser(),
  customTexts: selectCustomText(),
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
  withStyles(styles),
  memo,
)(Conditional(
  UserGroupListPage,
  ['permissions.groups_view'],
  (props, rs) => ROUTES.user.home.path(),
  permissionMessages.group.userListPage
));
