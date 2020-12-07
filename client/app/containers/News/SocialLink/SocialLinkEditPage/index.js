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
  getNewsItemBegin, updateSocialLinkBegin,
  newsFeedUnmount
} from 'containers/News/actions';

import SocialLinkForm from 'components/News/SocialLink/SocialLinkForm';
import messages from 'containers/News/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function SocialLinkEditPage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  const { group_id: groupId, item_id: itemId } = useParams();
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(groupId),
  };

  useEffect(() => {
    props.getNewsItemBegin({ id: itemId });

    return () => props.newsFeedUnmount();
  }, []);

  const { currentUser, currentGroup, currentNewsItem } = props;
  return (
    <SocialLinkForm
      edit
      socialLinkAction={props.updateSocialLinkBegin}
      buttonText={messages.update}
      currentUser={currentUser}
      currentGroup={currentGroup}
      newsItem={currentNewsItem}
      links={links}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
    />
  );
}

SocialLinkEditPage.propTypes = {
  getNewsItemBegin: PropTypes.func,
  updateSocialLinkBegin: PropTypes.func,
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

const mapDispatchToProps = {
  getNewsItemBegin,
  updateSocialLinkBegin,
  newsFeedUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  SocialLinkEditPage,
  ['currentNewsItem.permissions.update?', 'isFormLoading'],
  (props, params) => ROUTES.group.news.index.path(params.group_id),
  permissionMessages.news.socialLink.editPage
));
