import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedSelectGroups, selectGroupTotal } from 'containers/Group/selectors';
import reducer from 'containers/Group/reducer';

import { createGroupBegin, getGroupsBegin, groupFormUnmount } from 'containers/Group/actions';

import saga from 'containers/Group/saga';

import GroupForm from 'components/Group/GroupForm';

export function GroupCreatePage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  useEffect(() => {
    return () => {
      props.groupFormUnmount();
    };
  }, []);

  return (
    <GroupForm
      groupAction={props.createGroupBegin}
      buttonText='Create'
      getGroupsBegin={props.getGroupsBegin}
      selectGroups={props.groups}
    />
  );
}

GroupCreatePage.propTypes = {
  createGroupBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups()
});

function mapDispatchToProps(dispatch) {
  return {
    createGroupBegin: payload => dispatch(createGroupBegin(payload)),
    getGroupsBegin: payload => dispatch(getGroupsBegin(payload)),
    groupFormUnmount: () => dispatch(groupFormUnmount())
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
