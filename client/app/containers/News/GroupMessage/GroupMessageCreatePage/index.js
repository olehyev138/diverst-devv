import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';

import {
  createGroupMessageBegin, newsFeedUnmount
} from 'containers/News/actions';

import GroupMessageForm from 'components/News/GroupMessage/GroupMessageForm';

export function GroupMessageCreatePage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  // useEffect(() => () => props.newsFeedUnmount(), []);

  return (
    <GroupMessageForm
      groupMessageAction={props.createGroupMessageBegin}
      buttonText='Create'
    />
  );
}

GroupMessageCreatePage.propTypes = {
  createGroupMessageBegin: PropTypes.func,
  newsFeedUnmount: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
});

function mapDispatchToProps(dispatch) {
  return {
    createGroupMessageBegin: payload => dispatch(createGroupMessageBegin(payload)),
    newsFeedUnmount: () => dispatch(newsFeedUnmount())
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupMessageCreatePage);
