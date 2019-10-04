/**
 *
 * Group Message Comment Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import { FormattedMessage } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, CardHeader, TextField, Typography, Divider,
} from '@material-ui/core';
import withStyles from '@material-ui/core/styles/withStyles';

import messages from 'containers/News/messages';

const styles = theme => ({
  formTitle: {
    fontSize: 18,
  },

});

/* eslint-disable object-curly-newline */
export function GroupMessageCommentFormInner({ classes, handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Typography
            paragraph
          >
            Leave a Comment
          </Typography>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='content'
            name='content'
            variant='outlined'
            value={values.content}
            label={<FormattedMessage {...messages.content} />}
          />
        </CardContent>
        <Divider />
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
  );
}

export function GroupMessageCommentForm(props) {
  // No comment editing

  const initialValues = {
    author_id: dig(props, 'currentUserId') || undefined,
    message_id: dig(props, 'newsItem', 'group_message', 'id') || undefined,
    content: '',
  };

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        // pass news_feed_link_id to saga to refetch news_feed_link with new comment
        props.commentAction({
          news_feed_link_id: dig(props, 'newsItem', 'id') || undefined,
          attributes: values
        });

        actions.resetForm();
      }}

      render={formikProps => <GroupMessageCommentFormInner {...props} {...formikProps} />}
    />
  );
}

GroupMessageCommentForm.propTypes = {
  classes: PropTypes.object,
  commentAction: PropTypes.func,
  newsItem: PropTypes.object,
  currentUserId: PropTypes.number,
};

GroupMessageCommentFormInner.propTypes = {
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
    newsFeedIndex: PropTypes.string
  })
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMessageCommentForm);
