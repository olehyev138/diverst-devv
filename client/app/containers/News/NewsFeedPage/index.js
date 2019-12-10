import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import dig from 'object-dig';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';

import { selectPaginatedNewsItems, selectNewsItemsTotal, selectIsLoading } from 'containers/News/selectors';
import { deleteSocialLinkBegin, getNewsItemsBegin, newsFeedUnmount, deleteNewsLinkBegin, deleteGroupMessageBegin,
  updateGroupMessageBegin, updateNewsLinkBegin, updateSocialLinkBegin, updateNewsItemBegin } from 'containers/News/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';
import NewsFeed from 'components/News/NewsFeed';

const NewsFeedTypes = Object.freeze({
  approved: 0,
  not_approved: 1,
});

export function NewsFeedPage(props, context) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });
  const rs = new RouteService(useContext);

  const groupId = rs.params('group_id');

  const defaultParams = {
    count: 5,
    page: 0,
    order: 'asc',
    // eslint-disable-next-line react/prop-types
    news_feed_id: props.currentGroup.id,
  };

  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(rs.params('group_id')),
    newsLinkNew: ROUTES.group.news.news_links.new.path(rs.params('group_id')),
    newsLinkEdit: id => ROUTES.group.news.news_links.edit.path(rs.params('group_id'), id),
    socialLinkNew: ROUTES.group.news.social_links.new.path(rs.params('group_id')),
    socialLinkEdit: id => ROUTES.group.news.social_links.edit.path(rs.params('group_id'), id),
    groupMessageShow: (groupId, id) => ROUTES.group.news.messages.show.path(groupId, id),
    groupMessageNew: ROUTES.group.news.messages.new.path(rs.params('group_id')),
    groupMessageEdit: id => ROUTES.group.news.messages.edit.path(rs.params('group_id'), id),
    newsLinkShow: (groupId, id) => ROUTES.group.news.news_links.show.path(rs.params('group_id'), id),
  };

  const [tab, setTab] = useState(NewsFeedTypes.approved);
  const [params, setParams] = useState(defaultParams);

  const getNewsFeedItems = (scopes, resetParams = false) => {
    const id = dig(props, 'currentGroup', 'id');

    if (resetParams)
      setParams(defaultParams);

    if (id) {
      const newParams = {
        ...params,
        group_id: id,
        query_scopes: scopes
      };
      props.getNewsItemsBegin(newParams);
      setParams(newParams);
    }
  };

  useEffect(() => {
    getNewsFeedItems(['approved']);

    return () => {
      props.newsFeedUnmount();
    };
  }, [props.currentGroup]);

  const handleChangeTab = (event, newTab) => {
    setTab(newTab);
    switch (newTab) {
      case NewsFeedTypes.approved:
        getNewsFeedItems(['approved'], true);
        break;
      case NewsFeedTypes.not_approved:
        getNewsFeedItems(['not_approved'], true);
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

  return (
    <React.Fragment>
      <NewsFeed
        newsItems={props.newsItems}
        newsItemsTotal={props.newsItemsTotal}
        isLoading={props.isLoading}
        defaultParams={params}
        currentTab={tab}
        handleChangeTab={handleChangeTab}
        handlePagination={handlePagination}
        links={links}
        readonly={false}
        deleteGroupMessageBegin={props.deleteGroupMessageBegin}
        deleteNewsLinkBegin={props.deleteNewsLinkBegin}
        deleteSocialLinkBegin={props.deleteSocialLinkBegin}
        updateGroupMessageBegin={props.updateGroupMessageBegin}
        updateNewsLinkBegin={props.updateNewsLinkBegin}
        updateSocialLinkBegin={props.updateSocialLinkBegin}
        updateNewsItemBegin={props.updateNewsItemBegin}
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
  updateGroupMessageBegin: PropTypes.func,
  updateNewsLinkBegin: PropTypes.func,
  updateSocialLinkBegin: PropTypes.func,
  updateNewsItemBegin: PropTypes.func,
  isLoading: PropTypes.bool,
  currentGroup: PropTypes.shape({
    news_feed: PropTypes.shape({
      id: PropTypes.number
    })
  }),
};

const mapStateToProps = createStructuredSelector({
  newsItems: selectPaginatedNewsItems(),
  newsItemsTotal: selectNewsItemsTotal(),
  isLoading: selectIsLoading(),
});

const mapDispatchToProps = dispatch => ({
  getNewsItemsBegin: payload => dispatch(getNewsItemsBegin(payload)),
  deleteGroupMessageBegin: payload => dispatch(deleteGroupMessageBegin(payload)),
  deleteNewsLinkBegin: payload => dispatch(deleteNewsLinkBegin(payload)),
  deleteSocialLinkBegin: payload => dispatch(deleteSocialLinkBegin(payload)),
  updateGroupMessageBegin: payload => dispatch(updateGroupMessageBegin(payload)),
  updateNewsLinkBegin: payload => dispatch(updateNewsLinkBegin(payload)),
  updateSocialLinkBegin: payload => dispatch(updateSocialLinkBegin(payload)),
  updateNewsItemBegin: payload => dispatch(updateNewsItemBegin(payload)),
  newsFeedUnmount: () => dispatch(newsFeedUnmount()),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(NewsFeedPage);
