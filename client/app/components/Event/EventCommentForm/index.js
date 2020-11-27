/**
 *
 * Event Comment Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, CardHeader, TextField, Typography, Divider,
} from '@material-ui/core';
import withStyles from '@material-ui/core/styles/withStyles';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

import messages from 'containers/Event/messages';
import { DiverstFormattedMessage } from '../../Shared/DiverstFormattedMessage';

const styles = theme => ({
  formTitle: {
    fontSize: 18,
  },
});

/* eslint-disable object-curly-newline */
export function EventCommentFormInner({ classes, handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Typography
            paragraph
          >
            <DiverstFormattedMessage {...messages.comment.label} />
          </Typography>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            disabled={props.isCommitting}
            id='content'
            name='content'
            variant='outlined'
            value={values.content}
            label=<DiverstFormattedMessage {...messages.comment.input} />
            multiline
            required
          />
        </CardContent>
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            <DiverstFormattedMessage {...messages.comment.submit} />
          </DiverstSubmit>
        </CardActions>
      </Form>
    </Card>
  );
}

export function EventCommentForm(props) {
  const initialValues = {
    user_id: props?.currentUserId || undefined,
    initiative_id: props?.event?.id || undefined,
    content: '',
  };
  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        // pass initiative_id to saga to refresh event with new comment
        props.commentAction({
          initiative_id: props?.event?.id || undefined,
          attributes: values
        });
        actions.resetForm();
      }}
    >
      {formikProps => <EventCommentFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

EventCommentForm.propTypes = {
  classes: PropTypes.object,
  commentAction: PropTypes.func,
  event: PropTypes.object,
  currentUserId: PropTypes.number,
  isCommitting: PropTypes.bool,
};

EventCommentFormInner.propTypes = {
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(EventCommentForm);
