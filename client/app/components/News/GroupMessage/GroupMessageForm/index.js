/**
 *
 * Group Message Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Divider
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/News/messages';
import { buildValues } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function GroupMessageFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            required
            id='subject'
            name='subject'
            margin='normal'
            label={<DiverstFormattedMessage {...messages.subject} />}
            value={values.subject}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            required
            fullWidth
            multiline
            rows={4}
            variant='outlined'
            id='content'
            name='content'
            margin='normal'
            value={values.content}
            label={<DiverstFormattedMessage {...messages.content} />}
          />
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
            to={props.links.newsFeedIndex}
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupMessageForm(props) {
  const groupMessage = dig(props, 'newsItem', 'group_message');

  const initialValues = buildValues(groupMessage, {
    subject: { default: '' },
    content: { default: '' },
    owner_id: { default: dig(props, 'currentUser', 'id') || '' },
    group_id: { default: dig(props, 'currentGroup', 'id') || '' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupMessageAction(values);
      }}

      render={formikProps => <GroupMessageFormInner {...props} {...formikProps} />}
    />
  );
}

GroupMessageForm.propTypes = {
  groupMessageAction: PropTypes.func,
  groupMessage: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object
};

GroupMessageFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
    newsFeedIndex: PropTypes.string
  })
};

export default compose(
  memo,
)(GroupMessageForm);
