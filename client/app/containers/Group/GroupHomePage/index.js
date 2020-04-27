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
import { selectGroup, selectHasChanged } from 'containers/Group/selectors';

export function GroupHomePage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  return (
    <GroupHome
      currentGroup={props.currentGroup}
      joinGroup={props.joinGroupBegin}
      leaveGroup={props.leaveGroupBegin}
      joinSubgroups={props.joinSubgroupsBegin}
    />
  );
}

GroupHomePage.propTypes = {
  currentGroup: PropTypes.object,
  joinGroupBegin: PropTypes.func,
  leaveGroupBegin: PropTypes.func,
  joinSubgroupsBegin: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  group: selectGroup(),
});

const mapDispatchToProps = {
  joinGroupBegin,
  leaveGroupBegin,
  joinSubgroupsBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  memo,
  withConnect,
)(GroupHomePage);
