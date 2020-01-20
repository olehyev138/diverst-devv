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
import { Field, Formik, Form } from 'formik';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import messages from 'containers/Segment/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl, Divider, Box,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { serializeSegment } from 'utils/customFieldHelpers';

import SegmentRulesList from 'components/Segment/SegmentRulesList';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

const styles = theme => ({
  ruleInput: {
    width: '100%',
  },
});

/* eslint-disable object-curly-newline */
export function SegmentFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <React.Fragment>
      <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.segment}>
        <Card>
          <Form>
            <CardContent>
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                required
                id='name'
                name='name'
                label={<DiverstFormattedMessage {...messages.form.name} />}
                value={values.name}
              />
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                {buttonText}
              </DiverstSubmit>
            </CardActions>
          </Form>
        </Card>
      </DiverstFormLoader>
      <Box mb={3} />
      <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.segment}>
        <SegmentRulesList
          values={values}
          classes={props.classes}
          {...props.ruleProps}
          currentEnterprise={props.currentEnterprise}
        />
      </DiverstFormLoader>
    </React.Fragment>
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
        props.segmentAction(serializeSegment(values));
      }}
    >
      {formikProps => <SegmentFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

SegmentForm.propTypes = {
  edit: PropTypes.bool,
  segmentAction: PropTypes.func,
  segment: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number
  }).isRequired
};

SegmentFormInner.propTypes = {
  edit: PropTypes.bool,
  segment: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  classes: PropTypes.object,
  getGroupsBegin: PropTypes.func,
  ruleProps: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number
  }).isRequired
};

export default compose(
  memo,
  withStyles(styles)
)(SegmentForm);
