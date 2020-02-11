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

import Logo from 'components/Shared/Logo';
import messages from 'containers/Session/LoginPage/messages';

const styles = theme => ({
  card: {
    width: '100%',
  },
  submitButtonLabel: {
    minWidth: 'max-content',
  },
});

/* eslint-disable object-curly-newline */
export function EnterpriseFormInner({ handleSubmit, handleChange, handleBlur, errors, touched, values, classes }) {
  return (
    <Card raised className={classes.card}>
      <Form
        noValidate
      >
        <CardContent>
          <Logo coloredDefault maxHeight='45px' />
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
  );
}


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

  const Form = React.forwardRef((props, ref) => {
    const clone = Object.assign({}, props);
    delete clone.children;

    return (
      <Formik
        {...clone}
      >
        {/* eslint-disable-next-line react/prop-types */}
        {props.children}
      </Formik>
    );
  });

  return (
    <Form
      ref={form}
      initialValues={{
        email: ''
      }}
      validateOnBlur={false}
      validateOnChange={false}
      validationSchema={EnterpriseFormSchema}
      onSubmit={(values, actions) => {
        props.findEnterpriseBegin(values);
      }}
    >
      {props => <EnterpriseFormInner {...props} classes={classes} />}
    </Form>
  );
}

EnterpriseFormInner.propTypes = {
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  errors: PropTypes.object,
  touched: PropTypes.object,
  values: PropTypes.object
};

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

// without memo
export const StyledEnterpriseForm = withStyles(styles)(EnterpriseForm);

export default memo(withStyles(styles)(EnterpriseForm));
