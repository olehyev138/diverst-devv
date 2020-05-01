import React, { memo, useContext, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Poll/reducer';
import saga from 'containers/Poll/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { getPollBegin, pollsUnmount, updatePollBegin } from 'containers/Poll/actions';
import { getResponsesBegin, responsesUnmount } from 'containers/Poll/Response/actions';
import PollForm from 'components/Poll/PollForm';
import { selectIsCommitting, selectIsFetchingPoll, selectFormPoll } from 'containers/Poll/selectors';

import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Button, Tab, Card } from '@material-ui/core';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import switchExpression from 'utils/caseHelper';
import PollResponses from 'components/Poll/PollResponses';
import PollGraphs from 'components/Poll/PollGraphs';
import { selectIsFetchingResponses, selectPaginatedResponses } from 'containers/Poll/Response/selectors';
import responseReducer from 'containers/Poll/Response/reducer';
import responseSaga from 'containers/Poll/Response/saga';

export function PollCreatePage(props) {
  useInjectReducer({ key: 'polls', reducer });
  useInjectSaga({ key: 'polls', saga });
  useInjectReducer({ key: 'responses', reducer: responseReducer });
  useInjectSaga({ key: 'responses', saga: responseSaga });

  const [tab, setTab] = useState('responses');

  const rs = new RouteService(useContext);

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  useEffect(() => {
    const pollId = rs.params('poll_id');
    if (pollId)
      props.getPollBegin({ id: pollId });

    return () => props.pollsUnmount();
  }, []);

  useEffect(() => {
    const pollId = rs.params('poll_id');
    props.getResponsesBegin({ poll_id: pollId, ...params });

    return () => {
      props.responsesUnmount();
    };
  }, []);

  const links = {
    pollsIndex: ROUTES.admin.include.polls.index.path(),
    pollEdit: ROUTES.admin.include.polls.edit.path(rs.params('poll_id')),
  };

  const { intl } = props;

  return (
    <React.Fragment>
      <Card>
        <ResponsiveTabs
          value={tab}
          onChange={(_, newTab) => setTab(newTab)}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab
            label='Responses'
            value='responses'
          />
          <Tab
            label='Graphs'
            value='graphs'
          />
        </ResponsiveTabs>
      </Card>
      {switchExpression(tab,
        ['responses', (<PollResponses />)],
        ['graphs', (<PollGraphs />)],
        [null, (<React.Fragment />)])}
    </React.Fragment>
  );
}

PollCreatePage.propTypes = {
  intl: intlShape,
  updatePollBegin: PropTypes.func,
  pollsUnmount: PropTypes.func,
  getPollBegin: PropTypes.func,
  getResponsesBegin: PropTypes.func,
  responsesUnmount: PropTypes.func,
  poll: PropTypes.object,
  responses: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  responsesLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  poll: selectFormPoll(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFetchingPoll(),
  responses: selectPaginatedResponses(),
  responsesLoading: selectIsFetchingResponses(),
});

const mapDispatchToProps = {
  updatePollBegin,
  pollsUnmount,
  getPollBegin,
  getResponsesBegin,
  responsesUnmount,
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
