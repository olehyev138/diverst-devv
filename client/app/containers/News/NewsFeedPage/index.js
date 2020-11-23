import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';
import likeSaga from 'containers/Shared/Like/saga';

import { selectPaginatedNewsItems, selectNewsItemsTotal, selectIsLoading, selectHasChanged } from 'containers/News/selectors';
import {
  deleteSocialLinkBegin, getNewsItemsBegin, newsFeedUnmount, deleteNewsLinkBegin, deleteGroupMessageBegin,
  updateNewsItemBegin, archiveNewsItemBegin, pinNewsItemBegin, unpinNewsItemBegin, approveNewsItemBegin
} from 'containers/News/actions';
import { likeNewsItemBegin, unlikeNewsItemBegin } from 'containers/Shared/Like/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';
import NewsFeed from 'components/News/NewsFeed';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';
import { selectEnterprise, selectCustomText } from 'containers/Shared/App/selectors';

const NewsFeedTypes = Object.freeze({
  approved: 0,
  pending: 1,
});

const defaultParams = Object.freeze({
  count: 5, // TODO: Make this a constant and use it also in EventsList
  page: 0,
  order: 'desc',
  orderBy: 'news_feed_links.created_at',
  group_id: -1,
});

export function NewsFeedPage(props, context) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });
  useInjectSaga({ key: 'likes', saga: likeSaga });

  const { group_id: groupId } = useParams();

  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(groupId),
    newsLinkNew: ROUTES.group.news.news_links.new.path(groupId),
    newsLinkEdit: id => ROUTES.group.news.news_links.edit.path(groupId, id),
    socialLinkNew: ROUTES.group.news.social_links.new.path(groupId),
    socialLinkEdit: id => ROUTES.group.news.social_links.edit.path(groupId, id),
    groupMessageShow: (groupId, id) => ROUTES.group.news.messages.show.path(groupId, id),
    groupMessageNew: ROUTES.group.news.messages.new.path(groupId),
    groupMessageEdit: id => ROUTES.group.news.messages.edit.path(groupId, id),
    newsLinkShow: (groupId, id) => ROUTES.group.news.news_links.show.path(groupId, id),
  };

  const [tab, setTab] = useState(NewsFeedTypes.approved);
  const [params, setParams] = useState(defaultParams);

  const getNewsFeedItems = (scopes, resetParams = false) => {
    const newsFeedId = props.currentGroup.news_feed.id;
    const groupId = props.currentGroup.id;

    if (resetParams)
      setParams(defaultParams);

    if (newsFeedId) {
      const newParams = {
        ...params,
        group_id: groupId,
        query_scopes: scopes
      };
      props.getNewsItemsBegin(newParams);
      setParams(newParams);
    }
  };

  useEffect(() => {
    getNewsFeedItems(['approved', 'not_archived']);

    return () => {
      props.newsFeedUnmount();
    };
  }, [props.currentGroup]);

  useEffect(() => {
    if (props.hasChanged)
      props.getNewsItemsBegin(params);

    return () => {
      props.newsFeedUnmount();
    };
  }, [props.hasChanged]);

  const handleChangeTab = (event, newTab) => {
    setTab(newTab);
    switch (newTab) {
      case NewsFeedTypes.approved:
        getNewsFeedItems(['approved', 'not_archived'], true);
        break;
      case NewsFeedTypes.pending:
        getNewsFeedItems(['pending', 'not_archived'], true);
        break;
      default:
        break;
    }
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };
    props.getNewsItemsBegin(newParams);
    setParams(newParams);
  };

  const List = props.listComponent || NewsFeed;

  return (
    <React.Fragment>
      <List
        newsItems={props.newsItems}
        newsItemsTotal={props.newsItemsTotal}
        isLoading={props.isLoading}
        defaultParams={params}
        currentTab={tab}
        pending={tab === NewsFeedTypes.pending}
        handleChangeTab={handleChangeTab}
        handlePagination={handlePagination}
        currentGroup={props.currentGroup}
        links={links}
        readonly={props.readonly}
        deleteGroupMessageBegin={props.deleteGroupMessageBegin}
        deleteNewsLinkBegin={props.deleteNewsLinkBegin}
        deleteSocialLinkBegin={props.deleteSocialLinkBegin}
        updateNewsItemBegin={props.updateNewsItemBegin}
        archiveNewsItemBegin={props.archiveNewsItemBegin}
        approveNewsItemBegin={props.approveNewsItemBegin}
        pinNewsItemBegin={props.pinNewsItemBegin}
        unpinNewsItemBegin={props.unpinNewsItemBegin}
        likeNewsItemBegin={props.likeNewsItemBegin}
        unlikeNewsItemBegin={props.unlikeNewsItemBegin}
        enableLikes={props.currentEnterprise.enable_likes}
        customTexts={props.customTexts}
      />
    </React.Fragment>
  );
}

NewsFeedPage.propTypes = {
  getNewsItemsBegin: PropTypes.func.isRequired,
  newsFeedUnmount: PropTypes.func.isRequired,
  newsItems: PropTypes.array,
  newsItemsTotal: PropTypes.number,
  deleteGroupMessageBegin: PropTypes.func,
  deleteNewsLinkBegin: PropTypes.func,
  deleteSocialLinkBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  likeNewsItemBegin: PropTypes.func,
  unlikeNewsItemBegin: PropTypes.func,
  approveNewsItemBegin: PropTypes.func,
  isLoading: PropTypes.bool,
  hasChanged: PropTypes.bool,
  archiveNewsItemBegin: PropTypes.func,
  pinNewsItemBegin: PropTypes.func,
  unpinNewsItemBegin: PropTypes.func,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
    news_feed: PropTypes.shape({
      id: PropTypes.number
    })
  }),
  readonly: PropTypes.bool,
  listComponent: PropTypes.elementType,
  currentEnterprise: PropTypes.object,
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  newsItems: selectPaginatedNewsItems(),
  newsItemsTotal: selectNewsItemsTotal(),
  isLoading: selectIsLoading(),
  hasChanged: selectHasChanged(),
  currentEnterprise: selectEnterprise(),
  customTexts: selectCustomText(),
});

const mapDispatchToProps = dispatch => ({
  getNewsItemsBegin: payload => dispatch(getNewsItemsBegin(payload)),
  deleteGroupMessageBegin: payload => dispatch(deleteGroupMessageBegin(payload)),
  deleteNewsLinkBegin: payload => dispatch(deleteNewsLinkBegin(payload)),
  deleteSocialLinkBegin: payload => dispatch(deleteSocialLinkBegin(payload)),
  updateNewsItemBegin: payload => dispatch(updateNewsItemBegin(payload)),
  newsFeedUnmount: () => dispatch(newsFeedUnmount()),
  archiveNewsItemBegin: payload => dispatch(archiveNewsItemBegin(payload)),
  approveNewsItemBegin: payload => dispatch(approveNewsItemBegin(payload)),
  pinNewsItemBegin: payload => dispatch(pinNewsItemBegin(payload)),
  unpinNewsItemBegin: payload => dispatch(unpinNewsItemBegin(payload)),
  likeNewsItemBegin: payload => dispatch(likeNewsItemBegin(payload)),
  unlikeNewsItemBegin: payload => dispatch(unlikeNewsItemBegin(payload)),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  NewsFeedPage,
  ['currentGroup.permissions.news_view?'],
  (props, params) => props.readonly ? null : ROUTES.group.home.path(params.group_id),
  permissionMessages.news.NewsFeedPage
));
