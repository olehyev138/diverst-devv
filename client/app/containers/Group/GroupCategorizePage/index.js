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

import { createGroupCategoriesBegin, getGroupCategoriesBegin, categoriesUnmount } from 'containers/Group/GroupCategories/actions';
import { getGroupsBegin, groupCategorizeUnmount, updateGroupBegin, getGroupBegin } from 'containers/Group/actions';
import { selectPaginatedSelectGroups, selectFormGroup, selectCategorizeGroup } from 'containers/Group/selectors';
import { selectPaginatedSelectGroupCategories, selectGroupCategoriesIsCommitting } from 'containers/Group/GroupCategories/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import GroupCategorizeForm from 'components/Group/GroupCategorize';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/messages';
import RouteService from 'utils/routeHelpers';
import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';

const changePage = id => push(ROUTES.admin.manage.groups.categorize.path(id));

export function GroupCategorizePage(props) {
  useInjectReducer({ key: 'groupCategories', reducer });
  useInjectSaga({ key: 'groupCategories', saga });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });

  const { intl } = props;
  const rs = new RouteService(useContext);

  useEffect(() => {
    props.getGroupBegin({ id: rs.params('group_id') });
    props.getGroupsBegin();
    props.getGroupCategoriesBegin();
    return () => {
      props.groupCategorizeUnmount();
    };
  }, []);
  return (
    <GroupCategorizeForm
      group={props.group}
      selectGroups={props.groups}
      groupCategoriesAction={props.updateGroupBegin}
      buttonText='Save'
      categories={props.categories}
      isCommitting={props.isCommitting}
      changePage={props.changePage}
    />
  );
}

GroupCategorizePage.propTypes = {
  intl: intlShape,
  getGroupBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  updateGroupBegin: PropTypes.func,
  groupCategorizeUnmount: PropTypes.func,
  getGroupCategoriesBegin: PropTypes.func,
  changePage: PropTypes.func,
  group: PropTypes.object,
  groups: PropTypes.array,
  categories: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  group: selectCategorizeGroup(),
  groups: selectPaginatedSelectGroups(),
  currentUser: selectUser(),
  categories: selectPaginatedSelectGroupCategories(),
  currentEnterprise: selectEnterprise(),
  isCommitting: selectGroupCategoriesIsCommitting(),
});

const mapDispatchToProps = {
  getGroupBegin,
  getGroupsBegin,
  updateGroupBegin,
  getGroupCategoriesBegin,
  groupCategorizeUnmount,
  changePage,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  withConnect,
  memo,
)(GroupCategorizePage);
