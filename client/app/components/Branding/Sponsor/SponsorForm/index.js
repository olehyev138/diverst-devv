/**
 *
 * SponsorForm Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Field, Formik, Form } from 'formik';
import { withStyles } from '@material-ui/core/styles';

import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, TextField, Divider,
} from '@material-ui/core';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Branding/messages';
import DiverstFileInput from 'components/Shared/DiverstFileInput';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from 'components/Shared/DiverstCancel';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function SponsorFormInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Grid container>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={TextField}
                required
                onChange={handleChange}
                fullWidth
                id='sponsor_name'
                name='sponsor_name'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.Sponsors.name} />}
                value={values.sponsor_name}
              />
            </Grid>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={TextField}
                required
                onChange={handleChange}
                fullWidth
                id='sponsor_title'
                name='sponsor_title'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.Sponsors.title} />}
                value={values.sponsor_title}
              />
            </Grid>
            <Grid item xs={12} className={classes.noBottomPadding}>
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                id='sponsor_message'
                name='sponsor_messsage'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.Sponsors.message} />}
                value={values.sponsor_message}
              />
            </Grid>
            <Grid item className={classes.noBottomPadding}>
              <Field
                component={DiverstFileInput}
                id='sponsor_media'
                name='sponsor_media'
                margin='normal'
                fileName={props.sponsor && props.sponsor.sponsor_media_file_name}
                fullWidth
                label={<DiverstFormattedMessage {...messages.Sponsors.media} />}
                value={values.sponsor_media}
                fileType='image'
              />
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            {<DiverstFormattedMessage {...messages.save} />}
          </DiverstSubmit>
          <DiverstCancel
            redirectFallback={props.links.sponsorIndex}
            disabled={props.isCommitting}
          >
            {<DiverstFormattedMessage {...messages.cancel} />}
          </DiverstCancel>
        </CardActions>
      </Form>
    </Card>
  );
}

export function SponsorForm(props) {
  const initialValues = buildValues(props.sponsor, {
    id: { default: '' },
    sponsor_name: { default: '' },
    sponsor_title: { default: '' },
    sponsor_message: { default: '' },
    sponsor_media: { default: null },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        values.sponsorableId = props.sponsorableId;
        props.sponsorAction(values);
      }}

      render={formikProps => <SponsorFormInner {...props} {...formikProps} />}
    />
  );
}

SponsorForm.propTypes = {
  sponsorAction: PropTypes.func,
  sponsor: PropTypes.object,
  sponsorableId: PropTypes.string,
};

SponsorFormInner.propTypes = {
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  sponsor: PropTypes.object,
  links: PropTypes.shape({
    sponsorIndex: PropTypes.string
  }),
  isCommitting: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(SponsorForm);
