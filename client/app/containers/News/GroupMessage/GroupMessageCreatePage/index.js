import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import {
  createGroupMessageBegin, newsFeedUnmount
} from 'containers/News/actions';

import GroupMessageForm from 'components/News/GroupMessage/GroupMessageForm';

export function GroupMessageCreatePage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  useEffect(() => () => props.newsFeedUnmount(), []);

  const { currentUser, currentGroup } = props;

  return (
    <GroupMessageForm
      groupMessageAction={props.createGroupMessageBegin}
      buttonText='Create'
      currentUser={currentUser}
      currentGroup={currentGroup}
    />
  );
}

GroupMessageCreatePage.propTypes = {
  createGroupMessageBegin: PropTypes.func,
  newsFeedUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser()
});

const mapDispatchToProps = {
  createGroupMessageBegin,
  newsFeedUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupMessageCreatePage);
