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

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedGroups, selectGroupTotal, selectGroupIsLoading } from 'containers/Group/selectors';

import saga from 'containers/Group/saga';
import reducer from 'containers/Group/reducer';

import { getGroupsBegin, groupAllUnmount, deleteGroupBegin, updateGroupPositionBegin } from 'containers/Group/actions';
import GroupList from 'components/Group/AdminGroupList';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { injectIntl, intlShape } from 'react-intl';

import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';
import { createCsvFileBegin } from 'containers/Shared/CsvFile/actions';
import csvReducer from 'containers/Shared/CsvFile/reducer';
import csvSaga from 'containers/Shared/CsvFile/saga';

export function AdminGroupListPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  useInjectReducer({ key: 'csv_files', reducer: csvReducer });
  useInjectSaga({ key: 'csv_files', saga: csvSaga });

  const { intl } = props;

  const [params, setParams] = useState({ count: 5, page: 0, orderBy: 'position', order: 'asc', query_scopes: ['all_parents'] });

  useEffect(() => {
    props.getGroupsBegin(params);

    return () => props.groupAllUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getGroupsBegin(newParams);
    setParams(newParams);
  };

  const positions = [];
  for (let i = 0; i < props.groups.length; i += 1)
    positions[i] = { id: props.groups[i].id, position: props.groups[i].position };

  return (
    <React.Fragment>
      <GroupList
        isLoading={props.isLoading}
        groups={props.groups}
        positions={positions}
        groupTotal={props.groupTotal}
        defaultParams={params}
        deleteGroupBegin={props.deleteGroupBegin}
        updateGroupPositionBegin={props.updateGroupPositionBegin}
        handlePagination={handlePagination}
        importAction={props.createCsvFileBegin}
        intl={intl}
      />
    </React.Fragment>
  );
}

AdminGroupListPage.propTypes = {
  getGroupsBegin: PropTypes.func.isRequired,
  groupAllUnmount: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  groups: PropTypes.array,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  updateGroupPositionBegin: PropTypes.func,
  createCsvFileBegin: PropTypes.func,
  intl: intlShape.isRequired,
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectGroupIsLoading(),
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
  permissions: selectPermissions(),
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
  memo,
)(Conditional(
  AdminGroupListPage,
  ['permissions.groups_create'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.group.adminListPage
));
