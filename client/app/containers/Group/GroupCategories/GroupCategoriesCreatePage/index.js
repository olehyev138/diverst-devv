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
import GroupCategoriesForm from 'components/Group/GroupCategories/GroupCategoriesForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/messages';

export function GroupCategoriesCreatePage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  const { intl } = props;
  useEffect(() => () => props.categoriesUnmount(), []);

  return (
    <GroupCategoriesForm
      // groupAction={props.createGroupBegin}
      buttonText='Create'
      getGroupsBegin={props.getGroupCategoriesBegin}
      selectGroups={props.groups}
      isCommitting={props.isCommitting}
    />
  );
}

GroupCategoriesCreatePage.propTypes = {
  intl: intlShape,
  createGroupBegin: PropTypes.func,
  getGroupCategoriesBegin: PropTypes.func,
  categoriesUnmount: PropTypes.func,
  groups: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  // groups: selectPaginatedSelectGroups(),
  // isCommitting: selectGroupIsCommitting(),
});

const mapDispatchToProps = {
  // createGroupBegin,
  getGroupCategoriesBegin,
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
)(GroupCategoriesCreatePage);
