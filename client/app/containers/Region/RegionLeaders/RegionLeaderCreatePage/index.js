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

import { createRegionLeaderBegin, regionLeadersUnmount } from 'containers/Region/RegionLeaders/actions';
import { selectIsCommitting } from 'containers/Region/RegionLeaders/selectors';

import { selectPaginatedSelectMembers, selectIsFetchingMembers } from 'containers/Group/GroupMembers/selectors';
import { getMembersBegin, groupMembersUnmount } from 'containers/Group/GroupMembers/actions';

import { selectPaginatedSelectUserRoles } from 'containers/User/UserRole/selectors';
import { getUserRolesBegin, userRoleUnmount } from 'containers/User/UserRole/actions';

import { selectCustomText } from 'containers/Shared/App/selectors';

import RegionLeaderForm from 'components/Region/RegionLeaders/RegionLeaderForm';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Region/RegionLeaders/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function RegionLeaderCreatePage(props) {
  useInjectReducer({ key: 'regionLeaders', reducer });
  useInjectSaga({ key: 'regionLeaders', saga });
  useInjectReducer({ key: 'members', reducer: memberReducer });
  useInjectSaga({ key: 'members', saga: memberSaga });
  useInjectReducer({ key: 'roles', reducer: userRoleReducer });
  useInjectSaga({ key: 'roles', saga: userRoleSaga });

  const { intl } = props;
  const { isCommitting, members, currentRegion, ...rest } = props;

  const { region_id: regionId } = useParams();

  const links = {
    index: ROUTES.region.leaders.index.path(regionId),
  };

  useEffect(() => {
    props.getUserRolesBegin({ role_type: 'group' });
    props.getMembersBegin({
      count: 25, page: 0, order: 'asc',
      group_id: currentRegion.parent_id,
      query_scopes: ['active', 'accepted_users', ['user_search', '']]
    });

    return () => {
      props.regionLeadersUnmount();
      props.groupMembersUnmount();
      props.userRoleUnmount();
    };
  }, []);

  return (
    <RegionLeaderForm
      regionLeaderAction={props.createRegionLeaderBegin}
      buttonText={intl.formatMessage(messages.create, props.customTexts)}
      region={currentRegion}
      regionId={regionId}
      getMembersBegin={props.getMembersBegin}
      selectMembers={members}
      userRoles={props.userRoles}
      isCommitting={isCommitting}
      links={links}
      isLoadingMembers={props.isLoadingMembers}
      customTexts={props.customTexts}
    />
  );
}

RegionLeaderCreatePage.propTypes = {
  intl: intlShape.isRequired,
  createRegionLeaderBegin: PropTypes.func,
  regionLeadersUnmount: PropTypes.func,
  getMembersBegin: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  getUserRolesBegin: PropTypes.func,
  userRoleUnmount: PropTypes.func,
  members: PropTypes.array,
  userRoles: PropTypes.array,
  regionLeaders: PropTypes.array,
  isCommitting: PropTypes.bool,
  isLoadingMembers: PropTypes.bool,
  currentRegion: PropTypes.object,
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  members: selectPaginatedSelectMembers(),
  userRoles: selectPaginatedSelectUserRoles(),
  isCommitting: selectIsCommitting(),
  isLoadingMembers: selectIsFetchingMembers(),
  customTexts: selectCustomText(),
});

const mapDispatchToProps = {
  createRegionLeaderBegin,
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
  RegionLeaderCreatePage,
  ['currentRegion.permissions.leaders_create?'],
  (props, params) => ROUTES.region.leaders.index.path(params.region_id),
  permissionMessages.region.leaders.createPage
));
