/**
 *
 * GroupCategoriesPage
 *
 */
import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Group/GroupCategories/saga';
import reducer from 'containers/Group/GroupCategories/reducer';

import { getGroupCategoriesBegin, categoriesUnmount, deleteGroupCategoriesBegin } from 'containers/Group/GroupCategories/actions';
import { selectPaginatedGroupCategories, selectGroupCategoriesTotal, selectIsLoading } from 'containers/Group/GroupCategories/selectors';
import GroupCategoriesList from 'components/Group/GroupCategories/GroupCategoriesList';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function GroupCategoriesPage(props) {
  useInjectReducer({ key: 'groupCategories', reducer });
  useInjectSaga({ key: 'groupCategories', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  useEffect(() => {
    props.getGroupCategoriesBegin(params);

    return () => props.categoriesUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getGroupCategoriesBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <GroupCategoriesList
        isLoading={props.isLoading}
        categoryTypes={props.groupCategories}
        defaultParams={params}
        handlePagination={handlePagination}
        deleteGroupCategoriesBegin={props.deleteGroupCategoriesBegin}
        groupCategoriesTotal={props.groupCategoriesTotal}
      />
    </React.Fragment>
  );
}

GroupCategoriesPage.propTypes = {
  deleteGroupCategoriesBegin: PropTypes.func.isRequired,
  getGroupCategoriesBegin: PropTypes.func.isRequired,
  categoriesUnmount: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  groupCategories: PropTypes.object,
  groupCategoriesTotal: PropTypes.number,
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectIsLoading(),
  groupCategories: selectPaginatedGroupCategories(),
  groupCategoriesTotal: selectGroupCategoriesTotal(),
});
const mapDispatchToProps = {
  getGroupCategoriesBegin,
  categoriesUnmount,
  deleteGroupCategoriesBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  GroupCategoriesPage,
  ['permissions.groups_manage'],
  (props, rs) => ROUTES.admin.manage.groups.index.path(),
  permissionMessages.group.groupCategories.indexPage
));
