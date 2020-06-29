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
  getNewsItemBegin, updateGroupMessageBegin,
  newsFeedUnmount
} from 'containers/News/actions';

import GroupMessageForm from 'components/News/GroupMessage/GroupMessageForm';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/News/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function GroupMessageEditPage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });
  const { intl } = props;

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
    <GroupMessageForm
      edit
      groupMessageAction={props.updateGroupMessageBegin}
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

GroupMessageEditPage.propTypes = {
  intl: intlShape.isRequired,
  getNewsItemBegin: PropTypes.func,
  updateGroupMessageBegin: PropTypes.func,
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
  updateGroupMessageBegin,
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
  GroupMessageEditPage,
  ['currentNewsItem.permissions.update?', 'isFormLoading'],
  (props, params) => ROUTES.group.news.messages.show.path(params.group_id, params.item_id),
  permissionMessages.news.groupMessage.editPage
));
