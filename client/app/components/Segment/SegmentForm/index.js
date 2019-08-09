/**
 *
 * Segment Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'react-select';
import { Field, Formik, Form } from 'formik';
import { FormattedMessage } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Segment/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl
} from '@material-ui/core';

/* eslint-disable object-curly-newline */
export function SegmentFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
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
            label={<FormattedMessage {...messages.form.name} />}
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
        </CardActions>
      </Form>
    </Card>
  );
}

export function SegmentForm(props) {
  const initialValues = buildValues(props.segment, {
    name: { default: '' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.segmentAction({ segment: values.segment });
      }}

      render={formikProps => <SegmentFormInner {...props} {...formikProps} />}
    />
  );
}

SegmentForm.propTypes = {
  segmentAction: PropTypes.func,
  segment: PropTypes.object,
};

SegmentFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func
};

export default compose(
  memo,
)(SegmentForm);
