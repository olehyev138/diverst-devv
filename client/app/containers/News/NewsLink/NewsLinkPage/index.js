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
import { selectUser, selectCustomText } from 'containers/Shared/App/selectors';
import { selectNewsItem, selectIsCommitting, selectIsFormLoading } from 'containers/News/selectors';

import {
  getNewsItemBegin,
  createNewsLinkCommentBegin,
  newsFeedUnmount,
  deleteNewsLinkCommentBegin
} from 'containers/News/actions';

import NewsLink from 'components/News/NewsLink/NewsLink';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function NewsLinkPage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  const { group_id: groupId, item_id: itemId } = useParams();
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(groupId),
    newsLinkEdit: id => ROUTES.group.news.news_links.edit.path(groupId, id),
  };

  useEffect(() => {
    // get news item & comments specified in path
    props.getNewsItemBegin({ id: itemId });

    return () => props.newsFeedUnmount();
  }, []);

  const { currentUser, currentNewsItem } = props;

  return (
    <NewsLink
      commentAction={props.createNewsLinkCommentBegin}
      deleteNewsLinkCommentBegin={props.deleteNewsLinkCommentBegin}
      currentUserId={currentUser.user_id}
      newsItem={currentNewsItem}
      links={links}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
      customTexts={props.customTexts}
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
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentNewsItem: selectNewsItem(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
  customTexts: selectCustomText(),
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
)(Conditional(
  NewsLinkPage,
  ['currentNewsItem.permissions.show?', 'isFormLoading'],
  (props, params) => ROUTES.group.news.index.path(params.group_id),
  permissionMessages.news.newsLink.showPage
));
