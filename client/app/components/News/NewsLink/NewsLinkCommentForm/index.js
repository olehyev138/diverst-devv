import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, CardHeader, TextField, Typography, Divider,
} from '@material-ui/core';
import withStyles from '@material-ui/core/styles/withStyles';

import messages from 'containers/News/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

const styles = theme => ({
  formTitle: {
    fontSize: 18,
  },

});

/* eslint-disable object-curly-newline */
export function NewsLinkCommentFormInner({ classes, handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...props }) {
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
            disabled={props.isCommitting}
            id='content'
            name='content'
            variant='outlined'
            value={values.content}
            label={<DiverstFormattedMessage {...messages.content} />}
          />
        </CardContent>
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            <DiverstFormattedMessage {...messages.comment_submit} />
          </DiverstSubmit>
        </CardActions>
      </Form>
    </Card>
  );
}

export function NewsLinkCommentForm(props) {
  // No comment editing

  const initialValues = {
    author_id: dig(props, 'currentUserId') || undefined,
    news_link_id: dig(props, 'newsItem', 'news_link', 'id') || undefined,
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

      render={formikProps => <NewsLinkCommentFormInner {...props} {...formikProps} />}
    />
  );
}

NewsLinkCommentForm.propTypes = {
  classes: PropTypes.object,
  commentAction: PropTypes.func,
  newsItem: PropTypes.object,
  currentUserId: PropTypes.number,
  isCommitting: PropTypes.bool,
};

NewsLinkCommentFormInner.propTypes = {
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  links: PropTypes.shape({
    newsFeedIndex: PropTypes.string
  })
};

export default compose(
  memo,
  withStyles(styles)
)(NewsLinkCommentForm);
