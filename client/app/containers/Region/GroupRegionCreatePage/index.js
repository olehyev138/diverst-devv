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

import { createRegionBegin } from 'containers/Region/actions';
import { getGroupBegin, getGroupsBegin, groupListUnmount } from 'containers/Group/actions';
import { selectRegionIsCommitting } from 'containers/Region/selectors';
import { selectGroup, selectGroupIsFormLoading, selectPaginatedSelectGroups } from 'containers/Group/selectors';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Region/messages';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

import RegionForm from 'components/Region/RegionForm';

export function GroupRegionCreatePage(props) {
  useInjectReducer({ key: 'regions', reducer });
  useInjectSaga({ key: 'regions', saga });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });

  const { intl } = props;

  const { group_id: groupId } = useParams();

  useEffect(() => {
    props.getGroupBegin({ id: groupId });

    return () => props.groupListUnmount();
  }, []);

  // Even though the parent field is hidden on the form and doesn't use a select,
  // we have to set up the default parent object as a select object in order to set the value to send to the server
  const defaultRegionObject = props.parentGroup ? {
    parent: { label: props.parentGroup.name, value: props.parentGroup.id }
  } : {};

  return (
    <RegionForm
      isFormLoading={props.parentGroupIsLoading}
      parentGroup={props.parentGroup}
      region={defaultRegionObject}
      regionAction={props.createRegionBegin}
      buttonText={intl.formatMessage(messages.create)}
      getGroupsBegin={props.getGroupsBegin}
      selectGroups={props.selectGroups}
      isCommitting={props.isCommitting}
    />
  );
}

GroupRegionCreatePage.propTypes = {
  intl: intlShape.isRequired,
  createRegionBegin: PropTypes.func,
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
  parentGroup: selectGroup(),
  parentGroupIsLoading: selectGroupIsFormLoading(),
  selectGroups: selectPaginatedSelectGroups(),
  isCommitting: selectRegionIsCommitting(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  createRegionBegin,
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
  GroupRegionCreatePage,
  ['permissions.groups_create'],
  (props, rs) => ROUTES.admin.manage.groups.index.path(),
  permissionMessages.group.createRegionsPage
));
