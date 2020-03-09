/**
 *
 * CustomGraph Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, Divider
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/messages';
import Select from 'components/Shared/DiverstSelect';

import { buildValues, mapFields } from 'utils/formHelpers';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

/* eslint-disable object-curly-newline */
export function CustomGraphFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const fieldSelectAction = (searchKey = '') => {
    props.getFieldsBegin({
      enterpriseId: props.currentEnterprise.id,
      count: 10, page: 0, order: 'asc',
      orderBy: 'fields.id',
      search: searchKey,
    });
  };

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.customGraph}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={Select}
              fullWidth
              required
              name='field_id'
              id='field_id'
              label={<DiverstFormattedMessage {...messages.fields.field} />}
              margin='normal'
              disabled={props.isCommitting}
              value={values.field_id}
              options={props.fields}
              onMenuOpen={fieldSelectAction}
              onChange={value => setFieldValue('field_id', value)}
              onInputChange={value => fieldSelectAction(value)}
              onBlur={() => setFieldTouched('field_id', true)}
            />
            <Field
              component={Select}
              fullWidth
              name='aggregation_id'
              id='aggregation_id'
              label={<DiverstFormattedMessage {...messages.fields.aggregation} />}
              margin='normal'
              disabled={props.isCommitting}
              value={values.aggregation_id}
              options={props.fields}
              onMenuOpen={fieldSelectAction}
              onChange={value => setFieldValue('aggregation_id', value)}
              onInputChange={value => fieldSelectAction(value)}
              onBlur={() => setFieldTouched('aggregation_id', true)}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              component={WrappedNavLink}
              to={props.links.metricsDashboardShow}
              disabled={props.isCommitting}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function CustomGraphForm(props) {
  const customGraph = dig(props, 'customGraph');
  const initialValues = buildValues(customGraph, {
    id: { default: '' },
    field: { default: '', customKey: 'field_id' },
    aggregation: { default: '', customKey: 'aggregation_id' },
    metrics_dashboard_id: { default: props.metricsDashboardId }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.customGraphAction(mapFields(values, ['field_id', 'aggregation_id']));
      }}
    >
      {formikProps => <CustomGraphFormInner {...formikProps} {...props} />}
    </Formik>
  );
}

CustomGraphForm.propTypes = {
  edit: PropTypes.bool,
  customGraphAction: PropTypes.func,
  customGraph: PropTypes.object,
  metricsDashboardId: PropTypes.string.isRequired,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

CustomGraphFormInner.propTypes = {
  edit: PropTypes.bool,
  customGraph: PropTypes.object,
  metricsDashboardExists: PropTypes.bool,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  getFieldsBegin: PropTypes.func,
  fields: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number
  }),
  links: PropTypes.shape({
    metricsDashboardShow: PropTypes.string,
  })
};

export default compose(
  memo,
)(CustomGraphForm);
