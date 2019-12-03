import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Group/Outcome/reducer';
import saga from 'containers/Group/Outcome/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectOutcome, selectIsCommitting, selectIsFormLoading } from 'containers/Group/Outcome/selectors';

import {
  getOutcomeBegin, updateOutcomeBegin,
  outcomesUnmount
} from 'containers/Group/Outcome/actions';

import OutcomeForm from 'components/Group/Outcome/OutcomeForm';

export function OutcomeEditPage(props) {
  useInjectReducer({ key: 'outcomes', reducer });
  useInjectSaga({ key: 'outcomes', saga });

  const rs = new RouteService(useContext);
  const links = {
    outcomesIndex: ROUTES.group.plan.outcomes.index.path(rs.params('group_id')),
  };

  useEffect(() => {
    const outcomeId = rs.params('outcome_id');
    props.getOutcomeBegin({ id: outcomeId });

    return () => props.outcomesUnmount();
  }, []);

  const { currentUser, currentGroup, currentOutcome } = props;

  return (
    <OutcomeForm
      edit
      outcomeAction={props.updateOutcomeBegin}
      buttonText='Update'
      currentUser={currentUser}
      currentGroup={currentGroup}
      outcome={currentOutcome}
      links={links}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
    />
  );
}

OutcomeEditPage.propTypes = {
  getOutcomeBegin: PropTypes.func,
  updateOutcomeBegin: PropTypes.func,
  outcomesUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentOutcome: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentOutcome: selectOutcome(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  getOutcomeBegin,
  updateOutcomeBegin,
  outcomesUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(OutcomeEditPage);
