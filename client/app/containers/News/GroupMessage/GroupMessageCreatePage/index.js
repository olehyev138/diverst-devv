import React, { memo, useEffect, useState, useContext } from 'react';
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

import { routeContext } from 'utils/routeHelpers';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  createGroupMessageBegin, newsFeedUnmount
} from 'containers/News/actions';

import GroupMessageForm from 'components/News/GroupMessage/GroupMessageForm';

export function GroupMessageCreatePage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  const { currentUser, currentGroup } = props;
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(routeContext(useContext, 'group_id')),
  };

  useEffect(() => () => props.newsFeedUnmount(), []);

  return (
    <GroupMessageForm
      groupMessageAction={props.createGroupMessageBegin}
      buttonText='Create'
      currentUser={currentUser}
      currentGroup={currentGroup}
      links={links}
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
