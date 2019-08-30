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
import Select from 'components/Shared/DiverstSelect';

import { buildValues, mapFields } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function MetricsDashboardFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const groupSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  const segmentSelectAction = (searchKey = '') => {
    props.getSegmentsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

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
          <Field
            component={Select}
            fullWidth
            name='group_ids'
            id='group_ids'
            label='Groups'
            isMulti
            margin='normal'
            value={values.group_ids}
            options={props.groups}
            onMenuOpen={groupSelectAction}
            onChange={value => setFieldValue('group_ids', value)}
            onInputChange={value => groupSelectAction(value)}
            onBlur={() => setFieldTouched('group_ids', true)}
          />
          <Field
            component={Select}
            fullWidth
            name='segment_ids'
            id='segment_ids'
            label='Segments'
            isMulti
            margin='normal'
            value={values.segment_ids}
            options={props.segments}
            onMenuOpen={segmentSelectAction}
            onChange={value => setFieldValue('segment_ids', value)}
            onInputChange={value => groupSelectAction(value)}
            onBlur={() => setFieldTouched('segment_ids', true)}
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
    groups: { default: [], customKey: 'group_ids' },
    segments: { default: [], customKey: 'segment_ids' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.metricsDashboardAction(mapFields(values, ['group_ids', 'segment_ids']));
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
  getGroupsBegin: PropTypes.func,
  getSegmentsBegin: PropTypes.func,
  groups: PropTypes.array,
  segments: PropTypes.array,
  links: PropTypes.shape({
    metricsDashboardsIndex: PropTypes.string,
    metricsDashboardShow: PropTypes.string,
  })
};

export default compose(
  memo,
)(MetricsDashboardForm);
