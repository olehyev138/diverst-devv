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

import { getPollBegin, pollsUnmount, updatePollBegin } from 'containers/Poll/actions';
import PollForm from 'components/Poll/PollForm';
import { selectIsCommitting, selectIsFetchingPoll, selectFormPoll } from 'containers/Poll/selectors';

import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Button } from '@material-ui/core';

export function PollCreatePage(props) {
  useInjectReducer({ key: 'polls', reducer });
  useInjectSaga({ key: 'polls', saga });

  const rs = new RouteService(useContext);

  useEffect(() => {
    const pollId = rs.params('poll_id');
    if (pollId)
      props.getPollBegin({ id: pollId });

    return () => props.pollsUnmount();
  }, []);

  const links = {
    pollsIndex: ROUTES.admin.include.polls.index.path(),
    pollShow: '/' // ROUTES.admin.include.polls.index.path(),
  };
  const { intl } = props;

  return (
    <React.Fragment>
      <PollForm
        poll={props.poll}
        pollAction={props.updatePollBegin}
        isCommitting={props.isCommitting}
        buttonText={<DiverstFormattedMessage {...messages.update} />}
        isFormLoading={props.isFormLoading}
        edit

        links={links}
      />
    </React.Fragment>
  );
}

PollCreatePage.propTypes = {
  intl: intlShape,
  updatePollBegin: PropTypes.func,
  pollsUnmount: PropTypes.func,
  getPollBegin: PropTypes.func,
  poll: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  poll: selectFormPoll(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFetchingPoll(),
});

const mapDispatchToProps = {
  updatePollBegin,
  pollsUnmount,
  getPollBegin,
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
