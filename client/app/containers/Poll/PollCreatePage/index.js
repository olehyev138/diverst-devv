import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Poll/reducer';
import saga from 'containers/Poll/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { createPollBegin, pollsUnmount, createPollAndPublishBegin } from 'containers/Poll/actions';
import PollForm from 'components/Poll/PollForm';
import { selectIsCommitting } from 'containers/Poll/selectors';

import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

export function PollCreatePage(props) {
  useInjectReducer({ key: 'polls', reducer });
  useInjectSaga({ key: 'polls', saga });

  useEffect(() => () => {}, []);

  const links = {
    pollsIndex: ROUTES.admin.include.polls.index.path(),
  };
  const { intl } = props;

  return (
    <React.Fragment>
      <PollForm
        pollAction={props.createPollBegin}
        pollActionPublish={props.createPollAndPublishBegin}
        isCommitting={props.isCommitting}
        buttonText={<DiverstFormattedMessage {...messages.createPublish} />}
        draftButtonText={<DiverstFormattedMessage {...messages.createDraft} />}
        header={<DiverstFormattedMessage {...messages.form.header.create} />}
        links={links}
      />
    </React.Fragment>
  );
}

PollCreatePage.propTypes = {
  intl: intlShape.isRequired,
  createPollBegin: PropTypes.func,
  createPollAndPublishBegin: PropTypes.func,
  pollsUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createPollBegin,
  createPollAndPublishBegin,
  pollsUnmount,
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
  ['currentGroup.permissions.polls_create'],
  (props, params) => ROUTES.admin.include.polls.index.path(),
  permissionMessages.poll.createPage
));
