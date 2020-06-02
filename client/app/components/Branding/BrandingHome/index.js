/**
 *
 * BrandingHome Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import dig from 'object-dig';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Field, Formik, Form } from 'formik';
import { FormattedMessage, injectIntl, intlShape } from 'react-intl';
import { withStyles } from '@material-ui/core/styles';

import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Paper,
  TextField, Hidden, FormControl, Divider, Switch, FormControlLabel,
} from '@material-ui/core';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstLogoutDialog from 'components/Shared/DiverstLogoutDialog';
import messages from 'containers/Branding/messages';
import DiverstRichTextInput from 'components/Shared/DiverstRichTextInput';
import DiverstFileInput from 'components/Shared/DiverstFileInput';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function BrandingHomeInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const { intl } = props;
  return (
    <Card>
      <Form>
        <CardContent>
          <Grid container spacing={3} alignItems='center'>
            <Grid item xs={12}>
              <Field
                component={DiverstRichTextInput}
                required
                onChange={value => setFieldValue('home_message', value)}
                fullWidth
                id='home_message'
                name='home_message'
                margin='normal'
                label={intl.formatMessage(messages.Home.message)}
                value={values.home_message}
              />
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        <CardContent>
          <Grid container spacing={3} alignItems='center'>
            <Grid item xs={12}>
              <Field
                component={DiverstRichTextInput}
                required
                onChange={value => setFieldValue('privacy_statement', value)}
                fullWidth
                id='privacy_statement'
                name='privacy_statement'
                margin='normal'
                label={intl.formatMessage(messages.Home.privacy)}
                value={values.privacy_statement}
              />
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        <CardContent>
          <Grid container spacing={3} alignItems='center'>
            <Grid item xs={12}>
              <Field
                component={DiverstFileInput}
                id='banner'
                name='banner'
                margin='normal'
                fileName={props.banner_file_name}
                fullWidth
                label={intl.formatMessage(messages.Home.banner)}
                disabled={props.isCommitting}
                value={values.banner}
              />
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            <DiverstFormattedMessage {...messages.save} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function BrandingHome(props) {
  const initialValues = buildValues(props.enterprise, {
    id: { default: '' },
    home_message: { default: '' },
    privacy_statement: { default: '' },
    banner: {default: null},
  });

  const [open, setOpen] = React.useState(false);

  function handleClickOpen() {
    setOpen(true);
  }

  function handleClose() {
    setOpen(false);
  }

  return (
    <React.Fragment>
      <Formik
        initialValues={initialValues}
        enableReinitialize
        onSubmit={(values, actions) => {
          props.enterpriseAction(values);
          handleClickOpen();
        }}

        render={formikProps => <BrandingHomeInner {...props} {...formikProps} />}
      />

      <DiverstLogoutDialog
        open={open}
        handleClose={handleClose}
      />
    </React.Fragment>
  );
}

BrandingHome.propTypes = {
  enterpriseAction: PropTypes.func,
  enterprise: PropTypes.object,
};

BrandingHomeInner.propTypes = {
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  intl: intlShape,
  isCommitting: PropTypes.bool,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(BrandingHome);
