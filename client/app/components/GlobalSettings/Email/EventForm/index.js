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
import { injectIntl, intlShape } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import {
  Card,
  CardActions,
  CardContent,
  TextField,
  Divider,
  FormControlLabel,
  Switch,
  FormControl,
  Box, Button,
} from '@material-ui/core';

import messages from 'containers/GlobalSettings/Email/Event/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import { withStyles } from '@material-ui/core/styles';
import { DiverstTimePicker } from 'components/Shared/Pickers/DiverstTimePicker';
import Select from 'components/Shared/DiverstSelect';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

const styles = theme => ({
  padding: {
    padding: theme.spacing(3, 2),
    margin: theme.spacing(1, 0),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  data: {
    '&:not(:last-of-type)': { // Prevent last data item from adding bottom padding
      paddingBottom: theme.spacing(3),
    },
  },
  buttons: {
    marginLeft: 20,
    float: 'right',
  },
});

/* eslint-disable object-curly-newline */
export function EventFormInner({
  handleSubmit, handleChange, handleBlur, values, touched, errors,
  buttonText, setFieldValue, setFieldTouched, setFieldError, classes,
  ...props
}) {
  const { intl } = props;

  return (
    <React.Fragment>
      <DiverstFormLoader isLoading={props.isFormLoading} isError={!props.event}>
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
                label={<DiverstFormattedMessage {...messages.form.name} />}
                value={values.name}
              />
              <FormControl
                variant='outlined'
              >
                <FormControlLabel
                  labelPlacement='end'
                  checked={values.disabled}
                  control={(
                    <Field
                      component={Switch}
                      color='primary'
                      onChange={handleChange}
                      disabled={props.isCommitting}
                      id='disabled'
                      name='disabled'
                      margin='normal'
                      checked={values.disabled}
                      value={values.disabled}
                    />
                  )}
                  label={<DiverstFormattedMessage {...messages.form.disabled} />}
                />
              </FormControl>
            </CardContent>
            <Divider />
            <CardContent>
              <Field
                component={Select}
                disabled
                fullWidth
                id='day'
                name='day'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.form.day} />}
                value={values.day}
                options={dig(props, 'event', 'timezones') || []}
              />
              <Field
                component={DiverstTimePicker}
                disabled={props.isCommitting}
                keyboardMode
                required
                fullWidth
                id='at'
                name='at'
                margin='normal'
                onChange={(value) => {
                  setFieldValue('at', value.toLocaleString(DateTime.TIME_24_SIMPLE));
                  setFieldTouched('at', true);
                }}
                onBlur={() => setFieldTouched('at', true)}
                label={<DiverstFormattedMessage {...messages.form.at} />}
                value={DateTime.fromISO(values.at)}
              />
              <Field
                component={Select}
                disabled={props.isCommitting}
                fullWidth
                id='tz'
                name='tz'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.form.tz} />}
                value={values.tz}
                options={dig(props, 'event', 'timezones') || []}
                onChange={value => setFieldValue('tz', value)}
                onBlur={() => setFieldTouched('tz', true)}
              />
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                <DiverstFormattedMessage {...messages.form.update} />
              </DiverstSubmit>
              <Button
                component={WrappedNavLink}
                to={props.links.eventsIndex}
                variant='contained'
                size='large'
                color='primary'
                className={classes.buttons}
              >
                <DiverstFormattedMessage {...messages.form.cancel} />
              </Button>
            </CardActions>
          </Form>
        </Card>
      </DiverstFormLoader>
    </React.Fragment>
  );
}

export function EventForm(props) {
  const event = dig(props, 'event');

  const initialValues = buildValues(event, {
    id: { default: '' },
    name: { default: '' },
    disabled: { default: false },
    day: { default: { label: -1, value: '' } },
    at: { default: '00:00' },
    tz: { default: '' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.eventAction(mapFields(values, ['time_zone']));
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

  classes: PropTypes.object,
  intl: intlShape.isRequired,
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
    eventEdit: PropTypes.string,
  }),

  classes: PropTypes.object,
  intl: intlShape.isRequired,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles),
)(EventForm);
