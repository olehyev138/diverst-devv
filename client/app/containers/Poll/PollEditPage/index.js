import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Poll/reducer';
import saga from 'containers/Poll/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { getPollBegin, pollsUnmount, updatePollBegin, updatePollAndPublishBegin } from 'containers/Poll/actions';
import PollForm from 'components/Poll/PollForm';
import { selectIsCommitting, selectIsFetchingPoll, selectFormPoll } from 'containers/Poll/selectors';

import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

export function PollEditPage(props) {
  useInjectReducer({ key: 'polls', reducer });
  useInjectSaga({ key: 'polls', saga });

  const { poll_id: pollId } = useParams();

  useEffect(() => {
    if (pollId)
      props.getPollBegin({ id: pollId });

    return () => props.pollsUnmount();
  }, []);

  const links = {
    pollsIndex: ROUTES.admin.include.polls.index.path(),
    pollShow: ROUTES.admin.include.polls.index.path(),
  };
  const { intl } = props;

  return (
    <React.Fragment>
      <PollForm
        poll={props.poll}
        pollAction={props.updatePollBegin}
        pollActionPublish={props.updatePollAndPublishBegin}
        isCommitting={props.isCommitting}
        buttonText={<DiverstFormattedMessage {...messages.updatePublish} />}
        draftButtonText={<DiverstFormattedMessage {...messages.updateDraft} />}
        header={<DiverstFormattedMessage {...messages.form.header.edit} />}
        isFormLoading={props.isFormLoading}
        edit

        links={links}
      />
    </React.Fragment>
  );
}

PollEditPage.propTypes = {
  intl: intlShape.isRequired,
  updatePollBegin: PropTypes.func,
  updatePollAndPublishBegin: PropTypes.func,
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
  updatePollAndPublishBegin,
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
  PollEditPage,
  ['poll.permissions.update?', 'isFormLoading'],
  (props, params) => ROUTES.admin.include.polls.index.path(),
  permissionMessages.poll.editPage
));
