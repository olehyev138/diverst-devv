import React, { memo, useContext, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Poll/reducer';
import saga from 'containers/Poll/saga';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { createPollBegin, pollsUnmount } from 'containers/Poll/actions';
import PollForm from 'components/Poll/PollForm';
import { selectIsCommitting } from 'containers/Poll/selectors';

import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function PollCreatePage(props) {
  useInjectReducer({ key: 'polls', reducer });
  useInjectSaga({ key: 'polls', saga });

  useEffect(() => () => {}, []);

  const { currentUser, currentGroup } = props;
  const rs = new RouteService(useContext);
  const links = {
    pollsIndex: ROUTES.admin.include.polls.index.path(),
  };
  const { intl } = props;

  return (
    <React.Fragment>
      <PollForm
        pollAction={props.createPollBegin}
        isCommitting={props.isCommitting}
        buttonText={intl.formatMessage(messages.create)}
        currentUser={currentUser}
        currentGroup={currentGroup}
        links={links}
      />
    </React.Fragment>
  );
}

PollCreatePage.propTypes = {
  intl: intlShape,
  createPollBegin: PropTypes.func,
  pollsUnmount: PropTypes.func,
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
  createPollBegin,
  pollsUnmount
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
  PollCreatePage,
  ['currentGroup.permissions.polls_create?'],
  (props, rs) => ROUTES.admin.include.polls.index.path(),
  permissionMessages.poll.createPage
));
