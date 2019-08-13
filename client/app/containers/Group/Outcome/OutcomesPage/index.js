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

import { selectOutcomes } from 'containers/Group/Outcome/selectors';
import { getOutcomesBegin, outcomesUnmount } from 'containers/Group/Outcome/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import Outcomes from 'components/Group/Outcome/Outcomes';

const defaultParams = Object.freeze({
  count: 1000,
  page: 0,
  order: 'asc',
  orderBy: 'id',
});

export function OutcomesPage(props) {
  useInjectReducer({ key: 'outcomes', reducer });
  useInjectSaga({ key: 'outcomes', saga });

  useEffect(() => {
    const groupId = dig(props.currentGroup, 'id');
    if (groupId)
      props.getOutcomesBegin({ ...defaultParams, group_id: groupId });

    return () => props.outcomesUnmount();
  }, [dig(props.currentGroup, 'id')]);

  return (
    <Outcomes
      outcomes={props.outcomes}
    />
  );
}

OutcomesPage.propTypes = {
  getOutcomesBegin: PropTypes.func.isRequired,
  outcomesUnmount: PropTypes.func.isRequired,
  outcomes: PropTypes.array,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
};

const mapStateToProps = createStructuredSelector({
  outcomes: selectOutcomes(),
});

const mapDispatchToProps = {
  getOutcomesBegin,
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
