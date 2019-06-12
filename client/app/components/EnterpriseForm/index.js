/**
 *
 * EnterpriseForm
 *
 */

import React, { memo, useRef, useEffect } from 'react';
import PropTypes from 'prop-types';


import { FormattedMessage } from 'react-intl';
import {
  Button, Card, CardActions, CardContent, Grid, TextField, Hidden
} from '@material-ui/core';
import Search from '@material-ui/icons/Search';
import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import { withStyles } from '@material-ui/core/styles';

import Logo from 'components/Logo';

import messages from 'containers/LoginPage/messages';

const styles = theme => ({
  card: {
    width: '100%',
  },
  submitButtonLabel: {
    minWidth: 'max-content',
  },
});

function EnterpriseForm(props, context) {
  const { classes } = props;
  const { intl } = context;

  const EnterpriseFormSchema = Yup.object().shape({
    email: Yup
      .string()
      .email(intl.formatMessage(messages.invalidEmail))
  });

  const form = useRef();

  // Use React hook (as this is a functional component) to merge local validation errors with API validation errors
  useEffect(() => {
    if (form.current)
      form.current.setErrors({ ...form.current.state.errors, ...props.formErrors });
  });

  return (
    <Formik
      ref={form}
      initialValues={{
        email: '',
      }}
      validateOnBlur={false}
      validateOnChange={false}
      validationSchema={EnterpriseFormSchema}
      onSubmit={(values, actions) => {
        props.findEnterpriseBegin(values);
      }}
      render={({
        handleSubmit, handleChange, handleBlur, setErrors, errors, touched, values
      }) => (
        <Card raised className={classes.card}>
          <Form
            noValidate
          >
            <CardContent>
              <Grid container spacing={0} direction='column' alignItems='center' justify='center'>
                <Grid item xs={12}>
                  <Logo coloredDefault imgClass='large-img' />
                </Grid>
              </Grid>
              <br />
              <Field
                component={TextField}
                onChange={handleChange}
                onBlur={handleBlur}
                autoFocus
                fullWidth
                id='email'
                name='email'
                label={<FormattedMessage {...messages.email} />}
                margin='normal'
                type='email'
                variant='outlined'
                error={errors.email && touched.email}
                helperText={errors.email && touched.email ? errors.email : null}
              />
            </CardContent>
            <CardActions>
              <Grid container alignItems='center' justify='center'>
                <Grid item align='center' sm={6} xs={12}>
                  <Button
                    classes={{
                      label: classes.submitButtonLabel
                    }}
                    type='submit'
                    color='primary'
                    size='large'
                    variant='contained'
                    aria-hidden
                    disabled={!values.email}
                  >
                    <Hidden xsDown>
                      <Search />
                    </Hidden>
                    {<FormattedMessage {...messages.findEnterprise} />}
                  </Button>
                </Grid>
              </Grid>
            </CardActions>
            <br />
          </Form>
        </Card>
      )}
    />
  );
}

EnterpriseForm.propTypes = {
  classes: PropTypes.object,
  findEnterpriseBegin: PropTypes.func,
  enterpriseError: PropTypes.string,
  formErrors: PropTypes.shape({
    email: PropTypes.string,
  }),
};

EnterpriseForm.contextTypes = {
  intl: PropTypes.object.isRequired,
};

export default memo(withStyles(styles)(EnterpriseForm));
