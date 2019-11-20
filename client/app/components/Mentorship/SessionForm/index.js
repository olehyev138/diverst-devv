/**
 *
 * Session Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import { FormattedMessage, injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField,
  Divider, Grid, FormControlLabel, Switch, FormControl
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Mentorship/Session/messages';
import appMessages from 'containers/Shared/App/messages';
import { buildValues, mapFields } from 'utils/formHelpers';
import { withStyles } from '@material-ui/core/styles';

/* eslint-disable object-curly-newline */
export function SessionFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const days = [...Array(7).keys()].map(day => ({ label: props.intl.formatMessage(appMessages.days_of_week[day]), value: day }));
  return (
    <React.Fragment>
      { props.session && (
        <Card>
          <Form>
            <CardContent>
              {/* Notes Bio */}
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                margin='normal'
                multiline
                rows={4}
                variant='outlined'
                id='notes'
                name='notes'
                value={values.notes}
                label='TODO Notes'
              />
              {/* Interest */}
              <Select
                name='mentoring_interest_ids'
                id='mentoring_interest_ids'
                isMulti
                fullWidth
                margin='normal'
                label='TODO Topic'
                value={values.mentoring_interest_ids}
                options={props.interestsOptions}
                onChange={value => setFieldValue('mentoring_interest_ids', value)}
              />
              {/* Users */}
              <Select
                name='user_ids'
                id='user_ids'
                isMulti
                fullWidth
                margin='normal'
                label='TODO Users'
                value={values.user_ids}
                options={dig(props, 'user', 'mentees')}
                onChange={value => setFieldValue('user_ids', value)}
              />
            </CardContent>
            <CardActions>
              <Button
                color='primary'
                type='submit'
              >
                Submit
              </Button>
            </CardActions>
          </Form>
        </Card>
      )}
    </React.Fragment>
  );
}

export function SessionForm(props) {
  const session = dig(props, 'session');

  const initialValues = buildValues(session, {
    start: { default: '' },
    end: { default: '' },
    mentoring_interests: { default: [], customKey: 'mentoring_interest_ids' },
    medium: { default: 'Video' },
    users: { default: [], customKey: 'user_ids' },
    resources: { default: [], customKey: 'resource_ids' },
    notes: { default: '' },
    id: { default: undefined }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const payload = mapFields(values, ['mentoring_interest_ids', 'user_ids', 'resource_ids']);
        props.sessionAction(payload);
      }}
    >
      {formikProps => <SessionFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

SessionForm.propTypes = {
  sessionAction: PropTypes.func,
  session: PropTypes.object,
  currentSession: PropTypes.object,
};

SessionFormInner.propTypes = {
  intl: intlShape.isRequired,
  session: PropTypes.object,
  fieldData: PropTypes.array,
  updateFieldDataBegin: PropTypes.func,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  interestsOptions: PropTypes.array.isRequired,
  links: PropTypes.shape({
    sessionsIndex: PropTypes.string
  })
};

export default compose(
  memo,
  injectIntl,
)(SessionForm);
