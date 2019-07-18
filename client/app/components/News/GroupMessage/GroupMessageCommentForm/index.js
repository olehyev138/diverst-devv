/**
 *
 * Group Message Comment Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import {
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl
} from '@material-ui/core';
import Select from 'react-select';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { fillPath } from 'utils/routeHelpers';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/News/messages';

import { mapSelectAssociations } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function GroupMessageCommentFormInner({ handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
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
            Submit
          </Button>
          <Button
            to='/temp'
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupMessageCommentForm(props) {
  // No comment editing

  const initialValues = {
//    author_id: props.user.id,
//    message_id: props.groupMessage.id,
    content: '',
  };

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
         // props.commentAction(mapSelectAssociations(values, [], []));

        console.log('hey');
      }}

      render={formikProps => <GroupMessageCommentFormInner {...props} {...formikProps} />}
    />
  );
}

GroupMessageCommentForm.propTypes = {
  commentAction: PropTypes.func,
  groupMessage: PropTypes.object,
  user: PropTypes.object,
};

GroupMessageCommentFormInner.propTypes = {
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
)(GroupMessageCommentForm);
