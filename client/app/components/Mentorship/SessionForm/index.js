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

import messages from 'containers/Mentorship/Session/messages';
import { buildValues, mapFields } from 'utils/formHelpers';
import DiverstDateTimePicker from 'components/Shared/Pickers/DiverstDateTimePicker';
import { DateTime } from 'luxon';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

/* eslint-disable object-curly-newline */
export function SessionFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <React.Fragment>
      <Card>
        <Form>
          <CardContent>
            {/* Notes Bio */}
            <Field
              component={TextField}
              onChange={handleChange}
              disabled={props.isCommitting}
              fullWidth
              margin='normal'
              multiline
              rows={4}
              variant='outlined'
              id='notes'
              name='notes'
              value={values.notes}
              label={props.intl.formatMessage(messages.form.notes)}
            />
            { /* Start and End Pickers */ }
            <Field
              component={DiverstDateTimePicker}
              disabled={props.isCommitting}
              required
              keyboardMode
              /* eslint-disable-next-line dot-notation */
              maxDate={values['end'] || undefined}
              maxDateMessage={props.intl.formatMessage(messages.form.start_message)}
              fullWidth
              id='start'
              name='start'
              margin='normal'
              label={props.intl.formatMessage(messages.form.start)}
            />
            <Field
              component={DiverstDateTimePicker}
              disabled={props.isCommitting}
              required
              keyboardMode
              /* eslint-disable-next-line dot-notation */
              minDate={values['start']}
              minDateMessage={props.intl.formatMessage(messages.form.end_message)}
              fullWidth
              id='end'
              name='end'
              margin='normal'
              label={props.intl.formatMessage(messages.form.end)}
            />
            <Field
              component={TextField}
              onChange={handleChange}
              disabled={props.isCommitting}
              fullWidth
              margin='normal'
              rows={4}
              variant='outlined'
              id='link'
              name='link'
              value={values.link}
              label={props.intl.formatMessage(messages.form.link)}
            />
            {/* Interest */}
            <Select
              name='mentoring_interest_ids'
              id='mentoring_interest_ids'
              disabled={props.isCommitting}
              isMulti
              fullWidth
              margin='normal'
              label={props.intl.formatMessage(messages.form.topics)}
              value={values.mentoring_interest_ids}
              options={props.interestOptions}
              onChange={value => setFieldValue('mentoring_interest_ids', value)}
            />
            {/* Users */}
            <Select
              name='user_ids'
              id='user_ids'
              isMulti
              fullWidth
              margin='normal'
              label={props.intl.formatMessage(messages.form.users)}
              value={values.user_ids}
              options={dig(props, 'user', 'mentees')}
              onChange={value => setFieldValue('user_ids', value)}
            />
          </CardContent>
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
          </CardActions>
        </Form>
      </Card>
    </React.Fragment>
  );
}

export function SessionForm(props) {
  const session = dig(props, 'session');


  const initialValues = buildValues(session, {
    mentoring_interests: { default: [], customKey: 'mentoring_interest_ids' },
    medium: { default: 'Video' },
    users: { default: [], customKey: 'user_ids' },
    resources: { default: [], customKey: 'resource_ids' },
    start: { default: DateTime.local().plus({ hour: 1 }) },
    end: { default: DateTime.local().plus({ hour: 2 }) },
    link: { default: '' },
    creator_id: { default: props.user.id },
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
  user: PropTypes.object,
  isCommitting: PropTypes.bool,
  buttonText: PropTypes.string,
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
  interestOptions: PropTypes.array.isRequired,
  isCommitting: PropTypes.bool,
  links: PropTypes.shape({
    sessionsIndex: PropTypes.string
  })
};

export default compose(
  memo,
  injectIntl,
)(SessionForm);
