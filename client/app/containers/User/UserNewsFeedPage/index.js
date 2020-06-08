import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import dig from 'object-dig';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';
import likeSaga from 'containers/Shared/Like/saga';
import { likeNewsItemBegin, unlikeNewsItemBegin } from 'containers/Shared/Like/actions';

import { selectPaginatedPosts, selectPostsTotal, selectIsLoadingPosts } from 'containers/User/selectors';
import { selectPermissions, selectUser, selectEnterprise } from 'containers/Shared/App/selectors';
import { getUserPostsBegin, userUnmount } from 'containers/User/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import NewsFeed from 'components/News/NewsFeed';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function NewsFeedPage(props, context) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });
  useInjectSaga({ key: 'likes', saga: likeSaga });

  const [params, setParams] = useState({
    count: 5, page: 0, order: 'desc', order_by: 'created_at',
  });

  const links = {
    groupMessageShow: (groupId, id) => ROUTES.group.news.messages.show.path(groupId, id),
    newsLinkShow: (groupId, id) => ROUTES.group.news.news_links.show.path(groupId, id),
  };

  useEffect(() => {
    const userId = dig(props, 'currentUser', 'id');
    props.getUserPostsBegin(params);

    return () => {
      props.userUnmount();
    };
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getUserPostsBegin(newParams);
    setParams(newParams);
  };

  const List = props.listComponent || NewsFeed;

  return (
    <React.Fragment>
      <List
        newsItems={props.newsItems}
        newsItemsTotal={props.newsItemsTotal}
        defaultParams={params}
        handlePagination={handlePagination}
        links={links}
        isLoading={props.isLoading}
        readonly
        likeNewsItemBegin={props.likeNewsItemBegin}
        unlikeNewsItemBegin={props.unlikeNewsItemBegin}
        enableLikes={props.currentEnterprise.enable_likes}
      />
    </React.Fragment>
  );
}

NewsFeedPage.propTypes = {
  currentUser: PropTypes.object,
  getUserPostsBegin: PropTypes.func.isRequired,
  userUnmount: PropTypes.func.isRequired,
  newsItems: PropTypes.array,
  newsItemsTotal: PropTypes.number,
  likeNewsItemBegin: PropTypes.func,
  unlikeNewsItemBegin: PropTypes.func,
  isLoading: PropTypes.bool,
  listComponent: PropTypes.elementType,
  currentGroup: PropTypes.shape({
    news_feed: PropTypes.shape({
      id: PropTypes.number
    })
  }),
  currentEnterprise: PropTypes.object
};

const mapStateToProps = createStructuredSelector({
  newsItems: selectPaginatedPosts(),
  newsItemsTotal: selectPostsTotal(),
  currentUser: selectUser(),
  isLoading: selectIsLoadingPosts(),
  permissions: selectPermissions(),
  currentEnterprise: selectEnterprise()
});

const mapDispatchToProps = {
  getUserPostsBegin,
  userUnmount,
  likeNewsItemBegin,
  unlikeNewsItemBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  NewsFeedPage,
  ['permissions.news_view'],
  (props, params) => props.readonly ? null : ROUTES.user.home.path(),
  permissionMessages.user.newsFeedPage
));
