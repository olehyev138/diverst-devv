/**
 *
 * Event Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';
import { DateTime } from 'luxon';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Grid, Divider,
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Event/messages';
import { buildValues } from 'utils/formHelpers';

import DiverstDateTimePicker from 'components/Shared/Pickers/DiverstDateTimePicker';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstFileInput from 'components/Shared/DiverstFileInput';

/* eslint-disable object-curly-newline */
export function EventFormInner({
  handleSubmit, handleChange, handleBlur, values, touched, errors,
  buttonText, setFieldValue, setFieldTouched, setFieldError,
  ...props
}) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.event}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              disabled={props.isCommitting}
              required
              fullWidth
              id='name'
              name='name'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.inputs.name} />}
              value={values.name}
            />
            <Field
              component={TextField}
              onChange={handleChange}
              disabled={props.isCommitting}
              fullWidth
              id='description'
              name='description'
              multiline
              rows={4}
              variant='outlined'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.inputs.description} />}
              value={values.description}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <Grid container spacing={6} justify='space-between'>
              <Grid item xs md={5}>
                <Field
                  component={DiverstDateTimePicker}
                  disabled={props.isCommitting}
                  required
                  keyboardMode
                  /* eslint-disable-next-line dot-notation */
                  maxDate={touched['end'] ? values['end'] : undefined}
                  maxDateMessage={<DiverstFormattedMessage {...messages.inputs.starterror} />}
                  fullWidth
                  id='start'
                  name='start'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.inputs.start} />}
                />
              </Grid>
              <Grid item xs md={5}>
                <Field
                  component={DiverstDateTimePicker}
                  disabled={props.isCommitting}
                  required
                  keyboardMode
                  /* eslint-disable-next-line dot-notation */
                  minDate={values['start']}
                  minDateMessage={<DiverstFormattedMessage {...messages.inputs.enderror} />}
                  fullWidth
                  id='end'
                  name='end'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.inputs.end} />}
                />
              </Grid>
            </Grid>
          </CardContent>
          <Divider />
          <CardContent>
            <Field
              component={DiverstFileInput}
              fileName={props.event && props.event.picture_file_name}
              disabled={props.isCommitting}
              fullWidth
              id='picture'
              name='picture'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.inputs.picture} />}
              value={values.picture}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              to={props.event ? props.links.eventShow : props.links.eventsIndex}
              component={WrappedNavLink}
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

export function EventForm(props) {
  const event = dig(props, 'event');

  const initialValues = buildValues(event, {
    id: { default: '' },
    name: { default: '' },
    description: { default: '' },
    start: { default: DateTime.local().plus({ hour: 1 }) },
    end: { default: DateTime.local().plus({ hour: 2 }) },
    picture: { default: null },
    max_attendees: { default: '' },
    location: { default: '' },
    annual_budget_id: { default: '' },
    budget_item_id: { default: '' },
    pillar_id: { default: '' },
    owner_id: { default: '' },
    owner_group_id: { default: '' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.eventAction(values);
      }}
    >
      {formikProps => <EventFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

EventForm.propTypes = {
  edit: PropTypes.bool,
  eventAction: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

EventFormInner.propTypes = {
  edit: PropTypes.bool,
  event: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  touched: PropTypes.object,
  errors: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  setFieldError: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    eventsIndex: PropTypes.string,
    eventShow: PropTypes.string,
  })
};

export default compose(
  memo,
)(EventForm);
