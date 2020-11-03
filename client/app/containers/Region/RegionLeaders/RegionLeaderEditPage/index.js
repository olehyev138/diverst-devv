import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Region/RegionLeaders/reducer';
import saga from 'containers/Region/RegionLeaders/saga';

import memberReducer from 'containers/Group/GroupMembers/reducer';
import memberSaga from 'containers/Group/GroupMembers/saga';

import userRoleReducer from 'containers/User/UserRole/reducer';
import userRoleSaga from 'containers/User/UserRole/saga';

import { selectPaginatedSelectMembers } from 'containers/Group/GroupMembers/selectors';
import { getMembersBegin, groupMembersUnmount } from 'containers/Group/GroupMembers/actions';

import { selectIsCommitting, selectFormRegionLeader, selectIsFormLoading } from 'containers/Region/RegionLeaders/selectors';
import { getRegionLeaderBegin, updateRegionLeaderBegin, regionLeadersUnmount } from 'containers/Region/RegionLeaders/actions';

import { selectPaginatedSelectUserRoles } from 'containers/User/UserRole/selectors';
import { getUserRolesBegin, userRoleUnmount } from 'containers/User/UserRole/actions';

import RegionLeaderForm from 'components/Region/RegionLeaders/RegionLeaderForm';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Region/RegionLeaders/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function RegionLeaderEditPage(props) {
  const { intl, members, regionLeader, isCommitting, isFormLoading, ...rest } = props;

  useInjectReducer({ key: 'regionLeaders', reducer });
  useInjectSaga({ key: 'regionLeaders', saga });
  useInjectReducer({ key: 'members', reducer: memberReducer });
  useInjectSaga({ key: 'members', saga: memberSaga });
  useInjectReducer({ key: 'roles', reducer: userRoleReducer });
  useInjectSaga({ key: 'roles', saga: userRoleSaga });

  const { region_id: regionId, leader_id: regionLeaderId } = useParams();

  const links = {
    index: ROUTES.region.leaders.index.path(regionId),
  };

  useEffect(() => {
    props.getRegionLeaderBegin({ region_id: regionId, id: regionLeaderId });
    props.getUserRolesBegin({ role_type: 'group' });

    return () => {
      props.regionLeadersUnmount();
      props.groupMembersUnmount();
      props.userRoleUnmount();
    };
  }, []);

  return (
    <RegionLeaderForm
      edit
      getRegionLeaderBegin={props.getRegionLeaderBegin}
      regionLeader={regionLeader}
      regionLeaderAction={props.updateRegionLeaderBegin}
      getMembersBegin={props.getMembersBegin}
      selectMembers={members}
      userRoles={props.userRoles}
      regionId={regionId}
      isCommitting={isCommitting}
      isFormLoading={isFormLoading}
      buttonText={intl.formatMessage(messages.update)}
      links={links}
    />
  );
}

RegionLeaderEditPage.propTypes = {
  intl: intlShape.isRequired,
  getRegionLeaderBegin: PropTypes.func,
  getGroupMembersBegin: PropTypes.func,
  updateRegionLeaderBegin: PropTypes.func,
  regionLeadersUnmount: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  userRoleUnmount: PropTypes.func,
  getMembersBegin: PropTypes.func,
  getUserRolesBegin: PropTypes.func,
  members: PropTypes.array,
  userRoles: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  regionLeader: PropTypes.object,
  regionLeaderId: PropTypes.string,
};

const mapStateToProps = createStructuredSelector({
  members: selectPaginatedSelectMembers(),
  regionLeader: selectFormRegionLeader(),
  userRoles: selectPaginatedSelectUserRoles(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  updateRegionLeaderBegin,
  getRegionLeaderBegin,
  getMembersBegin,
  getUserRolesBegin,
  regionLeadersUnmount,
  groupMembersUnmount,
  userRoleUnmount,
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
  RegionLeaderEditPage,
  ['currentRegion.permissions.leaders_manage?'],
  (props, params) => ROUTES.region.leaders.index.path(params.region_id),
  permissionMessages.region.leaders.editPage
));
