/**
 *
 * AdminGroupListPage
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import { Button, Grid, Typography, Fade, Box } from '@material-ui/core';
import { injectIntl, intlShape } from 'react-intl';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import {
  selectPaginatedGroups,
  selectGroupTotal,
  selectGroupIsLoading,
  selectHasChanged
} from 'containers/Group/selectors';

import saga from 'containers/Group/saga';
import reducer from 'containers/Group/reducer';

import { getGroupsBegin, groupAllUnmount, deleteGroupBegin, updateGroupPositionBegin } from 'containers/Group/actions';

import messages from 'containers/Group/messages';

import GroupList from 'components/Group/AdminGroupList';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectPermissions, selectCustomText } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';
import { createCsvFileBegin } from 'containers/Shared/CsvFile/actions';
import csvReducer from 'containers/Shared/CsvFile/reducer';
import csvSaga from 'containers/Shared/CsvFile/saga';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

const styles = theme => ({
  headerText: {
    fontWeight: 'bold',
  },
});

const defaultGroupsParams = Object.freeze({
  count: 5,
  page: 0,
  orderBy: 'position',
  order: 'asc',
  query_scopes: ['all_parents'],
  with_children: false
});

export function AdminGroupListPage({ classes, ...props }) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  useInjectReducer({ key: 'csv_files', reducer: csvReducer });
  useInjectSaga({ key: 'csv_files', saga: csvSaga });

  const { intl } = props;

  const [displayParentUI, setDisplayParentUI] = useState(false);
  const [parentData, setParentData] = useState(undefined);

  const [params, setParams] = useState(defaultGroupsParams);

  useEffect(() => {
    props.getGroupsBegin(params);

    return () => props.groupAllUnmount();
  }, []);

  useEffect(() => {
    if (parentData === undefined || !parentData?.id) return;

    const newParams = { ...defaultGroupsParams, query_scopes: [['children_of', parentData?.id]] };

    props.getGroupsBegin(newParams);
    setParams(newParams);
  }, [parentData?.id]);

  const handleParentExpand = (id, name) => setParentData({ id, name });

  const handleFinishExitTransition = () => setDisplayParentUI(true);

  useEffect(() => props.hasChanged && getGroups(), [props.hasChanged]);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getGroupsBegin(newParams);
    setParams(newParams);
  };

  const getGroups = () => {
    const newParams = { ...defaultGroupsParams, order: params.order, orderBy: params.orderBy };

    setParentData({ name: parentData?.name });
    setDisplayParentUI(false);
    props.getGroupsBegin(newParams);
    setParams(newParams);
  };

  const positions = [];
  for (let i = 0; i < props.groups.length; i += 1)
    positions[i] = { id: props.groups[i].id, position: props.groups[i].position };

  return (
    <React.Fragment>
      <Fade
        in={displayParentUI}
        appear
        mountOnEnter
        unmountOnExit
        onExited={() => setParentData(null)}
      >
        <Box pt={1} pb={3}>
          <Grid container spacing={3}>
            <Grid item>
              <Button
                size='small'
                color='primary'
                variant='contained'
                onClick={() => {
                  setParentData({ name: parentData?.name });
                  getGroups();
                }}
              >
                <DiverstFormattedMessage {...messages.back} />
              </Button>
            </Grid>
            <Grid item xs align='center'>
              <Typography component='span' color='primary' variant='h5' className={classes.headerText}>
                {parentData?.name}
              </Typography>
              &nbsp;
              &nbsp;
              <Typography component='span' color='textSecondary' variant='h5' className={classes.headerText}>
                <DiverstFormattedMessage {...messages.childList} />
              </Typography>
            </Grid>
          </Grid>
        </Box>
      </Fade>
      <GroupList
        isLoading={props.isLoading}
        groups={props.groups}
        positions={positions}
        groupTotal={props.groupTotal}
        defaultParams={params}
        deleteGroupBegin={props.deleteGroupBegin}
        updateGroupPositionBegin={props.updateGroupPositionBegin}
        handleParentExpand={handleParentExpand}
        handleFinishExitTransition={handleFinishExitTransition}
        isDisplayingChildren={!!parentData?.name}
        handlePagination={handlePagination}
        importAction={props.createCsvFileBegin}
        permissions={props.permissions}
        intl={intl}
        customTexts={props.customTexts}
      />
    </React.Fragment>
  );
}

AdminGroupListPage.propTypes = {
  classes: PropTypes.object,
  getGroupsBegin: PropTypes.func.isRequired,
  groupAllUnmount: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  hasChanged: PropTypes.bool,
  groups: PropTypes.array,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  updateGroupPositionBegin: PropTypes.func,
  createCsvFileBegin: PropTypes.func,
  permissions: PropTypes.object,
  intl: intlShape.isRequired,
  customTexts: PropTypes.object
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectGroupIsLoading(),
  hasChanged: selectHasChanged(),
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
  permissions: selectPermissions(),
  customTexts: selectCustomText(),
});

const mapDispatchToProps = {
  getGroupsBegin,
  groupAllUnmount,
  deleteGroupBegin,
  createCsvFileBegin,
  updateGroupPositionBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  withConnect,
  withStyles(styles),
  memo,
)(Conditional(
  AdminGroupListPage,
  ['permissions.groups_create'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.group.adminListPage
));
