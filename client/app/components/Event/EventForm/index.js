/**
 *
 * Event Form Component
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
import messages from 'containers/Event/messages';
import { buildValues } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function EventFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
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
            label={<FormattedMessage {...messages.inputs.name} />}
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
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='start'
            name='start'
            value={values.start}
            label={<FormattedMessage {...messages.inputs.start} />}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='end'
            name='end'
            value={values.end}
            label={<FormattedMessage {...messages.inputs.end} />}
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
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
    eventsIndex: PropTypes.string,
    eventShow: PropTypes.string,
  })
};

export default compose(
  memo,
)(EventForm);
