import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Group/Outcome/reducer';
import saga from 'containers/Group/Outcome/saga';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectIsCommitting } from 'containers/Group/Outcome/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { createOutcomeBegin, outcomesUnmount } from 'containers/Group/Outcome/actions';
import OutcomeForm from 'components/Group/Outcome/OutcomeForm';

export function OutcomeCreatePage(props) {
  useInjectReducer({ key: 'outcomes', reducer });
  useInjectSaga({ key: 'outcomes', saga });

  const { currentUser, currentGroup } = props;
  const rs = new RouteService(useContext);
  const links = {
    outcomesIndex: ROUTES.group.plan.outcomes.index.path(rs.params('group_id')),
  };

  useEffect(() => () => props.outcomesUnmount(), []);

  return (
    <OutcomeForm
      outcomeAction={props.createOutcomeBegin}
      buttonText='Create'
      currentUser={currentUser}
      currentGroup={currentGroup}
      links={links}
      isCommitting={props.isCommitting}
    />
  );
}

OutcomeCreatePage.propTypes = {
  createOutcomeBegin: PropTypes.func,
  outcomesUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createOutcomeBegin,
  outcomesUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(OutcomeCreatePage);
