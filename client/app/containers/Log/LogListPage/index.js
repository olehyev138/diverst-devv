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

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectPaginatedLogs, selectLogTotal, selectIsLoading } from 'containers/Log/selectors';
import { getLogsBegin, logUnmount, exportLogsBegin } from 'containers/Log/actions';
import { selectEnterprise } from 'containers/Shared/App/selectors';

import LogList from 'components/Log/LogList';

export function LogListPage(props) {
  useInjectReducer({ key: 'logs', reducer });
  useInjectSaga({ key: 'logs', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  const exportMembers = () => {
    const newParams = {
      ...params,
      // query_scopes: getScopes({})
    };
    props.exportLogsBegin(newParams);
  };

  useEffect(() => {
    props.getLogsBegin(params);

    return () => {
      props.logUnmount();
    };
  }, []);

  const handleFilterChange = (values) => {
    // let from = null;
    // let to = null;
    // let segmentIds = null;
    // if (values.from) {
    //   from = ['joined_from', values.from];
    //   setFrom(from);
    // }
    // if (values.to) {
    //   to = ['joined_to', values.to];
    //   setTo(to);
    // }
    // if (values.segmentIds) {
    //   segmentIds = ['for_segment_ids', values.segmentIds];
    //   setSegmentIds(segmentIds);
    // }
    // if (values.segmentLabels) {
    //   segmentIds = ['for_segment_ids', values.segmentIds];
    //   setSegmentIds(segmentIds);
    //   setSegmentLabels(values.segmentLabels);
    // }
    // getLogss(getScopes({ from, to, segmentIds }, defaultParams));
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getLogsBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getLogsBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <LogList
        logs={props.logs}
        logTotal={props.logTotal}
        isLoading={props.isLoading}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        exportLogsBegin={exportMembers}
        currentEnterprise={props.currentEnterprise}
        handleFilterChange={handleFilterChange}
      />
    </React.Fragment>
  );
}

LogListPage.propTypes = {
  getLogsBegin: PropTypes.func.isRequired,
  logUnmount: PropTypes.func.isRequired,
  logs: PropTypes.object,
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
