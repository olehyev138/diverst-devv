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
import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import { selectIsCommitting } from 'containers/News/selectors';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { createSocialLinkBegin, newsFeedUnmount } from 'containers/News/actions';
import SocialLinkForm from 'components/News/SocialLink/SocialLinkForm';
import messages from 'containers/News/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function SocialLinkCreatePage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });

  const { group_id: groupId } = useParams();
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(groupId),
  };

  useEffect(() => () => props.newsFeedUnmount(), []);
  const { currentUser, currentGroup } = props;
  return (
    <SocialLinkForm
      get
      socialLinkAction={props.createSocialLinkBegin}
      buttonText={messages.create}
      currentUser={currentUser}
      currentGroup={currentGroup}
      links={links}
      isCommitting={props.isCommitting}
    />
  );
}

SocialLinkCreatePage.propTypes = {
  createSocialLinkBegin: PropTypes.func,
  newsFeedUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createSocialLinkBegin,
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
  SocialLinkCreatePage,
  ['currentGroup.permissions.news_create?', 'currentGroup.permissions.social_link_create?'],
  (props, params) => ROUTES.group.news.index.path(params.group_id),
  permissionMessages.news.socialLink.createPage
));
