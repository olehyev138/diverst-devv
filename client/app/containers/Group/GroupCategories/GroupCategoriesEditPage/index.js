import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Group/GroupCategories/saga';
import reducer from 'containers/Group/GroupCategories/reducer';

import { updateGroupCategoriesBegin, categoriesUnmount, getGroupCategoryBegin } from 'containers/Group/GroupCategories/actions';
import { selectPaginatedSelectGroupCategories, selectFormGroupCategories, selectGroupCategoriesIsCommitting } from 'containers/Group/GroupCategories/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import GroupCategoriesForm from 'components/Group/GroupCategories/GroupCategoriesForm';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/GroupCategories/messages';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function GroupCategoriesEditPage(props) {
  useInjectReducer({ key: 'groupCategories', reducer });
  useInjectSaga({ key: 'groupCategories', saga });
  const { intl } = props;

  const { group_category_type_id: groupCategoryTypeId } = useParams();

  useEffect(() => {
    props.getGroupCategoryBegin({ id: groupCategoryTypeId });
    return () => {
      props.categoriesUnmount();
    };
  }, []);
  return (
    <React.Fragment>
      <GroupCategoriesForm
        edit
        groupCategoriesAction={props.updateGroupCategoriesBegin}
        groupCategories={props.groupCategories}
        groupCategory={props.groupCategory}
        buttonText={intl.formatMessage(messages.update)}
        isCommitting={props.isCommitting}
        isFormLoading={props.isFormLoading}
      />
    </React.Fragment>
  );
}

GroupCategoriesEditPage.propTypes = {
  groupCategory: PropTypes.object,
  groupCategories: PropTypes.array,
  isFormLoading: PropTypes.bool,
  intl: intlShape,
  updateGroupCategoriesBegin: PropTypes.func,
  getGroupCategoryBegin: PropTypes.func,
  categoriesUnmount: PropTypes.func,
  categories: PropTypes.array,
  isCommitting: PropTypes.bool,

};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  groupCategory: selectFormGroupCategories(),
  groupCategories: selectPaginatedSelectGroupCategories(),
  currentEnterprise: selectEnterprise(),
  isCommitting: selectGroupCategoriesIsCommitting(),
});

const mapDispatchToProps = {
  updateGroupCategoriesBegin,
  getGroupCategoryBegin,
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
  GroupCategoriesEditPage,
  ['permissions.groups_manage'],
  (props, params) => ROUTES.admin.manage.groups.index.path(),
  permissionMessages.group.groupCategories.editPage
));
