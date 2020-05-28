import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import saga from 'containers/Group/saga';

import GroupHome from 'components/Group/GroupHome';

import {
  joinGroupBegin,
  leaveGroupBegin,
  joinSubgroupsBegin
} from 'containers/Group/actions';
import {
  getSubgroupCategoriesBegin,
  categoriesUnmount
} from 'containers/Group/GroupCategories/actions';
import categoriesReducer from 'containers/Group/GroupCategories/reducer';
import categoriesSage from 'containers/Group/GroupCategories/saga';
import { selectSubgroupCategories } from 'containers/Group/GroupCategories/selectors';
import { selectGroup, selectHasChanged } from 'containers/Group/selectors';

export function GroupHomePage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  useInjectReducer({ key: 'categoriesReducer', reducer: categoriesReducer });
  useInjectSaga({ key: 'categoriesSage', saga: categoriesSage });
  console.log('container');
  console.log(props.currentGroup);
  useEffect(() => {
    props.getSubgroupCategoriesBegin({query_scopes: [['parent_group', props.currentGroup.id]]});
    return () => props.categoriesUnmount();
  }, []);
  console.log(props.subgroupCategories);
  return (
    <GroupHome
      currentGroup={props.currentGroup}
      joinGroup={props.joinGroupBegin}
      leaveGroup={props.leaveGroupBegin}
      joinSubgroups={props.joinSubgroupsBegin}
      subgroupCategories={props.subgroupCategories}
    />
  );
}

GroupHomePage.propTypes = {
  currentGroup: PropTypes.object,
  joinGroupBegin: PropTypes.func,
  leaveGroupBegin: PropTypes.func,
  joinSubgroupsBegin: PropTypes.func,
  getSubgroupCategoriesBegin: PropTypes.func,
  categoriesUnmount: PropTypes.func,
  subgroupCategories: PropTypes.object
};

const mapStateToProps = createStructuredSelector({
  group: selectGroup(),
  subgroupCategories: selectSubgroupCategories(),
});

const mapDispatchToProps = {
  joinGroupBegin,
  leaveGroupBegin,
  joinSubgroupsBegin,
  getSubgroupCategoriesBegin,
  categoriesUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  memo,
  withConnect,
)(GroupHomePage);
