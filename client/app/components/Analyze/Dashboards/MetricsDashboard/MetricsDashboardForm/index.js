/**
 *
 * MetricsDashboard Form Component
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
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/messages';
import { buildValues } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function MetricsDashboardFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
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
          <Button
            to={props.metricsDashboardExists ? props.links.metricsDashboardShow : props.links.metricsDashboardsIndex}
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function MetricsDashboardForm(props) {
  const metricsDashboard = dig(props, 'metricsDashboard');

  const initialValues = buildValues(metricsDashboard, {
    id: { default: '' },
    name: { default: '' },
    description: { default: '' },
    start: { default: '' },
    end: { default: '' },
    max_attendees: { default: '' },
    location: { default: '' },
    annual_budget_id: { default: '' },
    budget_item_id: { default: '' },
    pillar_id: { default: '' },
    owner_id: { default: dig(props, 'currentUser', 'id') || '' },
    owner_group_id: { default: dig(props, 'currentGroup', 'id') || '' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.metricsDashboardAction(values);
      }}

      render={formikProps => <MetricsDashboardFormInner metricsDashboardExists={!!metricsDashboard} {...props} {...formikProps} />}
    />
  );
}

MetricsDashboardForm.propTypes = {
  metricsDashboardAction: PropTypes.func,
  metricsDashboard: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object
};

MetricsDashboardFormInner.propTypes = {
  metricsDashboardExists: PropTypes.bool,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
    metricsDashboardsIndex: PropTypes.string,
    metricsDashboardShow: PropTypes.string,
  })
};

export default compose(
  memo,
)(MetricsDashboardForm);
