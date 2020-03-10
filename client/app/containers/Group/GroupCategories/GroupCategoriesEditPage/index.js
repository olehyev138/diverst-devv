import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Group/GroupCategories/saga';
import reducer from 'containers/Group/GroupCategories/reducer';

import { getGroupCategoriesBegin, updateGroupCategoriesBegin, categoriesUnmount } from 'containers/Group/GroupCategories/actions';
import { selectPaginatedGroupCategories, selectGroupCategoriesIsCommitting } from 'containers/Group/GroupCategories/selectors';
import { selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import GroupCategoriesForm from 'components/Group/GroupCategories/GroupCategoriesForm';

import RouteService from 'utils/routeHelpers';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/messages';

export function GroupCategoriesEditPage(props) {
  useInjectReducer({ key: 'groupCategories', reducer });
  useInjectSaga({ key: 'groupCategories', saga });
  const { intl } = props;
  const rs = new RouteService(useContext);

  useEffect(() => {
    props.getGroupCategoriesBegin({ id: rs.params('group_id') });

    return () => {
      props.categoriesUnmount();
    };
  }, []);
  console.log('container');
  console.log(props);

  return (
    <React.Fragment>
      <GroupCategoriesForm
        edit
        groupAction={props.updateGroupCategoriesBegin}
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
  isFormLoading: PropTypes.bool,
  intl: intlShape,
  updateGroupCategoriesBegin: PropTypes.func,
  getGroupCategoriesBegin: PropTypes.func,
  categoriesUnmount: PropTypes.func,
  categories: PropTypes.array,
  isCommitting: PropTypes.bool,

};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  groupCategories: selectPaginatedGroupCategories(),
  currentEnterprise: selectEnterprise(),
  isCommitting: selectGroupCategoriesIsCommitting(),
});

const mapDispatchToProps = {
  updateGroupCategoriesBegin,
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
)(GroupCategoriesEditPage);
