import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/News/reducer';
import saga from 'containers/News/saga';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import { selectIsCommitting } from 'containers/News/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { createNewsLinkBegin, newsFeedUnmount } from 'containers/News/actions';
import NewsLinkForm from 'components/News/NewsLink/NewsLinkForm';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/News/messages';
import Conditional from 'components/Compositions/Conditional';

export function NewsLinkCreatePage(props) {
  useInjectReducer({ key: 'news', reducer });
  useInjectSaga({ key: 'news', saga });
  const { intl } = props;
  const rs = new RouteService(useContext);
  const links = {
    newsFeedIndex: ROUTES.group.news.index.path(rs.params('group_id')),
  };

  useEffect(() => () => props.newsFeedUnmount(), []);

  const { currentUser, currentGroup } = props;


  return (
    <NewsLinkForm
      get
      newsLinkAction={props.createNewsLinkBegin}
      buttonText={intl.formatMessage(messages.create)}
      currentUser={currentUser}
      currentGroup={currentGroup}
      links={links}
      isCommitting={props.isCommitting}
    />
  );
}

NewsLinkCreatePage.propTypes = {
  intl: intlShape,
  createNewsLinkBegin: PropTypes.func,
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
  createNewsLinkBegin,
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
  NewsLinkCreatePage,
  ['currentGroup.permissions.news_create?'],
  (props, rs) => ROUTES.group.news.index.path(rs.params('group_id')),
  'You don\'t have permission to post news links'
));
