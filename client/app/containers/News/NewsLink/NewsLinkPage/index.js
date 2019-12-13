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
  createNewsLinkCommentBegin,
  newsFeedUnmount,
  deleteNewsLinkCommentBegin
} from 'containers/News/actions';

import NewsLink from 'components/News/NewsLink/NewsLink';

export function NewsLinkPage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  const rs = new RouteService(useContext);
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(rs.params('group_id')),
    newsLinkEdit: id => ROUTES.group.news.news_links.edit.path(rs.params('group_id'), id),
  };

  useEffect(() => {
    const newsItemId = rs.params('item_id');

    // get news item & comments specified in path
    props.getNewsItemBegin({ id: newsItemId });

    return () => props.newsFeedUnmount();
  }, []);

  const { currentUser, currentGroup, currentNewsItem } = props;

  return (
    <NewsLink
      commentAction={props.createNewsLinkCommentBegin}
      deleteNewsLinkCommentBegin={props.deleteNewsLinkCommentBegin}
      currentUserId={currentUser.id}
      newsItem={currentNewsItem}
      links={links}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
    />
  );
}

NewsLinkPage.propTypes = {
  getNewsItemBegin: PropTypes.func,
  updateNewsLinkBegin: PropTypes.func,
  createNewsLinkCommentBegin: PropTypes.func,
  deleteNewsLinkCommentBegin: PropTypes.func,
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
  createNewsLinkCommentBegin: payload => dispatch(createNewsLinkCommentBegin(payload)),
  deleteNewsLinkCommentBegin: payload => dispatch(deleteNewsLinkCommentBegin(payload)),
  newsFeedUnmount: () => dispatch(newsFeedUnmount()),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(NewsLinkPage);
