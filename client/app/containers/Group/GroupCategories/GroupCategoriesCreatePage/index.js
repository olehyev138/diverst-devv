import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Group/GroupCategories/saga';
import reducer from 'containers/Group/GroupCategories/reducer';

import { createGroupCategoriesBegin, getGroupCategoriesBegin, categoriesUnmount } from 'containers/Group/GroupCategories/actions';
import { selectPaginatedGroupCategories, selectIsCommitting } from 'containers/Group/GroupCategories/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import GroupCategoriesForm from 'components/Group/GroupCategories/GroupCategoriesForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/GroupCategories/messages';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function GroupCategoriesCreatePage(props) {
  useInjectReducer({ key: 'groupCategories', reducer });
  useInjectSaga({ key: 'groupCategories', saga });
  const { intl } = props;
  useEffect(() => () => props.categoriesUnmount(), []);

  return (
    <GroupCategoriesForm
      groupCategoriesAction={props.createGroupCategoriesBegin}
      buttonText={intl.formatMessage(messages.create)}
      categories={props.categories}
      isCommitting={props.isCommitting}
    />
  );
}

GroupCategoriesCreatePage.propTypes = {
  intl: intlShape,
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  GroupCategoriesCreatePage,
  ['permissions.groups_manage'],
  (props, rs) => ROUTES.admin.manage.groups.index.path(),
  permissionMessages.group.groupCategories.createPage
));
