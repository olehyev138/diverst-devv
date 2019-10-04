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

import { FormattedMessage } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import {
  withStyles,
  Button, Card, CardActions, CardContent, TextField, Grid, Divider
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Event/messages';
import { buildValues } from 'utils/formHelpers';

import DiverstDateTimePicker from 'components/Shared/Pickers/DiverstDateTimePicker';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function EventFormInner({
  handleSubmit, handleChange, handleBlur, values, touched, errors,
  buttonText, setFieldValue, setFieldTouched, setFieldError,
  ...props
}) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={handleChange}
            required
            fullWidth
            id='name'
            name='name'
            label={<FormattedMessage {...messages.inputs.name} />}
            margin='normal'
            value={values.name}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='description'
            name='description'
            value={values.description}
            label={<FormattedMessage {...messages.inputs.description} />}
            multiline
            rows={4}
            variant='outlined'
            margin='normal'
          />
        </CardContent>
        <Divider />
        <CardContent>
          <Grid container spacing={6} justify='space-between'>
            <Grid item xs={12} sm md={5}>
              <Field
                component={DiverstDateTimePicker}
                required
                keyboardMode
                /* eslint-disable-next-line dot-notation */
                maxDate={touched['end'] ? values['end'] : undefined}
                maxDateMessage='Start date cannot be after end date'
                disablePast
                fullWidth
                id='start'
                name='start'
                margin='normal'
                label={<FormattedMessage {...messages.inputs.start} />}
              />
            </Grid>
            <Grid item xs={12} sm md={5}>
              <Field
                component={DiverstDateTimePicker}
                required
                keyboardMode
                /* eslint-disable-next-line dot-notation */
                minDate={values['start']}
                minDateMessage='End date cannot be before start date'
                disablePast
                fullWidth
                id='end'
                name='end'
                margin='normal'
                label={<FormattedMessage {...messages.inputs.end} />}
              />
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            {buttonText}
          </Button>
          <Button
            to={props.eventExists ? props.links.eventShow : props.links.eventsIndex}
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
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
        props.eventAction(values);
      }}

      render={formikProps => <EventFormInner eventExists={!!event} {...props} {...formikProps} />}
    />
  );
}

EventForm.propTypes = {
  eventAction: PropTypes.func,
  event: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object
};

EventFormInner.propTypes = {
  eventExists: PropTypes.bool,
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
  links: PropTypes.shape({
    eventsIndex: PropTypes.string,
    eventShow: PropTypes.string,
  })
};

export default compose(
  memo,
  withStyles(styles),
)(EventForm);
