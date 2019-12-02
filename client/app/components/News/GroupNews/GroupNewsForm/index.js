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
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

/* eslint-disable object-curly-newline */
export function GroupNewsFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.groupNews}>
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
            <Button
              disabled={props.isCommitting}
              to={props.links.newsFeedIndex}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function GroupNewsForm(props) {
  const groupNews = dig(props, 'newsItem', 'group_news');

  const initialValues = buildValues(groupNews, {
    id: { default: '' },
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
        props.groupNewsAction(values);
      }}

      render={formikProps => <GroupNewsFormInner {...props} {...formikProps} groupNews={groupNews} />}
    />
  );
}

GroupNewsForm.propTypes = {
  edit: PropTypes.bool,
  groupNewsAction: PropTypes.func,
  groupNews: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

GroupNewsFormInner.propTypes = {
  edit: PropTypes.bool,
  groupNews: PropTypes.object,
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
)(GroupNewsForm);
