import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Group/Outcome/reducer';
import saga from 'containers/Group/Outcome/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectOutcome, selectIsCommitting, selectIsFormLoading } from 'containers/Group/Outcome/selectors';

import {
  getOutcomeBegin, updateOutcomeBegin,
  outcomesUnmount
} from 'containers/Group/Outcome/actions';

import OutcomeForm from 'components/Group/Outcome/OutcomeForm';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/Outcome/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';


export function OutcomeEditPage(props) {
  useInjectReducer({ key: 'outcomes', reducer });
  useInjectSaga({ key: 'outcomes', saga });
  const { intl } = props;

  const { group_id: groupId, outcome_id: outcomeId } = useParams();
  const links = {
    outcomesIndex: ROUTES.group.plan.outcomes.index.path(groupId),
  };

  useEffect(() => {
    props.getOutcomeBegin({ id: outcomeId });

    return () => props.outcomesUnmount();
  }, []);

  const { currentUser, currentGroup, currentOutcome } = props;

  return (
    <OutcomeForm
      edit
      outcomeAction={props.updateOutcomeBegin}
      buttonText={intl.formatMessage(messages.update)}
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
  intl: intlShape.isRequired,
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  OutcomeEditPage,
  ['currentOutcome.permissions.update?', 'isFormLoading'],
  (props, params) => ROUTES.group.plan.index.path(params.group_id),
  permissionMessages.group.outcome.editPage
));
