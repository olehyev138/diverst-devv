/**
 *
 * MetricsDashboard Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Divider
} from '@material-ui/core';

import messages from 'containers/Analyze/Dashboards/MetricsDashboard/messages';
import Select from 'components/Shared/DiverstSelect';

import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from 'components/Shared/DiverstCancel';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

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
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.metricsDashboard}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              required
              id='name'
              name='name'
              margin='normal'
              disabled={props.isCommitting}
              label={<DiverstFormattedMessage {...messages.fields.name} />}
              value={values.name}
            />
            <Field
              component={Select}
              fullWidth
              name='group_ids'
              id='group_ids'
              label={<DiverstFormattedMessage {...messages.fields.groups} />}
              isMulti
              margin='normal'
              disabled={props.isCommitting}
              value={values.group_ids}
              options={props.groups}
              onChange={value => setFieldValue('group_ids', value)}
              onInputChange={value => groupSelectAction(value)}
              onBlur={() => setFieldTouched('group_ids', true)}
            />
            <Field
              component={Select}
              fullWidth
              name='segment_ids'
              id='segment_ids'
              label={<DiverstFormattedMessage {...messages.fields.segments} />}
              isMulti
              margin='normal'
              disabled={props.isCommitting}
              value={values.segment_ids}
              options={props.segments}
              onChange={value => setFieldValue('segment_ids', value)}
              onInputChange={value => groupSelectAction(value)}
              onBlur={() => setFieldTouched('segment_ids', true)}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              <DiverstFormattedMessage {...buttonText} />
            </DiverstSubmit>
            <DiverstCancel
              redirectFallback={props.links.metricsDashboardsIndex}
              disabled={props.isCommitting}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </DiverstCancel>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function MetricsDashboardForm(props) {
  const metricsDashboard = props?.metricsDashboard;
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
    >
      {formikProps => <MetricsDashboardFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

MetricsDashboardForm.propTypes = {
  edit: PropTypes.bool,
  metricsDashboardAction: PropTypes.func,
  metricsDashboard: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

MetricsDashboardFormInner.propTypes = {
  edit: PropTypes.bool,
  metricsDashboard: PropTypes.object,
  metricsDashboardExists: PropTypes.bool,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  getSegmentsBegin: PropTypes.func,
  groups: PropTypes.array,
  segments: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    metricsDashboardsIndex: PropTypes.string,
    metricsDashboardShow: PropTypes.string,
  })
};

export default compose(
  memo,
)(MetricsDashboardForm);
