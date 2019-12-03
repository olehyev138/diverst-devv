import React, { memo, useEffect, useContext } from 'react';
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
import { selectOutcome } from 'containers/Group/Outcome/selectors';

import { getOutcomeBegin, deleteOutcomeBegin, outcomesUnmount } from 'containers/Group/Outcome/actions';

import Outcome from 'components/Group/Outcome/Outcome';

export function OutcomePage(props) {
  useInjectReducer({ key: 'outcomes', reducer });
  useInjectSaga({ key: 'outcomes', saga });

  const rs = new RouteService(useContext);
  const links = {
    outcomesIndex: ROUTES.group.outcomes.index.path(rs.params('group_id')),
    outcomeEdit: ROUTES.group.outcomes.edit.path(rs.params('group_id'), rs.params('outcome_id')),
    eventNew: ROUTES.group.events.new.path(rs.params('group_id')),
    eventManage: eventId => ROUTES.group.events.manage.path(rs.params('group_id'), eventId)
  };

  useEffect(() => {
    const outcomeId = rs.params('outcome_id');

    // get outcome specified in path
    props.getOutcomeBegin({ id: outcomeId });

    return () => props.outcomesUnmount();
  }, []);

  const { currentUser, currentOutcome } = props;

  if (currentUser && currentOutcome)
    return (
      <Outcome
        currentUserId={currentUser.id}
        deleteOutcomeBegin={props.deleteOutcomeBegin}
        outcome={currentOutcome}
        links={links}
      />
    );
}

OutcomePage.propTypes = {
  getOutcomeBegin: PropTypes.func,
  deleteOutcomeBegin: PropTypes.func,
  outcomesUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentOutcome: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentOutcome: selectOutcome(),
});

const mapDispatchToProps = {
  getOutcomeBegin,
  deleteOutcomeBegin,
  outcomesUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(OutcomePage);
