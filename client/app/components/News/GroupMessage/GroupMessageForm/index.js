/**
 *
 * Group Message Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import {
  Button, Card, CardActions, CardContent, TextField
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/News/messages';

import { mapSelectAssociations, exclude } from 'utils/formHelpers';

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
            id='subject'
            name='subject'
            label={<FormattedMessage {...messages.subject} />}
            value={values.subject}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='content'
            name='content'
            value={values.content}
            label={<FormattedMessage {...messages.content} />}
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
            to={props.links.newsFeedIndex}
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupMessageForm(props) {
  const groupMessage = dig(props, 'newsItem', 'group_message');
  const initialValues = {
    subject: '',
    content: '',
  };

  return (
    <Formik
      initialValues={groupMessage || initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        // TODO: have to do this here - only place these are 100% set
        //   - write a helper
        let finalValues = exclude(values, 'group', 'comments_count', 'owner', 'comments');
        finalValues = {
          ...finalValues,
          owner_id: props.currentUser.id,
          group_id: props.currentGroup.id
        };

        props.groupMessageAction(mapSelectAssociations(finalValues, [], []));
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
