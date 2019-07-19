import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';

import { pathId, routeContext } from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectNewsItem } from 'containers/News/selectors';

import {
  getNewsItemBegin, updateGroupMessageBegin,
  newsFeedUnmount
} from 'containers/News/actions';

import GroupMessageForm from 'components/News/GroupMessage/GroupMessageForm';

export function GroupMessageEditPage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(routeContext(useContext, 'group_id')),
  };

  useEffect(() => {
    const newsItemId = pathId(props, 'item_id');
    props.getNewsItemBegin({ id: newsItemId });

    return () => props.newsFeedUnmount();
  }, []);

  const { currentUser, currentGroup, currentNewsItem } = props;

  return (
    <GroupMessageForm
      groupMessageAction={props.updateGroupMessageBegin}
      buttonText='Update'
      currentUser={currentUser}
      currentGroup={currentGroup}
      newsItem={currentNewsItem}
      links={links}
    />
  );
}

GroupMessageEditPage.propTypes = {
  getNewsItemBegin: PropTypes.func,
  updateGroupMessageBegin: PropTypes.func,
  newsFeedUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentNewsItem: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentNewsItem: selectNewsItem(),
});

const mapDispatchToProps = {
  getNewsItemBegin,
  updateGroupMessageBegin,
  newsFeedUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupMessageEditPage);
