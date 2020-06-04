import React, { memo, useContext, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Group/GroupCategories/saga';
import reducer from 'containers/Group/GroupCategories/reducer';
import groupSaga from 'containers/Group/saga';
import groupReducer from 'containers/Group/reducer';

import { getGroupCategoriesBegin } from 'containers/Group/GroupCategories/actions';
import { groupCategorizeUnmount, groupCategorizeBegin, getGroupBegin } from 'containers/Group/actions';
import {
  selectPaginatedSelectGroups,
  selectCategorizeGroup,
  selectGroupIsFormLoading
} from 'containers/Group/selectors';
import { selectPaginatedSelectGroupCategories, selectGroupCategoriesIsCommitting } from 'containers/Group/GroupCategories/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import GroupCategorizeForm from 'components/Group/GroupCategorize';
import RouteService from 'utils/routeHelpers';
import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function GroupCategorizePage(props) {
  useInjectReducer({ key: 'groupCategories', reducer });
  useInjectSaga({ key: 'groupCategories', saga });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });

  const rs = new RouteService(useContext);

  useEffect(() => {
    props.getGroupBegin({ id: rs.params('group_id') });
    props.getGroupCategoriesBegin();
    return () => {
      props.groupCategorizeUnmount();
    };
  }, []);

  return (
    <GroupCategorizeForm
      group={props.group}
      groupAction={props.groupCategorizeBegin}
      categories={props.categories}
      isCommitting={props.isCommitting}
    />
  );
}

GroupCategorizePage.propTypes = {
  getGroupBegin: PropTypes.func,
  groupCategorizeBegin: PropTypes.func,
  groupCategorizeUnmount: PropTypes.func,
  getGroupCategoriesBegin: PropTypes.func,
  group: PropTypes.object,
  groups: PropTypes.array,
  categories: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  group: selectCategorizeGroup(),
  currentUser: selectUser(),
  categories: selectPaginatedSelectGroupCategories(),
  currentEnterprise: selectEnterprise(),
  isCommitting: selectGroupCategoriesIsCommitting(),
  isFormLoading: selectGroupIsFormLoading(),
});

const mapDispatchToProps = {
  getGroupBegin,
  groupCategorizeBegin,
  getGroupCategoriesBegin,
  groupCategorizeUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  GroupCategorizePage,
  ['group.permissions.update?', 'isFormLoading'],
  (props, rs) => ROUTES.admin.manage.groups.index.path(),
  permissionMessages.group.categorizePage
));
