/**
 *
 * Outcome Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import { FormattedMessage } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Group/Outcome/messages';
import { buildValues } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function OutcomeFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='name'
            name='name'
            label={<FormattedMessage {...messages.inputs.name} />}
            value={values.name}
          />
        </CardContent>
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            {buttonText}
          </Button>
          <Button
            to={props.links.outcomesIndex}
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
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
      onSubmit={(values, _) => {
        props.outcomeAction(values);
      }}

      render={formikProps => <OutcomeFormInner {...props} {...formikProps} />}
    />
  );
}

OutcomeForm.propTypes = {
  outcomeAction: PropTypes.func,
  outcome: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object
};

OutcomeFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
    outcomesIndex: PropTypes.string,
  })
};

export default compose(
  memo,
)(OutcomeForm);
