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
export function SocialLinkFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.socialLink}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              disabled={props.isCommitting}
              required
              id='url'
              name='url'
              margin='normal'
              label= 'Social Link URL'
              value={values.url}
            />
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              disabled={props.isCommitting}
              required
              id='title'
              name='title'
              margin='normal'
              label= 'Title'
              value={values.title}
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
              id='description'
              name='description'
              margin='normal'
              value={values.description}
              label= 'Description'
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

export function SocialLinkForm(props) {
  const newsLink = dig(props, 'newsItem', 'social_link');

  const initialValues = buildValues(newsLink, {
    id: { default: '' },
    url: { default: '' },
    author_id: { default: dig(props, 'currentUser', 'id') || '' },
    group_id: { default: dig(props, 'currentGroup', 'id') || '' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.socialLinkAction(values);
      }}

      render={formikProps => <SocialLinkFormInner {...props} {...formikProps} newsLink={newsLink} />}
    />
  );
}

SocialLinkForm.propTypes = {
  edit: PropTypes.bool,
  socialLinkAction: PropTypes.func,
  socialLink: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

SocialLinkFormInner.propTypes = {
  edit: PropTypes.bool,
  socialLink: PropTypes.object,
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
)(SocialLinkForm);
