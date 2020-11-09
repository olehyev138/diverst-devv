import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';
import { injectIntl, intlShape } from 'react-intl';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Region/saga';
import reducer from 'containers/Region/reducer';
import groupSaga from 'containers/Group/saga';
import groupReducer from 'containers/Group/reducer';

import { getGroupRegionsBegin, deleteRegionBegin, regionListUnmount } from 'containers/Region/actions';
import { getGroupBegin, groupFormUnmount } from 'containers/Group/actions';
import { selectGroup, selectGroupIsFormLoading } from 'containers/Group/selectors';
import { selectPaginatedRegions, selectRegionTotal, selectRegionIsLoading } from 'containers/Region/selectors';
import { selectPermissions, selectCustomText } from 'containers/Shared/App/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

import GroupRegionsList from 'components/Region/GroupRegionsList';

export function GroupRegionsListPage(props) {
  useInjectReducer({ key: 'regions', reducer });
  useInjectSaga({ key: 'regions', saga });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });

  const { group_id: groupId } = useParams();

  const [params, setParams] = useState({ count: 5, page: 0, orderBy: 'position', order: 'asc' });

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getGroupRegionsBegin({ ...newParams, group_id: groupId });
    setParams(newParams);
  };

  useEffect(() => {
    props.getGroupBegin({ id: groupId });
    props.getGroupRegionsBegin({ ...params, group_id: groupId });
    return () => {
      props.groupFormUnmount();
      props.regionListUnmount();
    };
  }, []);

  return (
    <GroupRegionsList
      group={props.group}
      regions={props.regions}
      regionTotal={props.regionTotal}
      deleteRegionBegin={props.deleteRegionBegin}
      isLoading={props.isGroupLoading}
      isRegionsLoading={props.isRegionsLoading}
      handlePagination={handlePagination}
      params={params}
      permissions={props.permissions}
      customTexts={props.customTexts}
      intl={props.intl}
    />
  );
}

GroupRegionsListPage.propTypes = {
  getGroupBegin: PropTypes.func,
  getGroupRegionsBegin: PropTypes.func,
  deleteRegionBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func,
  regionListUnmount: PropTypes.func,
  group: PropTypes.object,
  regions: PropTypes.array,
  regionTotal: PropTypes.number,
  isGroupLoading: PropTypes.bool,
  isRegionsLoading: PropTypes.bool,
  permissions: PropTypes.object,
  customTexts: PropTypes.object,
  intl: intlShape.isRequired,
};

const mapStateToProps = createStructuredSelector({
  group: selectGroup(),
  regions: selectPaginatedRegions(),
  regionTotal: selectRegionTotal(),
  isGroupLoading: selectGroupIsFormLoading(),
  isRegionsLoading: selectRegionIsLoading(),
  permissions: selectPermissions(),
  customTexts: selectCustomText(),
});

const mapDispatchToProps = {
  getGroupBegin,
  getGroupRegionsBegin,
  deleteRegionBegin,
  groupFormUnmount,
  regionListUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  injectIntl,
  memo,
)(Conditional(
  GroupRegionsListPage,
  ['permissions.groups_view'],
  (props, params) => ROUTES.admin.manage.groups.index.path(),
  permissionMessages.group.manageRegionsPage
));
