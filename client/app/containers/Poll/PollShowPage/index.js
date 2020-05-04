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
import { Button, Tab, Card, Box } from '@material-ui/core';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import switchExpression from 'utils/caseHelper';
import PollResponses from 'components/Poll/PollResponses';
import PollGraphs from 'components/Poll/PollGraphs';
import {
  selectIsFetchingResponses,
  selectPaginatedResponses,
  selectResponsesTotal
} from 'containers/Poll/Response/selectors';
import responseReducer from 'containers/Poll/Response/reducer';
import responseSaga from 'containers/Poll/Response/saga';
import PollShowHeader from 'components/Poll/PollShowHeader';

export function PollCreatePage(props) {
  useInjectReducer({ key: 'polls', reducer });
  useInjectSaga({ key: 'polls', saga });
  useInjectReducer({ key: 'responses', reducer: responseReducer });
  useInjectSaga({ key: 'responses', saga: responseSaga });

  const [tab, setTab] = useState('responses');

  const rs = new RouteService(useContext);
  const pollId = rs.params('poll_id');

  const [params, setParams] = useState({ count: 10, page: 0, order: 'asc' });

  function getResponses(params) {
    props.getResponsesBegin({ poll_id: pollId, ...params });
  }

  useEffect(() => {
    const pollId = rs.params('poll_id');
    if (pollId)
      props.getPollBegin({ id: pollId });

    return () => props.pollsUnmount();
  }, []);

  useEffect(() => {
    getResponses(params);

    return () => {
      props.responsesUnmount();
    };
  }, []);

  const links = {
    pollsIndex: ROUTES.admin.include.polls.index.path(),
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getResponses(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    getResponses(newParams);
    setParams(newParams);
  };

  const { intl, poll, responses, isFormLoading, responsesLoading, responsesTotal } = props;

  const componentProps = {
    poll, responses, isFormLoading, responsesLoading, responsesTotal, links
  };

  return (
    poll && (
      <React.Fragment>
        <PollShowHeader {...componentProps} />
        <Box mb={2} />
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
        <Box mb={2} />
        {switchExpression(tab,
          ['responses', (
            <PollResponses
              {...componentProps}
              handleOrdering={handleOrdering}
              handlePagination={handlePagination}
            />
          )],
          ['graphs', (<PollGraphs {...componentProps} />)],
          [null, (<React.Fragment />)])}
      </React.Fragment>
    )
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
  responsesTotal: PropTypes.number,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  responsesLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  poll: selectFormPoll(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFetchingPoll(),
  responses: selectPaginatedResponses(),
  responsesTotal: selectResponsesTotal(),
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
