import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Region/reducer';
import saga from 'containers/Region/saga';
import groupSaga from 'containers/Group/saga';
import groupReducer from 'containers/Group/reducer';

import { getRegionBegin, updateRegionBegin, regionFormUnmount } from 'containers/Region/actions';
import { getGroupBegin, getGroupsBegin, groupListUnmount } from 'containers/Group/actions';
import { selectFormRegion, selectRegionIsFormLoading, selectRegionIsCommitting } from 'containers/Region/selectors';
import { selectGroup, selectGroupIsFormLoading, selectPaginatedSelectGroups } from 'containers/Group/selectors';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Region/messages';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

import RegionForm from 'components/Region/RegionForm';

export function GroupRegionEditPage(props) {
  useInjectReducer({ key: 'regions', reducer });
  useInjectSaga({ key: 'regions', saga });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });

  const { intl } = props;

  const { group_id: groupId, region_id: regionId } = useParams();

  useEffect(() => {
    props.getGroupBegin({ id: groupId });
    props.getRegionBegin({ id: regionId });

    return () => {
      props.groupListUnmount();
      props.regionFormUnmount();
    };
  }, []);

  return (
    <RegionForm
      edit
      isFormLoading={props.parentGroupIsLoading && props.regionIsLoading}
      parentGroup={props.parentGroup}
      region={props.region}
      regionAction={props.updateRegionBegin}
      buttonText={intl.formatMessage(messages.update)}
      getGroupsBegin={props.getGroupsBegin}
      selectGroups={props.selectGroups}
      isCommitting={props.isCommitting}
    />
  );
}

GroupRegionEditPage.propTypes = {
  intl: intlShape.isRequired,
  region: PropTypes.object,
  getRegionBegin: PropTypes.func,
  regionIsLoading: PropTypes.bool,
  regionFormUnmount: PropTypes.func,
  updateRegionBegin: PropTypes.func,
  getGroupBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  groupListUnmount: PropTypes.func,
  getGroupsSuccess: PropTypes.func,
  parentGroup: PropTypes.object,
  parentGroupIsLoading: PropTypes.bool,
  selectGroups: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  region: selectFormRegion(),
  regionIsLoading: selectRegionIsFormLoading(),
  parentGroup: selectGroup(),
  parentGroupIsLoading: selectGroupIsFormLoading(),
  selectGroups: selectPaginatedSelectGroups(),
  isCommitting: selectRegionIsCommitting(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getRegionBegin,
  regionFormUnmount,
  updateRegionBegin,
  getGroupBegin,
  getGroupsBegin,
  groupListUnmount,
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
  GroupRegionEditPage,
  ['permissions.groups_manage'],
  (props, rs) => ROUTES.admin.manage.groups.index.path(),
  permissionMessages.group.editRegionsPage
));
