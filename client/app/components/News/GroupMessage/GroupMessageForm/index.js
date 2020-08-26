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

import messages from 'containers/News/messages';
import { buildValues } from 'utils/formHelpers';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from '../../../Shared/DiverstCancel';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

/* eslint-disable object-curly-newline */
export function GroupMessageFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.groupMessage}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              disabled={props.isCommitting}
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
              disabled={props.isCommitting}
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
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <DiverstCancel
              disabled={props.isCommitting}
              redirectFallback={props.links.newsFeedIndex}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </DiverstCancel>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function GroupMessageForm(props) {
  const groupMessage = dig(props, 'newsItem', 'group_message');

  const initialValues = buildValues(groupMessage, {
    id: { default: '' },
    subject: { default: '' },
    content: { default: '' },
    owner_id: { default: dig(props, 'currentUser', 'user_id') || '' },
    group_id: { default: dig(props, 'currentGroup', 'id') || '' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupMessageAction(values);
      }}
    >
      {formikProps => <GroupMessageFormInner {...props} {...formikProps} groupMessage={groupMessage} />}
    </Formik>
  );
}

GroupMessageForm.propTypes = {
  edit: PropTypes.bool,
  groupMessageAction: PropTypes.func,
  groupMessage: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

GroupMessageFormInner.propTypes = {
  edit: PropTypes.bool,
  groupMessage: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    newsFeedIndex: PropTypes.string
  })
};

export default compose(
  memo,
)(GroupMessageForm);
