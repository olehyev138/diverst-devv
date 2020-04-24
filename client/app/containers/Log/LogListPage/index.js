/**
 *
 * LogListPage
 *
 */

import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/Log/saga';
import reducer from 'containers/Log/reducer';

import { selectPaginatedLogs, selectLogTotal, selectIsLoading } from 'containers/Log/selectors';
import { getLogsBegin, logUnmount, exportLogsBegin } from 'containers/Log/actions';
import { selectEnterprise } from 'containers/Shared/App/selectors';

import LogList from 'components/Log/LogList';
import groupSaga from 'containers/Group/saga';
import groupReducer from 'containers/Group/reducer';

export function LogListPage(props) {
  useInjectReducer({ key: 'logs', reducer });
  useInjectSaga({ key: 'logs', saga });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });

  const defaultParams = {
    count: 10, page: 0,
    orderBy: 'created_at', order: 'desc',
    query_scopes: []
  };

  const [params, setParams] = useState(defaultParams);
  const [from, setFrom] = React.useState(null);
  const [to, setTo] = React.useState(null);
  const [groupIds, setGroupIds] = React.useState(null);
  const [groupLabels, setGroupLabels] = React.useState(null);

  const getScopes = (scopes) => {
    // eslint-disable-next-line no-param-reassign
    if (scopes === undefined) scopes = {};
    if (scopes.from === undefined) scopes.from = from;
    if (scopes.to === undefined) scopes.to = to;
    if (scopes.groupIds === undefined) scopes.groupIds = groupIds;

    const queryScopes = [];
    if (scopes.from)
      queryScopes.push(scopes.from);
    if (scopes.to)
      queryScopes.push(scopes.to);
    if (scopes.groupIds && scopes.groupIds[1].length > 0)
      queryScopes.push(scopes.groupIds);

    return queryScopes;
  };

  const getLogs = (scopes, params = params) => {
    const newParams = {
      ...params,
      query_scopes: scopes
    };
    props.getLogsBegin(newParams);
    setParams(newParams);
  };

  const exportLogs = () => {
    const newParams = {
      ...params,
      query_scopes: getScopes({})
    };
    props.exportLogsBegin(newParams);
  };

  const handleFilterChange = (values) => {
    let from = null;
    let to = null;
    let groupIds = null;
    if (values.from) {
      from = ['joined_from', values.from];
      setFrom(from);
    }
    if (values.to) {
      to = ['joined_to', values.to];
      setTo(to);
    }
    if (values.groupIds) {
      groupIds = ['for_group_ids', values.groupIds];
      setGroupIds(groupIds);
    }
    if (values.groupLabels) {
      groupIds = ['for_group_ids', values.groupIds];
      setGroupIds(groupIds);
      setGroupLabels(values.groupLabels);
    }
    getLogs(getScopes({ from, to, groupIds }, defaultParams));
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getLogs(getScopes({}), newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    getLogs(getScopes({}), newParams);
  };

  useEffect(() => {
    props.getLogsBegin(params);

    return () => {
      props.logUnmount();
    };
  }, []);
  return (
    <React.Fragment>
      <LogList
        logs={props.logs}
        logTotal={props.logTotal}
        isLoading={props.isLoading}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        exportLogsBegin={exportLogs}
        currentEnterprise={props.currentEnterprise}
        handleFilterChange={handleFilterChange}
        setParams={params}
        params={params}
        logFrom={from ? from[1] : null}
        logTo={to ? to[1] : null}
        groupLabels={groupLabels || []}

      />
    </React.Fragment>
  );
}
LogListPage.propTypes = {
  getLogsBegin: PropTypes.func.isRequired,
  getGroupsBegin: PropTypes.func,
  logUnmount: PropTypes.func.isRequired,
  logs: PropTypes.array,
  logTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  exportLogsBegin: PropTypes.func,
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number,
  })
};

const mapStateToProps = createStructuredSelector({
  logs: selectPaginatedLogs(),
  logTotal: selectLogTotal(),
  isLoading: selectIsLoading(),
  currentEnterprise: selectEnterprise(),
});

const mapDispatchToProps = {
  getLogsBegin,
  exportLogsBegin,
  logUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(LogListPage);
