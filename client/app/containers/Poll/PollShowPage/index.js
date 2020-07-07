import React, { memo, useEffect, useState } from 'react';
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

import { getPollBegin, pollsUnmount, updatePollBegin } from 'containers/Poll/actions';
import { getResponsesBegin, responsesUnmount } from 'containers/Poll/Response/actions';
import { selectIsCommitting, selectIsFetchingPoll, selectPoll } from 'containers/Poll/selectors';

import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Button, Tab, Card, Box } from '@material-ui/core';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import PollResponses from 'components/Poll/PollResponses';
import PollGraphs from 'components/Poll/PollGraphs';
import dig from 'object-dig';

import {
  selectIsFetchingResponses,
  selectPaginatedResponses,
  selectResponsesTotal
} from 'containers/Poll/Response/selectors';
import responseReducer from 'containers/Poll/Response/reducer';
import responseSaga from 'containers/Poll/Response/saga';
import PollShowHeader from 'components/Poll/PollShowHeader';

const defaultParams = Object.freeze({
  count: 10,
  page: 0,
  order: 'desc',
  orderBy: 'poll_responses.id',
});

export function PollShowPage(props) {
  useInjectReducer({ key: 'polls', reducer });
  useInjectSaga({ key: 'polls', saga });
  useInjectReducer({ key: 'responses', reducer: responseReducer });
  useInjectSaga({ key: 'responses', saga: responseSaga });

  const [tab, setTab] = useState('responses');
  const [textField, setTextField] = useState(null);
  const [textFieldOptions, setTestFieldOptions] = useState([]);
  const [responseParams, setResponseParams] = useState(defaultParams);

  const { poll_id: pollId } = useParams();

  function getResponses(params) {
    props.getResponsesBegin({ poll_id: pollId, ...params });
  }

  const handlePagination = (state, set) => (payload) => {
    const newParams = { ...state, count: payload.count, page: payload.page };

    getResponses(newParams);
    set(newParams);
  };

  const handleOrdering = (state, set) => (payload) => {
    const newParams = { ...state, orderBy: payload.orderBy, order: payload.orderDir };

    getResponses(newParams);
    set(newParams);
  };

  useEffect(() => {
    if (pollId)
      props.getPollBegin({ id: pollId });

    return () => props.pollsUnmount();
  }, []);

  useEffect(() => {
    getResponses(responseParams);

    return () => {
      props.responsesUnmount();
    };
  }, []);

  useEffect(() => {
    if (props.poll)
      setTestFieldOptions(dig(poll, 'fields', fs => fs.filter(f => f.type === 'TextField')));

    return () => null;
  }, [dig(props, 'poll', 'id')]);

  const links = {
    pollsIndex: ROUTES.admin.include.polls.index.path(),
  };

  const { intl, poll, responses, isFormLoading, responsesLoading, responsesTotal } = props;

  const componentProps = {
    poll, responses, isFormLoading, responsesLoading, responsesTotal, links
  };

  const subPage = (tab) => {
    if (tab === 'responses')
      return (
        <PollResponses
          {...componentProps}
          field={textField || {}}
          setField={setTextField}
          fieldOptions={textFieldOptions}
          handlePagination={handlePagination(responseParams, setResponseParams)}
          handleOrdering={handleOrdering(responseParams, setResponseParams)}
        />
      );
    if (tab === 'graphs')
      return <PollGraphs {...componentProps} />;
    return <React.Fragment />;
  };

  return (
    poll && (
      <React.Fragment>
        <PollShowHeader {...componentProps} />
        <Box mb={2} />
        <Card>
          <ResponsiveTabs
            value={tab}
            onChange={(_, newTab) => {
              setResponseParams(defaultParams);
              if (['texts', 'responses'].some(t => t === newTab))
                getResponses(defaultParams);
              setTab(newTab);
            }}
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
        {subPage(tab)}
      </React.Fragment>
    )
  );
}

PollShowPage.propTypes = {
  intl: intlShape.isRequired,
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
  poll: selectPoll(),
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
  PollShowPage,
  ['poll.permissions.show?', 'isFormLoading'],
  (props, params) => ROUTES.admin.include.polls.index.path(),
  permissionMessages.poll.showPage
));
