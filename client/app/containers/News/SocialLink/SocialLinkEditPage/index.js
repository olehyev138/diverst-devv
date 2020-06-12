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

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectNewsItem, selectIsCommitting, selectIsFormLoading } from 'containers/News/selectors';

import {
  getNewsItemBegin, updateSocialLinkBegin,
  newsFeedUnmount
} from 'containers/News/actions';

import SocialLinkForm from 'components/News/SocialLink/SocialLinkForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/News/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function SocialLinkEditPage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });
  const { intl } = props;
  const rs = new RouteService(useContext);
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(rs.params('group_id')),
  };

  useEffect(() => {
    const newsItemId = rs.params('item_id');
    props.getNewsItemBegin({ id: newsItemId });

    return () => props.newsFeedUnmount();
  }, []);

  const { currentUser, currentGroup, currentNewsItem } = props;
  return (
    <SocialLinkForm
      edit
      socialLinkAction={props.updateSocialLinkBegin}
      buttonText={intl.formatMessage(messages.update)}
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
  intl: intlShape.isRequired,
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  SocialLinkEditPage,
  ['currentNewsItem.permissions.update?', 'isFormLoading'],
  (props, rs) => ROUTES.group.news.index.path(rs.params('group_id')),
  permissionMessages.news.socialLink.editPage
));
