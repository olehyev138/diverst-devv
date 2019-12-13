import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectNewsItem, selectIsCommitting, selectIsFormLoading } from 'containers/News/selectors';

import {
  getNewsItemBegin,
  createGroupMessageCommentBegin,
  newsFeedUnmount,
  getNewsItemsBegin, deleteGroupMessageBegin, deleteNewsLinkBegin, deleteSocialLinkBegin,
  deleteGroupMessageCommentBegin
} from 'containers/News/actions';

import GroupMessage from 'components/News/GroupMessage/GroupMessage';

export function GroupMessagePage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  const rs = new RouteService(useContext);
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(rs.params('group_id')),
  };

  useEffect(() => {
    const newsItemId = rs.params('item_id');

    // get news item & comments specified in path
    props.getNewsItemBegin({ id: newsItemId });

    return () => props.newsFeedUnmount();
  }, []);

  const { currentUser, currentNewsItem } = props;

  return (
    <GroupMessage
      commentAction={props.createGroupMessageCommentBegin}
      deleteGroupMessageCommentBegin={props.deleteGroupMessageCommentBegin}
      currentUserId={currentUser.id}
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
)(GroupMessagePage);
