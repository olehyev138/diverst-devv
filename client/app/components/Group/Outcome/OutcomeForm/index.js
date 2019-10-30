/**
 *
 * Outcome Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Group/Outcome/messages';
import { buildValues } from 'utils/formHelpers';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

/* eslint-disable object-curly-newline */
export function OutcomeFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.outcome}>
      <Card>
        <Form>
          <CardContent>
          </CardContent>
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={props.links.outcomesIndex}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function OutcomeForm(props) {
  const outcome = dig(props, 'outcome');

  const initialValues = buildValues(outcome, {
    id: { default: '' },
    name: { default: '' },
    group_id: { default: dig(props, 'currentGroup', 'id') || '' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.outcomeAction(values);
      }}

      render={formikProps => <OutcomeFormInner {...props} {...formikProps} />}
    />
  );
}

OutcomeForm.propTypes = {
  edit: PropTypes.bool,
  outcomeAction: PropTypes.func,
  outcome: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

OutcomeFormInner.propTypes = {
  edit: PropTypes.bool,
  outcome: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    outcomesIndex: PropTypes.string,
  })
};

export default compose(
  memo,
)(OutcomeForm);
