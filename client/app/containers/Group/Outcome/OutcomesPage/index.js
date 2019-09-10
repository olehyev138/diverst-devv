import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import dig from 'object-dig';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/Outcome/reducer';
import saga from 'containers/Group/Outcome/saga';

import { selectPaginatedOutcomes, selectOutcomeTotal } from 'containers/Group/Outcome/selectors';
import { getOutcomesBegin, deleteOutcomeBegin, outcomesUnmount } from 'containers/Group/Outcome/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import OutcomesList from 'components/Group/Outcome/OutcomesList';

const defaultParams = Object.freeze({
  count: 10,
  page: 0,
  order: 'asc',
  orderBy: 'id',
});

export function OutcomesPage(props) {
  useInjectReducer({ key: 'outcomes', reducer });
  useInjectSaga({ key: 'outcomes', saga });

  const [params, setParams] = useState(defaultParams);
  const groupId = dig(props.currentGroup, 'id');

  const rs = new RouteService(useContext);
  const links = {
    outcomesIndex: ROUTES.group.outcomes.index.path(rs.params('group_id')),
    outcomeNew: ROUTES.group.outcomes.new.path(rs.params('group_id')),
    outcomeEdit: id => ROUTES.group.outcomes.edit.path(rs.params('group_id'), id)
  };

  useEffect(() => {
    if (groupId)
      props.getOutcomesBegin({ ...params, group_id: groupId });

    return () => props.outcomesUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = {
      ...params,
      count: payload.count,
      page: payload.page
    };

    props.getOutcomesBegin({ ...newParams, group_id: groupId });
    setParams(newParams);
  };

  return (
    <OutcomesList
      outcomes={props.outcomes}
      outcomeTotal={props.outcomeTotal}
      deleteOutcomeBegin={props.deleteOutcomeBegin}
      defaultParams={defaultParams}
      handlePagination={handlePagination}
      links={links}
    />
  );
}

OutcomesPage.propTypes = {
  getOutcomesBegin: PropTypes.func.isRequired,
  deleteOutcomeBegin: PropTypes.func.isRequired,
  outcomesUnmount: PropTypes.func.isRequired,
  outcomes: PropTypes.array,
  outcomeTotal: PropTypes.number,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
};

const mapStateToProps = createStructuredSelector({
  outcomes: selectPaginatedOutcomes(),
  outcomeTotal: selectOutcomeTotal(),
});

const mapDispatchToProps = {
  getOutcomesBegin,
  deleteOutcomeBegin,
  outcomesUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(OutcomesPage);
