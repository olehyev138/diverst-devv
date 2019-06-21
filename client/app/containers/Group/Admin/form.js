import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib/';
import { compose } from 'redux/';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedGroups, selectGroupTotal } from 'containers/Group/selectors';
import reducer from 'containers/Group/reducer';
import { getGroupsBegin } from 'containers/Group/actions';

import saga from 'containers/Group/saga';

import GroupFormComponent from 'components/Admin/Manage/Groups/form';

export function GroupForm(props) {
  return (
    <GroupFormComponent />
  );
}

const mapStateToProps = createStructuredSelector({
});

function mapDispatchToProps(dispatch) {
  return {
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupForm);
