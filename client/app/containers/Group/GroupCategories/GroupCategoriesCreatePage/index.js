import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Group/GroupCategories/saga';
import reducer from 'containers/Group/GroupCategories/reducer';

import { createGroupCategoriesBegin, categoriesUnmount } from 'containers/Group/GroupCategories/actions';
import { selectPaginatedGroupCategories, selectIsCommitting } from 'containers/Group/GroupCategories/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import GroupCategoriesForm from 'components/Group/GroupCategories/GroupCategoriesForm';
import messages from 'containers/Group/GroupCategories/messages';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function GroupCategoriesCreatePage(props) {
  useInjectReducer({ key: 'groupCategories', reducer });
  useInjectSaga({ key: 'groupCategories', saga });
  useEffect(() => () => props.categoriesUnmount(), []);

  return (
    <GroupCategoriesForm
      groupCategoriesAction={props.createGroupCategoriesBegin}
      buttonText={messages.create}
      categories={props.categories}
      isCommitting={props.isCommitting}
    />
  );
}

GroupCategoriesCreatePage.propTypes = {
  createGroupCategoriesBegin: PropTypes.func,
  categoriesUnmount: PropTypes.func,
  categories: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  groupCategories: selectPaginatedGroupCategories(),
  currentEnterprise: selectEnterprise(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createGroupCategoriesBegin,
  categoriesUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  GroupCategoriesCreatePage,
  ['permissions.groups_manage'],
  (props, params) => ROUTES.admin.manage.groups.index.path(),
  permissionMessages.group.groupCategories.createPage
));
