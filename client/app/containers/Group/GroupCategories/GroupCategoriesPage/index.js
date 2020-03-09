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

import { getGroupCategoriesBegin, categoriesUnmount } from 'containers/Group/GroupCategories/actions';
import { selectPaginatedGroupCategories, selectGroupCategoriesTotal, selectGroupCategoriesIsLoading } from 'containers/Group/GroupCategories/selectors';
import GroupCategoriesList from 'components/Group/GroupCategories/GroupCategoriesList';


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
      />
    </React.Fragment>
  );
}

GroupCategoriesPage.propTypes = {
  getGroupCategoriesBegin: PropTypes.func.isRequired,
  categoriesUnmount: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  groupCategories: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectGroupCategoriesIsLoading(),
  groupCategories: selectPaginatedGroupCategories(),
  groupCategoriesTotal: selectGroupCategoriesTotal(),
});
const mapDispatchToProps = {
  getGroupCategoriesBegin,
  categoriesUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupCategoriesPage);
