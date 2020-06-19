import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectNewsItem, selectIsCommitting, selectIsFormLoading } from 'containers/News/selectors';

import {
  getNewsItemBegin,
  createGroupMessageCommentBegin,
  newsFeedUnmount,
  deleteGroupMessageCommentBegin
} from 'containers/News/actions';

import GroupMessage from 'components/News/GroupMessage/GroupMessage';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function GroupMessagePage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  const { group_id: groupId, item_id: itemId } = useParams();
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(groupId),
  };

  useEffect(() => {
    // get news item & comments specified in path
    props.getNewsItemBegin({ id: itemId });

    return () => props.newsFeedUnmount();
  }, []);

  const { currentUser, currentNewsItem } = props;

  return (
    <GroupMessage
      commentAction={props.createGroupMessageCommentBegin}
      deleteGroupMessageCommentBegin={props.deleteGroupMessageCommentBegin}
      currentUserId={currentUser.user_id}
      newsItem={currentNewsItem}
      links={links}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
    />
  );
}

GroupMessagePage.propTypes = {
  getNewsItemBegin: PropTypes.func,
  updateGroupMessageBegin: PropTypes.func,
  createGroupMessageCommentBegin: PropTypes.func,
  deleteGroupMessageCommentBegin: PropTypes.func,
  newsFeedUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentNewsItem: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentNewsItem: selectNewsItem(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = dispatch => ({
  getNewsItemBegin: payload => dispatch(getNewsItemBegin(payload)),
  createGroupMessageCommentBegin: payload => dispatch(createGroupMessageCommentBegin(payload)),
  deleteGroupMessageCommentBegin: payload => dispatch(deleteGroupMessageCommentBegin(payload)),
  newsFeedUnmount: () => dispatch(newsFeedUnmount()),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  GroupMessagePage,
  ['currentNewsItem.permissions.show?', 'isFormLoading'],
  (props, params) => ROUTES.group.news.index.path(params.group_id),
  permissionMessages.news.groupMessage.showPage
));
