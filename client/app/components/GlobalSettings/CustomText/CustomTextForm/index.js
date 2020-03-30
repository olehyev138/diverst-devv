/**
 *
 * Custom Text Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, Divider, Grid
} from '@material-ui/core';

import messages from 'containers/GlobalSettings/CustomText/messages';
import { buildValues } from 'utils/formHelpers';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstLogoutDialog from 'components/Shared/DiverstLogoutDialog';


/* eslint-disable object-curly-newline */
export function CustomTextFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Grid container spacing={3} justify='center'>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='erg'
                name='erg'
                label={<DiverstFormattedMessage {...messages.erg} />}
                value={values.erg}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='program'
                name='program'
                label={<DiverstFormattedMessage {...messages.program} />}
                value={values.program}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='structure'
                name='structure'
                label={<DiverstFormattedMessage {...messages.structure} />}
                value={values.structure}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='outcome'
                name='outcome'
                label={<DiverstFormattedMessage {...messages.outcome} />}
                value={values.outcome}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='badge'
                name='badge'
                label={<DiverstFormattedMessage {...messages.badge} />}
                value={values.badge}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='segment'
                name='segment'
                label={<DiverstFormattedMessage {...messages.segment} />}
                value={values.segment}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='dci_full_title'
                name='dci_full_title'
                label={<DiverstFormattedMessage {...messages.dci_full_title} />}
                value={values.dci_full_title}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='dci_abbreviation'
                name='dci_abbreviation'
                label={<DiverstFormattedMessage {...messages.dci_abbreviation} />}
                value={values.dci_abbreviation}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='member_preference'
                name='member_preference'
                label={<DiverstFormattedMessage {...messages.member_preference} />}
                value={values.member_preference}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='parent'
                name='parent'
                label={<DiverstFormattedMessage {...messages.parent} />}
                value={values.parent}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='sub_erg'
                name='sub_erg'
                label={<DiverstFormattedMessage {...messages.sub_erg} />}
                value={values.sub_erg}
              />
            </Grid>
            <Grid item xs='auto'>
              <Field
                component={TextField}
                onChange={handleChange}
                margin='normal'
                disabled={props.isCommitting}
                id='privacy_statement'
                name='privacy_statement'
                label={<DiverstFormattedMessage {...messages.privacy_statement} />}
                value={values.privacy_statement}
              />
            </Grid>
          </Grid>
        </CardContent>
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            {buttonText}
          </DiverstSubmit>
        </CardActions>
      </Form>
    </Card>
  );
}

export function CustomTextForm(props) {
  const [open, setOpen] = React.useState(false);

  function handleClickOpen() {
    setOpen(true);
  }

  function handleClose() {
    setOpen(false);
  }

  const customText = dig(props, 'customText');

  const initialValues = buildValues(customText, {
    id: { default: '' },
    erg: { default: 'ERG TEST' },
    program: { default: 'Goal TEST' },
    structure: { default: 'Structure TEST' },
    outcome: { default: 'Focus Area TEST' },
    badge: { default: 'Badge TEST' },
    segment: { default: 'Segment TEST' },
    dci_full_title: { default: 'Engagement TEST' },
    dci_abbreviation: { default: 'Engagement TEST' },
    member_preference: { default: 'Member Survey TEST' },
    parent: { default: 'Parent TEST' },
    sub_erg: { default: 'Sub-Group TEST' },
    privacy_statement: { default: 'Privacy Statement TEST' }
  });
  return (
    <React.Fragment>
      <Formik
        initialValues={initialValues}
        enableReinitialize
        onSubmit={(values, actions) => {
          props.customTextAction(values);
          handleClickOpen();
        }
        }
      >
        {formikProps => <CustomTextFormInner {...props} {...formikProps} />}
      </Formik>
      <DiverstLogoutDialog
        open={open}
        handleClose={handleClose}
      />
    </React.Fragment>
  );
}

CustomTextForm.propTypes = {
  customTextAction: PropTypes.func,
  customText: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
};

CustomTextFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  links: PropTypes.shape({
    customTextEdit: PropTypes.string
  })
};

export default compose(
  memo,
)(CustomTextForm);
