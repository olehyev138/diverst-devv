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
import { withStyles } from '@material-ui/core/styles';

import SegmentRulesList from 'components/Segment/SegmentRulesList';

const styles = theme => ({
  ruleInput: {
    width: '100%',
  },
});

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
        <SegmentRulesList
          values={values}
          classes={props.classes}
        />
      </Form>
    </Card>
  );
}

export function SegmentForm(props) {
  const initialValues = buildValues(props.segment, {
    id: { default: '' },
    name: { default: '' },
    field_rules: { default: [], customKey: 'field_rules_attributes' },
    order_rules: { default: [], customKey: 'order_rules_attributes' },
    group_rules: { default: [], customKey: 'group_rules_attributes' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        console.log(values);
        props.segmentAction(values);
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
  setFieldTouched: PropTypes.func,
  rules: PropTypes.object,
  classes: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles)
)(SegmentForm);
