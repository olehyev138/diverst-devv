/**
 *
 * Email Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';
import Interweave from 'interweave';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { injectIntl, intlShape } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import {
  Typography, Card, CardHeader, CardActions, CardContent, TextField, Grid, Divider, Box, Button
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/GlobalSettings/Email/Email/messages';
import { buildValues } from 'utils/formHelpers';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  padding: {
    padding: theme.spacing(3, 2),
    margin: theme.spacing(1, 0),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  data: {
    '&:not(:last-of-type)': { // Prevent last data item from adding bottom padding
      paddingBottom: theme.spacing(3),
    },
  },
  buttons: {
    marginLeft: 20,
    float: 'right',
  },
});

/* eslint-disable object-curly-newline */
export function EmailFormInner({
  handleSubmit, handleChange, handleBlur, values, touched, errors,
  buttonText, setFieldValue, setFieldTouched, setFieldError, classes,
  ...props
}) {
  const regex = /%{(.*?)}/g;
  const variables = dig(props, 'email', 'variables') || {};
  const replace = (whole, grouped) => {
    const example = dig(variables, grouped, 'example');
    return example || whole;
  };

  const { intl } = props;

  return (
    <React.Fragment>
      <DiverstFormLoader isLoading={props.isFormLoading} isError={!props.email}>
        <Card>
          <Form>
            <CardContent>
              <Field
                component={TextField}
                onChange={handleChange}
                disabled={props.isCommitting}
                required
                fullWidth
                id='subject'
                name='subject'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.form.subject} />}
                value={values.subject}
              />
              <Field
                component={TextField}
                onChange={handleChange}
                disabled={props.isCommitting}
                required
                fullWidth
                id='content'
                name='content'
                multiline
                rows={8}
                variant='outlined'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.form.content} />}
                value={values.content}
              />
            </CardContent>
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting}>
                <DiverstFormattedMessage {...messages.form.update} />
              </DiverstSubmit>
              <Button
                component={WrappedNavLink}
                to={props.links.emailsIndex}
                variant='contained'
                size='large'
                color='primary'
                className={classes.buttons}
              >
                <DiverstFormattedMessage {...messages.form.cancel} />
              </Button>
            </CardActions>
          </Form>
        </Card>
        <Box mb={2} />
        <Card>
          <CardHeader
            title={intl.formatMessage(messages.preview.title)}
            subheader={intl.formatMessage(messages.preview.subTitle)}
          />
          <CardContent>
            <Interweave
              content={values.subject.replace(regex, replace)}
            />
            <Divider />
            <Interweave
              content={values.content.replace(regex, replace)}
            />
          </CardContent>
        </Card>
        <Box mb={2} />
        <Card>
          <CardHeader
            title={intl.formatMessage(messages.variables.title)}
            subheader={intl.formatMessage(messages.variables.subTitle)}
          />
          {/* eslint-disable-next-line array-callback-return */}
          {props.email && Object.values(props.email.variables).map(variable => (
            <React.Fragment key={variable.id}>
              <CardContent>
                <Grid item>
                  <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                    {`%{${variable.key}}`}
                  </Typography>
                  <Typography color='secondary' component='h2' className={classes.data}>
                    {variable.description}
                  </Typography>
                </Grid>
              </CardContent>
              <Divider />
            </React.Fragment>
          ))}
        </Card>
      </DiverstFormLoader>
    </React.Fragment>
  );
}

export function EmailForm(props) {
  const email = dig(props, 'email');

  const initialValues = buildValues(email, {
    id: { default: '' },
    subject: { default: '' },
    content: { default: '' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.emailAction(values);
      }}
    >
      {formikProps => <EmailFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

EmailForm.propTypes = {
  edit: PropTypes.bool,
  emailAction: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,

  classes: PropTypes.object,
  intl: intlShape.isRequired,
};

EmailFormInner.propTypes = {
  edit: PropTypes.bool,
  email: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  touched: PropTypes.object,
  errors: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  setFieldError: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    emailsIndex: PropTypes.string,
    emailEdit: PropTypes.string,
  }),

  classes: PropTypes.object,
  intl: intlShape.isRequired,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles),
)(EmailForm);
