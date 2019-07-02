import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedGroups, selectGroupTotal } from 'containers/Group/selectors';
import reducer from 'containers/Group/reducer';

import { createGroupBegin } from 'containers/Group/actions';

import saga from 'containers/Group/saga';

import GroupForm from 'components/Group/GroupForm';

export function GroupCreatePage(props) {
  useInjectSaga({ key: 'groups', saga });

  return (
    <GroupForm
      groupAction={props.createGroupBegin}
      buttonText='Create'
    />
  );
}

const mapStateToProps = createStructuredSelector({
});

function mapDispatchToProps(dispatch) {
  return {
    createGroupBegin: payload => dispatch(createGroupBegin(payload)),
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupCreatePage);
